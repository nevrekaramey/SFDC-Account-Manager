@RestResource(urlMapping='/Account/*')
global with sharing class callAccount{
        
    @HttpGet
    //Creating a generic account getter method which returns all the accounts to local org and also allows to check for duplicates avoiding 
    //another query to remote org.
    global static List<Account> doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        List<Account> accList = [Select Id, Name From Account];
        
        return accList;
    }
}
