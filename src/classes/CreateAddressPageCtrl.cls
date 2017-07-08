public class CreateAddressPageCtrl {
    public final Address__c address {get;set;}
    private ApexPages.StandardController controller;
    public CreateAddressPageCtrl(ApexPages.StandardController controller) {
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The address ID is already used, please choose a unique address ID for the customer.'));
            return null;
        }
        
    }
    
}