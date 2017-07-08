/**
    *Trigger handler class that will be called on by CaseTrigger
    *@author Kengo CHINEN - Proquest IT
    *@version 1.1 Created 8/19/2014
**/ 
public with sharing class CaseTriggerHandler {

    public static void UpdateProductGroup(List<Case> cases){
        Set<ID> installedProductIDs = new Set<ID>(); 
        for(Case case1 : cases) {        
            If (case1.SVMXC__Component__c != NULL) {
                installedProductIDs.add(case1.SVMXC__Component__c); 
            } 
        } 
        if(InstalledProductIDs.size() > 0){
            List< SVMXC__Installed_Product__c > installedProducts =  [SELECT Id, Product_Group__c FROM SVMXC__Installed_Product__c WHERE id IN: InstalledProductIDs];   
            
            Map<Id, SVMXC__Installed_Product__c> InstalledProductMap = new Map<Id, SVMXC__Installed_Product__c>();      
           
            for(SVMXC__Installed_Product__c Installed_Product : installedProducts) {
                InstalledProductMap.put(Installed_Product.Id, Installed_Product);  
            }
            
            for (Case newCase : cases) {


                if(InstalledProductMap.containskey(newCase.SVMXC__Component__c)){
                     newCase.PQ_Product_Group__c = InstalledProductMap.get(newCase.SVMXC__Component__c).Product_Group__c;
                }
               
            }
        }
    }
    public static void CountOpenCases(List<Case> cases, Map<Id, Case> oldCases){
           
        System.debug('##LIST: '+cases);
        Set<Id> installProductIds = new Set<Id>();
        List<SVMXC__Installed_Product__c> 
        installProductToUpdate = new List<SVMXC__Installed_Product__c>();
    
        for(Case case2 : cases){
            if(case2.status != oldCases.get(case2.Id).status ){
            installProductIds.add(case2.SVMXC__Component__c);
            }
        }
        if(installProductIds.size() > 0){

            Map<id,SVMXC__Installed_Product__c> installMap = new Map<id,SVMXC__Installed_Product__c>([select id, Open_Cases__c from SVMXC__Installed_Product__c where id IN :installProductIds]);
      
            for (SVMXC__Installed_Product__c installedproduct1 : [select Id, Open_Cases__c,(select id from SVMXC__Case1__r where Status !='Closed'  ) from SVMXC__Installed_Product__c where Id IN :installProductIds]) {
                installMap.get(installedproduct1.Id).Open_Cases__c = installedproduct1.SVMXC__Case1__r.size();
            
                installProductToUpdate.add(installMap.get(installedproduct1.Id));

            }
            
            update installProductToUpdate; 
        }           
    }

    public static void CountOpenCases2(List<Case> cases){
           
        System.debug('##LIST: '+cases);
        Set<Id> installProductIds = new Set<Id>();
        List<SVMXC__Installed_Product__c> 
        installProductToUpdate = new List<SVMXC__Installed_Product__c>();
    
        for(Case case2 : cases){
            if(case2.status != null ){
            installProductIds.add(case2.SVMXC__Component__c);
            }
        }
        if(installProductIds.size() > 0){

            Map<id,SVMXC__Installed_Product__c> installMap = new Map<id,SVMXC__Installed_Product__c>([select id, Open_Cases__c from SVMXC__Installed_Product__c where id IN :installProductIds]);
      
            for (SVMXC__Installed_Product__c installedproduct1 : [select Id, Open_Cases__c,(select id from SVMXC__Case1__r where Status !='Closed'  ) from SVMXC__Installed_Product__c where Id IN :installProductIds]) {
                installMap.get(installedproduct1.Id).Open_Cases__c = installedproduct1.SVMXC__Case1__r.size();
            
                installProductToUpdate.add(installMap.get(installedproduct1.Id));

            }
            update installProductToUpdate;  
        }
         
    }

    public static void creditWorkOrders(Map<Id, Case> newCaseMap, Map<Id, Case> oldCaseMap){
        Set<Id> creditedCases = new Set<Id>();
        for(Case cs : newCaseMap.values()){
            if(cs.Total__c == 0 && cs.Total__c != oldCaseMap.get(cs.Id).Total__c){
                creditedCases.add(cs.Id);    
            }
        }
        
        if(creditedCases.size() > 0){
            List<SVMXC__Service_Order_Line__c> workDetails = [Select SVMXC__Actual_Price2__c, SVMXC__Use_Price_From_Pricebook__c From SVMXC__Service_Order_Line__c Where SVMXC__Service_Order__r.SVMXC__Case__c IN :creditedCases];
            for(SVMXC__Service_Order_Line__c workDetail : workDetails){
                workDetail.SVMXC__Actual_Price2__c = 0;
                workDetail.SVMXC__Use_Price_From_Pricebook__c = false;
            }
            if(workDetails.size() > 0){
                update workDetails;
            }
        }
    }

    public static void createInvoiceSummary(Map<Id, Case> oldCases, Map<Id, Case> newCases){
        Set<Id> caseIds = new Set<Id>();
        for(Case currentCase: newCases.values()){
            if(currentCase.Generate_Update_Invoice_Summary__c != oldCases.get(currentCase.Id).Generate_Update_Invoice_Summary__c && currentCase.Generate_Update_Invoice_Summary__c){
                caseIds.add(currentCase.Id);
            }
        }
        
        if(caseIds.size() > 0){
            Map<Id, Case> cases = CaseDAO.getCases(caseIds);
                
            Set<Id> invoiceSumIds = new Set<Id>();                          
            for(Case currentCase: cases.values()){
                if(currentCase.Invoice_Summary__c != null){
                    invoiceSumIds.add(currentCase.Invoice_Summary__c);
                }
            }                           
            
            Map<Id, Invoice_Summary__c> existingInvoiceSums = new Map<Id, Invoice_Summary__c>();
            if(invoiceSumIds.size() > 0){
                existingInvoiceSums = InvoiceSummaryDAO.getInvoiceSummaries(invoiceSumIds);
            }
            Set<Id> workOrderIds = new Set<Id>();
                                                                                
            List<Invoice_Summary__c> invoiceSummaries = new List<Invoice_Summary__c>();
            for(Case currentCase: cases.values()){
                if(currentCase.SVMXC__Service_Order__r.size() > 0){
                    Invoice_Summary__c invoiceSummary = new Invoice_Summary__c();
                    if(currentCase.Invoice_Summary__c != null){
                        invoiceSummary = existingInvoiceSums.get(currentCase.Invoice_Summary__c);
                    }
                    invoiceSummary.Action_Text__c = currentCase.PQ_Symptom__c;
                    invoiceSummary.Case__c = currentCase.Id;
                    invoiceSummary.Case_Number__c = currentCase.CaseNumber;
                    invoiceSummary.Contact_Name__c = currentCase.Contact_Name_Hidden__c;
                    invoiceSummary.Customer_Number__c = currentCase.Account.Customer_Number__c;
                    invoiceSummary.Customer_Order_Number__c = currentCase.Customer_Order_Number__c;
                    if(currentCase.SVMXC__Actual_Resolution__c != null){
                        invoiceSummary.Date_Of_Repair__c = date.newInstance(currentCase.SVMXC__Actual_Resolution__c.year(), currentCase.SVMXC__Actual_Resolution__c.month(), currentCase.SVMXC__Actual_Resolution__c.day());
                    }
                    invoiceSummary.Individual_Item_Number__c = currentCase.SVMXC__Component__r.Name;
                    invoiceSummary.Installed_Product_Product_Group__c = currentCase.PQ_Product_Group__c;
                    invoiceSummary.Movex_Site_ID__c = currentCase.SVMXC__Component__r.SVMXC__Site__r.Movex_Site_Id__c;
                    invoiceSummary.Serial_Lot_Number__c = currentCase.Top_Level_Serial_Lot_Number__c;
                    invoiceSummary.Product_Part_Name__c = currentCase.SVMXC__Component__r.SVMXC__Product__r.Name;
                            
                    Decimal total = 0;
                    Boolean mainActionSet = false;
                    for(SVMXC__Service_Order__c workOrder : currentCase.SVMXC__Service_Order__r){
                        total += workOrder.SVMXC__Total_Billable_Amount__c;
                        if(!mainActionSet){
                            invoiceSummary.Error_Sympt_txt__c = workOrder.SVMXC__How_Fixed__c;
                            mainActionSet = true;
                        }
                        workOrderIds.add(workOrder.Id);
                    }
                    invoiceSummary.Total__c = total;
                    invoiceSummaries.add(invoiceSummary);
                }
            }
            
            if(invoiceSummaries.size() > 0){
                upsert invoiceSummaries;
                createInvoiceDeatils(invoiceSummaries, cases, WorkDetailsDAO.getWorkDetails(workOrderIds));
            }
            
            
            if(caseIds.size() > 0){
                List<Case> updateCases = [Select Id, Generate_Update_Invoice_Summary__c From Case Where ID IN :caseIds AND Generate_Update_Invoice_Summary__c = true];
                for(Case cs: updateCases){
                    cs.Generate_Update_Invoice_Summary__c = false;
                }
                update updateCases;
            }
        }
    }
    
    private static void createInvoiceDeatils(List<Invoice_Summary__c> invoiceSummaries, Map<Id, Case> cases, List<SVMXC__Service_Order_Line__c> workDetails){
        List<Invoice_Summary_Detail__c> invoiceDetails = new List<Invoice_Summary_Detail__c>();
        for(Invoice_Summary__c summary: invoiceSummaries){
            invoiceDetails.addAll(summary.Invoice_Summary_Details__r);
        }
        if(invoiceDetails.size() > 0){
            delete invoiceDetails;
        }
        Map<Id, List<SVMXC__Service_Order_Line__c>> workDetailMap = new Map<Id, List<SVMXC__Service_Order_Line__c>>();
        for(SVMXC__Service_Order_Line__c workDetail: workDetails){
            if(workDetailMap.containsKey(workDetail.SVMXC__Service_Order__c)){
                workDetailMap.get(workDetail.SVMXC__Service_Order__c).add(workDetail);
            }else{
                workDetailMap.put(workDetail.SVMXC__Service_Order__c, new List<SVMXC__Service_Order_Line__c>{workDetail});
            }
        }
        invoiceDetails = new List<Invoice_Summary_Detail__c>();
        for(Invoice_Summary__c summary: invoiceSummaries){
            for(SVMXC__Service_Order__c workOrder : cases.get(summary.Case__c).SVMXC__Service_Order__r){
                if(workDetailMap.containsKey(workOrder.Id)){
                    for(SVMXC__Service_Order_Line__c detail: workDetailMap.get(workOrder.Id)){
                        Invoice_Summary_Detail__c invDetail = new Invoice_Summary_Detail__c();
                        invDetail.Activity_Type_Code__c = detail.SVMXC__Activity_Type__c;
                        invDetail.Billable_Line_Price__c = (detail.SVMXC__Billable_Quantity__c != null && detail.SVMXC__Billable_Quantity__c != 0) ? (detail.SVMXC__Billable_Line_Price__c/detail.SVMXC__Billable_Quantity__c) : detail.SVMXC__Billable_Line_Price__c;
                        invDetail.Billable_Quantity__c = detail.SVMXC__Billable_Quantity__c;
                        invDetail.Expense_Type__c = detail.SVMXC__Expense_Type__c;
                        invDetail.Item_No__c = detail.SVMXC__Product__r.Item_No__c;
                        invDetail.Invoice_Summary__c = summary.Id;
                        invDetail.Technician_Location__c = workOrder.SVMXC__Group_Member__r.SVMXC__Inventory_Location__r.Movex_Site_Id__c;
                        invoiceDetails.add(invDetail);
                    }
                }
            }
        }
        if(invoiceDetails.size() > 0){
            insert invoiceDetails;
        }
    }

}