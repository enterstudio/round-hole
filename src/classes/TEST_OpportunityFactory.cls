@isTest
public class TEST_OpportunityFactory extends TEST_SObjectFactory {
	private static Map<String, Object> defaultByKeyMap = new Map<String, Object>{
		'closeDate' => Date.today(),
		'stageName' => 'New'
	}; 
	
	public static List<Opportunity> createList(Opportunity template, Integer quantity, TEST_DummyInsertModeEnum insertMode){
		MockStrategyInterface strategy = new OpportunityInQuantityStrategy(template, quantity); 
		return (List<Opportunity>) TEST_SObjectFactory.createList(strategy, insertMode); 
	}
	
	public static Opportunity create(Opportunity template, TEST_DummyInsertModeEnum insertMode){
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	public static Opportunity create(TEST_DummyInsertModeEnum insertMode){
		Opportunity template = new Opportunity();
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	class OpportunityInQuantityStrategy extends SObjectInQuantityStrategy {
		OpportunityInQuantityStrategy(SObject template, Integer quantity) {
			super(template, quantity, 'Opportunity ', defaultByKeyMap);
		}
	}
}