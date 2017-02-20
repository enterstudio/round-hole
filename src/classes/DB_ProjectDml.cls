global virtual class DB_ProjectDml {
	global virtual Database.UpsertResult[] doUpsertUsingProjectRefAsExternalKey(List<Project__c> updatedProjectList){
		Schema.SObjectField externalKey = Project__c.fields.projectRef__c;
		return Database.upsert(updatedProjectList, externalKey, false);
	}    
}