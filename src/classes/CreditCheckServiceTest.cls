@isTest(seeAllData=true)
public class CreditCheckServiceTest {
	static testMethod void testNoAccount() {
        Test.startTest();
        CreditCheckService.runCreditReport('111');
        Test.stopTest();
    }
    
    static testMethod void testAccount() {
        Test.startTest(); 
        
        Account a = CreditReportTestDataFactory.createAccountsWithOpp();
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutSurname() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutVedaSurnameWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutGivenname() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutGiven_NameWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutGender() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutGenderWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutDOB() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutDOBWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutDriver() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutDriverWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutSuburb() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutSuburbWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutPostcode() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutPostcodeWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutStreetName() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutStreetNameWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
    
    static testMethod void testSoleTraderAccountWithoutStreetNumber() {
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        Account a = CreditReportTestDataFactory.createAccountsWithoutStreetNumberWithOpp();
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
		CreditCheckService.runCreditReport(a.id);
        Test.stopTest();

    }
}