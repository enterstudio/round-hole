@isTest
private class DB_ProjectDmlTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testDoUpsertUsingProjectRefAsExternalKey(){
		// Arrange
		DB_ProjectDml targetClass = new DB_ProjectDml();
		Project__c projectTemplate = new Project__c (projectRef__c = 'Test-Ref-001');
		Project__c project = TEST_ProjectFactory.create(projectTemplate, TEST_DummyInsertModeEnum.LATER); 
    
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.doUpsertUsingProjectRefAsExternalKey(new List<Project__c>{project}, true);
            }
            Test.stopTest();
        }

		// Assert
		List<Project__c> resultProjectList = [SELECT id FROM Project__c WHERE projectRef__c = :projectTemplate.projectRef__c];		
		System.assertEquals(1, resultProjectList.size());
	}
}