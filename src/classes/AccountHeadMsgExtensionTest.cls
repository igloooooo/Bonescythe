@isTest
public class AccountHeadMsgExtensionTest {
	public static testMethod void testAccountHeadMsgExtensionWithDisplay() {        
      	ApexPages.StandardController sc = new ApexPages.StandardController(
        	CreditReportTestDataFactory.createAccountsWithDisplayAlert());
        
        AccountHeadMsgExtension controller = new AccountHeadMsgExtension(sc);
		controller.checkAccountEntity();
        controller.Dismiss();
    }
    
    public static testMethod void testAccountHeadMsgExtensionWithoutDisplay() {        
      	ApexPages.StandardController sc = new ApexPages.StandardController(
        	CreditReportTestDataFactory.createAccountsWithoutVedaSurnameWithOpp());
        
        AccountHeadMsgExtension controller = new AccountHeadMsgExtension(sc);
		controller.checkAccountEntity();
        controller.Dismiss();
    }

}