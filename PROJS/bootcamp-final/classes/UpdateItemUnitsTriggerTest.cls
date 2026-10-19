@isTest
private class UpdateItemUnitsTriggerTest {
    
    @testSetup
    static void setup() {
        Item__c item = TestFactory.createGenericItem();
        item.Units__c = 100;
        insert item;
        
        Order__c order = TestFactory.createGenericOrder();
        insert order;
    }
	
    @isTest
    static void checkWhenRequestCreated() {
        Request__c request = new Request__c();
        request.Item__c = [SELECT Id FROM Item__c LIMIT 1].Id;
        request.Order__c = [SELECT Id FROM Order__c LIMIT 1].Id;
        request.Selected_Items_Quantity__c = 5;
        
        Test.startTest();
        insert request;
        Test.stopTest();
        
        Item__c item = [SELECT Units__c FROM Item__c LIMIT 1];
        Boolean condition = request.Selected_Items_Quantity__c + item.Units__c == 100;
        System.assert(condition, 'quantity: ' + request.Selected_Items_Quantity__c + ' | units: ' + item.Units__c);
    }
    
    @isTest
    static void checkWhenOrderUpdatedNotAproved() {
        Order__c order = [SELECT Status__c FROM Order__c LIMIT 1];
        order.Status__c = 'Not Aproved';
        
        Request__c request = new Request__c();
        request.Item__c = [SELECT Id FROM Item__c LIMIT 1].Id;
        request.Order__c = [SELECT Id FROM Order__c LIMIT 1].Id;
        request.Selected_Items_Quantity__c = 5;
        
        Test.startTest();
        insert request;
        update order;
        Test.stopTest();
        
        Item__c item = [SELECT Units__c FROM Item__c LIMIT 1];
        Boolean condition = item.Units__c == 100;
        System.assert(condition);
    }
}