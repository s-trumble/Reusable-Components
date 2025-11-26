/**
 * @description       : Invocable action to launch an Approval Orchestration Flow
 * @testing           : LaunchApprovalOrchestrationActionTest
 * @author            : FSM
 * @last modified on  : 04-24-2025 - FSM
 * @last modified by  : FSM
**/

public with sharing class LaunchApprovalOrchestrationAction {
    
    /**
     * @description Input parameters for the invocable action
     */
    public class ApprovalOrchestrationRequest {
        @InvocableVariable(label='Record ID' required=true description='The ID of the record to be approved')
        public String recordId;
        
        @InvocableVariable(label='Submission Comments' required=false description='Comments provided during submission')
        public String submissionComments;
        
        @InvocableVariable(label='Submitter' required=true description='The user who submitted the approval')
        public String submitter;
        
        @InvocableVariable(label='Orchestration Flow API Name' required=true description='API Name of the Orchestration Flow to launch')
        public String orchestrationFlowApiName;
        
        @InvocableVariable(label='Designated Approver 1' required=false description='First approver in the approval process')
        public User designatedApprover1;
        
        @InvocableVariable(label='Designated Approver 2' required=false description='Second approver in the approval process')
        public User designatedApprover2;
        
        @InvocableVariable(label='Designated Approver 3' required=false description='Third approver in the approval process')
        public User designatedApprover3;
    }
    
    /**
     * @description Output parameters for the invocable action
     */
    public class ApprovalOrchestrationResult {
        @InvocableVariable(label='Orchestration Instance ID' description='The ID of the created Flow Orchestration instance')
        public String orchestrationInstanceId;
        
        @InvocableVariable(label='Success' description='Whether the orchestration was launched successfully')
        public Boolean success;
        
        @InvocableVariable(label='Error Message' description='Error message if the orchestration failed to launch')
        public String errorMessage;
    }
     /**
     * @description Invocable method to launch the Approval Orchestration Flow
     * @param requests Collection of approval orchestration requests
     * @return Collection of approval orchestration results
     */
    @InvocableMethod(label='Launch Approval Orchestration' description='Launches the specified Approval Orchestration Flow' category='Approval Processes')
    public static List<ApprovalOrchestrationResult> launchApprovalOrchestration(List<ApprovalOrchestrationRequest> requests) {
        List<ApprovalOrchestrationResult> results = new List<ApprovalOrchestrationResult>();
        
        for (ApprovalOrchestrationRequest request : requests) {
            ApprovalOrchestrationResult result = new ApprovalOrchestrationResult();
            result.success = false;
            
            try {
                // Create a map of input variables for the flow
                Map<String, Object> flowInputs = new Map<String, Object>();
                flowInputs.put('recordId', request.recordId);
                flowInputs.put('submitter', request.submitter);
                
                // Add submission comments if provided
                if (request.submissionComments != null) {
                    flowInputs.put('submissionComments', request.submissionComments);
                }
                
                // Add designated approvers to flow inputs if they are provided
                if (request.designatedApprover1 != null) {
                    flowInputs.put('DesignatedApprover1', request.designatedApprover1);
                }
                
                if (request.designatedApprover2 != null) {
                    flowInputs.put('DesignatedApprover2', request.designatedApprover2);
                }
                
                if (request.designatedApprover3 != null) {
                    flowInputs.put('DesignatedApprover3', request.designatedApprover3);
                }
                
                // Create Flow.Interview instance for the specified orchestration flow
                Flow.Interview flowOrchestration = Flow.Interview.createInterview(request.orchestrationFlowApiName, flowInputs);
                
                // Start the flow interview
                flowOrchestration.start();
                
                // Get the orchestration instance ID if the flow provides it as an output variable
                Object orchestrationInstanceId = flowOrchestration.getVariableValue('orchestrationInstanceId');
                if (orchestrationInstanceId != null) {
                    result.orchestrationInstanceId = String.valueOf(orchestrationInstanceId);
                }
                
                result.success = true;
            } catch (Exception e) {
                result.errorMessage = 'Error launching approval orchestration: ' + e.getMessage() + 
                                      ' Stack trace: ' + e.getStackTraceString();
                result.success = false;
            }
            
            results.add(result);
        }
        
        return results;
    }
}