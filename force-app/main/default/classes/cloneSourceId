public with sharing class OpportunityTriggerHandler {
    public static void onBeforeInsert(List<Opportunity> newOpportunities) {
        // check if cloned and add Clone_Source_Id__c when needed
        for(Opportunity opp : newOpportunities){
            if(opp.isClone()){
                opp.Clone_Source_Id__c = opp.getCloneSourceId();
            }
        }
    }
}
