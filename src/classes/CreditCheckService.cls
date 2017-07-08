global with sharing class CreditCheckService {
	webservice static String runCreditReport(String accountId) {
        Account[] result = [select Name, NTE_ID__c, Veeda_Check_Date_Time__c, Veeda_Status__c, 
                            Entity_Type__c,
                            ACN__C, ABN__C, 
                           Veda_ST_Surname__c, Veda_ST_Given_Name__c, Veda_ST_Gender__c, 
                           Veda_ST_Date_of_Birth__c, Veda_ST_Driver_License_Number__c, 
                            Veda_ST_StreetName__c,Veda_ST_StreetNumber__c,
                           Veda_ST_Suburb__c,Veda_ST_Postcode__c
                               from Account a 
                               where a.id = :accountId];
        if (result.size() > 0) {
        	String entityTypeName = CheckCreditUtil.checkCreditForAccount(accountId);
            System.debug('entity type is ' + entityTypeName);
            if(String.isNotBlank(entityTypeName)) {
            	Account account = result[0];
                //if (account.Veeda_Status__c == 'Report processing') {
                //    return 'There is another credit report processing for account: ' + account.Name;    
                //} else {
                    if (entityTypeName.containsIgnoreCase('trust')) {
                        if(String.isEmpty(account.ACN__c)) {
                            return 'Customer is trust client, please enter ACN of the trust in Accounts to generate Veda report.'; 
                        }
                        // set ACN compulsory    
                    } else if (entityTypeName.containsIgnoreCase('company')) {
                        //runCreditReportJob(accountId, account.ABN__c);        
                        // do nothing            
                    } else if (entityTypeName.containsIgnoreCase('sole trader') || entityTypeName.containsIgnoreCase('partnership')) {
                        // set some fields compulsory
                        Boolean validationCheck = true;
                        if(String.isEmpty(account.Veda_ST_Surname__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter surname of the trust in Accounts to generate Veda report.';
                        }
                        if(String.isEmpty(account.Veda_ST_Given_Name__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter given name of the trust in Accounts to generate Veda report.';
                        }
                        if(String.isEmpty(account.Veda_ST_Gender__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter gender of the trust in Accounts to generate Veda report.';
                        }
                        if(String.isEmpty(account.Veda_ST_Date_of_Birth__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter date of birth of the trust in Accounts to generate Veda report.';
                        }
                        
                        if(String.isEmpty(account.Veda_ST_StreetName__c)) {
            				validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter street name of the trust in Accounts to generate Veda report.';
            			}
            			if(String.isEmpty(account.Veda_ST_StreetNumber__c)) {
            				validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter street number of the trust in Accounts to generate Veda report.';
            			}
                        if(String.isEmpty(account.Veda_ST_Suburb__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter suburb of the trust in Accounts to generate Veda report.';
                        }
                        if(String.isEmpty(account.Veda_ST_Postcode__c)) {
                            validationCheck = false;
                            return 'Customer is sole trader or partnership, please enter postcode of the trust in Accounts to generate Veda report.';
                        }
                        
                        
                    } else {
                        // run credit report
                        //runCreditReportJob(accountId, account.ABN__c);
                        System.debug('ready to run credit report.');
                    }
                    // update the account
                    account.NTE_ID__c = '';
        			account.Veeda_Check_Date_Time__c = System.now();
        			account.Entity_Type__c = entityTypeName;        
            		account.Veeda_Status__c = 'Report processing' ;
        			update account; 
                    
                    return 'Start to generate credit report for account: ' + account.Name; 
                //}
                    
            }else {
                return 'ABN is NOT valid.';
            }
               
        }else {
            return 'Account ' + accountId + ' does NOT exist.';
        }
        
    }
    
    
}