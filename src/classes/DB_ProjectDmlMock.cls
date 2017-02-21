@isTest 
public class DB_ProjectDmlMock extends DB_ProjectDml { 
	public List<Project__c> upsertedSObjectList {private set; get;}
	public Boolean upsertIsAllOrNone {private set; get;}
	
    public override Database.UpsertResult[] doUpsertUsingProjectRefAsExternalKey(List<Project__c> projectList, boolean allOrNone) {
    	if (projectList != null && !projectList.isEmpty()) {
    		this.upsertedSObjectList = projectList;
    	}
    	this.upsertIsAllOrNone = allOrNone;

    	// TODO: Create mock Database.UpsertResult[] -- Is that even possible?
    	return null; 
    }
}