/**
 * @description       : Wrapper class can be utilized to construct TransactionItem JSON
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
public with sharing class TransactionItemWrapper {
   
    public Keys keys;
    public Values values; 

    public class Keys {
        public String transactionItemId{get; set;}
    }

    public class Values {
        public String itemCost{get; set;}
        public String itemName{get; set;}
    }
}
