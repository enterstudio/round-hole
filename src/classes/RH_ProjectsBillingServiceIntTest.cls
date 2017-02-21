@isTest
private class RH_ProjectsBillingServiceIntTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testCallBillingServiceForList() {
		// Arrange
		RH_ProjectsBillingService targetClass = new RH_ProjectsBillingService();
		
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		Project__c project = TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.callBillingService(new List<Project__c>{project}); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
		
	}
	
	@isTest static void testAsyncCallBillingServiceUpdatesProject(){
		// Arrange
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                RH_ProjectsBillingService.asyncCallBillingService(projectRef, amount); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
	}
}