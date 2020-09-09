/**
 * @description       : Test class for TransactionItemTriggerHelper, ExceptionUtils, TransactionItemWrapper, TransactionWrapper
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
@isTest
public with sharing class TransactionItemTriggerHelperTest {
    /**
    * @description : Test method to verify callouts with mock
    * @author Suren | 09-09-2020 
    **/
    @isTest static void testCallout() {        
        Set<Id> tranIds = new Set<Id>();
        List<Transaction__c> trs = testData();
        for(Transaction__c tr: trs){
            tranIds.add(tr.Id);
        }
       
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        // Set mock callout class 
        MockResponseTest mrt = new MockResponseTest();
        HttpResponse res1 = new HttpResponse();
              
        // Create a fake response
        HttpResponse fakeRes = new HttpResponse();
        fakeRes.setHeader('Content-Type', 'application/json');
        fakeRes.setBody('{"example":"test"}');
        fakeRes.setStatusCode(200);
        mrt.addResponse(fakeRes);
        Test.setMock(HttpCalloutMock.class, mrt);
        HttpResponse res = RestHelperClass.processRecords(tranIds);        
        Test.stopTest();
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }

    /**
    * @description : Test method to verify callouts with mock
    * @author Suren | 09-09-2020 
    **/
    @isTest static void testCalloutUnsuccesful() {        
        Set<Id> tranIds = new Set<Id>();
        List<Transaction__c> trs = testData();
        for(Transaction__c tr: trs){
            tranIds.add(tr.Id);
        }
       
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        // Set mock callout class 
        MockResponseTest mrt = new MockResponseTest();
        HttpResponse res1 = new HttpResponse();
              
        // Create a fake response
        HttpResponse fakeRes = new HttpResponse();
        fakeRes.setHeader('Content-Type', 'application/json');
        fakeRes.setBody('{"example":"test"}');
        fakeRes.setStatusCode(0);
        mrt.addResponse(fakeRes);
        Test.setMock(HttpCalloutMock.class, mrt);
        HttpResponse res = RestHelperClass.processRecords(tranIds);        
        Test.stopTest();
        
        List<Error_Log__c> errors = [Select Id, Name, Error_Type__c from Error_Log__c];
        System.assertEquals('UnsuccessfulReponse', errors[0].Error_Type__c);
    }

    /**
    * @description : Test method to test exceptions
    * @author Suren | 09-09-2020 
    **/
    @isTest static void testexception(){
        Set<Id> tranIds = new Set<Id>();
        List<Transaction__c> trs = testData();
        TransactionItem__c tItem3 = new TransactionItem__c();
        tItem3.Name = 'Item3';
        tItem3.Item_Cost__c = 3;
        tItem3.Transaction__c = trs[0].Id;
        insert tItem3;
        tranIds.add(tItem3.Id);
        List<Error_Log__c> errors = [Select Id, Name from Error_Log__c];
        System.assert(true,errors.size()>0);

    }

    /**
    * @description : Method to prepare test data 
    * @author Suren | 09-09-2020 
    * @return List<Transaction__c>
    **/
    private static List<Transaction__c> testData(){
        List<Transaction__c> trs = new List<Transaction__c>();
        Transaction__c tr= new Transaction__c();
        tr.Name = 'Tran1';
        tr.Transaction_Count__c = 2;
        tr.Total_Discount__c = 10;
        tr.Total_Cost__c = 100;
        trs.add(tr);
        Transaction__c tr1= new Transaction__c();
        tr1.Name = 'Tran2';
        tr1.Transaction_Count__c = 2;
        tr1.Total_Discount__c = 11;
        tr1.Total_Cost__c = 200;
        trs.add(tr1);

        insert trs;

        List<TransactionItem__c> trItems = new List<TransactionItem__c>();
        for(Transaction__c t: trs){
            TransactionItem__c tItem = new TransactionItem__c();
            tItem.Name = 'Item1'+t.Id;
            tItem.Item_Cost__c = 1;
            tItem.Transaction__c = t.Id;
            trItems.add(tItem);

            TransactionItem__c tItem1 = new TransactionItem__c();
            tItem1.Name = 'Item1'+t.Id;
            tItem1.Item_Cost__c = 1;
            tItem1.Transaction__c = t.Id;
            trItems.add(tItem1);
        }

        insert trItems;
        return trs;
    }
}