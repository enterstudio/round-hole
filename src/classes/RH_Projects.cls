public virtual class RH_Projects {
	List<Project__c> projectList;
	RH_ProjectsBillingService projectsBillingService;
	
	public RH_Projects(List<Project__c> projectList, RH_ProjectsBillingService projectsBillingService) {
		this.projectList = projectList;
		this.projectsBillingService = projectsBillingService;
	}

	public RH_Projects(List<Project__c> projectList) {
		this(projectList, new RH_ProjectsBillingService());
	}

	public virtual void callBillingService(Map<Id, SObject> existingProjectMap) {
		List<Project__c> newlyBillableProjectList = buildNewlyBillableList(existingProjectMap); 
		projectsBillingService.callBillingService(newlyBillableProjectList);
	}
	
	@testVisible
	private List<Project__c> buildNewlyBillableList(Map<Id, SObject> existingProjectMap) {
		List<Project__c> newlyBillableProjectList = new List<Project__c>();
		for (Project__c project : projectList) {
			Boolean isBillable = project.status__c == 'Billable';
			Boolean wasNotBillable = existingProjectMap.get(project.id).get('status__c') != 'Billable';
			if (isBillable && wasNotBillable) {
				newlyBillableProjectList.add(project);
			}
		} 
		return newlyBillableProjectList;
	}
}