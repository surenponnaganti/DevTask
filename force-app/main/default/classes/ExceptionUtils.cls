/**
 * @description       : ExceptionUtils class can be used when any exception trown in the code
 * @author            : Suren
 * @group             : 
 * @last modified on  : 09-09-2020
 * @last modified by  : Suren
 * Modifications Log 
 * Ver   Date         Author   Modification
 * 1.0   09-09-2020   Suren   Initial Version
**/

public without sharing class ExceptionUtils {
    
    /**
    * @description : Handle exception method called whenever exception raised
    * @author Suren | 09-09-2020 
    * @param exceptionCaught Exception that was caught in the code
    * @param logToObject If needs to be logged into object or not
    **/
    public static void handleException(Exception exceptionCaught, Boolean logToObject) {
        
        Error_Log__c exceptionStaged = new Error_Log__c();
        exceptionStaged.Cause__c = String.valueOf(exceptionCaught.getCause());
        exceptionStaged.Error_Details__c = exceptionCaught.getMessage();
        exceptionStaged.Error_Type__c = exceptionCaught.getTypeName();
        
        if(logToObject) {
            ExceptionUtils.logToObject(exceptionStaged);
        }
    }    
        
    /**
    * @description : Insert into Error Log object
    * @author Suren | 09-09-2020 
    * @param exceptionPassed Exception that was caught in the code
    **/
    public static void logToObject(Error_Log__c exceptionPassed) {
		List<Error_Log__c> exceptionsToInsert = new List<Error_Log__c >();

        exceptionsToInsert.add(exceptionPassed);
        insert exceptionsToInsert;
    }
}
