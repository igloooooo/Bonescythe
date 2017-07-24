@isTest(SeeAllData=true)
public class CheckCreditTriggerTest {
	static testMethod void testTriggerOne() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountForTriggerOne();
        opp.StageName = 'Closed Won';    
		
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        update opp;    
        Test.stopTest();
    }
    
    static testMethod void testTriggerTwo() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerTwo();
		opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
		update opp;
        Test.stopTest();

    }
    
    static testMethod void testTriggerThree() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerThree();
		opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        EntityTypeMap.setDisplayName('PRV', 'Company');
		update opp;
        Test.stopTest();

    }
    
    static testMethod void testTriggerFour() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerFour();
		opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        EntityTypeMap.setDisplayName('PRV', 'Company');
		update opp;
        Test.stopTest();

    }

    static testMethod void testTriggerFive() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerFive();
        opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        EntityTypeMap.setDisplayName('PRV', 'Company');
        update opp;
        Test.stopTest();

    }

    static testMethod void testTriggerSix() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerSix();
        opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        EntityTypeMap.setDisplayName('PRV', 'Company');
        update opp;
        Test.stopTest();

    }

    static testMethod void testTriggerSeven() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccountWithNeopostFinanceForTriggerSeven();
        opp.StageName = 'Closed Won';    
        opp.ABN__c = '222';
        opp.Fulfilment_Status__c = 'abc';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        EntityTypeMap.setDisplayName('PRV', 'Company');
        update opp;
        Test.stopTest();

    }
}