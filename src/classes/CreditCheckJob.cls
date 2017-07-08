public class CreditCheckJob implements Queueable, Database.AllowsCallouts{
    private String opportunityId;
    private String accountId;
    
    public CreditCheckJob(String opportunityId, String accountId) {        
     	this.opportunityId = opportunityId;
        this.accountId = accountId;
    }
    
    public void execute(QueueableContext context) {
    	
    }

}