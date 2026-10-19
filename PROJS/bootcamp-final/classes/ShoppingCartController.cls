public with sharing class ShoppingCartController {
    public class ShoppingRow {
        @AuraEnabled public String itemId {get; set;}
        @AuraEnabled public Integer units {get; set;}
    }
    
	@AuraEnabled
    public static Order__c submitOrder(String buyerName, String buyerPhone, String buyerAddress, Decimal totalPrice, List<ShoppingRow> rows) {
        User currentUser = [SELECT ManagerId FROM User WHERE Id = :UserInfo.getUserId()];
        if (currentUser.ManagerId == null) {
            throw new AuraHandledException('You do not have a Sales Rep assigned, please contact with The Application Administrator.');
        }
        
        Order__c order = new Order__c();
        order.Buyer_Name__c = buyerName;
        order.Buyer_Phone__c = buyerPhone;
        order.Buyer_Address__c = buyerAddress;
        order.Total_Price__c = totalPrice;
        insert order;
        
        List<Request__c> requests = new List<Request__c>();
        
        for (ShoppingRow row : rows) {
            Request__c req = new Request__c();
            req.Item__c = row.itemId;
            req.Order__c = order.Id;
            req.Selected_Items_Quantity__c = row.units;
            requests.add(req);
        }
        insert requests;
        
        ShoppingCartController.fireApprovalProcessOrderStatus(order);
        
        return order;
    }
    
    @AuraEnabled
    public static void fireApprovalProcessOrderStatus(Order__c order) {
        Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
        approvalRequest.setComments('Submitting order for approval.');
        approvalRequest.setObjectId(order.Id);
        approvalRequest.setSubmitterId(UserInfo.getUserId());
        approvalRequest.setProcessDefinitionNameOrId('Order_Status_Approval_Process');
        
        Approval.ProcessResult result = Approval.process(approvalRequest);
    }
}