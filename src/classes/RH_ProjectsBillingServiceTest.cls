@isTest
private class RH_ProjectsBillingServiceTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
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
		RH_ProjectsBillingService targetClass = new RH_ProjectsBillingService(invoicesPortSoapMock, projectDmlMock);

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
		RH_ProjectsBillingService targetClass = new RH_ProjectsBillingService();
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