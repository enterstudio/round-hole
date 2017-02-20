// URL: /services/apexrest/project
@RestResource(urlMapping='/project')
global with sharing class ProjectRESTService {
	DB_GenericDml genericDml;
	DB_ProjectDml projectDml;
	
	global ProjectRESTService(DB_GenericDml genericDml, DB_ProjectDml projectDml){ 
		this.genericDml = genericDml;
		this.projectDml = projectDml;
	}
	
	global ProjectRESTService(){
		this(new DB_GenericDml(), new DB_ProjectDml());
	}
    
    /* Sample input: {
	    "projectRef" : "Test-Ref-001",
	    "projectName" : "Test Name",
	    "opportunityId": "0060Y000004EMyW",
	    "startDate": "2017-02-17",
	    "endDate": "2018-02-18",
	    "amount": 34225,
	    "status": "Running"
	} */
    
    @HttpPost
    global static String postProjectData(
	 	String	    projectRef,
	 	String	    projectName,
	 	String	    opportunityId,
	 	Date	    startDate,
	 	Date	    endDate,
	 	Double	    amount,
	 	String	    status
    ) {
    	return (new ProjectRESTService()).createProject(new Project__c(
    		projectRef__c = projectRef,
    		name = projectName,
			opportunity__c = opportunityId,
			start_date__c = startDate,    		
			end_date__c = endDate,
			billable_amount__c = amount,
			status__c = status    		
    	)); 
    }
    
    @testVisible
    private String createProject(Project__c project) {
    	SavePoint savePoint = Database.setSavePoint();
    	Database.UpsertResult upsertResult = this.projectDml.doUpsertUsingProjectRefAsExternalKey(new List<Project__c>{project})[0];
    	return (!upsertResult.isSuccess()) 
    				? buildErrorString(upsertResult.getErrors())
    				: setOpportunityToInProgress(project.opportunity__c, savePoint);
    }
    
    @testVisible
    private String setOpportunityToInProgress(Id opportunityId, SavePoint savePoint) {
    	Opportunity updatedOpportunity = new Opportunity(
    			id = opportunityId,
    			deliveryInstallationStatus__c = 'In Progress'
    		);
    	
    	Database.SaveResult saveResult = this.genericDml.doUpdate(new List<Opportunity>{updatedOpportunity})[0];
    	if (!saveResult.isSuccess()){
    		Database.rollback(savePoint);
    		return buildErrorString(saveResult.getErrors());
    	}
    	
    	return 'OK';
    }  

    @testVisible
    private String buildErrorString(List<Database.Error> errorList) {
    	String errors = 'The following errors have occured: ';
    	for (Database.Error error : errorList) {
    		errors += '* ' + error.getStatusCode() + ': ' + error.getMessage();
    	}
    	return errors;
    }  
}