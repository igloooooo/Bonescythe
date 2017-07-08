trigger CheckEntityTypeTrigger on Account (before insert, before update) {
	if(Trigger.isBefore) {
        if (Trigger.isInsert) {
        	for (Account accountNew : Trigger.new) {
            	if (String.isNotBlank(accountNew.ABN__c)) {
                    // trigger credit check entity
                    System.debug('trigger to check entity for account id: ' + accountNew.id);
                    accountNew.Display_Alert__c = true;
            	}	
            }
        } else if (Trigger.isUpdate) {
        	for (Account accountNew : Trigger.new) {
                Account accountOld = Trigger.oldMap.get(accountNew.ID);
                if(accountOld != null) {
                    if (String.isNotBlank(accountNew.ABN__c) && !accountNew.ABN__c.equals(accountOld.ABN__c)) {
                        // trigger credit check entity
                        System.debug('trigger to check entity for account id: ' + accountNew.id);                    
                        accountNew.Display_Alert__c = true;
                    }
            	}
            }    
        }
        
    }
}