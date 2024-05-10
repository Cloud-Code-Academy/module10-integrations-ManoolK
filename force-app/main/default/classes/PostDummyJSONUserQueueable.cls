public class PostDummyJSONUserQueueable implements Queueable, Database.AllowsCallouts {
    private List<String> contactIdList;

    public PostDummyJSONUserQueueable(List<String> contactIdList) {
        this.contactIdList = contactIdList;
    }

    public void execute(QueueableContext qc) {
        for (String contactId : contactIdList) {
            DummyJSONCallout.postCreateDummyJSONUser(contactId);
        }
    }
}