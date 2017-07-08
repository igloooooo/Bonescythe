trigger ProductStockTrigger on SVMXC__Product_Stock__c (after insert, after update) {
	 if(trigger.isAfter){
      
        if(trigger.isInsert){
        	ProductStockTriggerHandler.trunkProduct(Trigger.new, null);
        }
        
        if(trigger.isUpdate){
        	ProductStockTriggerHandler.trunkProduct(Trigger.new, Trigger.oldMap);
        }

    }
}