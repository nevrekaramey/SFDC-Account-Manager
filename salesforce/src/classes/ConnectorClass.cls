public with sharing class ConnectorClass {

    //OAUTH user/password information
    String clientId = EncodingUtil.urlEncode('3MVG9uudbyLbNPZOzOP.4rTsAV_2c2rxWZRWr7A449IcI.RalpoWgA1mOT9cYKAGpzu6jywO3NSanYnmxfmNI','UTF-8');
    String clientSecret = EncodingUtil.urlEncode('8389440981822293919','UTF-8');
    String username = EncodingUtil.urlEncode('remoteorg@worldofsalesforce.com','UTF-8');
    String password = EncodingUtil.urlEncode('orgremote16oTF3phhmnBFtWY5pmP1WsTNHu','UTF-8');
    String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password+'&access_type=offline';
    
    public OAuth2 authenticationInfo;
    private static ConnectorClass instance = new ConnectorClass();

    //Singleton pattern to instantiate only instance so multiple connection are not created.
    private ConnectorClass(){
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();

        req.setBody(reqbody);
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        req.setMethod('POST');

        HttpResponse res = h.send(req);
        authenticationInfo = (OAuth2)JSON.deserialize(res.getBody(),OAuth2.class);
    }

    public static ConnectorClass setConnection(){
        return instance;
    }
    
    //Deserialize token response
    public class OAuth2{
       public String Id {get;set;}
       public String issued_at{get;set;}
       public String instance_url{get;set;}
       public String signature{get;set;}
       public String access_token{get;set;}
    }
}