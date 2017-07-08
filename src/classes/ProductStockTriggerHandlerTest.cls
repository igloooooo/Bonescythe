@isTest(seealldata=true)
private class ProductStockTriggerHandlerTest {
	static testmethod void testProductStockNamePopulation(){
		List<Product2> products = TestDataUtility.createProduct(10);
		insert products;

		List<SVMXC__Site__c> locations = TestDataUtility.createLocations(200);
        insert locations;

        Set<Id> prodIds = new Set<Id>();
        List<SVMXC__Product_Stock__c> stocks = new List<SVMXC__Product_Stock__c>();
        for(SVMXC__Site__c location: locations){
        	for(Product2 product: products){
        		prodIds.add(product.Id);
        		stocks.add(new SVMXC__Product_Stock__c(	SVMXC__Product__c = product.Id,
        												SVMXC__Location__c = location.Id,
        												SVMXC__Quantity2__c = 0));
        	}
        }

        Test.startTest();
        	insert stocks;
        	products = [Select Product_Stock_Name_1__c, Product_Stock_Name_2__c, Product_Stock_Name_3__c From Product2 Where ID IN :prodIds];
        	for(Product2 product: products){
        		System.assert(product.Product_Stock_Name_1__c == null);
        		System.assert(product.Product_Stock_Name_2__c == null);
        		System.assert(product.Product_Stock_Name_3__c == null);
        	}
        	for(SVMXC__Product_Stock__c stock: stocks){
        		stock.SVMXC__Quantity2__c = 10;
        	}
        	update stocks;
        	products = [Select Product_Stock_Name_1__c, Product_Stock_Name_2__c, Product_Stock_Name_3__c From Product2 Where ID IN :prodIds];
        	for(Product2 product: products){
        		System.assert(product.Product_Stock_Name_1__c.contains('TEST'));
        		System.assert(product.Product_Stock_Name_2__c.contains('TEST'));
        		System.assert(product.Product_Stock_Name_3__c.contains('TEST'));
        	}
        Test.stopTest();
	}
}