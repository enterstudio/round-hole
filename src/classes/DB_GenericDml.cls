global virtual class DB_GenericDml {
	
    global virtual Database.SaveResult[] doUpdate(List<SObject> objectList) {
    	return Database.update(objectList, true);
    }
}