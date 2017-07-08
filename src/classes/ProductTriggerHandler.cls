public class ProductTriggerHandler {
    
    public static void createStandardPricebookEntry(List<Product2> products){
        
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        
        if([SELECT count() From Pricebook2 Where IsStandard=true] > 0){
            
            Pricebook2 standardPricebook = [SELECT  Id 
                                            From    Pricebook2 
                                            Where   IsStandard=true];
            
            for(Product2 product: products){
                
                pricebookEntries.add(new PricebookEntry(Product2Id = product.Id,
                                                        Pricebook2Id = standardPricebook.Id,
                                                        UnitPrice = 0,
                                                        Product_External_Id__c = product.Item_No__c+'_Standard Price Book'));
            }
            
            if(pricebookEntries.size() > 0){
                //if(!test.isRunningTest())
                    insert pricebookEntries; 
            }
        }
    }
}