global class CreditReportCheckSchedulable implements Schedulable, Database.AllowsCallouts{
    private Long recallTimes;
    private String accountId;
    private String NETId;
    private String reportLevel = '1';
    private String opportunityId;
    public CreditReportCheckSchedulable(Long recallTimes, String opportunityId, String accountId, String NETId) {
    	this.recallTimes = recallTimes;    
        this.accountId = accountId;
        this.NETId = NETId;
        this.opportunityId = opportunityId;
    }
    
    public CreditReportCheckSchedulable(Long recallTimes, String opportunityId, String accountId, String NETId, String reportLevel) {
    	this.recallTimes = recallTimes;    
        this.accountId = accountId;
        this.NETId = NETId;
        this.reportLevel = reportLevel;
        this.opportunityId = opportunityId;
    }
	global void execute(SchedulableContext ctx) {
    	doSynch(recallTimes, opportunityId, accountId, NETId, reportLevel);  
    }
    
    @future (callout=true)  
 	static void doSynch(Long recallTimes, String opportunityId, String accountId, String NETId, String reportLevel){
        if (recallTimes > 3) {
            System.debug('Job retry for ' + recallTimes + ' times. And We will stop it. THe NETID is ' + NETId);                  
            return;
        } else {
            String result = CheckCreditUtil.sendGetCreditReport(NETId, reportLevel);
            JSONParser parser = JSON.createParser(result);
        	System.debug('result is: ' + result);
            System.debug('start to parse object. ');
            CrediteReportTwo reportTwoResponse = (CrediteReportTwo)parser.readValueAs(CrediteReportTwo.class);
			System.debug(reportTwoResponse);
            //find the account by id
            Account account = [select NTE_ID__c, Veeda_Check_Date_Time__c, Entity_Type__c, Veeda_Status__c,
                               	RBN__c, RBN_State__c, ABN_Status__c, ACN_Status__c, GST_Status__c,
                               ACN_Status_Code__c, Locality__c, State__c, Postcode__c, Paid_Capital__c,
                               Application_URL__c, Entity_Status__c, Recommendation__c, Unpaid_Capital__c,
                               Number_Shares__c, Trading_Address__c, Business_Address__c, Credit_History__c,
                               Financial_Statements__c, Time_in_Business__c, Incorporation_Date__c,
                               Credit_Limit_Overdue__c, Credit_Limit_O_I_and_Orders__c
                               from Account a 
                               where a.id = :accountId];
            
            account.NTE_ID__c = reportTwoResponse.NTEId;
            account.Veeda_Check_Date_Time__c = System.now();
        	//account.Entity_Type__c = EntityTypeMap.getDisplayName(reportTwoResponse.EntityType);
        	account.Veeda_Status__c = 'OK' ;
            account.RBN__c = reportTwoResponse.RBN;
            account.RBN_State__c = reportTwoResponse.RBNState;
            account.ABN_Status__c = reportTwoResponse.ABNStatus;
            account.ACN_Status__c = reportTwoResponse.ACNStatus;
            account.GST_Status__c = reportTwoResponse.GSTStatus;
            account.ACN_Status_Code__c = reportTwoResponse.ACNStatusCode;
            account.Locality__c = reportTwoResponse.Locality;
            account.Entity_Status__c = reportTwoResponse.EntityStatus;
            account.State__c = reportTwoResponse.State;
            account.Postcode__c = reportTwoResponse.Postcode;
            account.Application_URL__c = reportTwoResponse.ApplicationURL;
            account.Recommendation__c = reportTwoResponse.Recommendation;
            account.Paid_Capital__c = reportTwoResponse.PaidCapital;
            account.Unpaid_Capital__c = reportTwoResponse.UnpaidCapital;
            account.Number_Shares__c = reportTwoResponse.NumberShares;
            account.Trading_Address__c = reportTwoResponse.TradingAddress;
            account.Business_Address__c = reportTwoResponse.BusinessAddress;
            //account.Credit_History__c = reportTwoResponse.CreditHistory;
            //account.Financial_Statements__c = reportTwoResponse.FinancialStatement;
            account.Time_in_Business__c = reportTwoResponse.TimeInBusiness;
            account.Incorporation_Date__c = reportTwoResponse.IncorporationDate;
            account.Recommendation__c = reportTwoResponse.Recommendation;
            Opportunity opportunity = null;
            System.debug('Get the result and start to check Opportunity' + opportunityId);
            if(!String.isEmpty(opportunityId)) {
            	opportunity = [select Fulfilment_Status__c, Payment_Method__c
                                       from Opportunity o
                                       where o.id = :opportunityId];    
            }
            
            if (reportTwoResponse.Recommendation == 'APPROVE') {
            	account.Credit_Limit_Overdue__c = 500;
            	account.Credit_Limit_O_I_and_Orders__c = 2000;
                account.Veeda_Status__c = 'OK' ;
                if(opportunity != null) {
                    if(opportunity.Payment_Method__c == 'Neopost Finance') {
                    	opportunity.Fulfilment_Status__c = 'Pending for Finance Approval';        
                    } else {
                    	opportunity.Fulfilment_Status__c = 'Ready for Movex';        
                    }
                	
                } else {
                    // update all opportunities with status is 'Pending for Veda Check Terms & Conditions'
                    Opportunity[] targetOpp = [select opp.Id, opp.Fulfilment_Status__c
                                            from Opportunity opp
                                            where opp.AccountId = :accountId];
                    if(targetOpp != null && targetOpp.size() > 0) {
                        for(Opportunity opp : targetOpp) {
                        	opp.Fulfilment_Status__c = 'Ready for Movex';    
                        }
                        update targetOpp;
                    }
                }              
            } else {
                account.Veeda_Status__c = reportTwoResponse.Recommendation;
                if(opportunity != null) {
                	opportunity.Fulfilment_Status__c = 'Credit Rejected/Pending for further Review';
                }
            }
            
            System.debug('Set account netid is: ' + account.NTE_ID__c);
            update account;
            
            if(opportunity != null) {
            	update opportunity;
            }
        }
        System.debug('Job finished');
    }
        
}