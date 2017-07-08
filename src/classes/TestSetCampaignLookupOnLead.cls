@isTest
private class TestSetCampaignLookupOnLead {

  private static testMethod void test() {
      Test.startTest();
      Campaign c = new Campaign(Name='Test1');
      insert c;
      Lead testLead1 = new Lead(FirstName='e2a',LastName='Ortoo',Status = 'Inquiry',Created_By_e2a__c ='Yes',Company='Google',Campaign_Name__c='Test1');
     
      insert testLead1;
      List<CampaignMember> obj_cmember = [SELECT id from CampaignMember where LeadId =:testLead1.id];
      System.assertEquals(obj_cmember.size(),1);
      Test.stopTest();

  }

}