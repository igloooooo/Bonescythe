@isTest
global class NEOCalloutSoleTraderMock implements HttpCalloutMock{
	global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('{"ABN": "85000666300","ACN": "000666366","ACNStatus": "External Administration","ACNStatusCode": "EXAD", "ABNStatus": "ACTIVE", "GSTStatus": "GST","EntityType": "IND","Name": "JOHN GIKAS PTY LTD", "RBN": "","RBNState": "","Recommendation": "REFER", "NTEId": "1008368", "ApplicationURL":"https://test.creditworks.com.au/index.php?Action=camp.application&ApplicationID=1008368", "Locality": "MELBOURNE VIC 3000","State": "VIC","Postcode": "3000","ExadFlag": "","WindupFlag": "","ApiID": 925890}');
    return res;
  }
}