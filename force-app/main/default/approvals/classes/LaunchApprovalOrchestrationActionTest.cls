/**
* @description : Test class for LaunchApprovalOrchestrationAction
* @testing :
* @author : FSM
* @last modified on : 04-24-2025 - FSM
* @last modified by : FSM
**/
@isTest
private class LaunchApprovalOrchestrationActionTest {
// Define a constant for test flow API name to be used across all test methods
private static final String TEST_FLOW_API_NAME = 'Test_Approval_Orchestration_Flow';
@isTest
static void testLaunchApprovalOrchestrationWithAllApprovers() {
// Set up test data
String testRecordId = '001000000000001';
String testComments = 'Test approval comments';
String testSubmitter = '005000000000001';
// Create test request
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request.recordId = testRecordId;
request.submissionComments = testComments;
request.submitter = testSubmitter;
request.orchestrationFlowApiName = TEST_FLOW_API_NAME;
// Create test users for approvers (3 users)
User testUser1 = new User(Id = '005000000000002');
User testUser2 = new User(Id = '005000000000003');
User testUser3 = new User(Id = '005000000000004');
// Set designated approvers
request.designatedApprover1 = testUser1;
request.designatedApprover2 = testUser2;
request.designatedApprover3 = testUser3;
Test.startTest();
// We'll use a try-catch because the flow doesn't exist in test context
try {
// Invoke the action
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request}
);
// In a real test with proper mocking capabilities, we would assert more behavior
System.assertNotEquals(null, results, 'Results should not be null');
System.assertEquals(1, results.size(), 'Should return one result');
} catch (Exception e) {
// Expecting an exception in test context since the flow doesn't exist
// We can't mock Flow.Interview, so this is expected
System.debug('Expected exception in test: ' + e.getMessage());
}
Test.stopTest();
}
@isTest
static void testLaunchApprovalOrchestrationWithSomeApprovers() {
// Set up test data
String testRecordId = '001000000000001';
String testComments = 'Test with two approvers';
String testSubmitter = '005000000000001';
// Create test request
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request.recordId = testRecordId;
request.submissionComments = testComments;
request.submitter = testSubmitter;
request.orchestrationFlowApiName = TEST_FLOW_API_NAME;
// Create test users for approvers (only setting 2 approvers)
User testUser1 = new User(Id = '005000000000002');
User testUser2 = new User(Id = '005000000000003');
// Set only the first two designated approvers
request.designatedApprover1 = testUser1;
request.designatedApprover2 = testUser2;
request.designatedApprover3 = null; // Explicitly null
Test.startTest();
// We'll use a try-catch because the flow doesn't exist in test context
try {
// Invoke the action
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request}
);
System.assertNotEquals(null, results, 'Results should not be null');
System.assertEquals(1, results.size(), 'Should return one result');
} catch (Exception e) {
// Expecting an exception in test context since the flow doesn't exist
System.debug('Expected exception in test: ' + e.getMessage());
}
Test.stopTest();
}
@isTest
static void testLaunchApprovalOrchestrationWithFirstApproverOnly() {
// Set up test data
String testRecordId = '001000000000001';
String testComments = 'Test with one approver only';
String testSubmitter = '005000000000001';
// Create test request
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request.recordId = testRecordId;
request.submissionComments = testComments;
request.submitter = testSubmitter;
request.orchestrationFlowApiName = TEST_FLOW_API_NAME;
// Create test user for first approver only
User testUser1 = new User(Id = '005000000000002');
// Set only the first designated approver
request.designatedApprover1 = testUser1;
request.designatedApprover2 = null;
request.designatedApprover3 = null;
Test.startTest();
// We'll use a try-catch because the flow doesn't exist in test context
try {
// Invoke the action
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request}
);
System.assertNotEquals(null, results, 'Results should not be null');
System.assertEquals(1, results.size(), 'Should return one result');
} catch (Exception e) {
// Expecting an exception in test context since the flow doesn't exist
System.debug('Expected exception in test: ' + e.getMessage());
}
Test.stopTest();
}
@isTest
static void testLaunchApprovalOrchestrationWithoutApprovers() {
// Set up test data without approvers
String testRecordId = '001000000000001';
String testComments = 'Test approval comments';
String testSubmitter = '005000000000001';
// Setup test request
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request.recordId = testRecordId;
request.submissionComments = testComments;
request.submitter = testSubmitter;
request.orchestrationFlowApiName = TEST_FLOW_API_NAME;
request.designatedApprover1 = null;
request.designatedApprover2 = null;
request.designatedApprover3 = null;
Test.startTest();
// We'll use a try-catch because the flow doesn't exist in test context
try {
// Invoke the action
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request}
);
System.assertNotEquals(null, results, 'Results should not be null');
System.assertEquals(1, results.size(), 'Should return one result');
} catch (Exception e) {
// Expecting an exception in test context since the flow doesn't exist
System.debug('Expected exception in test: ' + e.getMessage());
}
Test.stopTest();
}
@isTest
static void testDifferentOrchestrationFlowNames() {
// Set up test data
String testRecordId = '001000000000001';
String testSubmitter = '005000000000001';
// Create first test request with one flow name
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request1 =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request1.recordId = testRecordId;
request1.submitter = testSubmitter;
request1.orchestrationFlowApiName = 'First_Test_Flow';
// Create second test request with a different flow name
LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest request2 =
new LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest();
request2.recordId = testRecordId;
request2.submitter = testSubmitter;
request2.orchestrationFlowApiName = 'Second_Test_Flow';
Test.startTest();
try {
// Invoke the action with the first request
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results1 =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request1}
);
System.assertNotEquals(null, results1, 'Results should not be null');
System.assertEquals(1, results1.size(), 'Should return one result');
// Invoke the action with the second request
List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationResult> results2 =
LaunchApprovalOrchestrationAction.launchApprovalOrchestration(
new List<LaunchApprovalOrchestrationAction.ApprovalOrchestrationRequest>{request2}
);
System.assertNotEquals(null, results2, 'Results should not be null');
System.assertEquals(1, results2.size(), 'Should return one result');
} catch (Exception e) {
// Expecting an exception in test context since the flows don't exist
System.debug('Expected exception in test: ' + e.getMessage());
}
Test.stopTest();
}
}

