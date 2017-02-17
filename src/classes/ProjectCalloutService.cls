public virtual class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity to PMS' description='Posts Opportunity to Square Peg\'s Project Management System')
	public static void postOpportunityToPMS(List<Id> opportunityIdList){
		(new ProjectCalloutService()).postProjectToPMS(opportunityIdList); 
    }
    
    public void postProjectToPMS(List<Id> opportunityIdList) {
    	System.enqueueJob(new QueueablePMSCall(opportunityIdList));
    }
      
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
    	private Set<Integer> successCodeSet = new Set<Integer>{ 201 };
    	DB_GenericDml genericDml; 
    	DB_OpportunitiesSelector opportunitiesSelector;
		RH_OpportunityHelper opportunityHelper;
    	
    	List<Id> opportunityIdList;
    	
    	public QueueablePMSCall(
    			List<Id> opportunityIdList, 
    			DB_GenericDml genericDml, 
    			DB_OpportunitiesSelector opportunitiesSelector, 
    			RH_OpportunityHelper opportunityHelper
    	){
    		this.opportunityIdList = opportunityIdList;
    		this.genericDml = genericDml;
    		this.opportunitiesSelector = opportunitiesSelector;
    		this.opportunityHelper = opportunityHelper;
    	}	

    	public QueueablePMSCall(List<Id> opportunityIdList){
    		this(opportunityIdList, new DB_GenericDml(), new DB_OpportunitiesSelector(), new RH_OpportunityHelper());
    	}	
    	
	    public void execute(QueueableContext queueableContext) {
	    	List<Opportunity> opportunityList = opportunitiesSelector.selectWithAccountsById(opportunityIdList);
	    	HttpResponse response = (new Http()).send(this.createRequest(opportunityList));
			if (!(this.successCodeSet.contains(response.getStatusCode()))) {
				this.setStage(opportunityList, 'Submitted Project');
			} 
			else {
				this.setStage(opportunityList, 'Resubmit Project');
			}
	    }
	    
	    @testVisible
	    private HttpRequest createRequest(List<Opportunity> opportunityList) {
			HttpRequest request = new HttpRequest();
			request.setEndpoint('callout:ProjectService');
			request.setHeader('X-auth-token', ServiceTokens__c.getValues('ProjectServiceToken').token__c);
			request.setMethod ('POST'); 
			request.setHeader('Content-Type', 'application/json');
			request.setBody(this.createBody(opportunityList));
			return request; 
	    }
	    
	    @testVisible
	    private String createBody(List<Opportunity> opportunityList) {
	    	return opportunityHelper.convertToJson(opportunityList);
	    }
	    
	    @testVisible
	    private void setStage(List<Opportunity> opportunityList, String stageName) {
	    	for (Opportunity opportunity : opportunityList) {
	    		opportunity.stageName = stageName;
	    	}
	    	genericDml.doUpdate(opportunityList);
	    }
    }
}