@isTest
class WishListControllerTest {

    @isTest
    static void getWishedItemsByManagerId() {
        User buyer1 = TestFactory.createGenericUser('Buyer');
        buyer1.ManagerId = UserInfo.getUserId();
        insert buyer1;
        User buyer2 = TestFactory.createGenericUser('Buyer');
        buyer2.ManagerId = UserInfo.getUserId();
        insert buyer2;

        Wished_Item__c wishedItem1 = TestFactory.createGenericWishedItem();
        wishedItem1.Name = 'Item 1';
        wishedItem1.OwnerId = buyer1.Id;
        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.Name = 'Item 2';
        wishedItem2.OwnerId = buyer1.Id;
        Wished_Item__c wishedItem3 = TestFactory.createGenericWishedItem();
        wishedItem3.Name = 'Item 1';
        wishedItem3.OwnerId = buyer2.Id;

        List<Wished_Item__c> wishedItems = new List<Wished_Item__c> { wishedItem1, wishedItem2, wishedItem3 };
        insert wishedItems;

        List<WishListController.ItemWrapper> items = WishListController.getWishedItems();
        
        System.assert(items.size() == 2, 'size should be: 2, not ' + items.size());
        System.assert(items[0].TimesRequested == 2, 'times_requested should be 2, not ' + items[0].TimesRequested);
        System.assert(items[1].TimesRequested == 1, 'times_requested should be 1, not ' + items[1].TimesRequested);
    }

    @isTest
    static void getWishedItemsNoBuyersException() {
        User buyer1 = TestFactory.createGenericUser('Buyer');
        insert buyer1;
        User buyer2 = TestFactory.createGenericUser('Buyer');
        insert buyer2;

        Wished_Item__c wishedItem1 = TestFactory.createGenericWishedItem();
        wishedItem1.Name = 'Item 1';
        wishedItem1.OwnerId = buyer1.Id;
        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.Name = 'Item 2';
        wishedItem2.OwnerId = buyer1.Id;
        Wished_Item__c wishedItem3 = TestFactory.createGenericWishedItem();
        wishedItem3.Name = 'Item 1';
        wishedItem3.OwnerId = buyer2.Id;

        Boolean result = false;
        try {
            List<WishListController.ItemWrapper> items = WishListController.getWishedItems();
        } catch(Exception e) {
            result = true;
        }

        System.assert(result);
    }

    @isTest
    static void getWishedItemsEmptyException() {
        User buyer1 = TestFactory.createGenericUser('Buyer');
        buyer1.ManagerId = UserInfo.getUserId();
        insert buyer1;
        User buyer2 = TestFactory.createGenericUser('Buyer');
        buyer2.ManagerId = UserInfo.getUserId();
        insert buyer2;
        
        Boolean result = false;
        try {
            List<WishListController.ItemWrapper> items = WishListController.getWishedItems();
        } catch(Exception e) {
            result = true;
        }

        System.assert(result);
    }    

    @isTest
    static void createApprovalRequestWishedItem() {
        User salesManager = TestFactory.createGenericUser('Sales Manager');
        insert salesManager;
        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User salesRep = TestFactory.createGenericUser('Sales Rep');
        salesRep.ProfileId = adminId;
        salesRep.ManagerId = salesManager.Id;
        insert salesRep;
        
        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        wishedItem.Price__c = 10;
        wishedItem.Type__c = 'Spare';
        insert wishedItem;

        System.runAs(salesRep) {
            WishListController.sendApprovalRequest(wishedItem.Id);
        }

        List<ProcessInstance> processes = [SELECT pi.TargetObjectId, pi.Status FROM ProcessInstance pi WHERE TargetObjectId = :wishedItem.Id];
        System.assert(processes.size() == 1);

        ProcessInstance approvalProcess = processes[0];
        System.assert(approvalProcess.Status == 'Pending');

        Wished_Item__c wishedItemUpdated = [SELECT Status__c FROM Wished_Item__c LIMIT 1];
        System.assert(wishedItemUpdated.Status__c == 'Requested');
    }

    @isTest
    static void createApprovalRequestWishedItemSalesManagerNotAssigned() { 
        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        wishedItem.Price__c = 10;
        wishedItem.Type__c = 'Spare';
        insert wishedItem;

        Id adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        User salesRep = TestFactory.createGenericUser('Sales Rep');
        salesRep.ProfileId = adminId;
        insert salesRep;

        System.runAs(salesRep) {
            Boolean failed = false;
            try {
                WishListController.sendApprovalRequest(wishedItem.Id);
            } catch (Exception e) {
                failed = true;
            }

            System.assert(failed);
        }
    }
}