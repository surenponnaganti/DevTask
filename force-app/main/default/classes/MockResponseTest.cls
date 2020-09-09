/**
 * @description       : MockResponseTest class to create fake response for call outs
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
@isTest
public class MockResponseTest implements HttpCalloutMock {
    /**
    * @description : To create fake response when callout is made
    * @author Suren | 09-09-2020 
    * @param req 
    * @return HTTPResponse 
    **/
    // global HTTPResponse respond(HTTPRequest req) {               
    //     System.assertEquals('POST', req.getMethod());        
    //     // Create a fake response
    //     HttpResponse res = new HttpResponse();
    //     res.setHeader('Content-Type', 'application/json');
    //     res.setBody('{"example":"test"}');
    //     res.setStatusCode(200);
    //     return res;
    // }

    HttpResponse response = new HttpResponse();
    public void addResponse(HttpResponse res) {
        response = res;
    }
    public HttpResponse respond(HttpRequest req) {
        System.assertEquals('POST', req.getMethod());  
        return response;
    }
}
