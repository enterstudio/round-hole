@isTest
private class DB_SavePointHelperTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testSetSavePoint(){
		// Arrange
		DB_SavePointHelper targetClass = new DB_SavePointHelper();
		
		// Act
		SavePoint result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.setSavePoint();
            }
            Test.stopTest();
        }

		// Assert
		System.assertNotEquals(null, result);
	}

	@isTest static void testRollback(){
		// Arrange
		DB_SavePointHelper targetClass = new DB_SavePointHelper();
		
		String accountNumber = 'Original Account Number';
		Account account = TEST_AccountFactory.create(new Account(accountNumber = accountNumber), TEST_DummyInsertModeEnum.REAL);
		
		// Act
        System.runAs(TestRunner){
            Test.startTest();
            {
				SavePoint savePoint = Database.setSavePoint();
				account.accountNumber = 'New Account Number';
				update account;
		
                targetClass.rollback(savePoint);
            }
            Test.stopTest();
        }

		// Assert
		Account resultAccount = [SELECT accountNumber FROM Account WHERE id = :account.id];
		System.assertEquals(accountNumber, resultAccount.accountNumber);
	}

}