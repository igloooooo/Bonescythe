trigger ProductTrigger on Product2 (after insert) {
	if(trigger.isInsert && trigger.isAfter){
		ProductTriggerHandler.createStandardPricebookEntry(trigger.new);
	}
}