@IsTest
public class CreditCheckTriggerCallOutTest {
	static testMethod void testCallOut() {
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccount();
    	CreditCheckTriggerCallOut.triggerCheckCredit(opp.id, '1');	
    }
}