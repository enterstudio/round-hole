public virtual class RH_OpportunityHelper {
	public virtual String convertToJson(List<Opportunity> opportunityList) {
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
}