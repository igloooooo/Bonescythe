@isTest
public class ShipAddressDataFactory {
    public static Opportunity createOppWithShipAddress() {
        Account account = new Account(Name='TestAccountShipAddress');
        account.State__c = 'test';
        account.ABN__c = 'aaa';
        account.ACN__c = 'aaa';
        account.BillingCity = 'test bill city';  
        account.BillingState = 'test state';
        account.BillingPostalCode = '1111';
        account.Customer_Number__c = 'aaaa';
        account.Phone = '111';
        account.Reference_Contact_1__c  = 'asdf';
        insert account;
        
        Address__c address = new Address__c();
        address.Customer__c = account.Id;
        address.Street__c = 'asdf';
        address.Suburb__c = 'zcxv';
        address.State__c = 'nsw';
        address.Address_ID__c = '7916';
        insert address;
        Opportunity opp = new Opportunity(Name='TestOpportunityShipAddress',
                                         CloseDate=System.today().addMonths(1),
                                       AccountId=account.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Closed Won',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12); 
        opp.Ship_Address_Default__c = address.Id;
        opp.Requested_Delivery_Date__c = System.today().addMonths(1);
        insert opp;
        return opp;
    }
}