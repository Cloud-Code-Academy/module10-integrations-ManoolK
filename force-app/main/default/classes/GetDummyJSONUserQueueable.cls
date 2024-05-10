public class GetDummyJSONUserQueueable implements Queueable, Database.AllowsCallouts {
    private List<String> dummyJSONIdList;

    public GetDummyJSONUserQueueable(List<String> dummyJSONIdList) {
        this.dummyJSONIdList = dummyJSONIdList;
    }

    public void execute(QueueableContext qc) {
        for (String dummyJSONId : dummyJSONIdList) {
            DummyJSONCallout.getDummyJSONUserFromId(dummyJSONId);
        }
    }
}