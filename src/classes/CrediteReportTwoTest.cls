@isTest(seeAllData=False)
public class CrediteReportTwoTest {
	static testMethod void checkCrediteReportTwo() {
     	CrediteReportTwo report = new CrediteReportTwo();
        report.ABN = '111';
        report.ABNStatus = '111';
        report.ACN = '111';
        report.ACNStatus = '111';
        report.ACNStatusCode = '111';
        report.ApiID = 111;
        report.ApplicationURL = '111';
        report.BusinessAddress = '111';
        //report.CreditHistory = '111';
        report.EntityStatus = '111';
        report.EntityType = '111';
        report.ExadFlag = '111';
        report.FinancialStatement = new List<String>();
        report.GSTStatus = '111';
        report.IncorporationDate = '111';
        report.Locality = '111';
        report.Name = '111';
        report.NTEId = '111';
        report.NumberShares = '111';
        report.PaidCapital = '111';
        report.Postcode = '111';
        report.RBN = '111';
        report.RBNState = '111';
        report.Recommendation = '111';
        report.State = '111';
        report.TimeInBusiness = '111';
        report.TradingAddress = '111';
        report.UnpaidCapital = '111';
        report.WindupFlag = '111';
        
        System.assertEquals(report.WindupFlag,'111');
    }
}