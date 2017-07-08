trigger CheckCreditTrigger on Opportunity (before update) {  
    
    if(Trigger.isBefore) {
        // check if opportunity changed.
        for (Opportunity opportunity : Trigger.new) {
            if(Trigger.oldMap.get(opportunity.Id).StageName != opportunity.StageName && opportunity.StageName == 'Closed Won') {
                System.debug('Trigger to check credit.');
                String accountID = opportunity.AccountId;
                Account account = [select id, ACN__C, ABN__C, Entity_Name__c, Customer_Number__c, Entity_Type__c,
                               Veda_ST_Surname__c, Veda_ST_Given_Name__c, Veda_ST_Gender__c, 
                               Veda_ST_Date_of_Birth__c, Veda_ST_Driver_License_Number__c, 
                               Veda_ST_Suburb__c,Veda_ST_Postcode__c, Veda_ST_StreetName__c, Veda_ST_StreetNumber__c,
                               State__c, Veeda_Check_Date_Time__c, Veda_Terms_Conditions_Signed__c
                              from Account where id = :accountID];
                System.debug('account.Customer_Number__c is ' + account.Customer_Number__c);
                   System.debug('opportunity.Payment_Method__c is ' + opportunity.Payment_Method__c);
                   System.debug('account.Veda_Terms_Conditions_Signed__c ' + account.Veda_Terms_Conditions_Signed__c);
                //Old Customer + Not Finance
                if (opportunity.Payment_Method__c == 'Credit Card') {
                    System.debug('credit card, no veda checking. ');
                    opportunity.Fulfilment_Status__c = 'Ready for Movex'; 
                } else if(!String.isEmpty(account.Customer_Number__c) && opportunity.Payment_Method__c != 'Neopost Finance'){
                    // change Fulfillment Status = Ready for Movex
                    if (opportunity.Customer_Status1__c == '20') {
                        opportunity.Fulfilment_Status__c = 'Ready for Movex'; 
                    } else {
                        opportunity.Fulfilment_Status__c = 'Customer Status Invalid – Pending for AR Approval'; 
                    }
                       
                } else if(opportunity.Payment_Method__c == 'Neopost Finance') {
                    opportunity.Fulfilment_Status__c = 'Neopost Finance - Pending for AR Approval';    
                }
                // else if(opportunity.Payment_Method__c == 'Neopost Finance' 
                //     && (account.Veeda_Check_Date_Time__c == null || (account.Veeda_Check_Date_Time__c != null
                //     && CheckCreditUtil.betweenDaysToToday(account.Veeda_Check_Date_Time__c) > 90))) {
                    // start to check veda report
                //    opportunity.Fulfilment_Status__c = 'Pending for Finance Approval';    
                //    String message = CheckCreditUtil.checkCreditCondition(account.Entity_Type__c, account);
                //    System.debug('Error message is ' + message);
                //    if(String.isNotEmpty(message)){
                //        opportunity.addError('Missing compulsory fields for Veda Check: ' + message);            
                //    } else {
                //        CreditCheckTriggerCallOut.triggerCheckCredit(opportunity.id, '1');
                //        System.debug('start to check credit');      
                //    }
                //} 
                else if(String.isEmpty(account.Customer_Number__c) && opportunity.Payment_Method__c == 'On Account') {
                    String message = CheckCreditUtil.checkCreditCondition(account.Entity_Type__c, account);
                    System.debug('Error message is ' + message);
                    if(String.isNotEmpty(message)){
                        opportunity.addError('Missing compulsory fields for Veda Check:'+ message);          
                    } else {
                        opportunity.Fulfilment_Status__c = 'Performing Credit Check';
                        CreditCheckTriggerCallOut.triggerCheckCredit(opportunity.id, '1');
                        System.debug('start to check credit');      
                    }                         
                }
            }
            
        }
    }
}