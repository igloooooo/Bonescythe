public class RunCreditReportJob implements Queueable, Database.AllowsCallouts{
    private String accountId;
    private String opportunityId;
    private String abn;
    private String acn;
    private String reportLevel = '1';
    private Integer requestLevel = 0;
    private String surename;
    private String givename; 
    private String gender;
    private String dob;
    private String driverLicense;
    private String streetNumber;
    private String streetName;
    private String suburb;
    private String state;
    private String postcode;
    
    public RunCreditReportJob(String opportunityId, String accountId, String abn, String reportLevel) {
    	this.accountId = accountId; 
        this.abn = abn;
        requestLevel = 0;
        this.reportLevel = reportLevel;
        this.opportunityId = opportunityId;
    }
    
    public RunCreditReportJob(String opportunityId, String accountId, String abn, String acn, String reportLevel) {
    	this.accountId = accountId; 
        this.abn = abn;
        this.acn = acn;
        requestLevel = 1;
        this.reportLevel = reportLevel;
        this.opportunityId = opportunityId;
    }
    
    public RunCreditReportJob(String opportunityId, String accountId, String abn, String surename, String givename, 
                                           String gender, String dob, String driverLicense, String streetNumber, String streetName, 
                                           String suburb, String state, String postcode, String reportLevel) {
    	this.accountId = accountId; 
        this.abn = abn;
        this.surename = surename;
    	this.givename = givename; 
    	this.gender = gender;
    	this.dob = dob;
    	this.driverLicense = driverLicense;
    	this.streetNumber = streetNumber;
        this.streetName = streetName;
    	this.suburb = suburb;
    	this.state = state;
    	this.postcode = postcode;
        requestLevel = 2;
        this.reportLevel = reportLevel;
        this.opportunityId = opportunityId;                                       
    }
    
	public void execute(QueueableContext context) {      
        String NTEId;
        if(requestLevel == 0) {
     		NTEId = CheckCreditUtil.sendRunCreditReport(abn);
        } else if (requestLevel == 1) {
            NTEId = CheckCreditUtil.sendRunCreditReport(abn, acn);
        } else if (requestLevel == 2) {
            NTEId = CheckCreditUtil.sendRunCreditReport(abn, surename, givename, 
                                           gender, dob, driverLicense, streetNumber, streetName, 
                                           suburb, state, postcode);
        } else {
            NTEId = CheckCreditUtil.sendRunCreditReport(abn);
        }
        if (NTEId == null) {
        	system.debug('Can not generate the credit report. ');
            Account account = [select NTE_ID__c, Veeda_Check_Date_Time__c, Entity_Type__c, Veeda_Status__c,
                               	RBN__c, RBN_State__c, ABN_Status__c, ACN_Status__c, GST_Status__c,
                               ACN_Status_Code__c, Locality__c, State__c, Postcode__c, Paid_Capital__c,
                               Application_URL__c, Entity_Status__c, Recommendation__c, Unpaid_Capital__c,
                               Number_Shares__c, Trading_Address__c, Business_Address__c, Credit_History__c,
                               Financial_Statements__c, Time_in_Business__c, Incorporation_Date__c,
                               Credit_Limit_Overdue__c, Credit_Limit_O_I_and_Orders__c
                               from Account a 
                               where a.id = :accountId];

        	account.Veeda_Status__c = 'Fail';
            update account;
        } else {

            // start the process to get report
            DateTime now  = DateTime.now();
            String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
            Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
            String hexDigest = EncodingUtil.convertToHex(hash);
            system.debug('##########' + hexDigest );
            
            DateTime nextRunTime = now.addMinutes(2);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        	System.schedule(CreditReportCheckSchedulable.class.getName() + '-' + hashString, cronString, new CreditReportCheckSchedulable(0, opportunityId, accountId, NTEId, reportLevel));
        }
            
    }
}