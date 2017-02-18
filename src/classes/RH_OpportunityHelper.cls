public virtual class RH_OpportunityHelper {
   	DB_GenericDml genericDml; 
    	
   	public RH_OpportunityHelper(DB_GenericDml genericDml){
   		this.genericDml = genericDml;
   	}	

   	public RH_OpportunityHelper(){
   		this(new DB_GenericDml());
   	}	
	
    public virtual HttpRequest createHttpRequest(List<Opportunity> opportunityList) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint('callout:ProjectService');
		request.setMethod ('POST'); 
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('X-auth-token', ServiceTokens__c.getValues('ProjectServiceToken').token__c);
		request.setBody(this.convertToJson(opportunityList));
		return request; 
    }

	@testVisible
	private String convertToJson(List<Opportunity> opportunityList) {
		String json = '[';
		for (Opportunity opportunity: opportunityList) {
			json += convertToJson(opportunity);
		}
		return json + ']';
	}
	
	@testVisible
	private String convertToJson(Opportunity opportunity) {
		return '{'
			 + '"opportunityId" : "' + opportunity.id + '",' 
			 + '"opportunityName" : "' + opportunity.name + '",'
			 + '"accountName" : "' + opportunity.account.name + '",'
			 + '"closeDate" : "' + String.valueOf(opportunity.closeDate).subStringBefore(' ') + '",'
			 + '"amount" : "' + opportunity.amount + '"'
			 + '}';
	}
	
    public virtual void setStage(List<Opportunity> opportunityList, String stageName) {
    	for (Opportunity opportunity : opportunityList) {
    		opportunity.stageName = stageName;
    	}
    	this.genericDml.doUpdate(opportunityList);
    }
}