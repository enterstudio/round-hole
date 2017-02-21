@isTest 
public class DB_GenericDmlMock extends DB_GenericDml { 
	public List<SObject> updatedSObjectList {private set; get;}
	
    public override List<Database.SaveResult> doUpdate(List<SObject> objectList) {
    	if (objectList != null && !objectList.isEmpty()) {
    		this.updatedSObjectList = objectList;
    	}
    	
    	// TODO: Create mock Database.SaveResult[] -- Is that even possible?
    	return null; 
    }
}