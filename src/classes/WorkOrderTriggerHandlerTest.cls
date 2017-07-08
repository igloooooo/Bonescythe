@isTest(seealldata=true)
private class WorkOrderTriggerHandlerTest{
    
    static testMethod void createWorkOrder(){
    
        List<Account> accounts = TestDataUtility.createAccounts(1);
        accounts.get(0).Name ='testname';
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product(1, accounts, products);
        insert installedProducts;
        
        Test.startTest();
            List<SVMXC__Service_Order__c> workOrders = new List<SVMXC__Service_Order__c>();
            workOrders = TestDataUtility.createWorkOrder(1, accounts, installedProducts, products, null);
            insert workOrders;
        Test.stopTest();
    }

    static testMethod void CaseCustomRollupSummary() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(5,cases);
        insert workOrders;
    
        Id caseIdCount = cases.get(0).Id;
        
        Case caseCounter = [Select Id, PQ_Work_Order_Count__c from Case where Id = :caseIdCount];

        System.assertEquals(5,caseCounter.PQ_Work_Order_Count__c);
        
        //System.assertEquals(5,cases.get(0).PQ_Work_Order_Count__c);
        
        Delete workOrders.get(0);
        
        Case caseCounter2 = [Select Id, PQ_Work_Order_Count__c from Case where Id = :caseIdCount];
        
        System.assertEquals(4,caseCounter2.PQ_Work_Order_Count__c);
        
        Undelete workOrders.get(0);

        Case caseCounter3 = [Select Id, PQ_Work_Order_Count__c from Case where Id = :caseIdCount];
        
        System.assertEquals(5,caseCounter3.PQ_Work_Order_Count__c);
   
    }

    static testMethod void UpdateCaseStatus(){
    
        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;
        
        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;
        
        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        insert workOrders;
        
        Test.startTest();
        workOrders.get(0).Case_Completed__c = True;
        workOrders.get(0).SVMXC__Actual_Onsite_Response__c = system.now();
        workOrders.get(0).SVMXC__Actual_Resolution__c = system.now();
        workOrders.get(0).SVMXC__Actual_Restoration__c = system.now();
        workOrders.get(0).SVMXC__Actual_Restoration__c = system.now();
        workOrders.get(0).Technicians_Email_Address__c = 'quenelle@petifion.com';        
        Update workOrders;
        
        Id caseIdStatus = cases.get(0).Id;
        
        Case caseStatus = [Select Id, PQ_WO_Machine_Operational__c, PQ_WO_Onsite_Response__c, PQ_WO_Resolution__c, Technicians_Email_Address__c, Status from Case where Id = :caseIdStatus];
        System.assertEquals('Ready to be Closed',caseStatus.Status);
        System.assertEquals(True,caseStatus.PQ_WO_Machine_Operational__c);
        System.assertEquals(True,caseStatus.PQ_WO_Onsite_Response__c);
        System.assertEquals(True,caseStatus.PQ_WO_Resolution__c);
        System.assertEquals('quenelle@petifion.com',caseStatus.Technicians_Email_Address__c);
        Test.stopTest();
    }    

    static testMethod void OpenWorkOrderscount() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        insert workOrders;
    
        Id caseIdCount = cases.get(0).Id;
        
        Case caseCounter = [Select Id, PQ_Count_Open_Work_Orders__c from Case where Id = :caseIdCount];

        System.assertEquals(1,caseCounter.PQ_Count_Open_Work_Orders__c);
        
        workOrders.get(0).SVMXC__Order_Status__c = 'Cancel';
        Update workOrders;
        
        Case caseCounter2 = [Select Id, PQ_Count_Open_Work_Orders__c from Case where Id = :caseIdCount];
        
        System.assertEquals(0,caseCounter2.PQ_Count_Open_Work_Orders__c);
        
        workOrders.get(0).SVMXC__Order_Status__c = 'Open';
        Update workOrders;

        Case caseCounter3 = [Select Id, PQ_Count_Open_Work_Orders__c from Case where Id = :caseIdCount];
        
        System.assertEquals(1,caseCounter3.PQ_Count_Open_Work_Orders__c);
    }
        
    static testMethod void WorkOrderQueue() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        workOrders.get(0).SVMXC__State__c = 'NSW';
        insert workOrders; 
        
        SVMXC__Territory__c territory1 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='NSW/ACT Work Order Queue']; 
        SVMXC__Service_Order__c testOrder1 = [Select Id, SVMXC__Primary_Territory__c from SVMXC__Service_Order__c where Id = : workOrders.get(0).Id];

        System.assertEquals(territory1.Id ,testOrder1.SVMXC__Primary_Territory__c);  
        

    }
    
    static testMethod void WorkOrderQueue2() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        workOrders.get(0).SVMXC__State__c = 'QLD';
        insert workOrders; 
        
        SVMXC__Territory__c territory1 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='QLD/NT Work Order Queue']; 
        SVMXC__Service_Order__c testOrder1 = [Select Id, SVMXC__Primary_Territory__c from SVMXC__Service_Order__c where Id = : workOrders.get(0).Id];

        System.assertEquals(territory1.Id ,testOrder1.SVMXC__Primary_Territory__c);  
    }
    
    static testMethod void WorkOrderQueue3() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        workOrders.get(0).SVMXC__State__c = 'WA';
        insert workOrders; 
        
        SVMXC__Territory__c territory1 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='WA Work Order Queue']; 
        SVMXC__Service_Order__c testOrder1 = [Select Id, SVMXC__Primary_Territory__c from SVMXC__Service_Order__c where Id = : workOrders.get(0).Id];

        System.assertEquals(territory1.Id ,testOrder1.SVMXC__Primary_Territory__c);  
    }

    static testMethod void WorkOrderQueue4() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        insert accounts;

        List<Case> cases = TestDataUtility.createCase(1, accounts);
        insert cases;

        List<SVMXC__Service_Order__c> workOrders = TestDataUtility.createWorkOrder2(1,cases);
        workOrders.get(0).SVMXC__State__c = 'TAS';
        insert workOrders; 
        
        SVMXC__Territory__c territory1 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='VIC/TAS Work Order Queue']; 
        SVMXC__Service_Order__c testOrder1 = [Select Id, SVMXC__Primary_Territory__c from SVMXC__Service_Order__c where Id = : workOrders.get(0).Id];

        System.assertEquals(territory1.Id ,testOrder1.SVMXC__Primary_Territory__c);  
    }

    static testMethod void technicianLocationUpdate() {

        List<Account> accounts = TestDataUtility.createAccounts(1);
        accounts.get(0).Name ='testname';
        insert accounts;
        
        List<Product2> products = TestDataUtility.createProduct(1);
        
        List<SVMXC__Installed_Product__c> installedProducts = TestDataUtility.createInstalled_Product(1, accounts, products);
        insert installedProducts;
        
        List<SVMXC__Site__c> locations = TestDataUtility.createLocations(2);
        insert locations;
        
        List<SVMXC__Service_Group__c> serviceGroups = TestDataUtility.createServiceGroup(2);
        insert serviceGroups;
        
        List<SVMXC__Service_Group_Members__c> techs = TestDataUtility.createTechnicians(2, serviceGroups, locations);
        insert techs;
        
        Test.startTest();
            List<SVMXC__Service_Order__c> workOrders = new List<SVMXC__Service_Order__c>();
            workOrders = TestDataUtility.createWorkOrder(1, accounts, installedProducts, products, techs);
            insert workOrders;
            Set<Id> wIds = new Set<Id>();
            for(SVMXC__Service_Order__c workOrder : workOrders){
                wIds.add(workOrder.id);
            }
            workOrders = [Select Technician_Location__c From SVMXC__Service_Order__c Where ID IN :wIds];
            for(SVMXC__Service_Order__c workOrder : workOrders){
                System.assertNotEquals(workOrder.Technician_Location__c, null);
            }
        Test.stopTest();
        

    }

}