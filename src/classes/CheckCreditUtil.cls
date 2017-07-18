public class CheckCreditUtil {
    // test
    //private static String username = 'neo_APIUser';
    //private static String sharedKey = 'N30Pos7T35t';
    //private static String hostname = 'https://test.creditworks.com.au';
    //private static String salt = '$6$5000$a890dad89dnlpzj0'; 
    // production
    private static String username = 'neo_NeopostAPI';
    private static String sharedKey = '8ecfqLZQTd38y72tqu';   
    private static String hostname = 'https://secure.creditworks.com.au';
    private static String salt = '$6$5000$9chad78adnlkj12378cjl';      
    
    public static String checkCreditForAccount(String accountID) {
        Account account = [select id, ACN__C, ABN__C, 
                           Veda_ST_Surname__c, Veda_ST_Given_Name__c, Veda_ST_Gender__c, 
                           Veda_ST_Date_of_Birth__c, Veda_ST_Driver_License_Number__c, account.State__c,
                           Veda_ST_Suburb__c,Veda_ST_Postcode__c, Veda_ST_StreetName__c, Veda_ST_StreetNumber__c
                          from Account where id = :accountID];
        VerifyEntityResponse response = checkEntityType(account.ABN__c);
        if(String.isBlank(response.EntityType)) {
            return null;
        }
        String entityTypeName = EntityTypeMap.getDisplayName(response.EntityType);
        System.debug('entity name is ' + entityTypeName);
        if (entityTypeName.containsIgnoreCase('trust')) {
            if(!String.isEmpty(account.ACN__c)) {
            	runCreditReportJob(null, accountId, account.ABN__c, account.ACN__c, '1');    
            }
        	// set ACN compulsory    
        } else if (entityTypeName.containsIgnoreCase('company')) {
            runCreditReportJob(null, accountId, account.ABN__c, '1');        
			// do nothing            
        } else if (entityTypeName.containsIgnoreCase('sole trader') || entityTypeName.containsIgnoreCase('partnership')) {
            // set some fields compulsory
            Boolean validationCheck = true;
            System.debug('start to check sole trader.');
            if(String.isEmpty(account.Veda_ST_Surname__c)) {
            	validationCheck = false;
                System.debug('start to check sole trader.');
            }
            if(String.isEmpty(account.Veda_ST_Given_Name__c)) {
            	validationCheck = false;
                System.debug('start to check sole trader.');
            }
            if(String.isEmpty(account.Veda_ST_Gender__c)) {
            	validationCheck = false;
                System.debug('start to check sole trader.');
            }
            if(String.isEmpty(account.Veda_ST_Date_of_Birth__c) || date.parse(account.Veda_ST_Date_of_Birth__c) == null) {
            	validationCheck = false;
                System.debug('start to check sole trader.');
            }
            if(String.isEmpty(account.Veda_ST_Driver_License_Number__c)) {
            	validationCheck = false;
                System.debug('start to check sole trader.');
            }
            
            if(String.isEmpty(account.Veda_ST_StreetName__c)) {
            	validationCheck = false;
            }
            if(String.isEmpty(account.Veda_ST_StreetNumber__c)) {
            	validationCheck = false;
            }
            if(String.isEmpty(account.Veda_ST_Suburb__c)) {
            	validationCheck = false;
            }
            if(String.isEmpty(account.Veda_ST_Postcode__c)) {
            	validationCheck = false;
            }
            if(validationCheck) {
                // send credit report
                runCreditReportJob(null, accountId, account.ABN__c, account.Veda_ST_Surname__c, account.Veda_ST_Given_Name__c, 
                					account.Veda_ST_Gender__c, account.Veda_ST_Date_of_Birth__c, account.Veda_ST_Driver_License_Number__c, 
                                   	account.Veda_ST_StreetName__c, account.Veda_ST_StreetNumber__c, 
                                    account.Veda_ST_Suburb__c, account.State__c, account.Veda_ST_Postcode__c, '4');
            } 
            
        } else {
            // run credit report
            runCreditReportJob(null, accountId, account.ABN__c, '1');
            System.debug('Start to run credit report.');
        }
        return entityTypeName;
    }
    
    public static void checkCredit(Opportunity opportunity, String reportLevel) {        
        String opportunityId = opportunity.id;
        String accountId = opportunity.AccountId;
        Account account = [select id, ACN__C, ABN__C, 
                           Veda_ST_Surname__c, Veda_ST_Given_Name__c, Veda_ST_Gender__c, 
                           Veda_ST_Date_of_Birth__c, Veda_ST_Driver_License_Number__c, 
                           Veda_ST_Suburb__c,Veda_ST_Postcode__c, Veda_ST_StreetName__c, Veda_ST_StreetNumber__c,
                           State__c
                          from Account where id = :accountID];
        System.debug('start to credit check job for opportunity id ' + opportunityId + '; account id ' + accountId);
        // check the entity type firstly
        VerifyEntityResponse response = checkEntityType(account.ABN__c);
        String entityTypeName = EntityTypeMap.getDisplayName(response.EntityType);
        System.debug('entity name is ' + entityTypeName);

        if (entityTypeName.containsIgnoreCase('trust')) {
            if(String.isEmpty(account.ACN__c)) {
                opportunity.addError('You can NOT close this opportunity - Please enter ACN of the trust in Accounts to generate Veda report.');
            }else {
            	runCreditReportJob(opportunity.Id, accountId, account.ABN__c, account.ACN__c, reportLevel);      
            }
        	// set ACN compulsory    
        } else if (entityTypeName.containsIgnoreCase('company')) {
            runCreditReportJob(opportunity.Id, accountId, account.ABN__c, reportLevel);        
			// do nothing            
        } else if (entityTypeName.containsIgnoreCase('sole trader') || entityTypeName.containsIgnoreCase('partnership')) {
            // set some fields compulsory
            Boolean validationCheck = true;
            System.debug('Start to check sole trader.');
            if(String.isEmpty(account.Veda_ST_Surname__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Surname__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter surname in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Given_Name__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Given_Name__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter given name in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Gender__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Gender__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter gender in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Date_of_Birth__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Date_of_Birth__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter date of birth in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Driver_License_Number__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Driver_License_Number__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter driver license in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_StreetName__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_StreetName__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter street name in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_StreetNumber__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_StreetNumber__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter street number in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Suburb__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Suburb__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter suburb in Accounts to generate Veda report.');
            }
            if(String.isEmpty(account.Veda_ST_Postcode__c)) {
            	validationCheck = false;
                System.debug('account.Veda_ST_Postcode__c');
                //opportunity.addError('You can NOT close this opportunity - Please enter postcode in Accounts to generate Veda report.');
            }
            if(validationCheck) {
                // send credit report
                runCreditReportJob(opportunity.Id, accountId, account.ABN__c, account.Veda_ST_Surname__c, account.Veda_ST_Given_Name__c, 
                					account.Veda_ST_Gender__c, account.Veda_ST_Date_of_Birth__c, account.Veda_ST_Driver_License_Number__c, 
                                   	account.Veda_ST_StreetNumber__c, account.Veda_ST_StreetName__c,
                                    account.Veda_ST_Suburb__c, account.State__c, account.Veda_ST_Postcode__c, reportLevel);
            } 
        } else {
            // run credit report
            runCreditReportJob(opportunity.Id, accountId, account.ABN__c, reportLevel);
            System.debug('Start to run credit report.');
        }
        
    }
    
    private static void runCreditReportJob(String opportunityId, String accountId, String abn, String reportLevel){
        // clean up currently report
        Account account = [select Name, NTE_ID__c, Veeda_Check_Date_Time__c, Veeda_Status__c
                               from Account a 
                               where a.id = :accountId];
        account.NTE_ID__c = '';
        account.Veeda_Check_Date_Time__c = System.now();
        account.Veeda_Status__c = 'Report processing' ;
        update account;
        System.enqueueJob(new RunCreditReportJob(opportunityId, accountId, abn, reportLevel));
    }
    
    private static void runCreditReportJob(String opportunityId, String accountId, String abn, String acn, String reportLevel){
        // clean up currently report
        Account account = [select Name, NTE_ID__c, Veeda_Check_Date_Time__c, Veeda_Status__c
                               from Account a 
                               where a.id = :accountId];
        account.NTE_ID__c = '';
        account.Veeda_Check_Date_Time__c = System.now();
        account.Veeda_Status__c = 'Report processing' ;
        update account;
        System.enqueueJob(new RunCreditReportJob(opportunityId, accountId, abn, acn, reportLevel));
    }
    
    private static void runCreditReportJob(String opportunityId, String accountId, String abn, String surename, String givename, 
                                           String gender, String dob, String driverLicense, String streetNumber, String streetName, 
                                           String suburb, String state, String postcode, String reportLevel){
        // clean up currently report
        Account account = [select Name, NTE_ID__c, Veeda_Check_Date_Time__c, Veeda_Status__c
                               from Account a 
                               where a.id = :accountId];
        account.NTE_ID__c = '';
        account.Veeda_Check_Date_Time__c = System.now();
        account.Veeda_Status__c = 'Report processing' ;
        update account;
        System.enqueueJob(new RunCreditReportJob(opportunityId, accountId, abn, surename, givename, 
                                           gender, dob, driverLicense, streetNumber, streetName, 
                                           suburb, state, postcode, reportLevel));
    }

    public static VerifyEntityResponse checkEntityType(String abn) {
        String rawResponse = sendVerifyEntityRequest(abn);
        JSONParser parser = JSON.createParser(rawResponse);
        VerifyEntityResponse entityResponse = (VerifyEntityResponse)parser.readValueAs(VerifyEntityResponse.class);
        return entityResponse;        
    }
    
    public static String sendRunCreditReport(String abn){
    	String endpoint = hostname + '/api/run_credit_report';
		String body = 'ABN=' + abn + '&CreditLimit=1000';
        String hashToken = generateHash('run_credit_report');
        String rawResponse = sendPostRequest(body, endpoint, hashToken, username);
        JSONParser parser = JSON.createParser(rawResponse);
        RunCreditReportResponse reportResponse = (RunCreditReportResponse)parser.readValueAs(RunCreditReportResponse.class);
        return reportResponse.NTEId;    
    }
    
    public static String sendRunCreditReport(String abn, String acn){
    	String endpoint = hostname + '/api/run_credit_report';
		String body = 'ABN=' + abn + '&CreditLimit=5000&' + 'ACN=' + acn;
        String hashToken = generateHash('run_credit_report');
        String rawResponse = sendPostRequest(body, endpoint, hashToken, username);
        JSONParser parser = JSON.createParser(rawResponse);
        RunCreditReportResponse reportResponse = (RunCreditReportResponse)parser.readValueAs(RunCreditReportResponse.class);
        return reportResponse.NTEId;    
    }
    
    public static String sendRunCreditReport(String abn, String surename, String givename, 
                                           String gender, String dob, String driverLicense, String streetNumber, String streetName, 
                                           String suburb, String state, String postcode){
    	String endpoint = hostname + '/api/run_credit_report';
		String body = '{"ABN":"'+ abn 
            +'","StreetNumber": "'+streetNumber+'","StreetName": "'+streetName+'","Suburb":"'+suburb+'","State":"'+state+'","Postcode":"'+postcode
            +'","CreditLimit":5000,"ArrayOfOfficers":[{"OfficerFirstName":"'+givename
            +'","OfficerLastName":"'+surename+'","OfficerDOB":"'+dob+'","OfficerLicence":"'+driverLicense+'"}]}';
        String hashToken = generateHash('run_credit_report');
        String rawResponse = sendPostRequest(body, endpoint, hashToken, username);
        JSONParser parser = JSON.createParser(rawResponse);
        RunCreditReportResponse reportResponse = (RunCreditReportResponse)parser.readValueAs(RunCreditReportResponse.class);
        return reportResponse.NTEId;    
    }
    
    public static String sendGetCreditReport(String NETId) {
        return sendGetCreditReport(NETId, '4');     
    }
    
    public static String sendGetCreditReport(String NETId, String reportLevel) {
    	String endpoint = hostname + '/api/get_credit_report';
		String body = 'NTEId=' + NETId + '&ReportLevel=' + reportLevel;
        String hashToken = generateHash('get_credit_report');
        return sendPostRequest(body, endpoint, hashToken, username);     
    }
    
    public static String checkCreditCondition(String entityTypeName, Account account){
        List<String> errorList = new List<String>();
        System.debug('Entity name is ' + entityTypeName);
        String displayName = entityTypeName;
        if (String.isEmpty(displayName)) {
            errorList.add('Entity Name and Entity Type.');
            return joinErrorList(errorList);
        }
        if (displayName.containsIgnoreCase('trust')) {
            if(String.isEmpty(account.ACN__c)) {
                errorList.add('ACN');
                return joinErrorList(errorList);
                //return 'You can NOT close this opportunity - Please enter ACN of the trust in Accounts to generate Veda report.';
            }else {
            	return joinErrorList(errorList);      
            }
        	// set ACN compulsory    
        } else if (displayName.containsIgnoreCase('company')) {
            return null;            
        } else if (displayName.containsIgnoreCase('sole trader') || displayName.containsIgnoreCase('partnership')) {
            if(String.isEmpty(account.Veda_ST_Surname__c)) {
            	errorList.add('Surname');
                //return 'You can NOT close this opportunity - Please enter surname in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Given_Name__c)) {
                errorList.add('Given name');
                //return 'You can NOT close this opportunity - Please enter given name in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Gender__c)) {
                errorList.add('Gender');
                //return 'You can NOT close this opportunity - Please enter gender in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Date_of_Birth__c)) {
                errorList.add('Date of birth');
                //return 'You can NOT close this opportunity - Please enter date of birth in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Driver_License_Number__c)) {
            	errorList.add('Driver license');
                //return 'You can NOT close this opportunity - Please enter driver license in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_StreetName__c)) {
                errorList.add('Street name');
                //return 'You can NOT close this opportunity - Please enter street name in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_StreetNumber__c)) {
            	errorList.add('Street number');
                //return 'You can NOT close this opportunity - Please enter street number in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Suburb__c)) {
            	errorList.add('Suburb');
                //return 'You can NOT close this opportunity - Please enter suburb in Accounts to generate Veda report.';
            }
            if(String.isEmpty(account.Veda_ST_Postcode__c)) {
            	errorList.add('Postcode');
                //return 'You can NOT close this opportunity - Please enter postcode in Accounts to generate Veda report.';
            }
            return joinErrorList(errorList);
        } else {
            return joinErrorList(errorList);
        }
    }
    
    private static String joinErrorList(List<String> errorList) {
        List<String> valueCopy = new List<String>();
        for(String tmp : errorList) {
        	valueCopy.add(tmp);  
        }
        if(!valueCopy.isEmpty()) {
            System.debug('start to fill up error message.');
        	String result = valueCopy[0];
			valueCopy.remove(0);
			while(!valueCopy.isEmpty()) {
				result += ',' + valueCopy[0];
				valueCopy.remove(0);
            }  
            return result;
        }else{
            System.debug('start to fill up error message. but nothing.');
            return null;
        }
    }
    
    public static Integer betweenDaysToToday(Datetime targetDate) {
        Integer gap = Math.abs(Date.today().daysBetween(Date.newInstance(targetDate.year(), targetDate.month(), targetDate.day())));
        System.debug('Gap is ' + gap);
        return gap;
    }
    
    private static String sendVerifyEntityRequest(String abn){
    	String endpoint = hostname + '/api/verify_entity_generic';
		String body = 'ABN=' + abn;
        String hashToken = generateHash('verify_entity_generic');
        return sendPostRequest(body, endpoint, hashToken, username);
    }
    
    private static String sendPostRequest(String body, String endpoint, String hashToken, String user) {
		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('POST');
		req.setbody(body);
        req.setTimeout(120000);
        req.setHeader('X-Authorization', user + ':' + hashToken);
		Http http = new Http();
		HTTPResponse response;
        if(Test.isRunningTest()) {
        	response = new HttpResponse();
    		response.setStatus('OK');
    		response.setStatusCode(200);
    		response.setBody('{"ABN": "85000666300","ACN": "000666366","ACNStatus": "External Administration","ACNStatusCode": "EXAD", "ABNStatus": "ACTIVE", "GSTStatus": "GST","EntityType": "PRV","Name": "JOHN GIKAS PTY LTD", "RBN": "","RBNState": "","Recommendation": "REFER", "NTEId": "1008368", "ApplicationURL":"https://test.creditworks.com.au/index.php?Action=camp.application&ApplicationID=1008368", "Locality": "MELBOURNE VIC 3000","State": "VIC","Postcode": "3000","ExadFlag": "","WindupFlag": "","ApiID": 925890}');    
        }else{
        	response= http.send(req); 
        }
        String responseStr = response.getBody();
        System.debug('Server response: ' + responseStr);
        return responseStr;    
    }
    
    private static String generateHash(String action) {
        DateTime d = Date.Today() ;
		String now =  d.format('yyyyMMdd');
        String message = sharedKey + action + now;
        Blob data = crypto.generateMac('HmacSHA512', Blob.valueOf(message), Blob.valueOf(salt));
        String signature =EncodingUtil.convertToHex(data);		
        System.debug('generateHash : ' + signature);
        return signature;
    }
    
}