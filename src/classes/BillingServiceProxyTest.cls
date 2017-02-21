@isTest
private class BillingServiceProxyTest {
	private static final User TestRunner = TEST_RunAsUserFactory.create(); 
	
	@isTest static void testBillProjectSendsProjectOut(){
		// Arrange
		BillingServiceProxy.InvoicesPortSoap11 targetClass = new BillingServiceProxy.InvoicesPortSoap11();
		BillingServiceProxy.project project = new BillingServiceProxy.project(); 
		Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
		
		// Act
		String result;
        System.runAs(TestRunner){
            Test.startTest();
            {
                result = targetClass.billProject(project);
            }
            Test.stopTest();
        }

		// Assert
		System.assertEquals('OK', result);
	}
    
}