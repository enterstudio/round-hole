global virtual class DB_ProjectDml {
	global virtual List<Database.UpsertResult> doUpsertUsingProjectRefAsExternalKey(List<Project__c> projectList, boolean allOrNone){
		Schema.SObjectField externalKey = Project__c.fields.projectRef__c;
		return Database.upsert(projectList, externalKey, allOrNone);
	}    
}