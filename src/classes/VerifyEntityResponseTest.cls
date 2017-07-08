@isTest(seeAllData=False)
public class VerifyEntityResponseTest {
	static testMethod void checkVerifyEntityResponse() {
    	VerifyEntityResponse response = new VerifyEntityResponse();
        response.ABN = '111';
        response.ABNStatus = '111';
        response.ACN = '111';
        response.ACNStatus = '111';
        response.ACNStatusCode = '111';
        response.ApiID = 111;
        response.EntityType = '111';
        response.GSTStatus = '111';
        response.Locality = '111';
        response.Name = '111';
        response.Postcode = '111';
        response.RBN = '111';
        response.RBNState = '111';
        response.State = '111';
        
        System.assertEquals(response.Name,'111');
    }
}