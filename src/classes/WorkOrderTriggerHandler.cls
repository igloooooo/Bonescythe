/**
    *Trigger handler class that will be called on by WorkOrderTrigger
    *@author Kim Noceda - Proquest IT
    *@version 1.0 Created 8/25/2014
**/ 
public with sharing class WorkOrderTriggerHandler {

    public static void populateProductGroup(List<SVMXC__Service_Order__c> workOrders){
        Set<Id> installedProductIds = new Set<Id>();
        Map<Id, SVMXC__Installed_Product__c> installedProductsByIds = new Map<Id, SVMXC__Installed_Product__c>();
        for(SVMXC__Service_Order__c workOrder : workOrders){
            if(workOrder.SVMXC__Component__c != null){
                installedProductIds.add(workOrder.SVMXC__Component__c);
            }
        }
        
        List<SVMXC__Installed_Product__c> installedProducts = new List<SVMXC__Installed_Product__c>();
        
        installedProducts = [
            SELECT
                Id,
                Product_Group__c
            FROM
                SVMXC__Installed_Product__c
            WHERE
                Id
            IN
                :installedProductIds
            ];
        
        for(SVMXC__Installed_Product__c installedProduct : installedProducts){
            installedProductsByIds.put(installedProduct.Id, installedProduct);
        }
        
        for(SVMXC__Service_Order__c workOrder : workOrders){
            if(installedProductsByIds.containskey(workOrder.SVMXC__Component__c)){
                workOrder.Product_Group__c = installedProductsByIds.get(workOrder.SVMXC__Component__c).Product_Group__c;
            }
        }
    }
    
    public static void workOrderCountOnCase(List<SVMXC__Service_Order__c> newWorkOrders){
        
        Set<Id> CaseIds = new Set<Id>();
        
        for(SVMXC__Service_Order__c workOrder : newWorkOrders){
            CaseIds.add(workOrder.SVMXC__Case__c);
        }
        
        if(CaseIds.size() > 0){
            List<Case> casesToUpdate = [Select  Id, 
                                                PQ_Work_Order_Count__c,
                                                PQ_Count_Open_Work_Orders__c,
                                                (select id,SVMXC__Order_Status__c from SVMXC__Service_Order__r) 
                                        From    Case 
                                        Where   Id IN :caseIds];
        
            // query the cases and the related work orders and add the size of the work orders to the case's PQ_Work_Order_Count__c
            for (Case case1 : casesToUpdate) {
            	if(case1.PQ_Work_Order_Count__c != case1.SVMXC__Service_Order__r.size()){
            		case1.PQ_Work_Order_Count__c = case1.SVMXC__Service_Order__r.size();
            	}
            	Integer openWorkOrders = 0;
                for(SVMXC__Service_Order__c workOrder: case1.SVMXC__Service_Order__r){
                	if(workOrder.SVMXC__Order_Status__c != 'Close' || workOrder.SVMXC__Order_Status__c != 'Cancel'){
                		openWorkOrders++;
                	}
                }
                if(case1.PQ_Count_Open_Work_Orders__c != openWorkOrders){
                	case1.PQ_Count_Open_Work_Orders__c = openWorkOrders;
                }
            }
            update casesToUpdate;
        }
    
    }

    public static void UpdateCases(List<SVMXC__Service_Order__c> workorders, Map<Id, SVMXC__Service_Order__c> oldWorkOrders){
    
        List<SVMXC__Service_Order__c> updateOnsiteResponseWorkOrders = new List<SVMXC__Service_Order__c>();
        List<SVMXC__Service_Order__c> updateResolutionWorkOrders = new List<SVMXC__Service_Order__c>();
        List<SVMXC__Service_Order__c> updateRestorationWorkOrders = new List<SVMXC__Service_Order__c>();
        List<SVMXC__Service_Order__c> updateCaseStatusWorkOrders = new List<SVMXC__Service_Order__c>();
        List<SVMXC__Service_Order__c> UpdateTechnicianEmailAddressWorkOrders = new List<SVMXC__Service_Order__c>();
        Set<Id> caseIds = new Set<Id>();
        
        for(SVMXC__Service_Order__c workOrder : workOrders){
            if((workorder.SVMXC__Actual_Onsite_Response__c != Null) && (workorder.SVMXC__Actual_Onsite_Response__c != oldWorkOrders.get(workOrder.Id).SVMXC__Actual_Onsite_Response__c)){
                updateOnsiteResponseWorkOrders.add(workOrder);
                caseIds.add(workOrder.SVMXC__Case__c);
            }
            if((workorder.SVMXC__Actual_Restoration__c != Null) && (workorder.SVMXC__Actual_Restoration__c != oldWorkOrders.get(workOrder.Id).SVMXC__Actual_Restoration__c)){
                updateRestorationWorkOrders.add(workOrder);
                caseIds.add(workOrder.SVMXC__Case__c);
            }
            if((workorder.SVMXC__Actual_Resolution__c != Null) && (workorder.SVMXC__Actual_Resolution__c != oldWorkOrders.get(workOrder.Id).SVMXC__Actual_Resolution__c)){
                updateResolutionWorkOrders.add(workOrder);
                caseIds.add(workOrder.SVMXC__Case__c);
            }
            if((workorder.Case_Completed__c != false) && (workorder.Case_Completed__c != oldWorkOrders.get(workOrder.Id).Case_Completed__c)){
                updateCaseStatusWorkOrders.add(workOrder);
                caseIds.add(workOrder.SVMXC__Case__c);
            }
            if((workorder.Technicians_Email_Address__c != Null) && (workorder.Technicians_Email_Address__c != oldWorkOrders.get(workOrder.Id).Technicians_Email_Address__c)){
                UpdateTechnicianEmailAddressWorkOrders.add(workOrder);
                caseIds.add(workOrder.SVMXC__Case__c);
            }
            if( workOrder.SVMXC__Order_Status__c != oldWorkOrders.get(workOrder.Id).SVMXC__Order_Status__c ){
                caseIds.add(workOrder.SVMXC__Case__c);
            }
        }

        if(caseIds.size() > 0){
            Map<Id, Case> cases = new Map<Id,Case>([SELECT 	Id, 
            												Status, 
            												PQ_WO_Onsite_Response__c, 
            												PQ_WO_Machine_Operational__c, 
            												PQ_WO_Resolution__c, 
            												SVMXC__Actual_Resolution__c, 
            												SVMXC__Actual_Restoration__c, 
            												Technicians_Email_Address__c,
            												PQ_Count_Open_Work_Orders__c,
                                                    		(Select id from SVMXC__Service_Order__r where SVMXC__Order_Status__c !='Close' and SVMXC__Order_Status__c !='Cancel' )  
            										FROM 	Case 
            										WHERE 	id IN: CaseIDs]); 

            
            if(updateOnsiteResponseWorkOrders.size() > 0){
                UpdateOnsiteResponse(updateOnsiteResponseWorkOrders, cases);
            }
            if(updateRestorationWorkOrders.size() > 0){
                UpdateRestoration(updateRestorationWorkOrders, cases);
            }
            if(updateResolutionWorkOrders.size() > 0){
                UpdateResolution(updateResolutionWorkOrders, cases);
            }
            if(updateCaseStatusWorkOrders.size() > 0){
                UpdateCaseStatus(updateCaseStatusWorkOrders, cases);
            }
            if(UpdateTechnicianEmailAddressWorkOrders.size() > 0){
                UpdateTechnicianEmailAddress(UpdateTechnicianEmailAddressWorkOrders, cases);
            }

            if(cases.size() > 0){
            	UpdateCountOpenWorkOrders(cases);
                update cases.values();
            }
        }
    }


    public static void WorkorderQueueAssignment(List<SVMXC__Service_Order__c> workorders){

        List< SVMXC__Territory__c > territory = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='NSW/ACT Work Order Queue'  ];  

        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__State__c == 'NSW' || workorder.SVMXC__State__c == 'ACT' ) {
                workorder.SVMXC__Primary_Territory__c = territory.get(0).id ;      
            } 
        } 
        
        List< SVMXC__Territory__c > territory2 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='QLD/NT Work Order Queue'  ];  

        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__State__c == 'QLD' || workorder.SVMXC__State__c == 'NT' ) {
                workorder.SVMXC__Primary_Territory__c = territory2.get(0).id ; 
            } 
        } 

        List< SVMXC__Territory__c > territory3 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='VIC/TAS Work Order Queue'  ];  

        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__State__c == 'VIC' || workorder.SVMXC__State__c == 'TAS' ) {
                workorder.SVMXC__Primary_Territory__c = territory3.get(0).id ;       
            } 
        }     
            
        List< SVMXC__Territory__c > territory4 = [SELECT Id, Name FROM SVMXC__Territory__c  WHERE Name ='WA Work Order Queue'  ];  

        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__State__c == 'WA'  ) {
                workorder.SVMXC__Primary_Territory__c = territory4.get(0).id ;       
            } 
        } 
        
        List< SVMXC__Territory__c > territory5 = [SELECT Id, Name FROM SVMXC__Territory__c WHERE Name ='SA Work Order Queue'  ];  

        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__State__c == 'SA'  ) {
                workorder.SVMXC__Primary_Territory__c = territory5.get(0).id ;       
            } 
        }  
    }
    
    private static void UpdateCountOpenWorkOrders(Map<Id, Case> cases){
        
        for (Case case1 : cases.values()) {
            if(case1.PQ_Count_Open_Work_Orders__c != case1.SVMXC__Service_Order__r.size()){
                case1.PQ_Count_Open_Work_Orders__c = case1.SVMXC__Service_Order__r.size();
            }
        }
    }
    
    private static void UpdateCaseStatus(List<SVMXC__Service_Order__c> workorders, Map<Id, Case> cases){
        Set<ID> CaseIDs = new Set<ID>(); 
        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.Case_Completed__c == True) {
                Case case1 = cases.get(workorder.SVMXC__Case__c);
                if(case1 != null && case1.Status != 'Closed'){
                    case1.status = 'Ready to be Closed';  
                    case1.PQ_DateTimeReady_to_be_Closed__c = System.now();
                    case1.PQ_Case_Completed__c = True;
                }
            } 
        } 
    }

    private static void UpdateOnsiteResponse(List<SVMXC__Service_Order__c> workorders, Map<Id, Case> cases){
        Set<ID> CaseIDs = new Set<ID>(); 
        Datetime OnsiteResponse;
        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__Actual_Onsite_Response__c != Null) {
                Case case1 = cases.get(workorder.SVMXC__Case__c);
                if(case1 != null && case1.PQ_WO_Onsite_Response__c == false){
                    case1.PQ_WO_Onsite_Response__c = True;
                    case1.SVMXC__Actual_Onsite_Response__c = workorder.SVMXC__Actual_Onsite_Response__c ;
                }
            } 
        } 
    }


    private static void UpdateRestoration(List<SVMXC__Service_Order__c> workorders, Map<Id, Case> cases){
        Set<ID> CaseIDs = new Set<ID>(); 
        Datetime Restoration;
        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__Actual_Restoration__c != Null) {
                Case case1 = cases.get(workorder.SVMXC__Case__c);
                if(case1 != null && case1.PQ_WO_Machine_Operational__c == false){
                    case1.PQ_WO_Machine_Operational__c = True;
                    case1.SVMXC__Actual_Restoration__c = workorder.SVMXC__Actual_Restoration__c ;
                }
            } 
        } 

    }

	private static void UpdateResolution(List<SVMXC__Service_Order__c> workorders, Map<Id, Case> cases){
        Set<ID> CaseIDs = new Set<ID>(); 
        Datetime Resolution;
        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.SVMXC__Actual_Resolution__c != Null) {
                Case case1 = cases.get(workorder.SVMXC__Case__c);
                if(case1 != null && case1.PQ_WO_Resolution__c == false){
                    case1.PQ_WO_Resolution__c = True;
                    case1.SVMXC__Actual_Resolution__c = workorder.SVMXC__Actual_Resolution__c ;
                    case1.SVMXC__Actual_Restoration__c = workorder.SVMXC__Actual_Resolution__c ;
                }
            } 
        } 

    }

    private static void UpdateTechnicianEmailAddress(List<SVMXC__Service_Order__c> workorders, Map<Id, Case> cases){
        Set<ID> CaseIDs = new Set<ID>(); 
        String Email;
        for(SVMXC__Service_Order__c workorder : workorders) {        
            If (workorder.Technicians_Email_Address__c != Null) {
                Case case1 = cases.get(workorder.SVMXC__Case__c);
                if(case1 != null){
                    case1.Technicians_Email_Address__c = workorder.Technicians_Email_Address__c;
                }
            } 
        } 

    }
    
    public static void cloneAttachments(List<SVMXC__Service_Order__c> newWorkOrders){
        Map<String,Id> workOrderNumberToNewWorkOrder = new Map<String,Id>();
        
        for(SVMXC__Service_Order__c newWorkOrder : newWorkOrders) { 
            if(newWorkOrder.Old_WO_ID__c != null){
                workOrderNumberToNewWorkOrder.put(newWorkOrder.Old_WO_ID__c, newWorkOrder.Id);
            }
        }
        
        if(workOrderNumberToNewWorkOrder.size() > 0){
            List<SVMXC__Service_Order__c> oldWorkOrders = [Select Id, Name From SVMXC__Service_Order__c Where Name IN :workOrderNumberToNewWorkOrder.keySet()];
            
            Map<Id, String> workOrderIdToOldWorkOrderNumber = new Map<Id,String>();
            Set<Id> oldWorkOrderIds = new Set<Id>();
            for(SVMXC__Service_Order__c workOrder: oldWorkOrders){
                workOrderIdToOldWorkOrderNumber.put(workOrder.Id, workOrder.Name);
                oldWorkOrderIds.add(workOrder.Id);
            }
            
            List<Attachment> attachments = [
                                            SELECT 
                                                Id,
                                                Name,
                                                Body,
                                                ParentId
                                            FROM
                                                Attachment
                                            WHERE
                                                ParentId = :oldWorkOrderIds
                                            ];
                                            
            List<Attachment> clonedAttachments = new List<Attachment>();
            for(Attachment attachment: attachments){
                String workOrderNumber = workOrderIdToOldWorkOrderNumber.get(attachment.ParentId);
                Id newWorkOrderId = workOrderNumberToNewWorkOrder.get(workOrderNumber);
                Attachment clonedAttachment =  new Attachment(name = attachment.name, body = attachment.body, parentId = newWorkOrderId);
                clonedAttachments.add(clonedAttachment);
            }
            if(clonedAttachments.size() > 0){
                insert clonedAttachments;
            }
        }
    }
    
    public static void populateTechnicianLocation(List<SVMXC__Service_Order__c> workOrders, Map<Id, SVMXC__Service_Order__c> oldWorkOrders){
        Set<Id> technicianIds = new Set<Id>();
        for(SVMXC__Service_Order__c workOrder: workOrders){
            if((!oldWorkOrders.containsKey(workOrder.Id) && workOrder.SVMXC__Group_Member__c != null)
                || (oldWorkOrders.containsKey(workOrder.Id) && oldWorkOrders.get(workOrder.Id).SVMXC__Group_Member__c != workOrder.SVMXC__Group_Member__c && workOrder.SVMXC__Group_Member__c != null)){
                technicianIds.add(workOrder.SVMXC__Group_Member__c);
            }
        }
        if(technicianIds.size() > 0){
            Map<Id, SVMXC__Service_Group_Members__c> technicians = new Map<Id, SVMXC__Service_Group_Members__c>([Select Id, SVMXC__Inventory_Location__c, SVMXC__Inventory_Location__r.Mobile_State_Warehouse_Name__c From SVMXC__Service_Group_Members__c Where ID IN :technicianIds]);
            for(SVMXC__Service_Order__c workOrder: workOrders){
                if( (workOrder.Id == null && workOrder.SVMXC__Group_Member__c != null)  || 
                    (workOrder.Id != null && oldWorkOrders.get(workOrder.Id) != null && workOrder.SVMXC__Group_Member__c != oldWorkOrders.get(workOrder.Id).SVMXC__Group_Member__c)){
                    if(workOrder.SVMXC__Group_Member__c != null){
                        workOrder.Technician_Location__c = technicians.get(workOrder.SVMXC__Group_Member__c).SVMXC__Inventory_Location__c;
                        workOrder.SVMX_Mobile_State_Warehouse_Name__c = technicians.get(workOrder.SVMXC__Group_Member__c).SVMXC__Inventory_Location__r.Mobile_State_Warehouse_Name__c;
                    }else{
                        workOrder.Technician_Location__c = null;
                        workOrder.SVMX_Mobile_State_Warehouse_Name__c = '';
                    }
                }
            }
        }
    }
 
}