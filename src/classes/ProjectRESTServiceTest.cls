@isTest
private class ProjectRESTServiceTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 

  @isTest static void testPostProjectDataShouldCreateNewProject() {
		// Arrange
		String projectRef = 'Test-Project-001';
		String projectName = 'Test Project';
		Date startDate = Date.today();
		Date endDate = Date.today().addYears(1);
		Double amount = 32562;
		String status = 'Running';
		Id opportunityId = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.REAL).id;
		
		// Act
		String result; 
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = ProjectRESTService.postProjectData(projectRef, projectName, String.valueOf(opportunityId), startDate, endDate, amount, status);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('OK', result);
		
		List<Project__c> resultProjectList = [
			SELECT projectRef__c, name, start_date__c, end_date__c, billable_amount__c, status__c 
			FROM Project__c 
			WHERE opportunity__c = :opportunityId
		];
		System.assertEquals(1, resultProjectList.size());
		
		Project__c resultProject = resultProjectList[0];
		System.assertEquals(projectRef, resultProject.projectRef__c); 
		System.assertEquals(projectName, resultProject.name); 
		System.assertEquals(startDate, resultProject.start_date__c); 
		System.assertEquals(endDate, resultProject.end_date__c); 
		System.assertEquals(amount, resultProject.billable_amount__c); 
		System.assertEquals(status, resultProject.status__c); 
		
		Opportunity resultOpportunity = [SELECT deliveryInstallationStatus__c FROM Opportunity WHERE id = :opportunityId];
		System.assertEquals('In progress', resultOpportunity.deliveryInstallationStatus__c); 
  }
	
	
  @isTest static void testUpsertProjectShouldUpdateOpportunityOnSuccess() {
		// Arrange
		ProjectRESTService targetClass = new ProjectRESTService();
		Id opportunityId = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.REAL).id;
		Project__c project = TEST_ProjectFactory.create(new Project__c(opportunity__c = opportunityId), TEST_DummyInsertModeEnum.LATER);
		
		// Act
		String result; 
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.upsertProject(project);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('OK', result);
		
		List<Project__c> resultProjectList = [SELECT id FROM Project__c WHERE opportunity__c = :opportunityId];
		System.assertEquals(1, resultProjectList.size()); 
		
		Opportunity resultOpportunity = [SELECT deliveryInstallationStatus__c FROM Opportunity WHERE id = :opportunityId];
		System.assertEquals('In progress', resultOpportunity.deliveryInstallationStatus__c); 
  }
  
  @isTest static void testUpsertProjectShouldReturnErrorsOnFailure() {
		// Arrange
		ProjectRESTService targetClass = new ProjectRESTService();
		Project__c project = new Project__c();
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.upsertProject(project);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('The following errors have occured: * MISSING_ARGUMENT: ProjectRef__c not specified', result);
  }
  
  @isTest static void testSetOpportunityToInProgressShouldUpdateOpportunityOnSuccess() {
		// Arrange
		ProjectRESTService targetClass = new ProjectRESTService();
		Id opportunityId = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.REAL).id;
		
		// Act
		Account account;
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
				SavePoint savePoint = Database.setSavePoint();
				account = TEST_AccountFactory.create(TEST_DummyInsertModeEnum.REAL);
				
                result = targetClass.setOpportunityToInProgress(opportunityId, savePoint);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('OK', result);
		
		List<Account> resultAccountList = [SELECT id FROM Account WHERE id = :account.id];
		System.assertEquals(1, resultAccountList.size());
		
		Opportunity resultOpportunity = [SELECT deliveryInstallationStatus__c FROM Opportunity WHERE id = :opportunityId];
		System.assertEquals('In progress', resultOpportunity.deliveryInstallationStatus__c); 
  }

  @isTest static void testSetOpportunityToInProgressShouldRollbackAndReturnErrorsOnFailure() {
		// Arrange
		ProjectRESTService targetClass = new ProjectRESTService();
		Id opportunityId = TEST_OpportunityFactory.create(TEST_DummyInsertModeEnum.MOCK).id;
		
		// Act
		Account account;
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
				SavePoint savePoint = Database.setSavePoint();
				account = TEST_AccountFactory.create(TEST_DummyInsertModeEnum.REAL);
				
                result = targetClass.setOpportunityToInProgress(opportunityId, savePoint);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('The following errors have occured: * INVALID_CROSS_REFERENCE_KEY: invalid cross reference id', result);
		
		List<Account> resultAccountList = [SELECT id FROM Account WHERE id = :account.id];
		System.assertEquals(0, resultAccountList.size());
  }

  @isTest static void testBuildErrorStringShouldConcatErrors() {
		// Arrange
		ProjectRESTService targetClass = new ProjectRESTService();
		
		Database.SaveResult saveResult = Database.insert(new Account(), false);
		List<Database.Error> errorList = saveResult.getErrors(); 
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.buildErrorString(errorList);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('The following errors have occured: * REQUIRED_FIELD_MISSING: Required fields are missing: [Name]', result);
	}
}