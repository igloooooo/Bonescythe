@isTest
public class CheckEntityTypeTriggerTest {
	public static testMethod void testUpdateABN() {  
        Account raw = CreditReportTestDataFactory.createAccountsWithoutVedaSurnameWithOpp();
        raw.ABN__c = '111';
        update raw;
    }
}