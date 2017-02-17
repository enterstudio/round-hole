@isTest
public class TEST_AccountFactory extends TEST_SObjectFactory {
	private static Map<String, Object> defaultByKeyMap = new Map<String, Object>{
	}; 
	
	public static List<Account> createList(Account template, Integer quantity, TEST_DummyInsertModeEnum insertMode){
		MockStrategyInterface strategy = new AccountInQuantityStrategy(template, quantity); 
		return (List<Account>) TEST_SObjectFactory.createList(strategy, insertMode); 
	}
	
	public static Account create(Account template, TEST_DummyInsertModeEnum insertMode){
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	public static Account create(TEST_DummyInsertModeEnum insertMode){
		Account template = new Account();
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	class AccountInQuantityStrategy extends SObjectInQuantityStrategy {
		AccountInQuantityStrategy(SObject template, Integer quantity) {
			super(template, quantity, 'Account ', defaultByKeyMap);
		}
	}
}