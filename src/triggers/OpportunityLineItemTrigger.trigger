trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert, after update, after delete, after undelete){
    system.debug('OpportunityWorkflowUtility.isInLineItemTrigger: ' + OpportunityWorkflowUtility.isInLineItemTrigger);
    
    // check if Opportunity if Fulfilment_Status__c != 'Sent to Movex'
    if(!OpportunityWorkflowUtility.isInLineItemTrigger){

        OpportunityLineItemTriggerHelper.setIsInLineItemTrigger();
        OpportunityLineItemTriggerHelper.setIsInOppTrigger();
        
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
        
        string oppQuery = 'SELECT ';
        
        for (String fieldName: schemaFieldMap.keySet()) {
            oppQuery += fieldName + ', ';
        }
        
        oppQuery = oppQuery.removeEnd(', ');
        
        oppQuery += ' FROM Opportunity'
            + ' WHERE Id = ';
        
        Opportunity opp; 
        
        if(trigger.isDelete){
            
            OpportunityLineItemTriggerHelper.setContext('isDelete');
            oppQuery += '\'' + trigger.old[0].OpportunityId + '\' LIMIT 1';
            
            OpportunityLineItemTriggerHelper.setOpportunity(database.query(oppQuery));
            
            OpportunityLineItemTriggerHelper.setLineItemsForDelete(trigger.old);
            
            
        } else {
            if(trigger.isInsert){
                OpportunityLineItemTriggerHelper.setContext('isInsert'); 
            } else if(trigger.isUpdate){
                OpportunityLineItemTriggerHelper.setContext('isUpdate');
            } else if(trigger.isUndelete){
                OpportunityLineItemTriggerHelper.setContext('isUpdate');
            }
            
            oppQuery += '\'' + trigger.new[0].OpportunityId + '\' LIMIT 1';

            opp = database.query(oppQuery); 
            OpportunityLineItemTriggerHelper.setOpportunity(opp);

            if(opp.IsClosed){
                if(![select Can_Update_Closed_Opportunities__c from User where Id = :UserInfo.getUserId() limit 1].Can_Update_Closed_Opportunities__c){
                    if(trigger.isUpdate){
                        for(OpportunityLineItem item : trigger.new){
                            item.addError('You cannot edit Products on a closed Opportunity');
                        }
                    }
                    else if(trigger.isInsert){
                        for(OpportunityLineItem item : trigger.new){
                            item.addError('You cannot add Products to a closed Opportunity');
                        }
                    }
                }
            }

            if (opp.Fulfilment_Status__c != 'Sent to Movex') {
                OpportunityLineItemTriggerHelper.setLineItems(trigger.new);
            
                //OpportunityLineItemTriggerHelper.doCheckLineItemPrice();
                OpportunityLineItemTriggerHelper.doValidateOpportunityLineItems();
            }

    
        }
        
        // now that we're done with validating trigger.new, refresh lineItems list with all related OpportunityLineItem records
        OpportunityLineItemTriggerHelper.getLineItems();
        
        OpportunityLineItemTriggerHelper.doCheckLineItemPrice();
                
        system.debug('!!!!! LINEITEMTRIGGER: Executing Neopay Check');
        OpportunityLineItemTriggerHelper.doIsNeopayRequired();
        OpportunityLineItemTriggerHelper.doFinanceCalculation();
        OpportunityLineItemTriggerHelper.getRequiredTemplateIds();
        
        OpportunityLineItemTriggerHelper.doUpdateLineItems();
        
        
        //OpportunityLineItemTriggerHelper.doIsPricingApprovalRequired();
        OpportunityTriggerHelper.doIsFreightRequired();
        
        OpportunityLineItemTriggerHelper.doUpdateOpportunities();
        
    }
}