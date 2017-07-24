@isTest//(SeeAllData=true)
public class CreditReportTestDataFactory {
    
    public static Account createAccountsWithDisplayAlert() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        a.Display_Alert__c = true;
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutVedaSurnameWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        a.Display_Alert__c = false;
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutGiven_NameWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutGenderWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutDOBWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Date_of_Birth__c = '';
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutDriverWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutSuburbWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutPostcodeWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutStreetNameWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithoutStreetNumberWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Account createAccountsWithOpp() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Surname__c = '11';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = '1980-10-10';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return a;
    }
    
    public static Opportunity createOppWithAccountForTriggerOne() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.ABN__c = '1111';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;
        return opp;
    }
    
    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerTwo() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Veeda_Check_Date_Time__c = System.today();
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'Neopost Finance',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;
        return opp;
    }
    
    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerThree() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Entity_Name__c = 'test';
        a.Entity_Type__c = 'company';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'Neopost Finance',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;
        return opp;
    }
    
    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerFour() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Entity_Name__c = 'test';
        a.Entity_Type__c = 'company';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;
        return opp;
    }

    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerFive() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Entity_Name__c = 'test';
        a.Entity_Type__c = 'company';
        a.Customer_Number__c = '';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        return opp;
    }

    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerSix() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Entity_Name__c = 'test';
        a.Entity_Type__c = 'company';
        a.Customer_Number__c = '';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veeda_Check_Date_Time__c = System.today();
        a.Veeda_Status__c = 'OK';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        return opp;
    }

    public static Opportunity createOppWithAccountWithNeopostFinanceForTriggerSeven() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Entity_Name__c = 'test';
        a.Entity_Type__c = 'company';
        a.Customer_Number__c = '';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veeda_Check_Date_Time__c = System.today();
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Fulfilment_Status__c = 'Neopost Finance - Pending for Finance Approval',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        return opp;
    }
    
    public static Opportunity createOppWithAccount() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.ABN__c = '1111';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'On Account',
                                       Customer_Status__c = 'New',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;

        opp.StageName = 'Closed Won';
        update opp;
        
        return opp;
    }
    
    public static Opportunity createOppWithAccountWithNeopostFinance() {
        Account a = new Account(Name='TestAccountCheckVeda');   
        a.State__c = 'test';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'NSW';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.ABN__c = '1111';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        insert a;
        Opportunity opp = new Opportunity(Name=a.Name + ' Opportunity CheckVeda',
                                       CloseDate=System.today().addMonths(1),
                                       Requested_Delivery_Date__c = System.today().addMonths(1),
                                       AccountId=a.Id,   
                                       City__c = 'test city',
                                       ABN__c = '1111',
                                       StageName = 'Lead',
                                       Payment_Method__c = 'Credit Card',
                                       Amount = 12);
        
        // Insert all opportunities for all accounts.
        insert opp;
        List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry WHERE IsActive=true AND PriceBook2.isStandard=true LIMIT 1];
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId= opp.Id, 
            PricebookEntryId=priceBookList[0].Id,
            Quantity=1,
            WHS__c='NSW',
            TotalPrice=0.00);
        insert oli;
        return opp;
    }
    
}