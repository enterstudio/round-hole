@isTest
public class TEST_ProjectFactory extends TEST_SObjectFactory {
	private static Map<String, Object> defaultByKeyMap = new Map<String, Object>{
		'ProjectRef__c' => 'Test-Project'
	}; 
	
	public static List<Project__c> createList(Project__c template, Integer quantity, TEST_DummyInsertModeEnum projectInsertMode){
		if (template.opportunity__c == null) {
			TEST_DummyInsertModeEnum opportunityInsertMode = (projectInsertMode == TEST_DummyInsertModeEnum.REAL || projectInsertMode == TEST_DummyInsertModeEnum.LATER)
				? TEST_DummyInsertModeEnum.REAL
				: TEST_DummyInsertModeEnum.MOCK;
			defaultByKeyMap.put('opportunity__c', TEST_OpportunityFactory.create(opportunityInsertMode).id);
		}
		
		MockStrategyInterface strategy = new ProjectInQuantityStrategy(template, quantity); 
		return (List<Project__c>) TEST_SObjectFactory.createList(strategy, projectInsertMode); 
	}
	
	public static Project__c create(Project__c template, TEST_DummyInsertModeEnum insertMode){
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	public static Project__c create(TEST_DummyInsertModeEnum insertMode){
		Project__c template = new Project__c();
		Integer quantity = 1;
		return createList(template, quantity, insertMode)[0];
	}

	class ProjectInQuantityStrategy extends SObjectInQuantityStrategy {
		ProjectInQuantityStrategy(SObject template, Integer quantity) {
			super(template, quantity, 'Project ', defaultByKeyMap);
		}
	}
}