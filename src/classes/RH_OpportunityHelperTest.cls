@isTest
private class RH_OpportunityHelperTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	private static final String TEST_ACCOUNT_NAME = 'ABC Inc.';
	private static final String TEST_OPPORTUNITY_NAME = 'Test Opportunity';
	private static final Decimal TEST_AMOUNT = 2454;
	private static final Date TEST_CLOSE_DATE = Date.today(); 
	
	@isTest static void convertToJsonShouldConvertOpportunityListToJson(){
		// Arrange
		RH_OpportunityHelper targetClass = new RH_OpportunityHelper();
		Opportunity testOpportunity = createOpportunity();
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.convertToJson(new List<Opportunity>{testOpportunity});
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(true, result.contains('['));
		assertOpportunityObjectJson(testOpportunity.id, result);
		System.assertEquals(true, result.contains(']'));
	}

	@isTest static void convertToJsonShouldConvertSingleObjectToJson(){
		// Arrange
		RH_OpportunityHelper targetClass = new RH_OpportunityHelper();
		Opportunity testOpportunity = createOpportunity();
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.convertToJson(testOpportunity);
            }
            Test.stopTest();
        }

		// Assert
		assertOpportunityObjectJson(testOpportunity.id, result);
	}
	
	private static Opportunity createOpportunity() {
		Account accountTemplate = new Account(name = TEST_ACCOUNT_NAME);
		Opportunity opportunityTemplate = new Opportunity(
			name = TEST_OPPORTUNITY_NAME,
			account = TEST_AccountFactory.create(accountTemplate, TEST_DummyInsertModeEnum.MOCK),
			amount = TEST_AMOUNT,
			closeDate = TEST_CLOSE_DATE
		);
		return TEST_OpportunityFactory.create(opportunityTemplate, TEST_DummyInsertModeEnum.MOCK);
	}
	
	private static void assertOpportunityObjectJson(Id opportunityId, String resultJson) {
		System.assertEquals(true, resultJson.contains('{'));
		System.assertEquals(true, resultJson.contains('"opportunityId" : "' + opportunityId + '"'));
		System.assertEquals(true, resultJson.contains('"opportunityName" : "' + TEST_OPPORTUNITY_NAME + '"'));
		System.assertEquals(true, resultJson.contains('"closeDate" : "' + String.valueOf(TEST_CLOSE_DATE).subStringBefore(' ') + '"'));
		System.assertEquals(true, resultJson.contains('"amount" : "' + TEST_AMOUNT + '"'));
		System.assertEquals(true, resultJson.contains('"accountName" : "' + TEST_ACCOUNT_NAME + '"'));
		System.assertEquals(true, resultJson.contains('}'));
	}
	
}