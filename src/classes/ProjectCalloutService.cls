public virtual class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Post Opportunity to PMS' description='Posts Opportunity to Square Peg\'s Project Management System')
	public static void postOpportunityToPMS(List<Id> opportunityIdList){
		(new ProjectCalloutService()).postOpportunity(opportunityIdList); 
    }
    
    public void postOpportunity(List<Id> opportunityIdList) {
    	System.enqueueJob(new QueueablePMSCall(opportunityIdList));
    }
      
    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
    	private Set<Integer> successCodeSet = new Set<Integer>{ 201 };
    	DB_OpportunitiesSelector opportunitiesSelector;
		RH_OpportunityHelper opportunityHelper;
    	
    	List<Id> opportunityIdList;
    	
    	public QueueablePMSCall(
    			List<Id> opportunityIdList, 
    			DB_OpportunitiesSelector opportunitiesSelector, 
    			RH_OpportunityHelper opportunityHelper
    	){
    		this.opportunityIdList = opportunityIdList;
    		this.opportunitiesSelector = opportunitiesSelector;
    		this.opportunityHelper = opportunityHelper;
    	}	

    	public QueueablePMSCall(List<Id> opportunityIdList){
    		this(opportunityIdList, new DB_OpportunitiesSelector(), new RH_OpportunityHelper());
    	}	
    	
	    public void execute(QueueableContext queueableContext) {
	    	List<Opportunity> opportunityList = opportunitiesSelector.selectWithAccountsById(opportunityIdList);
	    	HttpResponse response = (new Http()).send(this.opportunityHelper.createHttpRequest(opportunityList));
			if (!(this.successCodeSet.contains(response.getStatusCode()))) {
				this.opportunityHelper.setStage(opportunityList, 'Resubmit Project');
			} 
			else {
				this.opportunityHelper.setStage(opportunityList, 'Submitted Project');
			}
	    }
    }
}