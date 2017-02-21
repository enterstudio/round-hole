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
  
  @isTest private static void testCallsBillingServiceForOldAndNewProjectRecordsSendsBilling() {
		// Arrange
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		Project__c newProject = TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		List<Project__c> newProjectList = new List<Project__c>{newProject};
				
		Project__c oldProject = newProject.clone(true, true, true, true);
		oldProject.status__c = 'Billed';
		Map<Id, Project__c> oldProjectByIdMap = new Map<Id, Project__c>{
			oldProject.id => oldProject
		};			
			
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                BillingCalloutService.callBillingService(newProjectList, oldProjectByIdMap); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
	}
	
    @isTest private static void testSendBillingAsyncronouslySendsBillings() {
		// Arrange
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		Project__c newProject = TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		List<Project__c> newProjectList = new List<Project__c>{newProject};
		BillingCalloutService targetClass = new BillingCalloutService(newProjectList);
				
		Project__c oldProject = newProject.clone(true, true, true, true);
		oldProject.status__c = 'Billed';
		Map<Id, Project__c> oldProjectByIdMap = new Map<Id, Project__c>{
			oldProject.id => oldProject
		};			
			
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.sendBilling(newProjectList, oldProjectByIdMap); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
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
		BillingCalloutService targetClass = new BillingCalloutService(new List<Project__c>{newProject});
		
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
                BillingCalloutService.asyncCallBillingService(projectRef, amount); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billed', resultProject.status__c);			
	}

	@isTest static void testAsyncCallBillingServiceDoesNotUpdateProjectOnSyncFailure(){
		// Arrange
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		TEST_ProjectFactory.create(new Project__c(
				projectRef__c = projectRef,
				billable_amount__c = amount,
				status__c = 'Billable'
			), TEST_DummyInsertModeEnum.REAL);
		TEST_ServiceCredentialsFactory.create();
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                BillingCalloutService.asyncCallBillingService(projectRef, amount); 
            }
            Test.stopTest();
        }

		Project__c resultProject = [SELECT status__c FROM Project__c WHERE projectRef__c = :projectRef];
		System.assertEquals('Billable', resultProject.status__c);			
	}
  
	@isTest static void testCallBillingServiceForRefWithAmountUpdatesProjectOnSuccess() {
		testCallBillingServiceForRefWithAmountDoesNotUpdateProject(true);
	}

	@isTest static void testCallBillingServiceForRefWithAmountDoesNotUpdateProjectOnFailure() {
		testCallBillingServiceForRefWithAmountDoesNotUpdateProject(false);
	}

	static void testCallBillingServiceForRefWithAmountDoesNotUpdateProject(Boolean isSuccess) {
		// Arrange
		String soapResponse = isSuccess ? 'OK' : 'FAILURE';
		BillingServiceProxyInvoicesPortSoapMock invoicesPortSoapMock = new BillingServiceProxyInvoicesPortSoapMock(soapResponse);
		DB_ProjectDmlMock projectDmlMock = new DB_ProjectDmlMock();
		BillingCalloutService targetClass = new BillingCalloutService(
			new List<Project__c>(), new RH_Projects(new List<Project__c>()), invoicesPortSoapMock, projectDmlMock
		);

		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		TEST_ServiceCredentialsFactory.create();
		 
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.callBillingService(projectRef, amount); 
            }
            Test.stopTest();
        }
         
        System.assertEquals(projectRef, invoicesPortSoapMock.projectRef);
        System.assertEquals(amount, invoicesPortSoapMock.amount);

		if (!isSuccess) {
			System.assertEquals(null, projectDmlMock.upsertedSObjectList);
		}
		else {
			System.assertEquals(1, projectDmlMock.upsertedSObjectList.size());
			Project__c resultProject = projectDmlMock.upsertedSObjectList[0];
			System.assertEquals(projectRef, resultProject.projectRef__c);
			System.assertEquals('Billed', resultProject.status__c);			
		}
	}
  
	@isTest static void testCreateBillingProject() {
		// Arrange
		BillingCalloutService targetClass = new BillingCalloutService(new List<Project__c>());
		String projectRef = 'Test-Project-001';
		Decimal amount = 34643;
		String username = 'John Doe';
		String password = 'qwerty123';
		TEST_ServiceCredentialsFactory.create(username, password);
		
		// Act
		BillingServiceProxy.Project result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createBillingProject(projectRef, amount);
            }
            Test.stopTest();
        }

		System.assertEquals(projectRef, result.projectRef);
		System.assertEquals(amount, result.billAmount);
		System.assertEquals(username, result.username);
		System.assertEquals(password, result.password);
	}
}