@isTest
private class TRIG_ProjectTriggerTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void projectUpdateShouldSetStatusToBilledAfterCallout(){
		// Arrange
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		Project__c newProject = TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		List<Project__c> newProjectList = new List<Project__c>{newProject};
				
		newProject.status__c = 'Billed';
			
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                update(newProject); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
	}
}