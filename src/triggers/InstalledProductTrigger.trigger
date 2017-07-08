trigger InstalledProductTrigger on SVMXC__Installed_Product__c (before insert, before update) {
    InstalledProductTriggerHandler.productAddressPrepopulate(trigger.new);
}