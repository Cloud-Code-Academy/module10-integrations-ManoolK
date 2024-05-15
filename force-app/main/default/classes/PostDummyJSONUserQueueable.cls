public class PostDummyJSONUserQueueable implements Queueable, Database.AllowsCallouts {

    private Map<Id, Contact> contsById;

    public PostDummyJSONUserQueueable(Map<Id, Contact> contactsById) {
        this.contsById = contactsById;
    }

    public void execute(QueueableContext qc) {
        List<Id> contactIdsForUpdate = DummyJSONCallout.postCreateDummyJSONUser(this.contsById.keySet());

        List<Contact> contacts = [
			SELECT Id, DummyJSON_Last_Updated__c 
			FROM Contact 
			WHERE Id IN :contactIdsForUpdate
        ];
        for (Contact cont : contacts) {
            cont.DummyJSON_Last_Updated__c = Datetime.now();
        }
		Database.update(contacts);
    }
}