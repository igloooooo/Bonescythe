@isTest(seealldata=true)
private class ProductTriggerHandlerTest {
	static testMethod void testStandardPricebookEntryCreation() {
        List<Product2> products = new List<Product2>();
        for(Integer i=0; i<200; i++){
        	products.add(new Product2(Name = 'Test Product'+i));
        }
        Test.startTest();
        	insert products;
        	Set<Id> productIds = new Set<Id>();
        	for(Product2 product: products){
        		productIds.add(product.Id);
        	}
        	List<PricebookEntry> pricebookEntries = [Select Id From PricebookEntry Where Product2Id IN :productIds];
        	System.assertEquals(pricebookEntries.size(), 200);
        test.stopTest();
    }
}