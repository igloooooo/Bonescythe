global class CreditCheckTriggerCallOut {
	@future(callout=true)
     Public static void triggerCheckCredit(String opportunityId, String reportLevel)
     {
		Opportunity opp = [select id, AccountId, ABN__c, ACN__c, Name, Post_Code__c, Address_Payer__c 
                           from Opportunity
                           where id = :opportunityId];
         if (opp != null) {
             CheckCreditUtil.checkCredit(opp, reportLevel);
         } else {
            System.debug('Opportunity id ' + opportunityId + ' does NOT exist!'); 
         }
     }
}