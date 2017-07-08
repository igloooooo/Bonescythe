global abstract class OpportunityWorkflowUtility {
    
    public static boolean isInOppTrigger = false;
    public static boolean isInLineItemTrigger = false;
    
    public static Opportunity opportunity = new Opportunity();
    public static map<id, Opportunity> oppsForUpdate = new map<Id, Opportunity>();
    
    public static List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    public static map<Id, OpportunityLineItem> lineItemsForUpdate = new map<Id, OpportunityLineItem>();
    public static List<OpportunityLineItem> lineItemsForUpsert = new List<OpportunityLineItem>();
    
    public static List<OpportunityLineItem> lineItemsForDelete = new List<OpportunityLineItem>();
    
    public static List<Case> casesForInsert = new List<Case>();
    
    public static map<string, string> contractCodeMap = new map<string,string>();
    public static map<string, string> productCodeMap = new map<string,string>();
    public static map<string, Id> congaTemplateMap = new map<string,string>();
    
    public static double totalMachineValue {get;set;}
    public static double totalContractValue {get;set;}
    
    public static boolean hasMaintenance {get;set;}
    
    public static map<string, RecordType> recordTypeMap{
        get{
            map<string, RecordType> rtMap = new map<string,RecordType>();
            List<RecordType> rtList = [select Id, Name, DeveloperName from RecordType where sObjectType = 'Opportunity'];
            
            for(RecordType rt : rtList){
                rtMap.put(rt.DeveloperName, rt);
            }
            return rtMap;
        }
    }
    
    public static string context {get;set;}
    
    public static void getProductCodeMap(){
        if(productCodeMap.isEmpty()){
            map<string,string> myMap = new map<string,string>();
            
            List<Product_Code_Map__mdt> codeList = [select DeveloperName, Codes__c
                                                    from Product_Code_Map__mdt];
            
            for(Product_Code_Map__mdt code : codeList){
                myMap.put(code.DeveloperName, code.Codes__c);
                if(!code.DeveloperName.contains('Maintenance_Contract')){
                    if(!myMap.containsKey('All_Machines')){
                        mymap.put('All_Machines', code.Codes__c + ',');
                    }
                    myMap.put('All_Machines', mymap.get('All_Machines') + code.Codes__c + ',');
                }
            }
            productCodeMap = myMap;
        }
    }
    
    public static void getContractCodeMap(){
        
        set<string> codeNameSet = new set<string>{
            'Standard_Maintenance_Contract',
                'Production_Maintenance_Contract',
                'RTB_Maintenance_Contract',
                'OLS_Rate_Protection',
                'Other_Maintenance_Items'
        };
        
        if(contractCodeMap.isEmpty()){
            map<string, string> myMap = new map<string, string>();
            List<Product_Code_Map__mdt> codeList = [select DeveloperName, Codes__c
                                                    from Product_Code_Map__mdt
                                                    where DeveloperName in :codeNameSet];
            
            for(Product_Code_Map__mdt code : codeList){
                myMap.put(code.DeveloperName, code.Codes__c);
                myMap.put('All_Contracts', mymap.get('All_Contracts') + code.Codes__c + ',');
            }
            
            contractCodeMap = myMap;
        }
    }
    
    public static void getCongaTemplateMap(){
        
        if(congaTemplateMap.isEmpty()){
            
            List<APXTConga4__Conga_Template__c> templates = [select Id, APXTConga4__Name__c from APXTConga4__Conga_Template__c];
            
            map<string, Id> myMap = new map<string, Id>();
            
            for(APXTConga4__Conga_Template__c temp : templates){
                myMap.put(temp.APXTConga4__Name__c, temp.Id);
            }
            
            congaTemplateMap = myMap;
        }
    }
    
    public static void getlineitems(){
        
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.OpportunityLineItem.fields.getMap();
        string lineItemQuery = 'SELECT ';
        
        for (String fieldName: schemaFieldMap.keySet()) {
            lineItemQuery += fieldName + ', ';
        }
        
        //lineItemQuery = lineItemQuery.removeEnd(', ');
        lineItemQuery += 'Opportunity.isClosed, Opportunity.isWon';
        
        lineItemQuery += ' FROM OpportunityLineItem '
            + 'where OpportunityId = \'' + opportunity.Id + '\' '
            + 'and Id not in :lineItemsForDelete ';
        //+ 'and Id not in :lineItems';
        
        List<OpportunityLineItem> items = database.query(lineItemQuery);
        
        if(!items.isEmpty()){
            lineItems = database.query(lineItemQuery);
        }
    }
    
    public static void doUpdateOpportunities(){
        List<Database.SaveResult> srList = database.update(oppsForUpdate.values());
    }
    
    public static void doUpdateLineItems(){
        List<Database.SaveResult> srList = database.update(lineItemsForUpdate.values());
    }
    
    public static void doUpsertLineItems(){
        List<Database.UpsertResult> srList = database.upsert(lineItemsForUpsert);
    }
    
    public static void getRequiredTemplateIds(){
        getCongaTemplateMap();
        getContractCodeMap();
        getProductCodeMap();
        
        string templatesIds = '';
        
        if(!lineitems.isEmpty()){
            for(OpportunityLineItem prod : lineitems){
                
                if(prod.Product_Group__c != null && productCodeMap.get('BMS_Postage_Meter').contains(prod.Product_Group__c)){
                    
                    templatesIds = congaTemplateMap.get('LAN Connection Form') + ','
                        + congaTemplateMap.get('LAN FAQ') + ','
                        + congaTemplateMap.get('Logo Creation Checklist') + ','
                        + congaTemplateMap.get('Australia Post License Application') + ',';
                    
                    if(prod.Postage_Payment_Type__c == 'Australia Post Account'){
                        templatesIds += congaTemplateMap.get('Australia Post Credit Application') + ',';
                        //'a0sp0000001Ga8j,';
                    } else if(prod.Postage_Payment_Type__c == 'Direct Debit'){
                        templatesIds += congaTemplateMap.get('Direct Debit Application') + ',';
                        //'a0sp0000001Ga8t,';
                    } else if(prod.Postage_Payment_Type__c == 'EFT'){
                        templatesIds += congaTemplateMap.get('EFT Form') + ',';
                        //'a0sp0000001Ga8Z,';
                    }
                }
                
                string contractCode = prod.Item_No__c.left(4);
                
                if(contractCode != null && contractCodeMap.get('All_Contracts').contains(contractCode)){
                    
                    if(contractCodeMap.get('Standard_Maintenance_Contract').contains(contractCode)){
                        // add standard maintenance contract
                        templatesIds += congaTemplateMap.get('Maintenance Contract - Standard') + ',';
                    } else if(contractCodeMap.get('Production_Maintenance_Contract').contains(contractCode)){
                        // add production maintenance contract
                        templatesIds += congaTemplateMap.get('Maintenance Contract - Production') + ',';
                    } else if(contractCodeMap.get('RTB_Maintenance_Contract').contains(contractCode)){
                        // add RTB contract
                        templatesIds += congaTemplateMap.get('Maintenance Contract - RTB') + ',';
                    } else  {
                        //
                    }
                }
            }
        }
        
        
        // determine required template IDs
        if(opportunity.Finance__c){
            // add finance document id
            templatesIds += congaTemplateMap.get('Finance Agreement') + ',';
        } else {
            // add external order schedule
            templatesIds += congaTemplateMap.get('External Order Schedule') + ',';
        }
        
        if(templatesIds != null){
            oppsForUpdate.get(opportunity.Id).Template_IDs__c = templatesIds.removeEnd(',');
        }
    }
    
    public static double totalFinancedAmount {get;set;}
    public static double financeRate {get;set;}
    public static double instalmentCount {get;set;}
    public static double financeRepaymentAmount {get;set;}
    public static double finalRepaymentAmount {get;set;}
    
    public static void getItemValues(){
        
        totalMachineValue = 0;
        totalContractValue = 0;
        hasMaintenance = false;
        
        // define Contract Code prefix set
        set<string> contractPrefixSet = new Set<string>();
        set<string> rateProtectionSet = new Set<string>();
        set<string> otherItemsSet = new Set<string>();
        
        system.debug('contractCodeMap.keyset(): ' + contractCodeMap.keyset());
        
        for(string mapName : contractCodeMap.keyset()){
            
            if(mapName != 'All_Contracts'){
                
                for(string code : contractCodeMap.get(mapName).split(',')){
                    
                    if(mapName == 'OLS_Rate_Protection'){
                        if(!rateProtectionSet.contains(code.left(4))){
                            rateProtectionSet.add(code.left(4));
                        }
                    }
                    
                    else if(mapName == 'Other_Maintenance_Items'){
                        if(!otherItemsSet.contains(code)){
                            otherItemsSet.add(code);
                        }
                    }
                    
                    else {
                        if(!contractPrefixSet.contains(code.left(3))){
                            contractPrefixSet.add(code.left(3));
                        }
                    }
                    
                }
            }
        }
        
        system.debug('@@@ contractPrefixSet : ' + contractPrefixSet);
        system.debug('@@@ rateProtectionSet : ' + rateProtectionSet);
        system.debug('@@@ otherItemsSet : ' + otherItemsSet);
        
        for(OpportunityLineItem prod : lineitems){
            
            // exclude anything with a negative quantity
            if(prod.Quantity > 0){
                
                // exclude existing NeoPay line item
                if(prod.Item_No__c != 'NEOPAY'){
                    
                    // add contracts to Contract value and set hasMaintenance to true
                    if(contractPrefixSet.contains(prod.Item_No__c.left(3))){
                        hasMaintenance = true;
                        totalContractValue += prod.totalPrice;
                    }
                    
                    // add OLS Rate Protection to Contract value
                    else if(rateProtectionSet.contains(prod.Item_No__c.left(4))){
                        totalContractValue += prod.totalPrice;
                    }
                    
                    // add other items to contract value
                    else if(otherItemsSet.contains(prod.Item_No__c)){
                        totalContractValue += prod.totalPrice;
                    }
                    
                    // Add Machines (without 'Payout' in the name) to Machine value
                    else if(!prod.Product_Name__c.toLowerCase().contains('payout')){
                        totalMachineValue += prod.totalPrice;
                    }
                }
            }
        }
        
        system.debug('@@@ totalMachineValue : ' + totalMachineValue);
        system.debug('@@@ totalContractValue : ' + totalContractValue);
    }
    
    public static void getTotalFinancedAmount(){
        
        double totalAmount = 0.0;
        
        /*if(opportunity.Customer_Class__c == 'OFF'){
totalAmount = totalMachineValue + totalContractValue;
} else */
        
        if(opportunity.Finance_Term__c == opportunity.Term_Maintenance__c || opportunity.Term_Maintenance__c == null){
            totalAmount = totalMachineValue;
        } else {
            totalAmount = totalMachineValue + totalContractValue;
        }
        
        totalFinancedAmount = totalAmount;
    }
    
    public static void getFinanceRate(){
        double fRate = 0.0;
        
        if(opportunity.Special_Rate_Required__c == true){
            fRate = opportunity.Rate__c;
        } else if(opportunity.Customer_Class__c == 'OFF'){
            List<Finance_Rate_Card__mdt> rateCard = [select Id, X24_Month_Rate__c, X36_Month_Rate__c, X48_Month_Rate__c,
                                                     X60_Month_Rate__c
                                                     from Finance_Rate_Card__mdt
                                                     where DeveloperName = 'Officeworks_Custom_Rate_Card'
                                                     limit 1];
            
            if(!rateCard.isEmpty()){
                if(opportunity.Finance_Term__c == '24 months'){
                    fRate = rateCard[0].X24_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '36 months'){
                    fRate = rateCard[0].X36_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '48 months') {
                    fRate = rateCard[0].X48_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '60 months'){
                    fRate = rateCard[0].X60_Month_Rate__c;
                }
            }
        } else {
            List<Finance_Rate_Card__mdt> rateCard = [select Id, X24_Month_Rate__c, X36_Month_Rate__c, X48_Month_Rate__c,
                                                     X60_Month_Rate__c
                                                     from Finance_Rate_Card__mdt
                                                     where Type__c = :opportunity.Finance_Payment_Frequency__c
                                                     and Starting_Value__c <= :totalFinancedAmount
                                                     and Ending_Value__c >= :totalFinancedAmount
                                                     and DeveloperName != 'Officeworks_Custom_Rate_Card'
                                                     limit 1];
            
            if(!rateCard.isEmpty()){
                if(opportunity.Finance_Term__c == '24 months'){
                    fRate = rateCard[0].X24_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '36 months'){
                    fRate = rateCard[0].X36_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '48 months') {
                    fRate = rateCard[0].X48_Month_Rate__c;
                } else if(opportunity.Finance_Term__c == '60 months'){
                    fRate = rateCard[0].X60_Month_Rate__c;
                }
            }
        }
        
        financeRate = fRate;
    }
    
    public static void getInstalmentCount(){
        double instalments = 0.0;
        
        integer term;
        integer divideBy;
        
        if(opportunity.Finance_Term__c == '24 months')
            term = 24;
        else if(opportunity.Finance_Term__c == '36 months')
            term = 36;
        else if(opportunity.Finance_Term__c == '48 months')
            term = 48;
        else if(opportunity.Finance_Term__c == '60 months')
            term = 60;
        
        if(opportunity.Finance_Payment_Frequency__c == 'Monthly')
            divideBy = 1;
        else if(opportunity.Finance_Payment_Frequency__c == 'Quarterly')
            divideBy = 3;
        
        instalments = term/divideBy;
        
        instalmentCount = instalments;
    }
    
    public static void getFinanceRepaymentAmount(){
        double repayments = (totalFinancedAmount * financeRate) / 1000;
        financeRepaymentAmount = repayments;
    }
    
    public static void getFinalRepaymentAmount(){
        double finalAmount = 0.0;
        if(opportunity.Finance_Term__c == opportunity.Term_Maintenance__c){
            finalAmount = financeRepaymentAmount + (totalContractValue / instalmentCount);
        } else if(opportunity.Finance_Term__c != opportunity.Term_Maintenance__c){
            finalAmount = financeRepaymentAmount;
        }
        finalRepaymentAmount = finalAmount;
    }
    
    public static void doFinanceCalculation(){
        if(!lineItems.isEmpty()){
            if(opportunity.Finance__c &&
               opportunity.Finance_Term__c != null &&
               opportunity.Finance_Payment_Frequency__c != null)
            {
                getTotalFinancedAmount();
                getFinanceRate();
                getInstalmentCount();
                getFinanceRepaymentAmount();
                getFinalRepaymentAmount();
                
                oppsForUpdate.get(opportunity.Id).Total_Amount_Financed__c = totalFinancedAmount;
                oppsForUpdate.get(opportunity.Id).Number_of_Instalments__c = instalmentCount;
                oppsForUpdate.get(opportunity.Id).Finance_Repayment_Amount__c = finalRepaymentAmount;
                oppsForUpdate.get(opportunity.Id).Rate__c = financeRate;
                oppsForUpdate.get(opportunity.Id).GST__c = finalRepaymentAmount * 0.1;
                oppsForUpdate.get(opportunity.Id).Total_Machine_Value__c = totalMachineValue;
                oppsForUpdate.get(opportunity.Id).Total_Maintenance_Value__c = totalContractValue;
                oppsForUpdate.get(opportunity.Id).Total_Maintenance_Amount__c = totalContractValue;
                oppsForUpdate.get(opportunity.Id).Total_Maintenance_Repayments__c = totalContractValue/instalmentCount;
                
            }
        }
    }
    
    public static void doIsFreightRequired(){
        
        if(!lineItems.isEmpty()){

            decimal actualValue = 0;
            OpportunityLineItem item = new OpportunityLineItem();
            boolean deleteItem = true;
            boolean isUpdate = false;
            
            for(OpportunityLineItem oi : lineItems){
                if(!oi.Product_Name__c.contains('PAYOUT')){
                    actualValue += oi.TotalPrice;
                }
            }
            
            for(OpportunityLineItem i : lineitems){
                if(i.Item_No__c == 'FREIGHT1'){
                    item.Id = i.Id;
                    isUpdate = true;
                }
            }
            
            system.debug('@@@@@@@@ ActualValue: ' + actualValue);
            
            if(actualValue <= 500){
                
                if (opportunity.Special_Delivery__c == 'Approved Exemption') {
                    system.debug('Sales Approved Exemption, no fee. ');
                } else if (opportunity.Special_Delivery__c == 'Sales Rep to Deliver') {
                    system.debug('Sales Rep to Deliver, no fee. ');
                } else if (opportunity.Special_Delivery__c == 'Customer to Collect') {
                    system.debug('Customer to Collect, no fee. ');
                } else if (opportunity.Special_Delivery__c == 'VIP Courier' ) {
                    item.UnitPrice = 50.0;
                    deleteItem = false;
                } else if (opportunity.Special_Delivery__c == 'Same Day Delivery') {
                    item.UnitPrice = 30.0;
                    deleteItem = false;
                } else if (opportunity.Freight__c == 'Standard' && actualValue <=200) {
                    item.UnitPrice = 25.0;
                    deleteItem = false;
                } else if (opportunity.Freight__c == 'Standard' && actualValue >200 && actualValue <500) {
                    item.UnitPrice = 20.0;
                    deleteItem = false;
                } else if (opportunity.Freight__c == 'Exempt over $200' && actualValue <=200) {
                    item.UnitPrice = 20.0;
                    deleteItem = false;
                } 
                
                if(!isUpdate){
                    
                    item.PricebookEntryId = [select Id
                                             from PricebookEntry
                                             where Product2.Item_No__c = 'FREIGHT1'
                                             and isActive = true
                                             and Pricebook2Id = :opportunity.Pricebook2Id
                                             limit 1
                                            ].Id;
                    
                    item.Quantity = 1;
                    item.OpportunityId = opportunity.Id;
                    item.Service_Install_Required__c = 'No';
                    item.WHS__c = lineItems[0].WHS__c;
                    item.Description = 'Freight';
                    
                    item.Completion_Status__c = 'Complete';
                }
                
                if(!deleteItem){
                    try{
                        database.upsert(item);
                        if(!isUpdate && opportunity.Requested_Delivery_Date__c != null){
                            oppsForUpdate.get(opportunity.Id).Requested_Delivery_Date__c = opportunity.Requested_Delivery_Date__c.addDays(5);
                        }
                    } catch (exception e){
                        system.debug('FREIGHT PRODUCT COULD NOT BE ADDED: ' + e.getMessage());
                    }
                } else {
                    if(isUpdate){
                        database.delete(item);
                        system.debug('@@@@@@@@ opportunity.Requested_Delivery_Date__c: ' + opportunity.Requested_Delivery_Date__c);
                        if(opportunity.Requested_Delivery_Date__c != null){
                            oppsForUpdate.get(opportunity.Id).Requested_Delivery_Date__c = opportunity.Requested_Delivery_Date__c.addDays(-5);
                        }
                        system.debug('@@@@@@@@ oppsForUpdate.get(opportunity.Id).Requested_Delivery_Date__c: ' + oppsForUpdate.get(opportunity.Id).Requested_Delivery_Date__c);
                    }
                }
            } else {
                if(isUpdate){
                    database.delete(item);
                    if(opportunity.Requested_Delivery_Date__c != null){
                    	oppsForUpdate.get(opportunity.Id).Requested_Delivery_Date__c = opportunity.Requested_Delivery_Date__c.addDays(-5);
                    }
                }
            }
        }
    }
    
    public static void doIsNeopayRequired(){
        
        if(!lineItems.isEmpty()){
            
            getItemValues();
            boolean requiresNeopay = false;
            
            OpportunityLineItem item = new OpportunityLineItem();
            
            for(OpportunityLineItem i : lineitems){
                if(i.Item_No__c == 'NEOPAY'){
                    item.Id = i.Id;
                }
            }
            
            system.debug('hasMaintenance : ' + hasMaintenance);
            system.debug('Direct_Debit__c : ' + opportunity.Direct_Debit__c);
            
            if(opportunity.Payment_Method__c != null && opportunity.Payment_Method__c.toLowerCase() == 'neopost finance'){
                
                if(opportunity.Finance_Term__c != null && opportunity.Term_Maintenance__c != null){
                    
                    if(opportunity.Finance_Term__c == opportunity.Term_Maintenance__c ||
                       (opportunity.Finance_Term__c != opportunity.Term_Maintenance__c && opportunity.Direct_Debit__c == 'No') /*||
                       (opportunity.Finance_Term__c != opportunity.Term_Maintenance__c && opportunity.Finance__c)*/
                      )
                    {
                        if(opportunity.Finance__c)
                            requiresNeopay = true;
                    }
                }
                
                if(!hasMaintenance && opportunity.Direct_Debit__c != 'Yes'){
                    requiresNeopay = true;
                }
            }
            
            if(requiresNeopay){
                
                if(item.id == null){
                    item.PricebookEntryId = [select Id
                                             from PricebookEntry
                                             where Product2.Item_No__c = 'NEOPAY'
                                             and isActive = true
                                             and Pricebook2Id = :opportunity.Pricebook2Id
                                             limit 1
                                            ].Id;
                    
                    item.Quantity = 1;
                    item.OpportunityId = opportunity.Id;
                    item.Service_Install_Required__c = 'No';
                    //item.UnitPrice = amount;
                    item.Completion_Status__c = 'Complete';
                }
                
                if(totalmachineValue < 9849 ){
                    item.UnitPrice = 150;
                    totalmachineValue = totalmachineValue + 150;
                } else if(totalmachineValue > 35000){
                    item.UnitPrice = 400;
                    totalmachineValue = totalmachineValue + 400;
                } else {
                    item.UnitPrice = 300;
                    totalmachineValue = totalmachineValue + 300;
                }
                
                try{
                    database.upsert(item);
                } catch (exception e){
                    system.debug('NEOPAY PRODUCT COULD NOT BE ADDED: ' + e.getMessage());
                }
                
            } else {
                if(item.Id != null)
                    database.delete(item);
            }
        }
    }
    
    public static void doCreateServicemaxCases(){
        
        OpportunityContactRole[] con = [select Id, ContactId from OpportunityContactRole where OpportunityId = :opportunity.Id limit 1];
        string queueId = [select Id from Group where DeveloperName = 'Installations' limit 1].Id;
        
        for(OpportunityLineItem lineItem : lineItems){
            
            if(lineItem.Service_Install_Required__c == 'Yes' && lineItem.Is_Primary_Product__c == true){
                
                Case c = new Case();
                c.Opportunity__c = opportunity.Id;
                c.AccountId = opportunity.AccountId;
                if(!con.isEmpty()){
                    c.ContactId = con[0].ContactId;
                }
                c.PQ_Customer_Requested_Date__c = opportunity.Requested_Install_Date__c;
                c.Origin = 'Opportunity';
                c.Subject = ' Pending Installation';
                c.Status = 'Open';
                c.Type = 'Pending Install';
                c.SVMXC__Product__c = lineItem.Product2Id;
                c.OwnerId = queueId;
                
                casesForInsert.add(c);
            }
        }
        
        if(!casesForInsert.isEmpty()){
            database.insert(casesForInsert);
        }
    }
    
    public static void doIsFinanceApprovalRequired(){
        if(opportunity.Finance_Approval_Status__c != 'Approved' &&
           opportunity.Finance_Approval_Status__c != 'Rejected' &&
           opportunity.Finance_Approval_Status__c != 'Pending' &&
           opportunity.Special_Rate_Required__c){
               if(opportunity.Rate__c == null){
                   opportunity.Rate__c.addError('Value is required');
                   opportunity.addError('Rate is required when requesting Special Rate approval');
               } else {
                   try{
                       Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                       psr.setObjectId(opportunity.Id);
                       psr.setSkipEntryCriteria(true);
                       psr.setProcessDefinitionNameOrId('Special_Finance_Rate_Request');
                       
                       Approval.process(psr);
                       
                       oppsForUpdate.get(opportunity.Id).Finance_Approval_Status__c = 'Pending';
                   } catch (exception e){
                       //opportunity.addError(e.getCause());
                   }
               }
           }
    }
    
    public static void doIsMaintenanceApprovalRequired(){
        if(opportunity.Maintenance_Approval__c != 'Approved' &&
           opportunity.Maintenance_Approval__c != 'Rejected' &&
           opportunity.Request_for_No_Maintenance__c){
               
               try{
                   Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                   psr.setObjectId(opportunity.Id);
                   psr.setSkipEntryCriteria(true);
                   psr.setProcessDefinitionNameOrId('Request_for_No_Maintenance');
                   
                   Approval.process(psr);
                   
               } catch (exception e){
                   //Approval.lock(opportunity.Id);
                   opportunity.addError(e.getMessage());
               }
               
           }
    }

    private static boolean requiresPMApproval {get; private set;}
    private static boolean requiresMGMTApproval {get; private set;}
    
    webservice static void doIsPricingApprovalRequired(string oppId){
        
        requiresPMApproval = false;
        requiresMGMTApproval = false;
        
        Opportunity o = [SELECT Id, Floor_Price_Exempt__c, Price_Approval__c,
                         (select Id, Requires_PM_Price_Approval__c, Requires_MGMT_Price_Approval__c
                          from OpportunityLineItems)
                         FROM Opportunity
                         WHERE Id = :oppId];
        
        system.debug('o.OpportunityLineItems : ' + o.OpportunityLineItems);
        
        for(OpportunityLineItem lineItem : o.OpportunityLineItems){
            if(lineItem.Requires_PM_Price_Approval__c){
                requiresPMApproval = true;
            }
            
            if(lineItem.Requires_MGMT_Price_Approval__c){
                requiresMGMTApproval = true;
            }
        }
        
        system.debug('o.Floor_Price_Exempt__c: ' + o.Floor_Price_Exempt__c);
        system.debug('o.Price_Approval__c: ' + o.Price_Approval__c);
        system.debug('requiresPMApproval:' + requiresPMApproval);
        system.debug('requiresMGMTApproval:' + requiresMGMTApproval);
        
        
        if(!o.Floor_Price_Exempt__c){
            
            if(!o.Price_Approval__c){
                
                system.debug('Price Approval is False');
                system.debug('PM Approval Required? ' + requiresPMApproval);
                system.debug('MGMT Approval Required? ' + requiresMGMTApproval);
                
                Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                psr.setObjectId(o.Id);
                //psr.setSkipEntryCriteria(true);
                
                // below product management pricing (floor) = product manager approval required
                if(requiresPMApproval != null && requiresPMApproval){
                    // enter Product Manager approval
                    
                    psr.setProcessDefinitionNameOrId('Product_Manager_Floor_Price_Approval');
                    try{
                        Approval.process(psr);
                        Approval.unlock(o, true);
                    } catch (exception e){
                        //opportunity.addError(e.getMessage());
                    }
                }
                
                // above management pricing (ceiling) = management approval required
                else if(requiresMGMTApproval != null && requiresMGMTApproval){
                    // enter Product Manager approval
                    
                    psr.setProcessDefinitionNameOrId('Rep_Manager_Floor_Price_Approval');
                    try{
                        Approval.process(psr);
                        Approval.unlock(o, true);
                    } catch (exception e){
                        //opportunity.addError(e.getMessage());
                        system.debug('Error submitting for approval: ' + e);
                    }
                }
            }
        }
    }
    
    public static void doCheckLineItemPrice(){
        
        requiresPMApproval = false;
        requiresMGMTApproval = false;
        
        system.debug('LineItems ' + lineItems);
        
        // check that the Opportunity does not already have Price Approval
        if(!opportunity.Price_Approval__c){
            
            // if there are OpportunityLineItem records to be checked
            if(!lineItems.isEmpty()){
                
                // loop through the OpportunityLineItems
                for(OpportunityLineItem lineItem : lineItems) {
                    
                    system.debug('LineItem.Id ' + lineItem.Id);
                    system.debug('UnitPrice: ' + lineitem.UnitPrice);
                    system.debug('Product_Manager_Qualifying_Amount__c: ' + lineitem.Product_Manager_Qualifying_Amount__c);
                    system.debug('Management_Qualifying_Amount__c: ' + lineitem.Management_Qualifying_Amount__c);

                    // If Product Type = 'CO'
                    if(lineItem.Product_Type__c == 'CO'){
                        if(lineItem.UnitPrice == 0 || (lineItem.UnitPrice > lineItem.Product_Manager_Qualifying_Amount__c && lineItem.UnitPrice < lineItem.Management_Qualifying_Amount__c)){

                            // does this Line Item already exist in the lineItemsForUpdate map?
                            if(lineItemsForUpdate.keySet().contains(lineItem.Id)){
                                // if yes, update
                                lineItemsForUpdate.get(lineItem.Id).FloorPriceStatus__c = 'DR';
                                lineItemsForUpdate.get(lineItem.Id).Requires_MGMT_Price_Approval__c = true;
                                lineItemsForUpdate.get(lineItem.Id).Requires_PM_Price_Approval__c = false;
                                
                            } else {
                                // if no, create ghost record
                                OpportunityLineItem item = new OpportunityLineItem();
                                item.Id = lineItem.Id;
                                item.FloorPriceStatus__c = 'DR';
                                item.Requires_MGMT_Price_Approval__c = true;
                                item.Requires_PM_Price_Approval__c = false;
                                
                                // add ghost to map
                                lineItemsForUpdate.put(lineItem.Id, item);
                            }
                            
                            // update oppForUpdate ghost
                            // oppsForUpdate.get(lineItem.OpportunityId).FloorPriceStatus__c = 'DR';
                        } else if (lineItem.UnitPrice > 0 && lineItem.UnitPrice < lineItem.Product_Manager_Qualifying_Amount__c){
                            
                            if(lineItemsForUpdate.keySet().contains(lineItem.Id)){
                                lineItemsForUpdate.get(lineItem.Id).FloorPriceStatus__c = 'EM';
                                lineItemsForUpdate.get(lineItem.Id).Requires_PM_Price_Approval__c = true;
                                lineItemsForUpdate.get(lineItem.Id).Requires_MGMT_Price_Approval__c = false;
                            } else {
                                OpportunityLineItem item = new OpportunityLineItem();
                                item.Id = lineItem.Id;
                                item.FloorPriceStatus__c = 'EM';
                                item.Requires_PM_Price_Approval__c = true;
                                item.Requires_MGMT_Price_Approval__c = false;
                                
                                lineItemsForUpdate.put(lineItem.Id, item);
                            }
                            
                            //oppForUpdate.FloorPriceStatus__c = 'EM';
                        } else {
                            
                            if(lineItemsForUpdate.keySet().contains(lineItem.Id)){
                                lineItemsForUpdate.get(lineItem.Id).FloorPriceStatus__c = ' ';
                                lineItemsForUpdate.get(lineItem.Id).Requires_PM_Price_Approval__c = false;
                                lineItemsForUpdate.get(lineItem.Id).Requires_MGMT_Price_Approval__c = false;
                            } else {
                                OpportunityLineItem item = new OpportunityLineItem();
                                item.Id = lineItem.Id;
                                item.FloorPriceStatus__c = ''; 
                                item.Requires_PM_Price_Approval__c = false;
                                item.Requires_MGMT_Price_Approval__c = false;
                                
                                lineItemsForUpdate.put(lineItem.Id, item);
                            }
                            
                            //oppForUpdate.FloorPriceStatus__c = ' ';
                        }
                    }
                    
                    //  Else if Product Type = 'MA'
                    if(lineItem.Product_Type__c == 'MA'){
                        
                        // if the item price is greater than 0 AND less than the Product Manager qualifying amount
                        if(lineItem.UnitPrice == 0 || (lineItem.UnitPrice > 0 && lineItem.UnitPrice < lineItem.Management_Qualifying_Amount__c)){
                            
                            if(lineItemsForUpdate.keySet().contains(lineItem.Id)){
                                lineItemsForUpdate.get(lineItem.Id).FloorPriceStatus__c = 'DR';
                                lineItemsForUpdate.get(lineItem.Id).Requires_MGMT_Price_Approval__c = true;
                                lineItemsForUpdate.get(lineItem.Id).Requires_PM_Price_Approval__c = false;
                            } else {
                                OpportunityLineItem item = new OpportunityLineItem();
                                item.Id = lineItem.Id;
                                item.FloorPriceStatus__c = 'DR';
                                item.Requires_MGMT_Price_Approval__c = true;
                                item.Requires_PM_Price_Approval__c = false;
                                
                                lineItemsForUpdate.put(lineItem.Id, item);
                            }
                            
                            //oppForUpdate.FloorPriceStatus__c = 'EM';
                        } else {
                            
                            if(lineItemsForUpdate.keySet().contains(lineItem.Id)){
                                lineItemsForUpdate.get(lineItem.Id).FloorPriceStatus__c = '';
                                lineItemsForUpdate.get(lineItem.Id).Requires_MGMT_Price_Approval__c = false;
                                lineItemsForUpdate.get(lineItem.Id).Requires_PM_Price_Approval__c = false;
                            } else {
                                OpportunityLineItem item = new OpportunityLineItem();
                                item.Id = lineItem.Id;
                                item.FloorPriceStatus__c = '';
                                item.Requires_PM_Price_Approval__c = false;
                                item.Requires_MGMT_Price_Approval__c = false;
                                
                                lineItemsForUpdate.put(lineItem.Id, item);
                            }
                            
                            //oppForUpdate.FloorPriceStatus__c = ' ';
                        }
                    }
                }
            }
        }
    }
    
    public static void doFreePostAlert(){
        if(opportunity.Free_Post_Amount__c != null){
            
            string htmlBody = 'An Opportunity has been marked as Free Post with the following details:<br/><br/>'
                + '<strong>Account Name:</strong> ' + [select Name from Account where Id = :opportunity.AccountId limit 1].Name + '<br/>'
                + '<strong>Opportunity Number:</strong> ' + opportunity.Opportunity_Number__c + '<br/>'
                + '<strong>Free Post Amount:</strong> $' + opportunity.Free_Post_Amount__c.setScale(2) + '<br/><br/>'
                + '<a href="' + Url.getSalesforceBaseUrl().toExternalForm() + '\\' + opportunity.Id + '">Click here</a> to view the Opportunity record';
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            
            email.setToAddresses(new List<string>{'k.burke@neopost.com'});
            //email.setToAddresses(new List<string>{'matt@systemlabs.com.au'});
            email.setSubject('Free Post Alert - ' + opportunity.Name);
            email.setHTMLBody(htmlBody);
            //email.setWhatId(opportunity.Id);
            //email.setSaveAsActivity(true);
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {email};
                Messaging.SendEmailResult[] sendResult = Messaging.SendEmail(messages);
            
        }
    }
}