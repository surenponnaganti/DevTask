/**
 * @description       : Helper class for TransactionItem trigger to check whether transaction count and related items are equal or not to send data to external system
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
public with sharing class TransactionItemTriggerHelper {
    
    /**
    * @description : Method to verify transaction count on transaction and related transaction items to equal and take transaction ids to process records
    * @author Suren | 09-09-2020 
    * @param trItems 
    * @param isInsert 
    * @param isUpdate 
    **/
    public static void validateTrasactionItem(List<TransactionItem__c> trItems,Boolean isInsert, Boolean isUpdate){
        Set<Id> transIds = new Set<Id>();
        for(TransactionItem__c trItem: trItems){
            transIds.add(trItem.Transaction__c);
        }               
        Set<Id> relTrans = new Set<Id>();
        for(Transaction__c tr: [Select Id, Name, Transaction_Count__c, Total_Discount__c, Total_Cost__c, CreatedDate, (Select Id, Name, Item_Cost__c from TransactionItem__r) from Transaction__c where Id IN: transIds]){
            if(tr.Transaction_Count__c == tr.TransactionItem__r.size()){                
                relTrans.add(tr.Id);
            }
        }
        
        if(relTrans.size() > 0){
            //call future method to send the details
            sendDetails(relTrans);
        }
    }
    /**
    * @description : Future method to process the request asynchronous, so it dosen't stop trigger execution when making a callout 
    * @author Suren | 09-09-2020 
    * @param tranIds 
    **/
    @future(callout = true)
    private static void sendDetails(Set<Id> tranIds){
        RestHelperClass.processRecords(tranIds);
    }
}