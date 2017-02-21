@isTest
private class RH_ProjectsTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testCallBillingService(){
		// Arrange
		Project__c newProject = TEST_ProjectFactory.create(new Project__c(status__c = 'Billable'), TEST_DummyInsertModeEnum.MOCK);
		RH_ProjectsBillingServiceMock projectsBillingService = new RH_ProjectsBillingServiceMock(); 
		RH_Projects targetClass = new RH_Projects(new List<Project__c>{newProject}, projectsBillingService);
		
		Project__c oldProject = newProject.clone(true, true, true, true);
		oldProject.status__c = 'Billed';
		Map<Id, Project__c> existingProjectMap = new Map<Id, Project__c>{
			oldProject.id => oldProject
		};
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.callBillingService(existingProjectMap);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(1, projectsBillingService.projectList.size());
		System.assertEquals(newProject, projectsBillingService.projectList[0]);
	}

	@isTest static void testBuildNewlyBillableListIncludesNewlyBillable(){
		Boolean isBillable = true;
		Boolean wasNotBillable = true;
		testBuildNewlyBillableList(isBillable, wasNotBillable);
	}

	@isTest static void testBuildNewlyBillableListExcludesNotBillable(){
		Boolean isBillable = false;
		Boolean wasNotBillable = true;
		testBuildNewlyBillableList(isBillable, wasNotBillable);
	}

	@isTest static void testBuildNewlyBillableListExcludesPreviouslyBillable(){
		Boolean isBillable = true;
		Boolean wasNotBillable = false;
		testBuildNewlyBillableList(isBillable, wasNotBillable);
	}

	static void testBuildNewlyBillableList(Boolean isBillable, Boolean wasNotBillable){
		// Arrange
		String status = isBillable ? 'Billable' : 'Billed';
		Project__c newProject = TEST_ProjectFactory.create(new Project__c(status__c = status), TEST_DummyInsertModeEnum.MOCK);
		RH_Projects targetClass = new RH_Projects(new List<Project__c>{newProject});
		
		Project__c oldProject = newProject.clone(true, true, true, true);
		oldProject.status__c = wasNotBillable ? 'Billed' : 'Billable';
		Map<Id, Project__c> existingProjectMap = new Map<Id, Project__c>{
			oldProject.id => oldProject
		};
		
		// Act
		List<Project__c> resultProjectList;
        System.runAs(TestRunner){
            Test.startTest();
            {
                resultProjectList = targetClass.buildNewlyBillableList(existingProjectMap);
            }
            Test.stopTest();
        }

		// Assert
		if (isBillable && wasNotBillable) {
			System.assertEquals(1, resultProjectList.size());
			System.assertEquals(newProject, resultProjectList[0]);
		}
		else {
			System.assertEquals(0, resultProjectList.size());
		}
	}

}