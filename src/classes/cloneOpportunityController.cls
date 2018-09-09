public with sharing class cloneOpportunityController {
    
    private Opportunity masterOpp {get;set;}
    public Opportunity cloneOpp {get;set;}
     
    public cloneOpportunityController(ApexPages.StandardController con){
       
    }
    
    public pagereference generateClonedOppty(){
        
        Map<String, Schema.SObjectField> schemaFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
        
        string q = 'select ';
        
        for (String fieldName: schemaFieldMap.keySet()) {
            q += fieldName + ', ';
        } 
        
        q += ' (select Id, ContactId, Role from OpportunityContactRoles), ';
        q += ' (select Id, PricebookEntryId, Quantity, UnitPrice, Service_Install_Required__c, Item_Type__c from OpportunityLineItems)';
        q += ' from Opportunity';
        q += ' where Id = \'' +  ApexPages.CurrentPage().getParameters().get('id') + '\'';
        q += ' limit 1';
        
        system.debug('q : ' + q);
        
        masterOpp = database.query(q);
        
        system.debug('masterOpp : ' + masterOpp);
        
        cloneOpp = masterOpp.clone();
        
        // reset lead stage
        cloneOpp.StageName = 'Lead (Unqualified)';
        
        // set close date
        cloneOpp.CloseDate = system.today().addDays(30);
        
        // clear finance approval details
        cloneOpp.Special_Rate_Required__c = false;
        cloneOpp.Finance_Approval_Status__c = null;
        
        // clear service approval details
        cloneOpp.Request_for_No_Maintenance__c = false;
        cloneOpp.Maintenance_Approval__c = null;
        
        // clear all fulfilment details
        cloneOpp.Fulfilment_Status__c = null;
        cloneOpp.Finance_AR_Approved__c = false;
        cloneOpp.Order_Number__c = null;
        cloneOpp.Order_Number_2__c = null;
        cloneOpp.Order_Low_Status__c = null;
        cloneOpp.Order_High_Status__c = null;
        cloneOpp.Order_Stop_Code__c = null;
        
        database.insert(cloneOpp);
        
        list<sObject> ins = new List<sObject>();

        for(OpportunityLineItem i : masterOpp.OpportunityLineItems){
            
            OpportunityLineItem item = new OpportunityLineItem();
            item.PricebookEntryId = i.PricebookEntryId;
            item.Quantity = i.Quantity;
            item.UnitPrice = i.UnitPrice;
            item.OpportunityId = cloneOpp.Id;
            item.Service_Install_Required__c = i.Service_Install_Required__c;
            item.Item_Type__c = i.Item_Type__c;
            
            ins.add(item);
        }

        for(OpportunityContactRole r : masterOpp.OpportunityContactRoles){
            OpportunityContactRole role = new OpportunityContactRole();
            role.ContactId = r.ContactId;
            role.OpportunityId = cloneOpp.Id;
            role.Role = r.Role;
            
            ins.add(role);
        }
        
        try{
            database.insert(ins);
            
            return new PageReference('/' + cloneOpp.Id);// + '/e?retURL=%2F' + cloneOpp.Id);
            
        } catch (exception e){
            return null;
        }
    }
}