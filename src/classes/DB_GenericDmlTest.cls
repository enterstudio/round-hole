@isTest 
private class DB_GenericDmlTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testDoUpdate(){
		// Arrange
		DB_GenericDml targetClass = new DB_GenericDml();
		Account testAccount = TEST_AccountFactory.create(new Account(name = 'ABC Inc.'), TEST_DummyInsertModeEnum.REAL);
		testAccount.name = 'New name';
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
				targetClass.doUpdate(new List<Account>{ testAccount });
            }
            Test.stopTest();
        }

		// Assert
		Account resultAccount = [SELECT name FROM Account WHERE id = :testAccount.id];
		System.assertEquals(testAccount.name, resultAccount.name);
	}
}