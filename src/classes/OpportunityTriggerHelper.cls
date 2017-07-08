public class OpportunityTriggerHelper extends OpportunityWorkflowUtility {

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

    public static void doUpdateOpportunities(){
        OpportunityWorkflowUtility.doUpdateOpportunities();
    }
    
    public static void doUpsertLineItems(){
        OpportunityWorkflowUtility.doUpsertLineItems();
    }

    public static void doValidateOpportunity(){
        
        boolean isValid = true;

        OpportunityWorkflowUtility.getProductCodeMap();
        OpportunityWorkflowUtility.getContractCodeMap();
        OpportunityWorkflowUtility.getlineitems();

        if(OpportunityWorkflowUtility.opportunity.Special_Rate_Required__c == null)
            OpportunityWorkflowUtility.oppsForUpdate.get(OpportunityWorkflowUtility.opportunity.Id).Finance_Approval_Status__c = 'Not Required';

        if(OpportunityWorkflowUtility.opportunity.isWon){

            boolean isDeliveryRequired = false;
            boolean isDigitalProduct = false;
            boolean isServiceInstallRequired = false;
            integer requiresMaintenanceContract = 0;
            integer hasMaintenanceContract = 0;
            boolean isFreePostValRequired = false;

            integer ContactRoleCount = [select count() from OpportunityContactRole
                                        where OpportunityId = : OpportunityWorkflowUtility.opportunity.Id];

            if(ContactRoleCount == 0){
                OpportunityWorkflowUtility.opportunity.addError('<br/>Opportunity must have a related Contact Role before being Closed Won', false);
                isValid = false;
            }

            // set checking variables
            for(OpportunityLineItem prod : OpportunityWorkflowUtility.lineitems){

                // requires service install?
                if(prod.Service_Install_Required__c == 'Yes'){
                    isServiceInstallRequired = true;
                }
                
                if(prod.Item_No__c == 'POST'){
                    system.debug('!!CONTAINS POST ITEM!!');
                    isFreePostValRequired = true;
                }

                // requires maintenance contract?
                if(OpportunityWorkflowUtility.opportunity.type != 'Re-rent'){
                    if(!OpportunityWorkflowUtility.productCodeMap.get('Maintenance_Exemptions').contains(prod.Item_No__c)){
                        if(prod.Product_Type__c == 'MA' && prod.Is_Primary_Product__c){
                            if(prod.TotalPrice >= 2000){
                                requiresMaintenanceContract += 1;
                            }
                        }
                    }
                }

                set<string> contractPrefixSet = new Set<string>();
                contractPrefixSet.add('M12');
                contractPrefixSet.add('M24');
                contractPrefixSet.add('M36');
                contractPrefixSet.add('M48');
                contractPrefixSet.add('M60');

                // has maintenance contract?
                if(contractPrefixSet.contains(prod.Item_No__c.left(3))){
                    hasMaintenanceContract += 1;
                    //OpportunityWorkflowUtility.opportunity.Has_Maintenance_Contract__c = true;
                }
            }

            if(isServiceInstallRequired){

                if(OpportunityWorkflowUtility.opportunity.Requested_Install_Date__c == null && OpportunityWorkflowUtility.opportunity.isWon){
                    OpportunityWorkflowUtility.opportunity.Requested_Install_Date__c.addError('Value is required');
                    OpportunityWorkflowUtility.opportunity.addError('<br/>Requested Install Date is required', false);
                    isValid = false;
                }

            }

            if(!OpportunityWorkflowUtility.opportunity.Request_for_No_Maintenance__c || (OpportunityWorkflowUtility.opportunity.Request_for_No_Maintenance__c && OpportunityWorkflowUtility.opportunity.Maintenance_Approval__c != 'Approved')){
                if(requiresMaintenanceContract > 0){
                    if(requiresMaintenanceContract > hasMaintenanceContract){
                        OpportunityWorkflowUtility.opportunity.addError('<br/>Opportunity has '+ requiresMaintenanceContract +' machines with a value greater than $2,000, and only '+ hasMaintenanceContract +'  maintenance contracts.<br/>Please ensure there is one maintenance contract for each machine.', false);
                        isValid = false;
                    }
                }
            }

            integer incompleteCount = [select count()
                                       from OpportunityLineItem
                                       where OpportunityId = :OpportunityWorkflowUtility.opportunity.Id
                                       and Service_Install_Required__c = 'Yes'
                                       and Completion_Status__c != 'Complete'];

            if(incompleteCount > 0){
                OpportunityWorkflowUtility.opportunity.addError('<br/>One or more Installation Checklists are Incomplete', false);
				isValid = false;                
            }

            if(!OpportunityWorkflowUtility.opportunity.Special_Rate_Required__c){
                OpportunityWorkflowUtility.oppsForUpdate.get(OpportunityWorkflowUtility.opportunity.Id).Finance_Approval_Status__c = 'Not Required';
            }

            if(isFreePostValRequired && OpportunityWorkflowUtility.opportunity.Free_Post_Amount__c == null){
                OpportunityWorkflowUtility.opportunity.Free_Post_Amount__c.addError('Value is Required');
                OpportunityWorkflowUtility.opportunity.addError('<br/>Free Post Amount is required', false);
                isValid = false;
            }
            
            if(isValid){
                OpportunityWorkflowUtility.oppsForUpdate.get(OpportunityWorkflowUtility.opportunity.Id).Movex_Sync_Flag__c = true;
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

    public static void doIsFreightRequired(){
        OpportunityWorkflowUtility.doIsFreightRequired();
    }

    public static void doIsFinanceApprovalRequired(){
        OpportunityWorkflowUtility.doIsFinanceApprovalRequired();
    }

    public static void doIsMaintenanceApprovalRequired(){
        OpportunityWorkflowUtility.doIsMaintenanceApprovalRequired();
    }

    public static void doCreateServicemaxCases(){
        OpportunityWorkflowUtility.doCreateServicemaxCases();
    }

    public static void doFreePostAlert(){
      OpportunityWorkflowUtility.doFreePostAlert();
    }

}