trigger AddFreightTrigger on Opportunity (before update, after update) {

    /*List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
    List<OpportunityLineItem> oluList = new List<OpportunityLineItem>();

    // check if price book exist
    Boolean priceExist = false;

    if(!AddFreightTriggerHelper.run) {
        for (Opportunity opp : Trigger.new) {
            List<Pricebook2> checkPriceBook = [SELECT Id FROM Pricebook2 WHERE Id = :opp.Pricebook2Id];
            List<PricebookEntry> checkFreight = new List<PricebookEntry>();
            if(!checkPriceBook.isEmpty()) {
                checkFreight = [SELECT Id, UnitPrice
                                FROM PricebookEntry
                                WHERE Pricebook2Id = :checkPriceBook.get(0).Id
                                AND Product2.Item_No__c = 'Freight1'];


                if(!checkFreight.isEmpty()) {
                    priceExist = true;
                }
            }
            if (priceExist) {
                Opportunity oppOld = Trigger.oldMap.get(opp.ID);
                if(opp.StageName == 'Closed Won' && (oppOld.Special_Delivery__c != opp.Special_Delivery__c
                                                 || oppOld.Freight__c != opp.Freight__c
                                                 || oppOld.Amount != opp.Amount
                                                 || opp.StageName != oppOld.StageName)) {

                     String oppId = opp.Id;
                     String entryId = checkFreight[0].Id;
                     String whs = '';

                     List<OpportunityLineItem> oliCur = [select Id, OpportunityId, PricebookEntryId, UnitPrice, Quantity
                                                         from OpportunityLineItem
                                                         where OpportunityId=:oppId and PricebookEntryId = :entryId];
                     // find the current warehouse
                     List<OpportunityLineItem> tempWarehouseList = [select Id, OpportunityId, PricebookEntryId, UnitPrice, Quantity, WHS__c
                                                                    from OpportunityLineItem
                                                                    where OpportunityId=:oppId];

                     if (!tempWarehouseList.isEmpty()) {
                         System.debug('warehouse is  ' + tempWarehouseList.get(0).WHS__c);
                         whs = tempWarehouseList.get(0).WHS__c;
                     }
                     System.debug('current feight is ' + oliCur.size());
                     if (opp.Special_Delivery__c == 'Approved Exemption') {
                         System.debug('Sales Approved Exemption, no fee. ');
                     } else if (opp.Special_Delivery__c == 'Sales Rep to Deliver') {
                         System.debug('Sales Rep to Deliver, no fee. ');
                     } else if (opp.Special_Delivery__c == 'Customer to Collect') {
                         System.debug('Customer to Collect, no fee. ');
                     } else if (opp.Special_Delivery__c == 'VIP Courier' ) {
                         System.debug('old is ' + oppOld.VIP_Courier__c + ' and new is ' + opp.Special_Delivery__c);
                         System.debug('condition one triggered.');
                         if(oliCur.isEmpty()) {
                             if (Trigger.isAfter) {
                                 oliList.add(new OpportunityLineItem(PricebookEntryId=entryId,
                                                                     OpportunityId=oppId,
                                                                     UnitPrice=50.0,
                                                                     Description='Freight',
                                                                     Completion_Status__c='Complete',
                                                                     WHS__c=whs,
                                                                     Quantity=1));
                             }
                             if (Trigger.isBefore) {
                                 if(opp.Requested_Delivery_Date__c != null) {
                                     opp.Requested_Delivery_Date__c = opp.Requested_Delivery_Date__c.addDays(5);
                                 }
                             }
                         }else {
                             OpportunityLineItem element = oliCur.get(0);
                             element.UnitPrice = 50.0;
                             oluList.add(element);
                         }


                     }else if (opp.Special_Delivery__c == 'Same Day Delivery') {
                         System.debug('condition two triggered.');
                         if(oliCur.isEmpty()) {
                             if (Trigger.isAfter) {
                                 oliList.add(new OpportunityLineItem(PricebookEntryId=entryId,
                                                                     OpportunityId=oppId,
                                                                     UnitPrice=30.0,
                                                                     Description='Freight',
                                                                     Completion_Status__c='Complete',
                                                                     WHS__c=whs,
                                                                     Quantity=1));
                             }
                             if (Trigger.isBefore) {
                                 if(opp.Requested_Delivery_Date__c != null) {
                                     opp.Requested_Delivery_Date__c = opp.Requested_Delivery_Date__c.addDays(5);
                                 }
                             }
                         }else {
                             OpportunityLineItem element = oliCur.get(0);
                             element.UnitPrice = 30.0;
                             oluList.add(element);
                         }

                     }else if (opp.Freight__c == 'Standard' && opp.Amount <=200) {
                         System.debug('condition three triggered.');
                         if(oliCur.isEmpty()) {
                             if (Trigger.isAfter) {
                                 oliList.add(new OpportunityLineItem(PricebookEntryId=entryId,
                                                                     OpportunityId=oppId,
                                                                     UnitPrice=25.0,
                                                                     Description='Freight',
                                                                     Completion_Status__c='Complete',
                                                                     WHS__c=whs,
                                                                     Quantity=1));
                             }
                             if (Trigger.isBefore) {
                                 if(opp.Requested_Delivery_Date__c != null) {
                                     opp.Requested_Delivery_Date__c = opp.Requested_Delivery_Date__c.addDays(5);
                                 }
                             }
                         }else {
                             OpportunityLineItem element = oliCur.get(0);
                             element.UnitPrice = 25.0;
                             oluList.add(element);
                         }

                     }else if (opp.Freight__c == 'Standard' && opp.Amount >200 && opp.Amount <500) {
                         System.debug('condition four triggered.');
                         if(oliCur.isEmpty()) {
                             if (Trigger.isAfter) {
                                 oliList.add(new OpportunityLineItem(PricebookEntryId=entryId,
                                                                     OpportunityId=oppId,
                                                                     UnitPrice=20.0,
                                                                     Description='Freight',
                                                                     Completion_Status__c='Complete',
                                                                     WHS__c=whs,
                                                                     Quantity=1));
                             }
                             if (Trigger.isBefore) {
                                 if(opp.Requested_Delivery_Date__c != null) {
                                     opp.Requested_Delivery_Date__c = opp.Requested_Delivery_Date__c.addDays(5);
                                 }
                             }
                         }else {
                             OpportunityLineItem element = oliCur.get(0);
                             element.UnitPrice = 20.0;
                             oluList.add(element);
                         }

                     }else if (opp.Freight__c == 'Exempt over $200' && opp.Amount <=200) {
                         System.debug('condition five triggered.');
                         if(oliCur.isEmpty()) {
                             if (Trigger.isAfter) {
                                 oliList.add(new OpportunityLineItem(PricebookEntryId=entryId,
                                                                     OpportunityId=oppId,
                                                                     UnitPrice=25.0,
                                                                     Description='Freight',
                                                                     Completion_Status__c='Complete',
                                                                     WHS__c=whs,
                                                                     Quantity=1));
                             }
                             if (Trigger.isBefore) {
                                 if(opp.Requested_Delivery_Date__c != null) {
                                     opp.Requested_Delivery_Date__c = opp.Requested_Delivery_Date__c.addDays(5);
                                 }
                             }
                         }else {
                             OpportunityLineItem element = oliCur.get(0);
                             element.UnitPrice = 25.0;
                             oluList.add(element);
                         }
                     }
                    }
                }
        }
    }
    System.debug('find the item line size is : ' + oliList.size());
    System.debug('find the update item line size is : ' + oluList.size());
    if (Trigger.isAfter) {
        if(!oliList.isEmpty()) {
            AddFreightTriggerHelper.run = true;
            insert oliList;
            AddFreightTriggerHelper.run = false;
        }
        if(!oluList.isEmpty()) {
            AddFreightTriggerHelper.run = true;
            update oluList;
            AddFreightTriggerHelper.run = false;
        }
    }*/
}