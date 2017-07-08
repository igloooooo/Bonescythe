public with sharing class AccountHeadMsgExtension {
    public final Account acc {get;set;}
    public AccountHeadMsgExtension(ApexPages.StandardController stdController) {
        String accountId = ((Account)stdController.getRecord()).Id;
        acc = [select Id, Display_Alert__c, Check_Entity_Status__c, ABN__c, Entity_Type__c, Entity_Name__c
               from Account where id = :accountId];       
    }
    
    public void checkAccountEntity(){
        if(acc.Display_Alert__c) {
            System.debug('start to check entity for ABN: ' + acc.ABN__c);
            if (String.isBlank(acc.ABN__c)) {
                acc.Check_Entity_Status__c = 'ABN not valid, Please check it and try again!';
                update acc;    
            } else {
                VerifyEntityResponse response = CheckCreditUtil.checkEntityType(acc.ABN__c);
                if (String.isNotBlank(response.EntityType)) {
                    String entityTypeName = EntityTypeMap.getDisplayName(response.EntityType);
                    System.debug('start to update the account ID: ' + acc.Id);
                    acc.Entity_Type__c = EntityTypeMap.getDisplayName(response.EntityType);
                    acc.Entity_Name__c = response.Name;
                    acc.Check_Entity_Status__c = 'ABN verified.';
                    acc.Display_Alert__c = false;
                    update acc;
                } else {
                    acc.Check_Entity_Status__c = 'ABN not valid, Please check it and try again!';
                    acc.Display_Alert__c = false;
                    update acc;
                }    
            }
            
        }
    }
    
    public PageReference Dismiss(){
        acc.Display_Alert__c = false;
        acc.Check_Entity_Status__c = '';
        update acc;
        System.debug('You should not see this.');
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(true);
        return pageRef;
    }
}