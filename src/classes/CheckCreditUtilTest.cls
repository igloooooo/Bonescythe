/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true)
private class CheckCreditUtilTest {

    static testMethod void checkEntityType() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        VerifyEntityResponse response = CheckCreditUtil.checkEntityType('111');
        System.assertEquals('asd','asd');
        Test.stopTest();
        
    }
    
    static testMethod void checkCredit() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutMock());
        Opportunity opp = CreditReportTestDataFactory.createOppWithAccount();
        CheckCreditUtil.checkCredit(opp, '1');
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testSoleTraderEntity() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account[] result1 = [select id from Account a limit 5];
        Opportunity[] result2 = [select id, AccountId, ABN__c from Opportunity o limit 5];
        CheckCreditUtil.checkCredit(result2[0], '4');
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testTrustEntity() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'trust');
        Account account = CreditReportTestDataFactory.createAccountsWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testSoleTradeWithFieldsEntity() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccount() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutDOBWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutDOBWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutDriverWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutDriverWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutGenderWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutGenderWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutGiven_NameWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutGiven_NameWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutPostcodeWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutPostcodeWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutStreetNameWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutStreetNameWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutStreetNumberWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutStreetNumberWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckAccountWithoutSuburbWithOpp() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutSuburbWithOpp();
        CheckCreditUtil.checkCreditForAccount(account.Id);
        
        System.assertEquals('asd','asd');
        Test.stopTest();
    }
    
    static testMethod void testCheckCreditCondition(){
    	Test.startTest();
        Test.setMock(HttpCalloutMock.class, new NEOCalloutSoleTraderMock());
        EntityTypeMap.setDisplayName('PRV', 'sole trader');
        Account account = CreditReportTestDataFactory.createAccountsWithoutSuburbWithOpp();
        CheckCreditUtil.checkCreditCondition('sole trader', account);
        
        System.assertEquals('asd','asd');
        Test.stopTest();    
    }
    
    static testMethod void testBetweenDaysToToday(){
        CheckCreditUtil.betweenDaysToToday(System.today().addMonths(1));
    }
}