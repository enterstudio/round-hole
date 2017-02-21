@isTest
public class BillingServiceProxyInvoicesPortSoapMock extends BillingServiceProxy.InvoicesPortSoap11 {
	public String projectRef {private set; get; }
	public Decimal amount {private set; get; }
	String response;
	
	public BillingServiceProxyInvoicesPortSoapMock(String response) {
		this.response = response;
	}
	
    public override String billProject(BillingServiceProxy.project project) {
    	this.projectRef = project.projectRef;
    	this.amount = project.billAmount;
    	return this.response;
    }	
}