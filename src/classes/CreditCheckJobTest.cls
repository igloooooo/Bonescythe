@isTest(seeAllData=true)
public class CreditCheckJobTest {
	static testmethod void test1() {
        Test.startTest();
        Account[] result1 = [select id from Account a limit 5];
        Opportunity[] result2 = [select id from Opportunity o limit 5];
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        System.enqueueJob(new CreditCheckJob(result1[0].id, result2[0].id));
        Test.stopTest();
    }
}