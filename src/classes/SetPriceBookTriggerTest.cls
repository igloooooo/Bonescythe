@isTest(SeeAllData=true)
public class SetPriceBookTriggerTest {
	public static testMethod void testOneNoPriceGroup() {
        Account a = SetPriceBookTriggerTestDataFactory.createAccountsWithoutPriceGroup();
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead (Unqualified)',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;  
    }
    
    public static testMethod void testOneWithGV() {
        Account a = SetPriceBookTriggerTestDataFactory.createAccountsWithGV();
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead (Unqualified)',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;  
    }
}