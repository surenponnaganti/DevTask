/**
 * @description       : RestHelperClass class for callouts
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
public with sharing class RestHelperClass {

    private final String clientId = '***';
    private final String clientSecret = '***';
    private final String username = 'scponnaganti@gmail.com.devtask';
    private final String password = '***';

    public static String accessToken = null;
    public static List<TransactionItemWrapper> tiwLst = new List<TransactionItemWrapper>();
    public static List<TransactionWrapper> tLst = new List<TransactionWrapper>();

    public class DeserializeResponse
    {       
        public String accessToken{get; set;}
    }


    public String returnAccessToken (RestHelperClass rest)
    {
        DeserializeResponse response = new DeserializeResponse();
        try{
            String reqbody = 'grant_type=password&amp;client_id='
                +clientId+'&amp;client_secret='
                +clientSecret+'&amp;username='
                +username+'&amp;password='+password;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setBody(reqbody);
            req.setMethod('POST');
            req.setEndpoint('https://login.salesforce.com/services/oauth2/token');
            HttpResponse res = h.send(req);            
            //Commented bacause no actual end point
            //response = (DeserializeResponse)JSON.deserialize(res.getbody(),DeserializeResponse.class);            
            response.accessToken = 'test';
            return response.accessToken;
        }catch(Exception ex){
            ExceptionUtils.handleException(ex, true);
        }
        return null;
    }

    /**
    * @description : Method to create JSON from trans and tran items to send to external system 
    * @author Suren | 09-09-2020 
    * @param tranIds : Transaction Ids
    * @return HttpResponse 
    **/
    public static HttpResponse processRecords(Set<Id> tranIds){
        try{
        List<Transaction__c> trans = [Select Id, Name, Transaction_Count__c, Total_Discount__c, Total_Cost__c, CreatedDate, (Select Id, Name, Item_Cost__c from TransactionItem__r) from Transaction__c where Id IN: tranIds];
            // Construct TransactionItems data and Transaction data by utilizing Wrapper class
            for(Transaction__c tr: trans){
                TransactionWrapper trw = new TransactionWrapper();
                TransactionWrapper.Keys trk = new TransactionWrapper.Keys();
                TransactionWrapper.Values trv = new TransactionWrapper.Values();
                trk.transactionId = String.valueOf(tr.Id);
                trv.transactionDate = String.valueOf(tr.CreatedDate);
                trv.totalDiscount = String.valueOf(tr.Total_Discount__c);
                trv.totalCount = String.valueOf(tr.Transaction_Count__c);
                trv.totalCost = String.valueOf(tr.Total_Cost__c);
                trw.keys = trk;
                trw.values = trv;
                tLst.add(trw);
                for(TransactionItem__c trItem: tr.TransactionItem__r){
                    TransactionItemWrapper tiw = new TransactionItemWrapper();
                    TransactionItemWrapper.Keys trIk = new TransactionItemWrapper.Keys();
                    TransactionItemWrapper.Values trIv = new TransactionItemWrapper.Values();
                    trIk.transactionItemId = String.valueOf(trItem.Id);
                    trIv.itemCost = String.valueOf(trItem.Item_Cost__c);
                    trIv.itemName = trItem.Name;
                    tiw.keys = trIk;
                    tiw.values = trIv;
                    tiwLst.add(tiw);
                }
            }
            
            RestHelperClass rhc = new RestHelperClass();
            accessToken = rhc.ReturnAccessToken(rhc);

            if(!String.isEmpty(accessToken)){

                String endPoint = 'https://login.salesforce.com/test1';
                HttpResponse res = sendDataExternalSystem(true, endPoint);  
                if(res.getStatusCode() == 200){
                    // If Transaction items sent successfully then send Transaction details    
                    endPoint = 'https://login.salesforce.com/test2';                
                    HttpResponse res2 = sendDataExternalSystem(false, endPoint);                    
                    return res2;                
                }
                else{
                    //create a record in error log to track
                    Error_Log__c er = new Error_Log__c();
                    er.Cause__c = 'Response is unsuccessful';
                    er.Error_Details__c = res.toString();
                    er.Error_Type__c = 'UnsuccessfulReponse';
                    ExceptionUtils.logToObject(er);
                }
        }
        
        }catch(Exception ex){
            ExceptionUtils.handleException(ex, true);
        }
        return null;    
            
    }
    /**
    * @description : Method to send data to external system using end point
    * @author Suren | 09-09-2020 
    * @param isTranItems 
    * @param endPoint 
    * @return HttpResponse 
    **/
    public static HttpResponse sendDataExternalSystem(Boolean isTranItems, String endPoint){        
        String body = null;
        if(isTranItems){  
            body = JSON.serialize(tiwLst);
        }
        else {
            body = JSON.serialize(tLst);
        }                
        HttpResponse res = CalloutHelper.makeCallOut(accessToken, endPoint, body, 'POST');            
        return res; 
    }
    
}
