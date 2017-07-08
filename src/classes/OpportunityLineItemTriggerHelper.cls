public class OpportunityLineItemTriggerHelper extends OpportunityWorkflowUtility {

    public static void setIsInLineItemTrigger(){
        OpportunityWorkflowUtility.isInLineItemTrigger = true;
    }
    
    public static void setIsInOppTrigger(){
        OpportunityWorkflowUtility.isInOppTrigger = true;
    }
    
    public static void setContext(string triggerContext){ 
        OpportunityWorkflowUtility.context = triggerContext;
    }
    
    public static void setOpportunity(Opportunity oppty){
        OpportunityWorkflowUtility.opportunity = oppty;
        OpportunityWorkflowUtility.oppsForUpdate.put(oppty.Id, new Opportunity(Id=oppty.Id));
    }
    
    public static void setLineItemsForDelete(List<OpportunityLineItem> items){
        OpportunityWorkflowUtility.lineItemsForDelete = items;
    }
    
    public static void setLineItems(List<OpportunityLineItem> items){
        OpportunityWorkflowUtility.lineItems = items;
    }
    
    public static void getLineItems(){
        OpportunityWorkflowUtility.getlineitems();
    }
    
    public static void doUpdateOpportunities(){
        OpportunityWorkflowUtility.doUpdateOpportunities();
    }
    
    public static void doUpdateLineItems(){
        OpportunityWorkflowUtility.doUpdateLineItems();
    }
    
    public static void doValidateOpportunityLineItems(){
                
        OpportunityWorkflowUtility.getProductCodeMap();
        OpportunityWorkflowUtility.getContractCodeMap();
        
        for(OpportunityLineItem item : OpportunityWorkflowUtility.lineitems){
            
            OpportunityLineItem oi = new OpportunityLineItem();
                oi.Id = item.Id;
                oi.Completion_Status__c = 'Complete';
            
            /*if(!item.Requires_Install__c){
                oi.Service_Install_Required__c = 'No';
            } else*/ 
            
            if(item.Requires_Install__c && item.Service_Install_Required__c != 'Yes'){
                oi.Service_Install_Required__c = 'Yes';
                oi.Completion_Status__c = 'Incomplete';
            } 
            
            if(item.Item_No__c != 'FREIGHT1'){
                
                //if(item.Requires_Install__c){
                    
                    if(OpportunityWorkflowUtility.context == 'isUpdate'){       

                        system.debug('@@@@ IS CLOSED : ' + item.Opportunity.isWon);

                        if(item.Opportunity.isClosed){
                            if(![select Can_Update_Closed_Opportunities__c from User where Id = :UserInfo.getUserId() limit 1].Can_Update_Closed_Opportunities__c){
                                //item.addError('You cannot edit Products on a closed Opportunity');
                            }
                        }                 
                                                
                        if(OpportunityWorkflowUtility.productCodeMap.get('BMS_Inserter').contains(item.Product_Group__c)){
                            
                            oi.Item_Type__c = 'BMS';
                            
                            if(item.Date_Completed_BMS__c == null && item.Service_Install_Required__c == 'Yes'){
                                oi.Completion_Status__c = 'Incomplete';
                                item.Date_Completed_BMS__c.addError('Value is required');
                            }
                            
                            /*if(item.Date_Completed_BMS__c == null && oi.Service_Install_Required__c == 'Yes' && item.Completion_Status__c == 'Complete'){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if (item.Date_Completed_BMS__c == null && (oi.Service_Install_Required__c == 'Yes' && item.Service_Install_Required__c == 'No')){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if(item.Date_Completed_BMS__c == null && oi.Service_Install_Required__c == 'Yes' ){
                                item.Date_Completed_BMS__c.addError('Value is required');
                            } */
                        } 
                        
                        else if(OpportunityWorkflowUtility.productCodeMap.get('BMS_Postage_Meter').contains(item.Product_Group__c)){
                            
                            oi.Item_Type__c = 'BMSPM';
                            
                            if(item.Date_Completed_BMSPM__c == null && item.Service_Install_Required__c == 'Yes'){
                                oi.Completion_Status__c = 'Incomplete';
                                item.Date_Completed_BMSPM__c.addError('Value is required');
                            } 
                            
                            /*if(item.Date_Completed_BMSPM__c == null && oi.Service_Install_Required__c == 'Yes' && item.Completion_Status__c == 'Complete'){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if (item.Date_Completed_BMSPM__c == null && (oi.Service_Install_Required__c == 'Yes' && item.Service_Install_Required__c == 'No')){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if(item.Date_Completed_BMSPM__c == null && oi.Service_Install_Required__c == 'Yes' ){
                                item.Date_Completed_BMSPM__c.addError('Value is required');
                            }*/
                        } 
                        
                        else if(OpportunityWorkflowUtility.productCodeMap.get('PFS').contains(item.Product_Group__c)){ 
                            
                            oi.Item_Type__c = 'PFS';
                            
                            if(item.Date_Completed_PFS__c == null && item.Service_Install_Required__c == 'Yes'){
                                oi.Completion_Status__c = 'Incomplete';
                                item.Date_Completed_PFS__c.addError('Value is required');
                            }
                            
                            /*if(item.Date_Completed_PFS__c == null && oi.Service_Install_Required__c == 'Yes' && item.Completion_Status__c == 'Complete'){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if (item.Date_Completed_PFS__c == null && (oi.Service_Install_Required__c == 'Yes' && item.Service_Install_Required__c == 'No')){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if(item.Date_Completed_PFS__c == null && oi.Service_Install_Required__c == 'Yes' ){
                                item.Date_Completed_PFS__c.addError('Value is required');
                            }*/
                            
                        } 
                        
                        else if(OpportunityWorkflowUtility.productCodeMap.get('Wide_Format').contains(item.Product_Group__c)){
                            
                            oi.Item_Type__c = 'PFSWF';

                            if(item.Date_Completed_PFS__c == null && item.Service_Install_Required__c == 'Yes'){
                                oi.Completion_Status__c = 'Incomplete';
                                item.Date_Completed_PFS__c.addError('Value is required');
                            }
                            
                            /*if(item.Date_Completed_PFS__c == null && oi.Service_Install_Required__c == 'Yes' && item.Completion_Status__c == 'Complete'){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if (item.Date_Completed_PFS__c == null && (oi.Service_Install_Required__c == 'Yes' && item.Service_Install_Required__c == 'No')){
                                oi.Completion_Status__c = 'Incomplete';
                            } else if(item.Date_Completed_PFS__c == null && item.Service_Install_Required__c == 'Yes' ){
                                item.Date_Completed_PFS__c.addError('Value is required');
                            }*/
                        }
                    } 
                    
                    else if(OpportunityWorkflowUtility.context == 'isInsert'){
                                                
                        boolean isClosed = [select isClosed from Opportunity where Id = :item.OpportunityId].isClosed;
                        
                        if(isClosed){
                            //item.addError('Products cannot be added to a closed Opportunity');
                        }
                        
                        if(item.Service_Install_Required__c == 'Yes' || item.Requires_Install__c){
                            oi.Completion_Status__c = 'Incomplete'; 
                        }
                    }
                    
                //} 
                
                OpportunityWorkflowUtility.lineItemsForUpdate.put(oi.Id, oi);
            }
        }
        
    }
    
    public static void getRequiredTemplateIds(){
        OpportunityWorkflowUtility.getRequiredTemplateIds();
    }
    
    public static void doFinanceCalculation(){
        OpportunityWorkflowUtility.doFinanceCalculation();
    }
    
    public static void doIsNeoPayRequired(){
        OpportunityWorkflowUtility.doIsNeopayRequired();
    }
    
    public static void doCheckLineItemPrice(){
    	OpportunityWorkflowUtility.doCheckLineItemPrice();
    }
    
    /*public static void doIsPricingApprovalRequired(){
        OpportunityWorkflowUtility.doIsPricingApprovalRequired();
    }*/

}