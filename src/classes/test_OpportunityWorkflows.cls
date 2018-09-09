@isTest//(seealldata=true)
public class test_OpportunityWorkflows {

    //public static OpportunityTriggerUtility util = new OpportunityTriggerUtility();

    @testSetup static void insertRecords(){

        // insert Account
        Account a = new Account();
            a.Name = 'Test Account';
            a.BillingStreet = '123 Street Rd';
            a.BillingCity = 'Sydney';
            a.BillingState = 'NSW';
            a.BillingPostalcode = '2000';
            a.BillingCountry = 'Australia';
            a.Entity_Name__c = 'Test Account Pty Ltd';
            a.Entity_Type__c = 'Company';
        insert a;

        // insert Contact
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'dev@prolytics.com.au';
        c.Phone = '0444444444';
        c.AccountId = a.Id;
        insert c;

        List<Product2> prodList = new List<Product2>();

        // insert Products
        Product2 bms = new Product2();
            bms.Name = 'Test BMS';
            bms.Product_Group__c = 'MMI';
            bms.Product_Type__c = 'MA';
            bms.is_primary_Product__c = true;
            bms.Service_Install_Required__c = true;
            bms.IsActive = true;
            bms.Item_No__c = 'BMS1234';
            bms.Cost__c = 3000;
            bms.Product_Manager_Qualifi__c = 1000;
            bms.Management_Qualifying_Amount__c = 2000;
        prodList.add(bms);

        Product2 bmspm = new Product2();
            bmspm.Name = 'Test BMSPM';
            bmspm.Product_Group__c = 'MMF';
            bmspm.Product_Type__c = 'MA';
            bmspm.is_primary_Product__c = true;
            bmspm.IsActive = true;
            bmspm.Item_No__c = 'BMSPM1234';
            bmspm.Cost__c = 1000;
            bmspm.Service_Install_Required__c = true;
            bmspm.Product_Manager_Qualifi__c = 250;
            bmspm.Management_Qualifying_Amount__c = 500;
        prodList.add(bmspm);

        Product2 pfs = new Product2();
            pfs.Name = 'Test PFS';
            pfs.Product_Group__c = 'MGD';
            pfs.Product_Type__c = 'MA';
            pfs.is_primary_Product__c = true;
            pfs.IsActive = true;
            pfs.Item_No__c = 'PFS1234';
            pfs.Cost__c = 2000;
            pfs.Service_Install_Required__c = true;
            pfs.Product_Manager_Qualifi__c = 500;
            pfs.Management_Qualifying_Amount__c = 1000;
        prodList.add(pfs);

        Product2 pfswf = new Product2();
            pfswf.Name = 'Test PFSWF';
            pfswf.Product_Group__c = 'MIJ';
            pfswf.Product_Type__c = 'MA';
            pfswf.is_primary_Product__c = true;
            pfswf.IsActive = true;
            pfswf.Item_No__c = 'PFSWS1234';
            pfswf.Cost__c = 2000;
            pfswf.Service_Install_Required__c = false;
            pfswf.Product_Manager_Qualifi__c = 500;
            pfswf.Management_Qualifying_Amount__c = 1000;
        prodList.add(pfswf);

        Product2 consumable = new Product2();
            consumable.Name = 'Test CO1';
            consumable.Product_Group__c = 'CO';
            consumable.Product_Type__c = 'CO';
            consumable.is_primary_Product__c = true;
            consumable.IsActive = true;
            consumable.Item_No__c = 'CO1234';
            consumable.Cost__c = 2000;
            consumable.Service_Install_Required__c = false;
            consumable.Product_Manager_Qualifi__c = 500;
            consumable.Management_Qualifying_Amount__c = 1000;
        prodList.add(consumable);

        Product2 consumable2 = new Product2();
            consumable2.Name = 'Test CO2';
            consumable2.Product_Group__c = 'CO';
            consumable2.Product_Type__c = 'CO';
            consumable2.is_primary_Product__c = true;
            consumable2.IsActive = true;
            consumable2.Item_No__c = 'CO1234';
            consumable2.Cost__c = 2000;
            consumable2.Service_Install_Required__c = false;
            consumable2.Product_Manager_Qualifi__c = 500;
            consumable2.Management_Qualifying_Amount__c = 1000;
        prodList.add(consumable2);

        Product2 NEOPAY = new Product2();
            NEOPAY.Name = 'NEOPAY';
            NEOPAY.Product_Group__c = 'MIJ';
            NEOPAY.Product_Type__c = 'MA';
            //NEOPAY.is_primary_Product__c = true;
            NEOPAY.IsActive = true;
            NEOPAY.Item_No__c = 'NEOPAY';
            NEOPAY.Cost__c = 2000;
        prodList.add(NEOPAY);

        Product2 FREIGHT = new Product2();
            FREIGHT.Name = 'FREIGHT';
            FREIGHT.Product_Group__c = 'MIJ';
            FREIGHT.Product_Type__c = 'MA';
            //NEOPAY.is_primary_Product__c = true;
            FREIGHT.IsActive = true;
            FREIGHT.Item_No__c = 'FREIGHT1';
            FREIGHT.Cost__c = 1;
        prodList.add(FREIGHT);

        for(integer i=0; i<3; i++){
            Product2 maint1 = new Product2();
                maint1.Name = 'Test MAINTENANCE';
                maint1.Product_Group__c = 'SMT';
                maint1.Product_Type__c = 'SM';
                maint1.IsActive = true;
                maint1.Item_No__c = 'M12POST';
                maint1.Cost__c = 2000;
            prodList.add(maint1);
        }
        database.insert(prodList);

        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        string standardPricebookId = test.getStandardPricebookId();

        // Add Pricebook Entries
        for(Product2 prod : prodList){

            PricebookEntry pbe = new PricebookEntry();
                pbe.IsActive = true;
                pbe.Pricebook2Id = standardPricebookId;
                pbe.Product2Id = prod.Id;
                pbe.UnitPrice = prod.Cost__c;

            pbeList.add(pbe);
        }

        database.insert(pbeList);
        
        system.debug('@@@@ pbes : ' + [select Id, Product2Id, Product2.Name, Pricebook2Id from PricebookEntry]);
        system.debug('@@@@ standardPricebookId : ' + standardPricebookId);

        //insert shipping address
        Address__c address = new Address__c();
        address.Customer__c = a.Id;
        address.Street__c = 'asdf';
        address.Suburb__c = 'zcxv';
        address.State__c = 'nsw';
        address.Address_ID__c = '7916';
        insert address;

        //insert Opportunity
        Opportunity o = new Opportunity();
            o.Name = 'Test Opportunity';
            o.StageName = 'Negotiation/Review';
            o.CloseDate = system.today().addDays(30);
            o.AccountId = a.Id;
            o.Requested_Delivery_Date__c = system.today().addDays(45);
            o.Type = 'New Business';
            o.LeadSource = 'Referral';
            o.Payment_Method__c = 'Neopost Finance';
            o.Ship_Address_Default__c = address.Id;
            //o.Pricebook2Id = standardPricebookId;
            //o.Term_Maintenance__c = '60 Months';
            //o.Finance_Term__c = '60 Months';
            //o.Special_Rate_Required__c = true;
            //o.Rate__c = 50.0;
         insert o;


        //insert OpportunityContactRole
        OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = o.id;
            ocr.ContactId = c.Id;
            ocr.isPrimary = true;
        insert ocr;

        // insert Opportunity Line Items
        List<OpportunityLineItem> items = new List<OpportunityLineItem>();

        pbeList = [select Id, Product2.Name, UnitPrice, Product2.Product_Type__c from PricebookEntry];

        for(PricebookEntry pbeRecord : pbeList){

            if(pbeRecord.Product2.Name != 'NEOPAY' && pbeRecord.Product2.Name != 'FREIGHT'){

                OpportunityLineItem oi = new OpportunityLineItem();
                oi.OpportunityId = o.Id;
                oi.PricebookEntryId = pbeRecord.Id;
                oi.Quantity = 1;
                oi.UnitPrice = pbeRecord.UnitPrice;

                // set product values based on type
                if(pbeRecord.Product2.Name == 'Test BMSPM'){
                    oi.Service_Install_Required__c = 'No';
                    oi.item_type__c = 'BMSPM';
                } else if(pbeRecord.Product2.Name == 'Test BMS'){
                    oi.Service_Install_Required__c = 'Yes';
                    oi.Item_Type__c = 'BMS';
                    //oi.UnitPrice = 500;
                } else if(pbeRecord.Product2.Name == 'Test PFS'){
                    oi.Service_Install_Required__c = 'No';
                    oi.Item_Type__c = 'PFS';
                } else if(pbeRecord.Product2.Name == 'Test PFSWF'){
                    oi.Item_Type__c = 'PFSWF';
                    oi.Service_Install_Required__c = 'Yes';
                }

                items.add(oi);
            }
        }

        database.insert(items);

    }

    public static testmethod void test_NoContactRole_OpportunityUpdate(){

        Opportunity opp = [select Id, StageName, (select Id, Date_Completed_bms__c, Date_Completed_BMSPM__c, Date_Completed_PFS__c, Product2Id, Product2.Name from OpportunityLineItems) from Opportunity where Name = 'Test Opportunity' limit 1];
        database.delete([select Id from OpportunityContactRole where OpportunityId = :opp.Id limit 1]);

        // complete checklists
        for(OpportunityLineItem item : opp.OpportunityLineItems){

            if(item.Product2.Name == 'TEST BMS'){
                item.Date_Completed_BMS__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'Standard';
            } else if(item.Product2.Name == 'TEST BMSPM'){
                item.Date_Completed_BMSPM__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'Production';
            } else if(item.Product2.Name == 'TEST PFS'){
                item.Date_Completed_PFS__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'RTB';
            } else if(item.Product2.Name == 'TEST PFSWF'){
                item.Date_Completed_PFS__c = system.today().addDays(14);
            }

            update item;
        }

        test.startTest();

        try{
            opp.StageName = 'Closed Won';
            update opp;
        } catch (exception e){
            system.debug('###### e.getMessage() : ' + e.getMessage());
            //system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Opportunity must have a related Contact Role before being Closed Won'));
        }

        test.stopTest();
    }
    
    public static testmethod void test_FinanceRateCalculation_OpportunityUpdate(){
        
        Opportunity opp = [select Id, Finance__c from Opportunity where Name = 'Test Opportunity' limit 1];
        
        test.startTest();
            opp.Finance__c = true;
            opp.Term_Maintenance__c = '60 Months';
            opp.Finance_Term__c = '60 Months';
            opp.Finance_Payment_Frequency__c = 'Monthly';
            database.update(opp);
        test.stopTest();
    }

    public static testmethod void test_SpecialRate_OpportunityInsert(){

        test.startTest();

        // retrieve Account
        Account a = [select Id from Account where Name = 'Test Account' limit 1];

        // insert Opportunity
        Opportunity o = new Opportunity();
            o.Name = 'Test Opportunity';
            o.Amount = 10000;
            o.StageName = 'Lead (Qualification)';
            o.CloseDate = system.today().addDays(30);
            o.AccountId = a.Id;
            o.Requested_Delivery_Date__c = system.today().addDays(45);
            o.Type = 'New Business';
            o.LeadSource = 'Referral';
            o.Special_Rate_Required__c = true;
            o.Special_Rate_Required_Comments__c = 'for testing.';
            o.Rate__c = 50.0;
            o.Finance__c = true;
            o.Finance_Payment_Frequency__c = 'Monthly';
            o.Finance_Term__c = '60 Months';
            o.Term_Maintenance__c = '60 Months';

        insert o;

        test.stopTest();

    }

    public static testmethod void test_SpecialRate_OpportunityUpdate(){

        Opportunity opp = [select Id, Special_Rate_Required__c, Rate__c from Opportunity where Name = 'Test Opportunity' limit 1];

        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                                Where TargetObjectID = :opp.Id];

        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};

        for(ProcessInstance instance : pi){

            for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments('Approved');
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);

            }
        }

        if(!prWkItems.isEmpty()){
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }

        test.startTest();
            opp.Special_Rate_Required__c = true;
            opp.Rate__c = 50.0;
            opp.Special_Rate_Required_Comments__c = 'for testing.';
            update opp;
        test.stopTest();

    }

    public static testmethod void test_Officeworks_OpportunityInsert(){

        Account acc = [select Id, Customer_Class__c from Account where Name = 'Test Account' limit 1];
        acc.Customer_Class__c = 'OFF';

        Opportunity opp = [select Id, Finance__c, Finance_Term__c, Finance_Payment_Frequency__c from Opportunity where Name = 'Test Opportunity' limit 1];

        opp.Finance__c = true;
        opp.Finance_Term__c = '60 months';
        opp.Finance_Payment_Frequency__c = 'Monthly';

        test.startTest();

            update acc;
            update opp;

        test.stopTest();

    }

    public static testmethod void test_NoMaintenance_OpportunityUpdate(){

        Opportunity opp = [select Id, Request_for_No_Maintenance__c from Opportunity where Name = 'Test Opportunity' limit 1];

        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                                Where TargetObjectID = :opp.Id];

        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};

        for(ProcessInstance instance : pi){

            for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments('Approved');
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);

            }
        }

        if(!prWkItems.isEmpty()){
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }

        test.startTest();
            opp.Request_for_No_Maintenance__c = true;
            update opp;
        test.stopTest();

    }

    public static testmethod void test_IncompleteChecklists_OpportunityUpdate(){

        Opportunity opp = [select Id, Requested_Install_Date__c, StageName from Opportunity where Name = 'Test Opportunity' limit 1];
        //OpportunityWorkflowUtility.opportunity = opp;

        test.startTest();

        try{
            opp.Requested_Install_Date__c = system.today().addDays(30);
            opp.StageName = 'Closed Won';
            update opp;
        } catch (exception e){
            system.debug('@@@@ Closed Won Failing: ' + e);
        }

        List<OpportunityLineItem> items = [select Id, Product2.Name,Date_Completed_BMS__c, Date_Completed_BMSPM__c, Date_Completed_PFS__c, Maintenance_Contract_Type__c
                                           from OpportunityLineItem where Product2.Name like 'TEST%'];

        for(OpportunityLineItem item : items){
            if(item.Product2.Name == 'TEST BMS'){
                item.Date_Completed_BMS__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'Standard';
            } else if(item.Product2.Name == 'TEST BMSPM'){
                item.Date_Completed_BMSPM__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'Production';
            } else if(item.Product2.Name == 'TEST PFS'){
                item.Date_Completed_PFS__c = system.today().addDays(14);
                item.Maintenance_Contract_Type__c = 'RTB';
            } else if(item.Product2.Name == 'TEST PFSWF'){
                item.Date_Completed_PFS__c = system.today().addDays(14);
            }
        }


        update items;

        try{
            opp.Finance__c = true;
            opp.Finance_Payment_Frequency__c = 'Monthly';
            opp.Finance_Term__c = '60 Months';
            opp.Term_Maintenance__c = '60 Months';
            opp.StageName = 'Closed Won';
            update opp;
        } catch (exception e){
            system.debug('@@@@ Closed Won Failing: ' + e);
        }

        test.stopTest();

    }

    public static testMethod void test_OpportunityAddNeopayItem(){

        Opportunity opp = [select Id, finance__c, finance_Payment_Frequency__c, finance_term__c, term_Maintenance__c from Opportunity limit 1];

        opp.finance_term__c = '24 months';
        opp.Term_Maintenance__c = '24 months';
        opp.Finance__c = true;

        test.startTest();
            update(opp);
        test.stopTest();

    }

    public static testmethod void test_OpportunityLineItemDelete(){

        OpportunityLineItem item  = [select id from OpportunityLineItem limit 1];

        test.startTest();
            database.delete(item);
        test.stopTest();

    }

    public static testmethod void test_APPostagePaymentType_OpportunityLineItemUpdate(){

        List<OpportunityLineItem> bmspmItems = [select Id, Postage_Payment_Type__c, Date_Completed_BMSPM__c, Date_Completed_BMS__c, Date_Completed_PFS__c
                                                from OpportunityLineItem
                                                where Product2.Name like '%BMSPM'];

        test.startTest();

        for(OpportunityLineItem bmspmItem : bmspmItems){
                bmspmItems[0].Postage_Payment_Type__c = 'Australia Post Account';
                bmspmItems[0].Date_Completed_BMSPM__c = system.today();
        }

        database.update(bmspmItems);

        test.stopTest();

    }

    public static testmethod void test_DirectDebitPostagePaymentType_OpportunityLineItemUpdate(){

        List<OpportunityLineItem> bmspmItems = [select Id, Postage_Payment_Type__c, Date_Completed_BMSPM__c, Date_Completed_BMS__c, Date_Completed_PFS__c
                                                from OpportunityLineItem
                                                where Product2.Name like '%BMSPM'];

        test.startTest();

        for(OpportunityLineItem bmspmItem : bmspmItems){
                bmspmItems[0].Postage_Payment_Type__c = 'Direct Debit';
                bmspmItems[0].Date_Completed_BMSPM__c = system.today();
        }

        database.update(bmspmItems);

        test.stopTest();

    }

    public static testmethod void test_EFTPostagePaymentType_OpportunityLineItemUpdate(){

        List<OpportunityLineItem> bmspmItems = [select Id, Postage_Payment_Type__c, Date_Completed_BMSPM__c, Date_Completed_BMS__c, Date_Completed_PFS__c
                                                from OpportunityLineItem
                                                where Product2.Name like '%BMSPM'];

        test.startTest();

        for(OpportunityLineItem bmspmItem : bmspmItems){
                bmspmItems[0].Postage_Payment_Type__c = 'EFT';
                bmspmItems[0].Date_Completed_BMSPM__c = system.today();
        }

        database.update(bmspmItems);

        test.stopTest();

    }

    public static testmethod void test_MachineFloorPriceManagerApprovalRequest(){

        Opportunity o = [select Id, Requested_Install_Date__c, StageName,
                         (select Id, UnitPrice, Management_Qualifying_Amount__c, Product_Manager_Qualifying_Amount__c from OpportunityLineItems where Product2.Product_Type__c = 'MA' limit 1)
                         from Opportunity where Name = 'Test Opportunity' limit 1];

        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                                Where TargetObjectID = :o.Id];

        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};

        for(ProcessInstance instance : pi){

            for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments('Approved');
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);

            }
        }

        if(!prWkItems.isEmpty()){
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }

         for(OpportunityLineItem item : o.OpportunityLineItems){

             item.UnitPrice = item.Management_Qualifying_Amount__c - 1;
             item.Date_Completed_BMS__c = system.today();
             item.Date_Completed_BMSPM__c = system.today();
             item.Date_Completed_PFS__c = system.today();

            test.startTest();
                database.update(item);
            test.stopTest();
        }

    }

    public static testmethod void test_ConsumableFloorPriceManagerApprovalRequest(){

        Opportunity o = [select Id, Requested_Install_Date__c, StageName,
                         (select Id, UnitPrice, Management_Qualifying_Amount__c, Product_Manager_Qualifying_Amount__c from OpportunityLineItems where Product2.Product_Type__c = 'CO'  limit 1)
                         from Opportunity where Name = 'Test Opportunity' limit 1];

        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                                Where TargetObjectID = :o.Id];

        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};

        for(ProcessInstance instance : pi){

            for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments('Approved');
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);

            }
        }

        if(!prWkItems.isEmpty()){
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }

         for(OpportunityLineItem item : o.OpportunityLineItems){

            item.UnitPrice = item.Management_Qualifying_Amount__c - 1;

            test.startTest();
                database.update(item);
            test.stopTest();
        }

    }

    public static testmethod void test_ConsumableFloorPriceProductManagerApprovalRequest(){

        Opportunity o = [select Id, Requested_Install_Date__c, StageName,
                         (select Id, UnitPrice, Management_Qualifying_Amount__c, Product_Manager_Qualifying_Amount__c from OpportunityLineItems where Product2.Product_Type__c = 'CO'  limit 1)
                         from Opportunity where Name = 'Test Opportunity' limit 1];

        ProcessInstance[] pi = [Select ID, Status, TargetObject.Name,
                                (SELECT Id, ActorId, ProcessInstanceId FROM Workitems),
                                (SELECT Id, StepStatus, Comments FROM Steps) From ProcessInstance
                                Where TargetObjectID = :o.Id];

        Approval.ProcessWorkitemRequest[] prWkItems = New Approval.ProcessWorkItemRequest[]{};

        for(ProcessInstance instance : pi){

            for(ProcessInstanceWorkItem workItem : instance.WorkItems){

                Approval.ProcessWorkitemRequest prWkItem = new Approval.ProcessWorkitemRequest();

                prWkItem.setWorkItemID(workItem.id);
                prWkItem.setComments('Approved');
                prWkItem.setAction('Approve');
                prWkItems.add(prWkItem);

            }
        }

        if(!prWkItems.isEmpty()){
            Approval.ProcessResult[] appResult = Approval.process(prWkItems);
        }

         for(OpportunityLineItem item : o.OpportunityLineItems){

            item.UnitPrice = item.Product_Manager_Qualifying_Amount__c - 1;

            test.startTest();
                database.update(item);
            test.stopTest();
        }

    }

    public static testmethod void test_FreePostAlert(){

        Opportunity opp = [select Id, StageName, (select Id, Date_Completed_bms__c, Date_Completed_BMSPM__c, Date_Completed_PFS__c, Product2Id, Product2.Name from OpportunityLineItems) from Opportunity where Name = 'Test Opportunity' limit 1];

        // complete checklists
        for(OpportunityLineItem item : opp.OpportunityLineItems){

            item.Date_Completed_BMS__c = system.today().addDays(14);
            item.Date_Completed_BMSPM__c = system.today().addDays(14);
            item.Date_Completed_PFS__c = system.today().addDays(14);

            update item;
        }
        
        OpportunityWorkflowUtility.isInOppTrigger = false;

        test.startTest();
        
        opp.Free_Post_Amount__c = 100;
        opp.StageName = 'Closed Won';

        try{
            update opp;
        } catch (exception e){
            system.debug('###### e.getMessage() : ' + e.getMessage());
            //system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Opportunity must have a related Contact Role before being Closed Won'));
        }

        test.stopTest();
    }
    
    public static testmethod void test_isFreightRequired(){

        Opportunity opp = [select Id, (select Id, Date_Completed_bms__c, Date_Completed_BMSPM__c, Date_Completed_PFS__c, Product2Id, Product2.Name from OpportunityLineItems) from Opportunity where Name = 'Test Opportunity' limit 1];

        // complete checklists
        for(OpportunityLineItem item : opp.OpportunityLineItems){

            item.Date_Completed_BMS__c = system.today().addDays(14);
            item.Date_Completed_BMSPM__c = system.today().addDays(14);
            item.Date_Completed_PFS__c = system.today().addDays(14);
            item.unitPrice = 1;

            update item;
        }
        
        OpportunityWorkflowUtility.isInOppTrigger = false;

        test.startTest();

        try{
            update opp;
        } catch (exception e){
            system.debug('###### e.getMessage() : ' + e.getMessage());
        }

        test.stopTest();
    }
    
    public static testmethod void test_isPricingApprovalRequired(){
        Opportunity opp = [select id from Opportunity where Name = 'Test Opportunity' limit 1];  
        
        test.startTest();
        OpportunityWorkflowUtility.doIsPricingApprovalRequired(opp.Id);
        test.stopTest();
    }
    
    public static testmethod void test_UpdateClosedOpportunity(){
        
        Opportunity opp = [select Id, (select Id, Date_Completed_bms__c, Date_Completed_BMSPM__c, Date_Completed_PFS__c, Product2Id, Product2.Name, Quantity from OpportunityLineItems) from Opportunity where Name = 'Test Opportunity' limit 1];

        // complete checklists
        for(OpportunityLineItem item : opp.OpportunityLineItems){

            item.Date_Completed_BMS__c = system.today().addDays(14);
            item.Date_Completed_BMSPM__c = system.today().addDays(14); 
            item.Date_Completed_PFS__c = system.today().addDays(14);

            update item;
        }
        
        opp.StageName = 'Closed Won';
        update opp;

        OpportunityWorkflowUtility.isInLineItemTrigger = false;
        
        test.startTest();
            opp.opportunitylineitems[0].quantity = 2;
            update(opp.opportunitylineitems[0]);
        test.stopTest();
        
    }

}