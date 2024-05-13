/**
 * Key Behaviors:
 * 1. When a new Contact is inserted and doesn't have a value for the DummyJSON_Id__c field, the trigger generates a random number between 0 and 100 for it.
 * 2. Upon insertion, if the generated or provided DummyJSON_Id__c value is less than or equal to 100, the trigger initiates the getDummyJSONUserFromId API call.
 * 3. If a Contact record is updated and the DummyJSON_Id__c value is greater than 100, the trigger initiates the postCreateDummyJSONUser API call.
 * 
 * Best Practices for Callouts in Triggers:
 * 
 * 1. Avoid Direct Callouts: Triggers do not support direct HTTP callouts. Instead, use asynchronous methods like @future or Queueable to make the callout.
 * 2. Bulkify Logic: Ensure that the trigger logic is bulkified so that it can handle multiple records efficiently without hitting governor limits.
 * 3. Avoid Recursive Triggers: Ensure that the callout logic doesn't result in changes that re-invoke the same trigger, causing a recursive loop.
 */

public with sharing class ContactTriggerHandler extends TriggerHandler {

    private List<Contact> newConts;

    /**
     * Constructor. Set instance variables.
     */
    public ContactTriggerHandler() {
        this.newConts = (List<Contact>) Trigger.new;
    }

    /**
     * Before Insert method.
     * 
     * When a contact is inserted
     * if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
     * if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
     */
    public override void beforeInsert() {
        List<String> dummyJSONIdList = new List<String>();
        for (Contact cont : newConts) {
            if (cont.DummyJSON_Id__c == null) {
                cont.DummyJSON_Id__c = String.valueOf(Math.round(Math.random() * 100));
            }
            if (Integer.valueOf(cont.DummyJSON_Id__c) <= 100 && !System.isFuture()) {
                DummyJSONCallout.getDummyJSONUserFromId(cont.DummyJSON_Id__c);
            }
        }
    }

    /**
     * After Update method.
     * 
	 * When a contact is updated
	 * if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
     */
    public override void afterUpdate() {
        for (Contact cont : newConts) {
            if (Integer.valueOf(cont.DummyJSON_Id__c) > 100 && !System.isFuture()) {
                DummyJSONCallout.postCreateDummyJSONUser(cont.Id);
            }
        }
    }
}