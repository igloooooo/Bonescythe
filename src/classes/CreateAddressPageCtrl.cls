public class CreateAddressPageCtrl {
    public final Address__c address {get;set;}
    public final datasan__Address__c a {get;set;}

    private ApexPages.StandardController controller;
    public CreateAddressPageCtrl(ApexPages.StandardController controller) {
        controller.addFields(new String[]{
            'Id',
            'Customer__c',
            'Address_ID__c',
            'Type__c',
            'Address_For_Order__c',
            'Phone__c',
            'Description__c',
            'Street__c',
            'Suburb__c',
            'State__c',
            'Postcode__c',
            'Country__c',
            'Address_Key__c'
        });

        address = (Address__c)controller.getrecord();   
        this.controller = controller;
    }
    
    public PageReference save() {
        Account acc = [select Customer_Number__c, Name from Account where id = :address.Customer__c];
        String customerNumber = acc.Customer_Number__c;
        if (String.isEmpty(customerNumber)) {
            Integer rand = Math.round(Math.random()*100000);
            customerNumber = String.valueof(rand);
        }
        String name = acc.Name.left(5).trim() + customerNumber + address.Type__c + address.Address_ID__c;
        String key = customerNumber + address.Type__c + address.Address_ID__c;
        List<Address__c> result = [select name, Address_Key__c from Address__c where Address_Key__c = :key];
        if (result.size() <= 0) {
            address.name = name;       
            address.Address_Key__c = key;
            System.debug('address is ' + address);
            insert address;
            return this.controller.cancel();
        } else {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The address ID is already used, please choose a unique address ID for the customer.'));
            return this.controller.save();
        }
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('AUPAF','Australian postal addresses (AUPAF)'));
        options.add(new SelectOption('GNAF','Australian geo-coded addresses (GNAF)'));
        return options;
    }

    public datasan__Setting__c getDsSetting() {
        datasan__Setting__c setting = [select name, datasan__Key__c, datasan__Endpoint__c from datasan__Setting__c limit 1];
        return setting;    
    }
    
}