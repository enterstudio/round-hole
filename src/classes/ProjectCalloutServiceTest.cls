@isTest
private class ProjectCalloutServiceTest {
	@isTest static void testPostOpportunityToPMS(){
		// Arrange
		Opportunity testOpportunity = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.REAL);
		TEST_ProjectServiceTokenFactory.create();
		Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
		
		// Act
        //System.runAs(TestRunner){
            Test.startTest();
            {
				ProjectCalloutService.postOpportunityToPMS(new List<Id>{testOpportunity.id});
            }
            Test.stopTest();
        //}

		// Assert
		Opportunity resultOpportunity = [SELECT stageName FROM Opportunity WHERE id = :testOpportunity.id];
		System.assertEquals('Submitted Project', resultOpportunity.stageName);
	}
	
	@isTest static void testQueueablePMSCallExecuteShouldSucceed(){
		testQueueablePMSCallExecute(new ProjectCalloutServiceMock(), 'Submitted Project');
	}	

	@isTest static void testQueueablePMSCallExecuteShouldFail(){
		testQueueablePMSCallExecute(new ProjectCalloutServiceMockFailure(), 'Resubmit Project');
	}	

	static void testQueueablePMSCallExecute(HttpCalloutMock calloutMock, String updateStageName) {
		// Arrange
		User TestRunner = TEST_RunAsUserFactory.create();
		Opportunity testOpportunity = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.MOCK);
		DB_OpportunitiesSelectorMock opportunitySelector = new DB_OpportunitiesSelectorMock();  
		RH_OpportunityHelperMock opportunityHelper = new RH_OpportunityHelperMock();
		ProjectCalloutService.QueueablePMSCall targetClass = new ProjectCalloutService.QueueablePMSCall(
			new List<Id>{testOpportunity.id}, opportunitySelector, opportunityHelper
		);
		
		List<Opportunity> testOpportunityList = new List<Opportunity>{ testOpportunity };
		opportunitySelector.returnedOpportunityList = testOpportunityList;

		Test.setMock(HttpCalloutMock.class, calloutMock);
				
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
				targetClass.execute(null);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(testOpportunityList, opportunityHelper.updatedOpportunityList);
		System.assertEquals(updateStageName, opportunityHelper.updateStageName);
	}
}