@isTest(seealldata = true)
private class CounterDetailTriggerHandlerTest {
    static testmethod void lastCounterUpdate(){
        List<Account> accounts = TestDataUtility.createAccounts(1);
        accounts.get(0).Name ='testname';
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        products.get(0).PM_Cycle__c = true;
        insert products;
        
        List<SVMXC__Site__c> sites = TestDataUtility.createLocations(1);
        sites.get(0).SVMXC__Account__c = accounts.get(0).Id;
        insert sites;
        System.debug('site is' + sites.get(0).Id);
        System.debug(sites.get(0));
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product_with_Site(1, accounts, products, sites);
        insert installedProducts;
        
        List<SVMXC__Counter_Details__c> counters = TestDataUtility.createCounterRecords(3, installedProducts);
        
        Test.startTest();
            insert counters;
            installedProducts = [Select Id, Last_Counter_Reading__c From SVMXC__Installed_Product__c Where ID = :installedProducts.get(0).Id ];
            //System.assertEquals(installedProducts.get(0).Last_Counter_Reading__c, 550000);
        Test.stopTest();
    }
}