/**
 * @description       : Trigger on TransactionItem object to send data to external application after create/update
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/

trigger TransactionItemTrigger on TransactionItem__c (after insert, after update) {     
        //call helper class method to verify transcation items and transaction record count to send details to external system
        TransactionItemTriggerHelper.validateTrasactionItem(Trigger.new, Trigger.isInsert, Trigger.isUpdate);
    
}