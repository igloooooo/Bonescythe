/**
  *This class contains the creation of test data for the test classes
  *@author Kengo CHINEN - Proquest IT
  *@version 1.0 Created 20/08/2014
**/
@isTest
public with sharing class TestDataUtility {
    
    public static Id requestReciptRecordTypeId = [Select Id from RecordType where DeveloperName = 'RequestReceipt'].Id;
    
  //CREATE ACCOUNT
  public static List<Account> createAccounts(integer numberOfAccounts){
    

    List<Account> accountList = new List<Account>();
    accountList = new List<Account>();
    for(Integer i = 0; i < numberOfAccounts; i++){
      Account account = new Account();
      account.Name = 'TESTNAME'+i;
      account.Phone = '1111111111';
      account.Sales_Rep_Name__c = 'Test rep Name';
      account.BillingCity = 'Test City';
      account.BillingState = 'NSW';
      account.BillingPostalCode = '2000';
      accountList.add(account);
    }
    
    /*if(accountList.size() > 0){
      insert accountList;
    }*/
    
    return accountList;
  }
    

  //CREATE PRODUCT
  public static List<Product2> createProduct(integer numberOfProducts){
      
      List<Product2> products = new List<Product2>();
      for(integer i = 0; i < numberOfProducts; i++){
          Product2 product = new Product2();
          product.Name = 'Test Product';
          product.isActive = TRUE;
          products.add(product);
      }
      
      return products;
  }

    //CREATE INSTALLED PRODUCT with site
  public static List<SVMXC__Installed_Product__c> createInstalled_Product_with_Site(integer numberOfInstalled_Product, List<Account> accounts, List<Product2> products, List<SVMXC__Site__c> sites){
    
    List<SVMXC__Installed_Product__c> Installed_Products = new List<SVMXC__Installed_Product__c>();
    for(Integer i = 0; i < numberOfInstalled_Product; i++){
      SVMXC__Installed_Product__c Installed_Product = new SVMXC__Installed_Product__c();
      Installed_Product.Name = 'installPRandom';
      Installed_Product.Product_Group__c = 'Binders';
      Installed_Product.SVMXC__Company__c = accounts.get(0).Id;
      Installed_Product.SVMXC__Product__c = products.get(0).Id;
      Installed_Product.SVMXC__Site__c = sites.get(0).Id;
      Installed_Product.Related_Location__c = sites.get(0).Id;
      Installed_Product.SVMXC__Serial_Lot_Number__c = '1';
      
      Installed_Products.add(Installed_Product);
    }
    
    return Installed_Products;
  }
  
  //CREATE INSTALLED PRODUCT
  public static List<SVMXC__Installed_Product__c> createInstalled_Product(integer numberOfInstalled_Product, List<Account> accounts, List<Product2> products){
    
    List<SVMXC__Installed_Product__c> Installed_Products = new List<SVMXC__Installed_Product__c>();
    for(Integer i = 0; i < numberOfInstalled_Product; i++){
      SVMXC__Installed_Product__c Installed_Product = new SVMXC__Installed_Product__c();
      Installed_Product.Name = '000';
      Installed_Product.Product_Group__c = 'Binders';
      Installed_Product.SVMXC__Company__c = accounts.get(0).Id;
      Installed_Product.SVMXC__Product__c = products.get(0).Id;
      Installed_Product.SVMXC__Serial_Lot_Number__c = '1';
      
      Installed_Products.add(Installed_Product);
    }
    
    return Installed_Products;
  }
  
  
  //CREATE CONTACT
  public static List<Contact> createContact(integer numberOfContact, List<Account> account){
    
    List<Contact> contacts = new List<Contact>();
    for(Integer i = 0; i < numberOfContact; i++){
      Contact contact = new Contact();
      contact.FirstName = 'TESTFIRST';
      contact.LastName = 'TESTLAST';
      contact.AccountId = account.get(0).Id;
      
      contacts.add(contact);
    }
    
    return contacts;
  }
  
  //CREATE CASE
  public static List<Case> createCase(integer numberOfCase, List<Account> account){
    
    List<Case> cases = new List<Case>();
    for(Integer i = 0; i < numberOfCase; i++){
      Case case1 = new Case();
      case1.AccountId = account.get(0).Id;
      case1.Status = 'Open';

      cases.add(Case1);
    }
    
    return cases;
  }

  //CREATE CASE 2
  public static List<Case> createCase2(integer numberOfCase, List<Account> account, List<SVMXC__Installed_Product__c> installedProducts){
    
    List<Case> cases = new List<Case>();
    for(Integer i = 0; i < numberOfCase; i++){
      Case case2 = new Case();
      case2.AccountId = account.get(0).Id;
      case2.Status = 'Open';
      case2.SVMXC__Component__c = installedProducts.get(0).Id;

      cases.add(Case2);
    }
    
    return cases;
  }
    //CREATE WORKORDER
    public static List<SVMXC__Service_Order__c> createWorkOrder(integer numberOfWorkOrder, List<Account> accounts, List<SVMXC__Installed_Product__c> installedProducts, List<Product2> products, List<SVMXC__Service_Group_Members__c> technicians ){
        
           List<SVMXC__Service_Order__c> workOrders = new List<SVMXC__Service_Order__c>();
           for(Integer i = 0; i < numberOfWorkOrder; i++){
               SVMXC__Service_Order__c workOrder = new SVMXC__Service_Order__c();
               workOrder.SVMXC__Company__c = accounts.get(0).Id;
               workOrder.SVMXC__Order_Status__c = 'Open';
               workOrder.SVMXC__Priority__c = 'Metro Medium';
               workOrder.SVMXC__Order_Type__c = 'Pending Install';
               workOrder.SVMXC__Component__c = installedProducts.get(0).Id;
               workOrder.SVMXC__Product__c = products.get(0).Id;
               if(technicians != null){
                workOrder.SVMXC__Group_Member__c = technicians.get(0).Id;
               }
               
               workOrders.add(workOrder);
           }
           return workOrders;
    }

    //CREATE WORKORDER 2 Test for Roll up summary
 public static List<SVMXC__Service_Order__c> createWorkOrder2(integer numberOfWorkOrder, List<Case> cases ){
        
           List<SVMXC__Service_Order__c> workOrders = new List<SVMXC__Service_Order__c>();
           for(Integer i = 0; i < numberOfWorkOrder; i++){
               SVMXC__Service_Order__c workOrder = new SVMXC__Service_Order__c();          
               workOrder.SVMXC__Order_Status__c = 'Open';
               workOrder.SVMXC__Priority__c = 'Metro Medium';
               workOrder.SVMXC__Order_Type__c = 'Pending Install';
               workOrder.SVMXC__Case__c = cases.get(0).Id;
               
               workOrders.add(workOrder);
           }
           return workOrders;
    }
  
    //CREATE WORKORDER LINE
    public static List< SVMXC__Service_Order_Line__c > createWorkOrderLine(integer numberOfWorkOrderLine, List<SVMXC__Service_Order__c> workorders ){
        
           List<SVMXC__Service_Order_Line__c> workOrderlines = new List<SVMXC__Service_Order_Line__c>();
           for(Integer i = 0; i < numberOfWorkOrderLine; i++){
               SVMXC__Service_Order_Line__c workOrderLine = new SVMXC__Service_Order_Line__c();
               workOrderLine.SVMXC__Service_Order__c = workorders.get(0).Id;
               workOrderLine.RecordTypeid = requestReciptRecordTypeId;
              
               workOrderlines.add(workOrderLine);
           }
           return workOrderlines;
    }  
    
    public static List<Attachment> createAttachments(Integer numberofAttachments, Id parentId){
        List<Attachment> attachments = new List<Attachment>();
        for(Integer i=0; i < numberofAttachments; i++){
            Attachment attachment = new Attachment(name = 'Test Doc'+i, body = blob.toPDF('Test Doc'), ParentId = parentId);
            attachments.add(attachment);
        }
        
        return attachments;
    }
    
    public static List<SVMXC__Site__c> createLocations(Integer numberOfLocations){
        List<SVMXC__Site__c> locations = new List<SVMXC__Site__c>();
        for(Integer i=0; i < numberOfLocations; i++){
            SVMXC__Site__c site = new SVMXC__Site__c(name = 'Site'+i);
            site.SVMXC__Street__c = '12 York Street';
            site.SVMXC__City__c = 'Sydney';
            site.SVMXC__State__c = 'NSW';
            site.SVMXC__Zip__c = '2140';
            site.SVMXC__Country__c = 'Australia';
        site.Movex_Site_Id__c = 'NMWTEST'+i;
            locations.add(site);
        }
        
        return locations;
    }
    
    public static List<SVMXC__Service_Group__c> createServiceGroup(Integer numberOfGroups){
        List<SVMXC__Service_Group__c> serviceGroups = new List<SVMXC__Service_Group__c>();
        for(Integer i=0; i < numberOfGroups; i++){
            SVMXC__Service_Group__c serviceGroup = new SVMXC__Service_Group__c(name = 'Test Group'+i);
            serviceGroups.add(serviceGroup);
        }
        
        return serviceGroups;
    }
    
    public static List<SVMXC__Service_Group_Members__c> createTechnicians(Integer numberOfTechs, List<SVMXC__Service_Group__c> serviceGroups, List<SVMXC__Site__c> locations){
        List<SVMXC__Service_Group_Members__c> technicians = new List<SVMXC__Service_Group_Members__c>();
        for(Integer i = 0; i < numberOfTechs; i++){
           SVMXC__Service_Group_Members__c technician = new SVMXC__Service_Group_Members__c();
           technician.SVMXC__Service_Group__c = serviceGroups.get(i).Id;
           technician.Name = 'Tech'+i;
           technician.SVMXC__Inventory_Location__c = locations.get(i).Id;
           technicians.add(technician);
        }
        return technicians;
    }
    
    public static List<SVMXC__Counter_Details__c> createCounterRecords(Integer numberOfCounters, List<SVMXC__Installed_Product__c> installedProducts){
        RecordType counterReading = [Select Id From RecordType Where DeveloperName = 'Reading'];
        List<Decimal> counterReadings = new List<Decimal> {100000, 275000, 550000};
        List<SVMXC__Counter_Details__c> counters = new List<SVMXC__Counter_Details__c>();
        for(Integer i=0; i < numberOfCounters; i++){
            for(SVMXC__Installed_Product__c product : installedProducts){
                SVMXC__Counter_Details__c counter = new SVMXC__Counter_Details__c(SVMXC__Installed_Product__c = product.Id, RecordTypeId = counterReading.Id, SVMXC__Counter_Reading__c = counterReadings.get(i));
                counters.add(counter);
            }
        }
        return counters;
    }

    public static List<SVMXC__Service_Level__c> createServiceLevels(Integer numberOfContracts){
        List<BusinessHours> bhs=[select id from BusinessHours where IsDefault=true];
        List<SVMXC__Service_Level__c> contracts = new List<SVMXC__Service_Level__c>();
        for(Integer i=0; i < numberOfContracts; i++){
            SVMXC__Service_Level__c contract = new SVMXC__Service_Level__c( Name = 'Test Level',
                                                                            SVMXC__Initial_Response_Tracked_On__c = 'Case',
                                                                            SVMXC__Onsite_Response_Tracked_On__c = 'Case',
                                                                            SVMXC__Resolution_Tracked_On__c = 'Case',
                                                                            SVMXC__Restoration_Tracked_On__c = 'Case',
                                                                            SVMXC__Business_Hours__c = bhs.get(0).Id);
            contracts.add(contract);
        }
        return contracts;
    }
    
    public static List<SVMXC__Service_Pricebook__c> createServicePricebooks(Integer numberOfPbs){
        List<SVMXC__Service_Pricebook__c> contracts = new List<SVMXC__Service_Pricebook__c>();
        for(Integer i=0; i < numberOfPbs; i++){
            SVMXC__Service_Pricebook__c contract = new SVMXC__Service_Pricebook__c( Name = 'Test Level',
                                                                            SVMXC__Description__c = 'Case',
                                                                            SVMXC__Active__c = true);
            contracts.add(contract);
        }
        return contracts;
    }
    
    public static List<SVMXC__Service_Contract_Products__c> createCoveredProducts(List<SVMXC__Installed_Product__c> installedProducts, List<SVMXC__Service_Contract__c> contracts ){
        List<SVMXC__Service_Contract_Products__c> coveredProducts = new List<SVMXC__Service_Contract_Products__c>();
        for(SVMXC__Service_Contract__c contract : contracts){
            for(SVMXC__Installed_Product__c product : installedProducts){
                coveredProducts.add(new SVMXC__Service_Contract_Products__c(SVMXC__Installed_Product__c = product.Id, SVMXC__Service_Contract__c = contract.Id));
            }
        }
        return coveredProducts;
    }
    
}