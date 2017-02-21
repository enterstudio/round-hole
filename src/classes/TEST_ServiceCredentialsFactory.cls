@isTest
public class TEST_ServiceCredentialsFactory {
	public static void create(String testUsername, String testPassword) {
		insert (new ServiceCredentials__c(
			name = 'BillingServiceCredential',
			username__c = testUsername,
			password__c = testPassword
		));
	}

	public static void create() {
		create('John Smith', 'abc123');
	}
}