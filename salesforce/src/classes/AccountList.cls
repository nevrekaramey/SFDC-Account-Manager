public class AccountList{ 
    //List to store all records
    public List<Account> allAccounts = new List<Account>();
    
    //List to show the records on the page
    public List<Account> accountsToShow{get;set;}
    
    //Navigation variables
    Integer counter = 0;
    Integer pageSize = 0;
    Integer totalSize =0;
    
    //Constructor
    public AccountList(List<Account> accounts){
        accountsToShow = new List<Account>();
        
        //Setting page size dynamically using custom setting value
        AccountManger__c am = AccountManger__c.getInstance();
        //If page size is not setting defaulting the page size
        if(am.Pagesize__c == null){
            pagesize = 5;
        }
        else{
            pagesize = integer.valueof(am.Pagesize__c);    
        }
        
        //Set all the records 
        AllAccounts = accounts;

        //Set the total size
        totalSize = allAccounts.size();
        
        //Intial adding of records to accountsToShow depending on the page size
        if((counter+pageSize) <= totalSize){
            for(Integer i=0;i<pageSize;i++){
                accountsToShow.add(AllAccounts.get(i));
            }
        }else{
            for(Integer i=0;i<totalSize;i++){
                accountsToShow.add(AllAccounts.get(i));
            }
        }
    }
    
    //Navigation methods
    public void start(){
   
        accountsToShow.clear();
        counter=0;

        if((counter + pageSize) <= totalSize){
            for(Integer i=0;i<pageSize;i++){
                accountsToShow.add(AllAccounts.get(i));
            }    
        } 
        else{
            for(Integer i=0;i<totalSize;i++){
                accountsToShow.add(AllAccounts.get(i));
            }       
        }
    }
   
    public void next(){
   
        accountsToShow.clear();
        counter=counter+pageSize;

        if((counter+pageSize) <= totalSize){
            for(Integer i=counter-1;i<(counter+pageSize);i++){
                accountsToShow.add(AllAccounts.get(i));
            }
        } 
        else{
            for(Integer i=counter;i<totalSize;i++){
                accountsToShow.add(AllAccounts.get(i));
            }
        }
    }
   
    public void previous(){
   
        accountsToShow.clear();
        counter=counter-pageSize;       
       
        for(Integer i=counter;i<(counter+pageSize); i++){
            accountsToShow.add(AllAccounts.get(i));
        }
    }

    public void last (){
   
        accountsToShow.clear();
       
        if(math.mod(totalSize , pageSize) == 0){
            counter = pageSize * ((totalSize/pageSize)-1);
        } else if (math.mod(totalSize , pageSize) != 0){
            counter = pageSize * ((totalSize/pageSize));
        }
       
        for(Integer i=counter-1;i<totalSize-1;i++){
                accountsToShow.add(AllAccounts.get(i));
        }
       
    }
   
    public Boolean getDisableNext(){
   
        if((counter + pageSize) >= totalSize)
            return true;
        else
            return false;
    }
   
    public Boolean getDisablePrevious(){
   
        if(counter == 0)
            return true;
        else
            return false;
    } 
}
