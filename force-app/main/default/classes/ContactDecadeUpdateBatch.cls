/*Years_Attended__c is a multi-select picklist field with values from 1952 to current year. 
Tracks the years some attended college, storing values like 2019;2020;2021.
This batch class determines the first decade they attended by splitting the Years_Attended__c field into a list,
then calculating based on the 0 index value.
*/
global class ContactDecadeUpdateBatch implements Database.Batchable<sObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Years_Attended__c, First_Decade_Attended__c 
            FROM Contact 
            WHERE Years_Attended__c != null
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Contact con : scope) {
            String earliestDecade = getEarliestDecade(con.Years_Attended__c);
            if (earliestDecade != null && earliestDecade != con.First_Decade_Attended__c) {
                con.First_Decade_Attended__c = earliestDecade;
                contactsToUpdate.add(con);
            }
        }
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // Optional: Add any post-processing logic here
    }
    
    private String getEarliestDecade(String yearsAttended) {
        if (String.isBlank(yearsAttended)) return null;
        
        List<String> years = yearsAttended.split(';');
        String earliestYear = years[0]; // Get the first year
        return earliestYear.substring(0, 3) + '0s'; // Take first 3 chars and add '0s'
    }
    
    // Schedulable interface method
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new ContactDecadeUpdateBatch(), 200);
    }
}