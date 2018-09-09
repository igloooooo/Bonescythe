@isTest(seealldata=true)
public class test_CloneOpportunity {
    
    public static Opportunity opp {get;set;}
    
    public static testmethod void insertRecords(){
        
        // insert Account
        Account a = new Account();
        	a.Name = 'Test Account';
        	a.BillingStreet = '123 Street Rd';
        	a.BillingCity = 'Sydney';
        	a.BillingState = 'NSW';
        	a.BillingPostalcode = '2000';
        	a.BillingCountry = 'Australia';
        insert a;
        
        // insert Contact
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'dev@prolytics.com.au';
        c.Phone = '0444444444';
        c.AccountId = a.Id;
        insert c;
        
        // insert Products
        Product2 bms = new Product2();
        	bms.Name = 'Test BMS';
        	bms.Product_Group__c = 'MMI';
        	bms.Product_Type__c = 'MA';
        	bms.is_primary_Product__c = true;
        	bms.Service_Install_Required__c = true;
        	bms.IsActive = true;
        	bms.Item_No__c = 'BMS1234';
        insert bms;
        
        Product2 bmspm = new Product2();
        	bmspm.Name = 'Test BMSPM';
        	bmspm.Product_Group__c = 'MMF';
        	bmspm.Product_Type__c = 'MA';
        	bmspm.is_primary_Product__c = true;
        	bmspm.IsActive = true;
        	bmspm.Item_No__c = 'BMSPM1234';
        insert bmspm;
        
        Product2 pfs = new Product2();
        	pfs.Name = 'Test PFS';
        	pfs.Product_Group__c = 'MGD';
        	pfs.Product_Type__c = 'MA';
        	pfs.is_primary_Product__c = true;
        	pfs.IsActive = true;
        	pfs.Item_No__c = 'PSF1234';
        insert pfs;
		
        Product2 pfswf = new Product2();
        	pfswf.Name = 'Test PFSWF';
        	pfswf.Product_Group__c = 'MIJ';
        	pfswf.Product_Type__c = 'MA';
        	pfswf.is_primary_Product__c = true;
        	pfswf.IsActive = true;
        	pfswf.Item_No__c = 'PSFWS1234';
        insert pfswf;
        
        // Pricebook Entries taken care of automatically through existing trigger
        
        // insert Opportunity
        Opportunity o = new Opportunity();
            o.Name = 'Test Opportunity';
            o.StageName = 'Negotiation/Review';
            o.CloseDate = system.today().addDays(30);
            o.AccountId = a.Id;
            o.Requested_Delivery_Date__c = system.today().addDays(45);
            o.Type = 'New Business';
            o.LeadSource = 'Referral';
         insert o;   
        
        //insert OpportunityContactRole
        OpportunityContactRole ocr = new OpportunityContactRole();
        	ocr.OpportunityId = o.id;
        	ocr.ContactId = c.Id;
        	ocr.isPrimary = true;
        insert ocr;
        
        Set<string> prodIds = new Set<string>();
            prodIds.add(bms.Id);
            prodIds.add(bmspm.Id);
            prodIds.add(pfs.Id);
            prodIds.add(pfswf.Id);
        
        List<PricebookEntry> pbeList = [select Id, Product2Id, Product2.Item_No__c 
                                        from PricebookEntry
                                       	where Product2Id in :prodIds];
        
        Map<string, string> pbeMap = new map<string,string>();
        
        for(PricebookEntry pbe : pbeList){
            pbe.isActive = true;
            
            if(pbe.Product2.Item_No__c == 'BMS1234'){
                pbe.UnitPrice = 3000;
            }
            
            update pbe;
            
            pbeMap.put(pbe.Product2Id, pbe.Id);
        }
        
        system.debug('pbeMap: ' + pbeMap);

        // insert OpportunityLineItems
        
        //OpportunityTriggerUtility.firstRun = true;
        
        OpportunityLineItem bmsOi = new OpportunityLineItem();
        	bmsOi.OpportunityId = o.Id;
        	bmsOi.PricebookEntryId = pbeMap.get(bms.Id);
        	bmsOi.Quantity = 1;
        	bmsOi.UnitPrice = 4000;
        	bmsOi.Service_Install_Required__c = 'Yes';
        insert bmsOi;
        
        OpportunityLineItem bmspmOi = new OpportunityLineItem();
        	bmspmOi.OpportunityId = o.Id;
        	bmspmOi.PricebookEntryId = pbeMap.get(bmspm.Id);
        	bmspmOi.Quantity = 1;
        	bmspmOi.UnitPrice = 3000;
        	bmspmOi.Service_Install_Required__c = 'No';
        insert bmspmOi;
        
        OpportunityLineItem pfsOi = new OpportunityLineItem();
        	pfsOi.OpportunityId = o.Id;
        	pfsOi.PricebookEntryId = pbeMap.get(pfs.Id);
        	pfsOi.Quantity = 1;
        	pfsOi.UnitPrice = 2000;
        	pfsOi.Service_Install_Required__c = 'Yes';
        insert pfsOi;
        
        OpportunityLineItem pfswfOi = new OpportunityLineItem();
        	pfswfOi.OpportunityId = o.Id;
        	pfswfOi.PricebookEntryId = pbeMap.get(pfswf.Id);
        	pfswfOi.Quantity = 1;
        	pfswfOi.UnitPrice = 1000;
        	pfswfOi.Service_Install_Required__c = 'No';
        insert pfswfOi;

        	opp = o;
        	/*acc = a;
        	bmsItem = bmsOi;
        	bmspmItem = bmspmOi;
        	pfsItem = pfsOi;
        	pfswfItem = pfswfOi;
			*/
    }

    
    public static testmethod void testGenerateClonedOppty(){
        
        insertRecords();
        
        test.setCurrentPage(Page.cloneOpportunity);
        ApexPages.currentPage().getParameters().put('id', opp.Id);
        
        ApexPages.StandardController stdCon = new ApexPages.StandardController(opp);
        cloneOpportunityController con = new cloneOpportunityController(stdCon);
        
        con.generateClonedOppty();
        
    }

}