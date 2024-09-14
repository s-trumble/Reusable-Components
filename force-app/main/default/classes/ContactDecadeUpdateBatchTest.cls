@isTest
private class ContactDecadeUpdateBatchTest {
    
    @testSetup
    static void setup() {
        List<Contact> testContacts = new List<Contact>();
        
        // Create test contacts with various Years_Attended__c values
        testContacts.add(new Contact(LastName='Test1', Years_Attended__c='1952;1953;1954'));
        testContacts.add(new Contact(LastName='Test2', Years_Attended__c='1960;1961'));
        testContacts.add(new Contact(LastName='Test3', Years_Attended__c='1959;1960;1961'));
        testContacts.add(new Contact(LastName='Test4', Years_Attended__c='1970'));
        testContacts.add(new Contact(LastName='Test5', Years_Attended__c='2020;2021;2022'));
        testContacts.add(new Contact(LastName='Test6', Years_Attended__c=null));
        
        insert testContacts;
    }
    
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        ContactDecadeUpdateBatch batchJob = new ContactDecadeUpdateBatch();
        Database.executeBatch(batchJob);
        Test.stopTest();
        
        // Verify results
        List<Contact> updatedContacts = [SELECT Id, Years_Attended__c, First_Decade_Attended__c FROM Contact WHERE Years_Attended__c != null];
        System.assertEquals(5, updatedContacts.size(), 'Expected 5 contacts to be updated');
        
        for (Contact con : updatedContacts) {
            if (con.Years_Attended__c == '1952;1953;1954') {
                System.assertEquals('1950s', con.First_Decade_Attended__c, 'Expected 1950s for years 1952;1953;1954');
            } else if (con.Years_Attended__c == '1960;1961') {
                System.assertEquals('1960s', con.First_Decade_Attended__c, 'Expected 1960s for years 1960;1961');
            } else if (con.Years_Attended__c == '1959;1960;1961') {
                System.assertEquals('1950s', con.First_Decade_Attended__c, 'Expected 1950s for years 1959;1960;1961');
            } else if (con.Years_Attended__c == '1970') {
                System.assertEquals('1970s', con.First_Decade_Attended__c, 'Expected 1970s for year 1970');
            } else if (con.Years_Attended__c == '2020;2021;2022') {
                System.assertEquals('2020s', con.First_Decade_Attended__c, 'Expected 2020s for years 2020;2021;2022');
            } else {
                System.assert(false, 'Unexpected Years_Attended__c value: ' + con.Years_Attended__c);
            }
        }
        
        // Verify that contact with null Years_Attended__c was not updated
        Contact nullYearsContact = [SELECT Id, Years_Attended__c, First_Decade_Attended__c FROM Contact WHERE Years_Attended__c = null LIMIT 1];
        System.assertEquals(null, nullYearsContact.First_Decade_Attended__c, 'Expected null First_Decade_Attended__c for contact with null Years_Attended__c');
    }
    
    @isTest
    static void testSchedulableExecution() {
        Test.startTest();
        String jobId = System.schedule('Test Contact Decade Update', '0 0 0 * * ?', new ContactDecadeUpdateBatch());
        Test.stopTest();
        
        // Verify that the job was scheduled
        List<CronTrigger> cronTriggers = [SELECT Id, CronExpression FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, cronTriggers.size(), 'Expected one scheduled job');
        System.assertEquals('0 0 0 * * ?', cronTriggers[0].CronExpression, 'Cron expression should match');
    }
}