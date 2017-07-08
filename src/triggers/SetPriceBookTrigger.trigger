trigger SetPriceBookTrigger on Opportunity (before insert) {
    for (Opportunity opp : Trigger.new) {
        String accountID = opp.AccountId;
        Account account = [select id, Price_Group__c
                      from Account where id = :accountID];
        if (!String.isEmpty(account.Price_Group__c)) {
            List<PriceGroupMap__c> result = [select Price_Book_Name__c, PriceGroupName__c from PriceGroupMap__c where PriceGroupName__c = :account.Price_Group__c];
            if (result.size() > 0) {
                opp.Pricebook2Id = result.get(0).Price_Book_Name__c;
            }
        }
        
    }
}