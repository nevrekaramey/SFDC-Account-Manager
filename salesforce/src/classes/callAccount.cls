@RestResource(urlMapping='/Account/*')
global with sharing class callAccount{
        
    @HttpGet
    global static List<Account> doGet(){
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        List<Account> accList = [Select Id, Name From Account];
        
        return accList;
    }
}