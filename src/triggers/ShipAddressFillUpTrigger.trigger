trigger ShipAddressFillUpTrigger on Opportunity (before insert, before update) {
	for (Opportunity o : Trigger.new)
    {
        System.debug('ship address:' + o.Ship_Address_Default__c);
        if (o.Ship_Address_Default__c != null && Trigger.oldMap.get(o.Id).Fulfilment_Status__c != 'Sent to Movex')
        {
            // find the default ship address
            String accountId = o.AccountId;
            String addressId = o.Ship_Address_Default__c;
            List<Address__c> shipAddress = [select Name, Address_ID__c, Address_For_Order__c, Address_Key__c,
                                   Street__c, Suburb__c, State__c, Postcode__c         
                                   from Address__c 
                                   where Id = :addressId];
            System.debug('ship address:' + shipAddress);
            if(!shipAddress.isEmpty()){
                System.debug('find ship address.');
            	o.Address_ID__c = shipAddress.get(0).Address_ID__c;    
                o.Shipping_Address__c = shipAddress.get(0).Street__c +'\n' 
                    + shipAddress.get(0).Suburb__c + ' ' + shipAddress.get(0).State__c + ' ' + shipAddress.get(0).Postcode__c;
            }
            
        }
        
    }
}