@isTest 
public class DB_GenericDmlMock extends DB_GenericDml { 
	public List<SObject> updatedSObjectList {private set; get;}
	
    public override void doUpdate(List<SObject> objectList) {
    	if (objectList != null && !objectList.isEmpty()) {
    		this.updatedSObjectList = objectList;
    	}
    	
    }
}