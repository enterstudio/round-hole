@isTest
public class DB_OpportunitiesSelectorMock extends DB_OpportunitiesSelector{
	public List<Opportunity> returnedOpportunityList{set; private get;}
	
	public override List<Opportunity> selectWithAccountsById(List<Id> idList) {
		return returnedOpportunityList;
    } 
}