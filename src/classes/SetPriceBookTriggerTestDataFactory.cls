@isTest(SeeAllData=true)
public class SetPriceBookTriggerTestDataFactory {
	public static Account createAccountsWithoutPriceGroup() {
        Account a = new Account(Name='TestAccountWithoutPriceGroup');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'test state';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = 'aa';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        a.Display_Alert__c = false;
        insert a;
             
        return a;
    }
    
    public static Account createAccountsWithGV() {
        Account a = new Account(Name='TestAccountWithoutPriceGroup');   
        a.State__c = 'test';
        a.ABN__c = 'aaa';
        a.ACN__c = 'aaa';
        a.BillingCity = 'test bill city';  
        a.BillingState = 'test state';
        a.BillingPostalCode = '1111';
        a.Customer_Number__c = 'aaaa';
        a.Phone = '111';
        a.Reference_Contact_1__c  = 'asdf';
        a.Veda_ST_Given_Name__c = '11';
        a.Veda_ST_Gender__c = '11';
        a.Veda_ST_Date_of_Birth__c = 'aa';
        a.Veda_ST_Driver_License_Number__c = 'aa'; 
        a.Veda_ST_Suburb__c = 'aa';
        a.Veda_ST_Postcode__c = 'bb';
        a.Veda_ST_StreetName__c = 'cc';
        a.Veda_ST_StreetNumber__c = 'aa';
        a.Display_Alert__c = false;
        a.Price_Group__c = 'GV';
        insert a;
             
        return a;
    }
}