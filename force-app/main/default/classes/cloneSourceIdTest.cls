@IsTest
public class OpportunityTriggerHandlerTest {

    @TestSetup
    static void setupData() {
        // Test data setup: create an original Opportunity to clone later
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;

        Opportunity originalOpp = new Opportunity(
            Name = 'Test Opportunity', 
            StageName = 'Tracking', 
            CloseDate = Date.today().addDays(30),
            AccountId = testAccount.Id,
            Bus_Unit__c = 'BCU | NE',
            State_of_Project_Site__c = 'ME',
            Estimated_Value_SC__c = 10000,
            Estimated_Fee_Pct__c = 10
        );
        insert originalOpp;
    }

    @IsTest
    static void testOpportunityCloneBehavior() {
        // Fetch the original Opportunity to clone
        Opportunity originalOpp = [SELECT Id FROM Opportunity LIMIT 1];

        // Clone the original opportunity
        Opportunity clonedOpp = originalOpp.clone(false, true); // Set to deep clone
        clonedOpp.Name = 'Cloned Opportunity';
        clonedOpp.StageName = 'Evaluation';
        clonedOpp.CloseDate = Date.today().addDays(30);
        insert clonedOpp;

        // Verify that Clone_Source_Id__c was populated
        Opportunity insertedClone = [SELECT Clone_Source_Id__c FROM Opportunity WHERE Id = :clonedOpp.Id];
        System.assertNotEquals(null, insertedClone.Clone_Source_Id__c, 'Clone_Source_Id__c should be populated when an Opportunity is cloned.');
        System.assertEquals(originalOpp.Id, insertedClone.Clone_Source_Id__c, 'Clone_Source_Id__c should reference the original Opportunity.');
    }

    @IsTest
    static void testNonCloneOpportunity() {
        // Create a new opportunity that is not cloned
        Opportunity newOpp = new Opportunity(
            Name = 'Non-Cloned Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert newOpp;

        // Verify that Clone_Source_Id__c is not populated
        Opportunity insertedOpp = [SELECT Clone_Source_Id__c FROM Opportunity WHERE Id = :newOpp.Id];
        System.assertEquals(null, insertedOpp.Clone_Source_Id__c, 'Clone_Source_Id__c should be null for a non-cloned Opportunity.');
    }

    @IsTest
    static void testOpportunityWithoutCloneSourceId() {
        // Create a mock cloned opportunity with no Clone Source ID
        Opportunity originalOpp = [SELECT Id FROM Opportunity LIMIT 1];

        // Attempt a shallow clone (which would not have a clone source ID)
        Opportunity shallowClonedOpp = originalOpp.clone(false, false); // shallow clone
        shallowClonedOpp.Name = 'Shallow Cloned Opportunity';
        shallowClonedOpp.StageName = 'Prospecting';
        shallowClonedOpp.CloseDate = Date.today().addDays(30);
        insert shallowClonedOpp;

        // Verify that Clone_Source_Id__c is not populated for shallow clone
        Opportunity insertedShallowClone = [SELECT Clone_Source_Id__c FROM Opportunity WHERE Id = :shallowClonedOpp.Id];
        System.assertEquals(null, insertedShallowClone.Clone_Source_Id__c, 'Clone_Source_Id__c should not be populated for a shallow cloned Opportunity.');
    }
}
