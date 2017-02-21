public virtual class RH_ProjectsBillingService {
	BillingServiceProxy.InvoicesPortSoap11 invoicesPort;
	DB_ProjectDml projectDml;
	
	public RH_ProjectsBillingService(BillingServiceProxy.InvoicesPortSoap11 invoicesPort, DB_ProjectDml projectDml) {
		this.invoicesPort = invoicesPort;
		this.projectDml = projectDml;
	}

	public RH_ProjectsBillingService() {
		this(new BillingServiceProxy.InvoicesPortSoap11(), new DB_ProjectDml());
	}

	public virtual void callBillingService(List<Project__c> projectList) {
		for (Project__c project: projectList) {
			asyncCallBillingService(project.projectRef__c, project.billable_amount__c);
		}
	}
	
	@testVisible
	@future(callout=true)
	private static void asyncCallBillingService(String projectRef, Decimal amount) {
		(new RH_ProjectsBillingService()).callBillingService(projectRef, amount); 
	}
	
	@testVisible
	private void callBillingService(String projectRef, Decimal amount) {
		BillingServiceProxy.Project project = createBillingProject(projectRef, amount);
		if(this.invoicesPort.billProject(project) == 'OK') {
			Project__c updatedProject = new Project__c(projectRef__c = project.projectRef, status__c = 'Billed'); 
			this.projectDml.doUpsertUsingProjectRefAsExternalKey(new List<Project__c>{updatedProject}, true);
		}
	}
	
	@testVisible
	private BillingServiceProxy.Project createBillingProject(String projectRef, Decimal amount) {
		BillingServiceProxy.Project billingProject = new BillingServiceProxy.Project();
		billingProject.projectRef = projectRef;
		billingProject.billAmount = amount;
		billingProject.username = ServiceCredentials__c.getValues('BillingServiceCredential').username__c;
		billingProject.password = ServiceCredentials__c.getValues('BillingServiceCredential').password__c;
		return billingProject;
	}    
}