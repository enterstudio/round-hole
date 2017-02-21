public class BillingCalloutService extends fflib_SObjectDomain {
    List<Project__c> projectList;
    RH_Projects projects; 
	BillingServiceProxy.InvoicesPortSoap11 invoicesPort;
	DB_ProjectDml projectDml;

    public BillingCalloutService(List<Project__c> projectList, RH_Projects projects, BillingServiceProxy.InvoicesPortSoap11 invoicesPort, DB_ProjectDml projectDml) {
        super(projectList);
        this.projectList = projectList;
        this.projects = projects;
		this.invoicesPort = invoicesPort;
		this.projectDml = projectDml;
    }
    
    public BillingCalloutService(List<Project__c> projectList, RH_Projects projects) {
        this(projectList, projects, new BillingServiceProxy.InvoicesPortSoap11(), new DB_ProjectDml());
    }
 
    public BillingCalloutService(List<Project__c> projectList) {
        this(projectList, new RH_Projects(projectList));
    }
    
    /*
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> projectList) {
            return new BillingCalloutService (projectList);
        }
    } 
    */
    
    // ---------------------------------------

    public override void onAfterUpdate(Map<Id,SObject> existingProjectMap) {
    	projects.callBillingService(existingProjectMap);
    }
    
    
    // Shitty code required by trailhead --------------------------------------------------------------------------------------
    
    public static void callBillingService(List<Project__c> newProjects, Map<Id, Project__c> oldProjectByIdMap) {
    	(new BillingCalloutService(newProjects)).sendBilling(newProjects, oldProjectByIdMap); 
	} 
	
	@testVisible
	private void sendBilling(List<Project__c> newProjects, Map<Id, Project__c> oldProjectByIdMap){
    	for (Project__c project: buildNewlyBillableList(oldProjectByIdMap)) {
			asyncCallBillingService(project.projectRef__c, project.billable_amount__c);
		}
	}
	
	@testVisible
	private List<Project__c> buildNewlyBillableList(Map<Id, Project__c> existingProjectMap) {
		List<Project__c> newlyBillableProjectList = new List<Project__c>();
		for (Project__c project : projectList) {
			Boolean isBillable = project.status__c == 'Billable';
			Boolean wasNotBillable = existingProjectMap.get(project.id).get('status__c') != 'Billable';
			if (isBillable && wasNotBillable) {
				newlyBillableProjectList.add(project);
			}
		} 
		return newlyBillableProjectList;
	}

	@testVisible
	@future(callout=true)
	private static void asyncCallBillingService(String projectRef, Decimal amount) {
		(new BillingCalloutService(new List<Project__c>())).callBillingService(projectRef, amount); 
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