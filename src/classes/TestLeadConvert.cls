@isTest
private class TestLeadConvert{

    private static testMethod void test() {
        
        Lead testLead1 = new Lead(FirstName='Imran',LastName='Amin',Status = 'Inquiry',Created_By_e2a__c='Yes',Company='Google');
        Test.startTest();
        insert testLead1;
        
        ortoo_e2a__EmailMessage__c newEmailMessage = new ortoo_e2a__EmailMessage__c(ortoo_e2a__From_Address__c='testfrom@test.com',ortoo_e2a__Incoming__c=true,ortoo_e2a__Owner_Object__c = '00Q',ortoo_e2a__Lead_Id__c = testLead1.Id,ortoo_e2a__Subject__c='Test',ortoo_e2a__Text_Body__c='Test');
        insert newEmailMessage;
        List<Lead> results = [Select isConverted from Lead where id=:testLead1.id];
        
        System.assertEquals(1, results.size());
        System.assert(results.get(0).isConverted);
        
        //For dublication
        testLead1 = new Lead(FirstName='Imran',LastName='Amin',Status = 'Inquiry',Created_By_e2a__c='Yes',Company='Google');
        
        insert testLead1;
        
        newEmailMessage = new ortoo_e2a__EmailMessage__c(ortoo_e2a__From_Address__c='testfrom@test.com',ortoo_e2a__Incoming__c=true,ortoo_e2a__Owner_Object__c = '00Q',ortoo_e2a__Lead_Id__c = testLead1.Id,ortoo_e2a__Subject__c='Test',ortoo_e2a__Text_Body__c='Test');
        insert newEmailMessage;
        
        System.assertEquals(1, results.size(),'Did not get the right number of leads back');
        System.assert(results.get(0).isConverted,'The lead should have been converted since it was a LeadSource "Web"');
        
        Test.stopTest();

    }

}