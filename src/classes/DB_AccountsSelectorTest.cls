@isTest
private class DB_AccountsSelectorTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testGetSObjectType(){
		// Arrange
		DB_AccountsSelector targetClass = new DB_AccountsSelector();
		// TO DO: arrange unit test
		
		
		// Act
		Schema.SObjectType result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.getSObjectType();
            }
            Test.stopTest();
        }

		// Assert
		// TO DO: assert results
		System.assertEquals(Account.sObjectType, result);
	}
}