@isTest
private class RH_OpportunityHelperTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	private static final String TEST_TOKEN = 'Test-Token';
	private static final String TEST_ACCOUNT_NAME = 'ABC Inc.';
	private static final String TEST_OPPORTUNITY_NAME = 'Test Opportunity';
	private static final Decimal TEST_AMOUNT = 2454;
	private static final Date TEST_CLOSE_DATE = Date.today(); 
	
	@isTest static void testCreateHttpRequest(){
		// Arrange
		RH_OpportunityHelper targetClass = new RH_OpportunityHelper();
		Opportunity testOpportunity = createOpportunity();
		createProjectServiceToken();
		
		// Act
		HttpRequest result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.createHttpRequest(new List<Opportunity>{testOpportunity});
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('callout:ProjectService', result.getEndpoint());
		System.assertEquals('POST', result.getMethod());
		System.assertEquals('application/json', result.getHeader('Content-Type'));
		System.assertEquals(TEST_TOKEN, result.getHeader('X-auth-token'));
		assertOpportunityObjectListJson(testOpportunity.id, result.getBody());
	}
	
	@isTest static void testConvertToJsonShouldConvertOpportunityListToJson(){
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
		assertOpportunityObjectListJson(testOpportunity.id, result);
	}

	@isTest static void testConvertToJsonShouldConvertSingleObjectToJson(){
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
	
	@isTest static void testSetStage(){
		// Arrange
		DB_GenericDmlMock genericDml = new DB_GenericDmlMock();
		RH_OpportunityHelper targetClass = new RH_OpportunityHelper(genericDml);
		Opportunity testOpportunity = createOpportunity();
		String testState = 'Test';
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                targetClass.setStage(new List<Opportunity>{testOpportunity}, testState);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals(1, genericDml.updatedSObjectList.size());
		Opportunity resultOpportunity = (Opportunity) genericDml.updatedSObjectList[0];
		System.assertEquals(testState, resultOpportunity.stageName);
		
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
	
	private static void createProjectServiceToken() {
		//ServiceTokens__c.getValues('ProjectServiceToken').token__c
		insert (new ServiceTokens__c(
			name = 'ProjectServiceToken',
			token__c = TEST_TOKEN
		));
	}

	private static void assertOpportunityObjectListJson(Id opportunityId, String resultJson) {
		System.assertEquals(true, resultJson.contains('['));
		assertOpportunityObjectJson(opportunityId, resultJson);
		System.assertEquals(true, resultJson.contains(']'));
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