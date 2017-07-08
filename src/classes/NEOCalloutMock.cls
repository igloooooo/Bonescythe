@isTest
global class NEOCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('{"Recommendation":"REFER","NTEId":"91650","ApplicationURL":"https://secure.creditworks.com.au/index.php?Action=camp.application&ApplicationID=91650","ABN":"62515507453","ACN":"","EntityStatus":"ACT","Name":"DAVID JOHN THORLEY","RBN":"","RBNState":"","EntityType":"IND","ACNStatus":"as","ACNStatusCode":"","ABNStatus":"","GSTStatus":"","PaidCapital":"null","UnpaidCapital":"null","NumberShares":"null","TradingAddress":"null","BusinessAddress":"null","CreditHistory":"test history","FinancialStatement":["F"],"IncorporationDate":null,"ApiID":879347}');
    return res;
  }
}