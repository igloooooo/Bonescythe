@isTest(seeAllData=true)
public class CreditReportCheckSchedulableTest {
	static testMethod void testScheduleTwo() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        //Account account = CreditReportTestDataFactory.createAccountsWithOpp();
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccount();
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(1);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        System.schedule('test credit report check schedulable.', cronString, new CreditReportCheckSchedulable(3, opp.Id, opp.accountId, '11'));
        Test.stopTest();
    }
    
    static testMethod void testScheduleOne() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        //Account account = CreditReportTestDataFactory.createAccountsWithOpp();
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccount();
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(1);
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        System.schedule('test credit report check schedulable.', cronString, new CreditReportCheckSchedulable(1, opp.Id, opp.accountId, '11'));
        Test.stopTest();
    }
}