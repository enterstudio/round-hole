@isTest
private class ProjectCalloutServiceTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testPostOpportunityToPMS(){
		// Arrange
		ProjectCalloutService targetClass = new ProjectCalloutService();
		// TODO
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
				// TODO targetClass.TODO();
            }
            Test.stopTest();
        }

		// Assert
		// TODO : EXPECTED/ACTUAL
	}
	
	@isTest static void testPostOpportunity(){
		// Arrange
		ProjectCalloutService targetClass = new ProjectCalloutService();
		// TODO
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
				// TODO targetClass.TODO();
            }
            Test.stopTest();
        }

		// Assert
		// TODO : EXPECTED/ACTUAL
	}	

	@isTest static void testQueueablePMSCallExecuteShouldSucceed(){
		testQueueablePMSCallExecute(new ProjectCalloutServiceMock(), 'Submitted Project');
	}	

	@isTest static void testQueueablePMSCallExecuteShouldFail(){
		testQueueablePMSCallExecute(new ProjectCalloutServiceMockFailure(), 'Resubmit Project');
	}	

	static void testQueueablePMSCallExecute(HttpCalloutMock calloutMock, String updateStageName) {
		// Arrange
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