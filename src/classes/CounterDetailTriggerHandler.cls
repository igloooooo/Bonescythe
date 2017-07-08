public class CounterDetailTriggerHandler {
    public static void calculateInstalledProductLastCounterReading(List<SVMXC__Counter_Details__c> counterDetails){
        Set<Id> productIds = new Set<Id>();
        RecordType counterReading = [Select Id From RecordType Where DeveloperName = 'Reading'];
        Map<Id, Decimal> newCounterValue = new Map<Id, Decimal>();
        for(SVMXC__Counter_Details__c counterDetail: counterDetails){
            if(counterReading.Id == counterDetail.RecordTypeId){
            	productIds.add(counterDetail.SVMXC__Installed_Product__c);
                if( !newCounterValue.containsKey(counterDetail.SVMXC__Installed_Product__c) || 
                    (newCounterValue.containsKey(counterDetail.SVMXC__Installed_Product__c) && counterDetail.SVMXC__Counter_Reading__c > newCounterValue.get(counterDetail.SVMXC__Installed_Product__c))){
            		newCounterValue.put(counterDetail.SVMXC__Installed_Product__c, counterDetail.SVMXC__Counter_Reading__c);
                }
            }
        }

        Map<Id, SVMXC__Installed_Product__c> installedProducts = new Map<Id, SVMXC__Installed_Product__c>([Select Id, Last_Counter_Reading__c From SVMXC__Installed_Product__c Where ID IN :productIds AND PM_Cycle__c = true ]);
        
        Map<Decimal, Decimal>  counterBrackets = new Map<Decimal,Decimal>();
        for(CounterReadingBrackets__c bracket: CounterReadingBrackets__c.getAll().values() ){
            Decimal startValue = Decimal.valueOf(bracket.Name);
            counterBrackets.put(startValue, bracket.End__c);
        }
        
        List<Decimal> counterStarts = new List<Decimal>();
        counterStarts.addAll(counterBrackets.keySet());
        counterStarts.sort();
        for(SVMXC__Installed_Product__c product: installedProducts.values()){
            if(product.Last_Counter_Reading__c != newCounterValue.get(product.Id)){
                for(Decimal counter : counterStarts){
                    Decimal lastReading = product.Last_Counter_Reading__c != null ? product.Last_Counter_Reading__c : 0;
                    if(counter <= newCounterValue.get(product.Id) && counter > lastReading){
                    	product.Last_Counter_Reading__c = newCounterValue.get(product.Id);
                    }
                }
            }
        }
        
        if(installedProducts.size() > 0){
        	update installedProducts.values();
        }
    }
}