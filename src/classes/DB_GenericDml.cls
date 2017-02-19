global virtual class DB_GenericDml {
    global virtual Database.SaveResult[] doInsert(List<SObject> objectList) {
    	return Database.insert(objectList, true);
    }

    global virtual Database.SaveResult[] doUpdate(List<SObject> objectList) {
    	return Database.update(objectList, true);
    }
}