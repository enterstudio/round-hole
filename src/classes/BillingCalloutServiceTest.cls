@isTest
private class BillingCalloutServiceTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
  
  @isTest private static void testOnAfterUpdateCallsBillingService() {
		// Arrange
		List<Project__c> newProjectList = new List<Project__c>{TEST_ProjectFactory.create(TEST_DummyInsertModeEnum.MOCK)};
		RH_ProjectsMock projectsMock = new RH_ProjectsMock(newProjectList);		
		BillingCalloutService targetClass = new BillingCalloutService(newProjectList, projectsMock);
		
		Map<Id,SObject> existingProjectMap = new Map<Id,SObject>(newProjectList); 
		
		// Act
		BillingServiceProxy.Project result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.onAfterUpdate(existingProjectMap);
            }
            Test.stopTest();
        } 

		System.assertEquals(existingProjectMap, projectsMock.existingProjectMap);
  }
}