@isTest(SeeAllData=true)
public class AddFreightTriggerTest {
    public static testMethod void testOneNoFee() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.Special_Delivery__c = 'Sales Rep to Deliver';
        opp.Freight__c = 'Standard';
        opp.StageName = 'Closed Won';
        update opp;
        
    }
    
    public static testMethod void testTwoNoFee() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.Special_Delivery__c = 'Customer to Collect';
        opp.Freight__c = 'Standard';
        opp.StageName = 'Closed Won';
        update opp;
    }
    
    public static testMethod void testOne() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.Special_Delivery__c = 'VIP Courier';
        opp.Freight__c = 'Standard';
        opp.StageName = 'Closed Won';
        update opp;
        
        opp.Special_Delivery__c = 'Same Day Delivery';
        update opp;
    }
    
    public static testMethod void testTwo() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.StageName = 'Closed Won';
        opp.Special_Delivery__c = 'Same Day Delivery';
        update opp;
        opp.Special_Delivery__c = '';
        opp.Freight__c = 'Exempt over $200'; 
        opp.Amount =200;
        update opp;
    }
    
    public static testMethod void testThree() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.StageName = 'Closed Won';
        opp.Freight__c = 'Standard'; 
        opp.Amount =200;
        update opp;
        opp.Amount =300;
        
        update opp;
    }
    
    public static testMethod void testFour() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.StageName = 'Closed Won';
        opp.Freight__c = 'Standard'; 
        opp.Amount =300;
        update opp;
        opp.Amount =200;
        update opp;
    }
    
    public static testMethod void testFive() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinance();
        opp.StageName = 'Closed Won';
        opp.Freight__c = 'Exempt over $200'; 
        opp.Amount =200; 
        update opp;
        opp.VIP_Courier__c = true;
        update opp;
    }
}