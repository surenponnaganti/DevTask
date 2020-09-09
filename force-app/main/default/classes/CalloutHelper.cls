/**
 * @description       : Helper class for call outs
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
public with sharing class CalloutHelper {
    /**
    * @description : Method to construct http request based on accessToken, method, endPoint
    * @author Suren | 09-09-2020 
    * @param accessToken 
    * @param method 
    * @param endPoint 
    * @return HttpRequest 
    **/
    public static HttpRequest constructHttpRequest(string accessToken, string method, string endPoint){        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer ' + accessToken);
        req.setHeader('Content-Type','application/json');            
        req.setMethod(method);
        req.setEndpoint(endPoint);
        return req;
    }

    /**
    * @description : Method to send data to external system using end point
    * @author Suren | 09-09-2020 
    * @param isTranItems 
    * @param endPoint 
    * @return HttpResponse 
    **/
    public static HttpResponse makeCallOut(String accessToken, String endPoint, String body, string method){
        try{   
            Http h = new Http();
            HttpRequest req = constructHttpRequest(accessToken, method, endPoint);            
            req.setBody(body);
            HttpResponse res = h.send(req);            
            return res;                
            
        }catch(Exception ex){
            ExceptionUtils.handleException(ex, true);
        }
        return null;
    }
}
