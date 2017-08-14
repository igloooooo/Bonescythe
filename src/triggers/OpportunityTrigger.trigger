trigger OpportunityTrigger on Opportunity (after update) {
    
    for(Opportunity o : trigger.new){
        
        if(!OpportunityWorkflowUtility.isInOppTrigger && Trigger.oldMap.get(o.Id).Fulfilment_Status__c != 'Sent to Movex'){
            
            OpportunityTriggerHelper.setIsInOppTrigger();
            
            OpportunityTriggerHelper.setOpportunity(o);
            
            integer priceApprovalRequiredCount = [select count() from OpportunityLineItem where OpportunityId = :o.id  AND (Requires_MGMT_Price_Approval__c = true OR Requires_PM_Price_Approval__c = true) limit 1];
            integer PendingApprovalCount = [select count() from ProcessInstance where Status = 'Pending' and TargetObjectId = : o.id];
            
            system.debug('PendingApprovalCount:' + PendingApprovalCount);
            system.debug('Trigger.New.IsWon: ' + o.isWon);
            
            if(trigger.isUpdate){

                if(o.isWon && PendingApprovalCount > 0){
                    o.addError('<br/>This Opportunity has a pending Approval Request and cannot be Closed Won', false);
                }
                
                if(o.isWon && priceApprovalRequiredCount > 0){
                    if(!o.Price_Approval__c && !o.Floor_Price_Exempt__c){
                        o.addError('<br/>Opportunity has one or more items that require floor price approval.<br/>Once approved, the Opportunity can be Closed Won.', false);
                    }
                }
                
                if(trigger.oldMap.get(o.Id).isClosed){
                    
                    // closed Opportunity can only be edited by Users with the Can Update Closed Opportunities permission enabled
                    if(![select Can_Update_Closed_Opportunities__c from User where Id = :UserInfo.getUserId() limit 1].Can_Update_Closed_Opportunities__c){
                        o.addError('<br/>You cannot change a closed Opportunity', false);
                    }
                }
                
            }
            
            if(o.RecordTypeId == OpportunityWorkflowUtility.recordTypeMap.get('Machine_Consumables_Opportunity').Id){
                
                if(trigger.isInsert){
                    OpportunityTriggerHelper.setContext('isInsert');
                }
                else if(trigger.isUpdate){
                    OpportunityTriggerHelper.setContext('isUpdate');
                    
                }
                
                OpportunityTriggerHelper.doValidateOpportunity();
                
                OpportunityTriggerHelper.getRequiredTemplateIds();
                OpportunityTriggerHelper.doIsFinanceApprovalRequired();
                OpportunityTriggerHelper.doIsMaintenanceApprovalRequired();
                //OpportunityTriggerHelper.doIsFloorPriceApprovalRequired();
                
                system.debug('!!!!! OPPTYTRIGGER: Executing Neopay Check');
                OpportunityTriggerHelper.doIsNeoPayRequired();
                
                OpportunityWorkflowUtility.getLineItems();
                OpportunityTriggerHelper.doIsFreightRequired();
                
                OpportunityTriggerHelper.doFinanceCalculation();

                if(o.isWon){
                    if(trigger.isInsert || (trigger.isUpdate && !trigger.oldMap.get(o.Id).isWon)){
                        OpportunityTriggerHelper.doCreateServicemaxCases();
                        OpportunityTriggerHelper.doFreePostAlert();
                    }
                }
            }
            
            OpportunityWorkflowUtility.getLineItems();
            OpportunityTriggerHelper.doIsFreightRequired();
            
            OpportunityTriggerHelper.doUpdateOpportunities(); 
        }
    }
    
}