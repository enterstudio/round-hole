trigger ProjectTrigger on Project__c (after update) {
    //fflib_SObjectDomain.triggerHandler(BillingCalloutService.class);
    BillingCalloutService.callBillingService(Trigger.new, Trigger.oldMap);
}