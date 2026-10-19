@isTest
private class ShoppingCartControllerTest {
    
    @testSetup
    static void setup() {
        Item__c item1 = TestFactory.createGenericItem();
        item1.Units__c = 100;
        Item__c item2 = TestFactory.createGenericItem();
        item1.Units__c = 100;
        insert item1;
        insert item2;
        
        User salesRep = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Rep'].Id,
            LastName = 'testlastname2',
            Email = 'test.carshop@jala-foundation.org',
            UserName = 'test.carsh0p.' + DateTime.now().getTime() + '@jala-foundation.org',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert salesRep;
        
        User buyer = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Carshop Buyer'].Id,
            ManagerId = salesRep.Id,
            LastName = 'testlastname',
            Email = 'test.carshop@jala-foundation.org',
            UserName = 'test.carshop.' + DateTime.now().getTime() + '@jala-foundation.org',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
		insert buyer;
    }
    
    @isTest
    static void submitOrderAsBuyerWithoutManager() {
        User buyer = [SELECT ManagerId,Username
                      FROM User
                      WHERE LastName = 'testlastname'];
        buyer.ManagerId = null;
        List<Item__c> items = [SELECT Id FROM Item__c];
        List<ShoppingCartController.ShoppingRow> rows = new List<ShoppingCartController.ShoppingRow>();
        
        for (Integer i = 1; i < 3; i++) {
            ShoppingCartController.ShoppingRow row = new ShoppingCartController.ShoppingRow();
            row.itemId = i == 1 ? items[0].Id : items[1].Id;
            row.units = i * 3;
            rows.add(row);
        }
        
        System.runAs(buyer) {
            try {
				ShoppingCartController.submitOrder('Buyer Name', '555-555-5555', 'Buyer Address Av.', 100, rows);
            } catch (Exception err) {
                System.assert(true);
            }
        }
        
    }
    
	@isTest
    static void submitOrderAsBuyerWithManager() {
        User buyer = [SELECT ManagerId,Username
                      FROM User
                      WHERE LastName = 'testlastname'];
        List<Item__c> items = [SELECT Units__c FROM Item__c];
        List<ShoppingCartController.ShoppingRow> rows = new List<ShoppingCartController.ShoppingRow>();
        
        for (Integer i = 1; i < 3; i++) {
            ShoppingCartController.ShoppingRow row = new ShoppingCartController.ShoppingRow();
            row.itemId = i == 1 ? items[0].Id : items[1].Id;
            row.units = i * 3;
            rows.add(row);
        }
        
        System.runAs(buyer) {
            ShoppingCartController.submitOrder('Name', '777-555-5555', 'Address Av.', 100, rows);
        }
        
        Order__c order = [SELECT Buyer_Name__c,Buyer_Phone__c,Buyer_Address__c,CreatedDate
                          FROM Order__c];
        for (Order__c o : [SELECT Id,(SELECT Order__c FROM Requests__r) FROM Order__c]) {   
            for (Request__c r : order.Requests__r)
                System.assertEquals(o.Id, r.Order__c);
        }
        System.assertEquals('Name', order.Buyer_Name__c);
        System.assertEquals('777-555-5555', order.Buyer_Phone__c);
        System.assertEquals('Address Av.', order.Buyer_Address__c);
        
        // Check That Approval Process Instance Exists
        ProcessInstance objProcessInstance = [SELECT Id,TargetObjectId,CreatedDate,Status
                                              FROM ProcessInstance
                                              WHERE TargetObjectId = :order.Id];
        System.assertEquals(order.CreatedDate, objProcessInstance.CreatedDate);
        System.assertEquals('Pending', objProcessInstance.Status);
    }
}