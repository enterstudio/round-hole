@isTest
public class TEST_ProjectServiceTokenFactory {
	public static void create(String testToken) {
		insert (new ServiceTokens__c(
			name = 'ProjectServiceToken',
			token__c = testToken
		));
	}

	public static void create() {
		create('Test Token');
	}
}