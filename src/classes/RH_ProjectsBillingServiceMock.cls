@isTest
public class RH_ProjectsBillingServiceMock extends RH_ProjectsBillingService {
	public List<Project__c> projectList {private set; get;}
	
	public override void callBillingService(List<Project__c> projectList) {
		System.debug('###### projectList: ' + projectList.size());
		this.projectList = projectList;
	}
}