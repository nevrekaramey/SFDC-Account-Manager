public with sharing class AccountManager {

    //Unique label for the request
    public String requestLabel;
    //Result of callout
    public String result {get;set;}
    //Account object declaration to create new account
    public Account newAccount {get;set;}
    //List to hold accounts returned from remote org
    public List<Account> accounts {get;set;}
    //AccountList object declaration to paginate the account results returned from remote org
    public AccountList accountList {get;set;}

    //Display messages
    public String messageResponse {get;set;}
    public String remoteMessageResponse {get;set;}


    /*
      Ideally would set org URLs from custom setting so that URL value be dynamically changed.
    */
    //Remote Org URL
    private static final String REMOTE_ORG_URL = 'https://eu6.salesforce.com/';
    //Rest Api URL 
    private static final String SERVICE_URL = 'https://eu6.salesforce.com/services/apexrest/Account/';

    public AccountManager(){
    	//Initializing all necessary objects.
    	newAccount = new Account();
    	accounts =   new List<Account>();
    }
    
    //Async invocation method
    public Object startRequests() {
        
        //Setting timeout for continuation
        Continuation con = new Continuation(60);
        //Setting callback method
        con.continuationMethod='processResponse';

      try{
        //Getting authentication info of remote org
        ConnectorClass connection = ConnectorClass.setConnection();  
        
        //Creating callout request to remote org
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+connection.authenticationInfo.access_token);
        req.setHeader('Content-type','application/json');
        req.setHeader('accept','application/json');
        req.setMethod('GET');
        req.setEndpoint(SERVICE_URL);
        
        //Adding callout request to continuation
        this.requestLabel = con.addHttpRequest(req);
      }
      catch(Exception e){
          remoteMessageResponse = 'Error while connecting to remote org! Try again!';
          e.getStackTraceString();
      } 

      return con;  
    }

    // Callback method invoked only when responses of callout is returned.
    public Object processResponse() {

      try{
        //Get the response of the request
        HttpResponse response = Continuation.getResponse(this.requestLabel);

        //Deserializing JSON response consisting of List of Accounts from Rest Servivce
        accounts = (List<Account>) JSON.deserialize(response.getBody(), List<Account>.class); 

        //Pass accounts to pagination class to paginate date
        accountList = new AccountList(accounts);
      }
      catch(Exception e){
          remoteMessageResponse = 'Error while getting response from remote org';
          e.getStackTraceString();
      }
                 
      return null;
    }

    //Method to create Account in current org and check to if there is a duplicate
    public PageReference insertRecord() {

      //List of accounts to be updated
    	List<Account> updateAccounts = new List<Account>();
    	//Map to maintain reference between new and remote account
      Map<Account, Account> refAccount = new Map<Account,Account>();

      Savepoint sp = Database.setSavepoint();

      try{
        //Insert the account to be created
        insert newAccount;

        //Check to if the account created exist in remote org from the list returned and if exist then update the new account with reference to remote account.
        //Not doing another callout to remote org as all the accounts from remote org available to check if there are duplicates.
        if(!accounts.isEmpty()){
          for(Account acc : accounts){
            //check to see if remote account list consist of new account
            if(acc.Name == newAccount.Name){ 
              //map to maintain reference between new and remote account.
              refAccount.put(newAccount,acc); 
            }
          }

          if(!refAccount.isEmpty()){
            for(Account acc : refAccount.keySet()){
              acc.Org2_Id__c = REMOTE_ORG_URL + refAccount.get(acc).Id;
              updateAccounts.add(acc);
            }

            //Update the current account with reference to remote account
            if(!updateAccounts.isEmpty()){
              update updateAccounts;
            }
          }
        }

        /*
          Ideally would use ApexPages.addMessage to return back messages to the page. 
          but using apex:pageMessages in VF page with Continuation class results in error which seems to be a bug.
          Hence using workaround to display messages using apex:outputText.
        */
        messageResponse = 'Saved Successfully';
      }
      catch(Exception e){
        Database.rollback(sp);
        messageResponse = 'Error while saving record. Rolling back the transaction';
        e.getStackTraceString();
      }

      return null;
    }
}
