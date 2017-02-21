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
    
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> projectList) {
            return new BillingCalloutService (projectList);
        }
    } 
    
    public override void onAfterUpdate(Map<Id,SObject> existingProjectMap) {
    	projects.callBillingService(existingProjectMap);
    }	
}