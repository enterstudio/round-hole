@isTest
public class RH_OpportunityHelperMock extends RH_OpportunityHelper { 
	public List<Opportunity> updatedOpportunityList {private set; get;}
	public String updateStageName {private set; get;}
	
    public override HttpRequest createHttpRequest(List<Opportunity> opportunityList) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint('http://test.example.com');
		request.setMethod ('POST'); 
		return request; 
    }
    
    public override void setStage(List<Opportunity> opportunityList, String stageName) {
    	this.updatedOpportunityList = opportunityList;
    	this.updateStageName = stageName;
    }
}