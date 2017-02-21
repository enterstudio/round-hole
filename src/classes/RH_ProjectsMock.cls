@isTest
public class RH_ProjectsMock extends RH_Projects {
	public Map<Id, SObject> existingProjectMap {private set; get;}
	
	public RH_ProjectsMock(List<Project__c> projectList) {
		super(projectList, new RH_ProjectsBillingService());
	}
		
	public override void callBillingService(Map<Id, SObject> existingProjectMap) {
		this.existingProjectMap = existingProjectMap;
	}
}