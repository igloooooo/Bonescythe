@isTest(seealldata = true)
private class CounterDetailTriggerHandlerTest {
    static testmethod void lastCounterUpdate(){
        List<Account> accounts = TestDataUtility.createAccounts(1);
        accounts.get(0).Name ='testname';
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        products.get(0).PM_Cycle__c = true;
        insert products;
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product(1, accounts, products);
        insert installedProducts;
        
        List<SVMXC__Counter_Details__c> counters = TestDataUtility.createCounterRecords(3, installedProducts);
        
        Test.startTest();
            insert counters;
            installedProducts = [Select Id, Last_Counter_Reading__c From SVMXC__Installed_Product__c Where ID = :installedProducts.get(0).Id ];
            //System.assertEquals(installedProducts.get(0).Last_Counter_Reading__c, 550000);
        Test.stopTest();
    }
}