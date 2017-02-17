@isTest
private class DB_OpportunitiesSelectorTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testSelectWithAccountsById(){
		// Arrange
		DB_OpportunitiesSelector targetClass = new DB_OpportunitiesSelector();
		Account accountTemplate = new Account(name = 'ABC Inc.');
		Id testAccountId = TEST_AccountFactory.create(accountTemplate, TEST_DummyInsertModeEnum.REAL).id;
		Opportunity opportunityTemplate = new Opportunity(
			name = 'Test Opportunity',
			accountId = testAccountId,
			amount = 2345,
			closeDate = Date.today()
		);
		Id testOpportunityId = TEST_OpportunityFactory.create(opportunityTemplate, TEST_DummyInsertModeEnum.REAL).id;
		
		// Act
		List<Opportunity> resultList;
        System.runAs(TestRunner){
            Test.startTest();
            {
                resultList = targetClass.selectWithAccountsById(new List<Id>{ testOpportunityId });
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(1, resultList.size());
		
		Opportunity result = resultList[0];
		System.assertEquals(testOpportunityId, result.id);
		System.assertEquals(opportunityTemplate.name, result.name);
		System.assertEquals(accountTemplate.name, result.account.name);
		System.assertEquals(opportunityTemplate.amount, result.amount);
		System.assertEquals(opportunityTemplate.closeDate, result.closeDate);
	}
}