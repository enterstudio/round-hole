global virtual class DB_GenericDml {
    global virtual Database.SaveResult[] doUpdate(List<SObject> objectList, Boolean allOrNone) {
    	return Database.update(objectList, allOrNone);
    }

    global virtual Database.SaveResult[] doUpdate(List<SObject> objectList) {
    	return this.doUpdate(objectList, true);
    }
}