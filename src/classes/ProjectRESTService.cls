@RestResource(urlMapping='/project')
global with sharing class ProjectRESTService {
	DB_GenericDml genericDml;
	
	global ProjectRESTService(DB_GenericDml genericDml){ 
		this.genericDml = genericDml;
	}
	
	global ProjectRESTService(){
		this(new DB_GenericDml());
	}
    
    /*
     * This triggers the PMS to make a RESTful call back to Round’s Salesforce org with a subset of the new Project record’s data. 
     * The inbound call’s authentication with Salesforce is dependent upon the Org Registration of the Connected App authentication keys.
	 * (X) Implement an Apex REST Service class (named ProjectRESTService) 
	 * (X) with a method (named postProjectData) 
	 * (X) that accepts the post 
	 * (X) and inserts 
	 * (-) (or updates) a corresponding project record associated with the opportunity from which it originated. 
	 * 
	 * (X) The inbound call to: https://eu11.salesforce.com/services/apexrest/project contains a data packet for the following elements 
	 * (X) closely matching the names and types of the Project custom object (Project__c) fields as defined in the table below.
	 *	
	 *		Field Type	Field Name  		API Name
	 *		String	    ProjectRef			projectRef__c
	 *		String	    ProjectName			name
	 *		String	    OpportunityId		opportunity__c
	 *		Date	    StartDate			start_date__c
	 *		Date	    EndDate				end_date__c
	 *		Double	    Amount				billable_amount__c
	 *		String	    Status				status__c
	 * 
	 *     The tech lead has insisted that 
	 * (X) you must use parameters on the service method for fetching the fields in the JSON body rather than using Apex deserialization
	 *	
	 * 	   Ensure the service method in the ProjectRESTService class 
	 * (X) creates 
	 * (-) (or updates) a project record in Salesforce 
	 * (X) using the passed field values from the external system. 
	 *
	 * (X) Add logic to update the Delivery/Installation Status field 
	 * (X) as In Progress on the associated opportunity record. 
	 * (X) Create the project record as a child of the associated opportunity. 
	 * (X) To safeguard data integrity, ensure all data operations are managed in an explicit single transaction using a savepoint. 
	 * (X) The method should return a string value of "OK" or an error message to the calling service.
	 *
	 *
	 * TODO:
	 * (-) Post Update (?!)
	 * (-) Put Update
	 * (-) Patch Update 
	 * ProjectRef__c is an external ID.
     */
    
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
    	Project__c newProject = new Project__c(
    		projectRef__c = projectRef,
    		name = projectName,
			opportunity__c = opportunityId,
			start_date__c = startDate,    		
			end_date__c = endDate,
			billable_amount__c = amount,
			status__c = status    		
    	);
    	return (new ProjectRESTService()).createProject(newProject);
    }
    
    @testVisible
    private String createProject(Project__c newProject) {
    	SavePoint savePoint = Database.setSavePoint();
    	Database.SaveResult saveResult = this.genericDml.doInsert(new List<Project__c>{newProject})[0];
    	return (!saveResult.isSuccess()) 
    				? buildErrorString(saveResult.getErrors())
    				: setOpportunityToInProgress(newProject.opportunity__c, savePoint);
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