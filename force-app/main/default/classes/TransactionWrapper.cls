/**
 * @description       : Wrapper class can be utilized to construct Transaction JSON
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/
public with sharing class TransactionWrapper {
    
    public Keys keys;
    public Values values;	    

    public class Keys {
        public String transactionId{get; set;}
    }

    public class Values {
        public String totalCost{get; set;}
        public String totalDiscount{get; set;}
        public String transactionDate{get; set;}
        public String totalCount{get; set;}
    }
}
