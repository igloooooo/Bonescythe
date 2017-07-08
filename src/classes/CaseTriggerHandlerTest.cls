@isTest(seealldata=true)
private class CaseTriggerHandlerTest{
    
    static testMethod void createCase(){
    
        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product(1, accounts, products);
        insert installedProducts;
        
        Test.startTest();
            List<Case> cases = new List<Case>();
            cases = TestDataUtility.createCase2(1, accounts, installedProducts);
            insert cases;
        Test.stopTest();
    }

static testMethod void Opencasecount() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        insert products;
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product(1, accounts, products);
        insert installedProducts;

        List<Case> cases = TestDataUtility.createCase2(1, accounts, installedProducts);
        cases.get(0).status = 'Open';
        insert cases;
        
        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        insert workOrders;
        
        Test.startTest();
        workOrders.get(0).Case_Completed__c = true;
        workOrders.get(0).SVMXC__Root_Cause__c = 'PC/Printer Hardware';
        workOrders.get(0).SVMXC__How_Fixed__c = 'Adjustment/Setting';
        update workOrders;
    
        Id InstalledProductsIdCount = installedProducts.get(0).Id;
        
        SVMXC__Installed_Product__c installedProductsCounter = [Select Id, Open_Cases__c from SVMXC__Installed_Product__c where Id = :InstalledProductsIdCount];

        System.assertEquals(1,installedProductsCounter.Open_Cases__c);
        
        cases.get(0).Status = 'Ready to be Closed';
        cases.get(0).Reason = 'Cleaning';
        Update cases;
        
        SVMXC__Installed_Product__c installedProductsCounter2 = [Select Id, Open_Cases__c from SVMXC__Installed_Product__c where Id = :InstalledProductsIdCount];
        
        //System.assertEquals(0,installedProductsCounter2.Open_Cases__c);
        
        cases.get(0).Status = 'Open';
        Update cases;

        SVMXC__Installed_Product__c installedProductsCounter3 = [Select Id, Open_Cases__c from SVMXC__Installed_Product__c where Id = :InstalledProductsIdCount];
        
        //System.assertEquals(1,installedProductsCounter3.Open_Cases__c);
        Test.stopTest();
    }

    static testmethod void creditCases(){
        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;
        
        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;
        
        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        insert workOrders;

        List<SVMXC__Service_Order_Line__c> workOrderLines = TestDataUtility.createWorkOrderLine(2,workOrders);
        for(SVMXC__Service_Order_Line__c workOrder: workOrderLines){
            workOrder.SVMXC__Actual_Price2__c = 100;
        }
        insert workOrderLines;
        
        cases.get(0).Total__c = 0;
        Test.startTest();
            update cases;
            workOrders = [Select SVMXC__Total_Billable_Amount__c From SVMXC__Service_Order__c Where ID = :workOrders.get(0).Id];
            System.assertEquals(workOrders.get(0).SVMXC__Total_Billable_Amount__c, 0);
        Test.stopTest();
    }
    
    static testmethod void createInvoiceSummary(){
        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;
        
        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;
        
        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        insert workOrders;

		RecordType usageConsum = [Select Id From RecordType Where DeveloperName = 'UsageConsumption'];
		
        List<SVMXC__Service_Order_Line__c> workOrderLines = TestDataUtility.createWorkOrderLine(2,workOrders);
        for(SVMXC__Service_Order_Line__c workOrder: workOrderLines){
            workOrder.SVMXC__Actual_Price2__c = 100;
            workOrder.RecordTypeId = usageConsum.Id;
        }
        insert workOrderLines;

        Test.startTest();
            workOrders.get(0).Case_Completed__c = true;
            workOrders.get(0).SVMXC__Root_Cause__c = 'PC/Printer Hardware';
            workOrders.get(0).SVMXC__How_Fixed__c = 'Adjustment/Setting';
            update workOrders;
        
        
            cases.get(0).Generate_Update_Invoice_Summary__c = true;
            update cases;
            List<Invoice_Summary__c> invoiceSum = [Select Id From Invoice_Summary__c Where Case__c = :cases.get(0).Id];
            System.assertEquals(invoiceSum.size(), 1);
            List<Invoice_Summary_Detail__c> invoiceDetail = [Select Id From Invoice_Summary_Detail__c Where Invoice_Summary__c = :invoiceSum.get(0).Id];
            //System.assertEquals(invoiceDetail.size(), 1);
            System.assertEquals(invoiceDetail.size(), 2);
        Test.stopTest();
    }
}