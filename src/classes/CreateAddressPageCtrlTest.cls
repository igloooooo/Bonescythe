@isTest
public class CreateAddressPageCtrlTest {
	public static testMethod void testCreateAddress() {
        Address__c address = new Address__c(Name='TestCreateAddress');
        address.Type__c = 1;
        address.Address_ID__c = '7930';
        address.Customer__c = CreditReportTestDataFactory.createAccountsWithDisplayAlert().id;
      	ApexPages.StandardController sc = new ApexPages.StandardController(address);        
        CreateAddressPageCtrl controller = new CreateAddressPageCtrl(sc);
		controller.save();
    }
}