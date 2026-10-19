@isTest
class WishedItemUpdateTriggerTest {

    @isTest
    static void wishedItemApprovedAndCarBrandNotExists() {
        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        wisheditem.Price__c = 100;
        wisheditem.Status__c = 'Requested';
        insert wishedItem;

        // Approval process update Status field to Approved
        wisheditem.Status__c = 'Approved';
        update wishedItem;

        Item__c newItemCreated = [SELECT Name, Price__c, Car_Brand__r.Name, Type__c FROM Item__c LIMIT 1];
        Wished_Item__c wishedItemUpdated = [SELECT Name, Price__c, Car_Brand__c, Type__c, Item__c, Status__c FROM Wished_Item__c LIMIT 1];

        System.assert(isEqual(newItemCreated, wishedItemUpdated));
        System.assert(newItemCreated.Id == wishedItemUpdated.Item__c);
    }

    @isTest
    static void wishedItemApprovedAndCarBrandExists() {
        Car_Brand__c carBrand = TestFactory.createGenericCarBrand();
        insert carBrand;

        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        wishedItem.Price__c = 100;
        wishedItem.Status__c = 'Requested';
        insert wishedItem;

        // Approval process update Status field to Approved
        wishedItem.Status__c = 'Approved';
        update wishedItem;

        Item__c newItemCreated = [SELECT Name, Price__c, Car_Brand__r.Name, Type__c FROM Item__c LIMIT 1];
        Wished_Item__c wishedItemUpdated = [SELECT Name, Price__c, Car_Brand__c, Type__c, Item__c, Status__c FROM Wished_Item__c LIMIT 1];

        System.assert(isEqual(newItemCreated, wishedItemUpdated));
        System.assert(newItemCreated.Id == wishedItemUpdated.Item__c);
    }

    @isTest
    static void wishedItemRejected() {
        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        wisheditem.Price__c = 100;
        wisheditem.Status__c = 'Requested';
        insert wishedItem;

        // Approval process update Status field to Not Approved
        wisheditem.Status__c = 'Not Approved';
        update wishedItem;

        Integer newItemsCount = [SELECT COUNT() FROM Item__c];

        System.assert(newItemsCount == 0);
    }

    @isTest
    static void wishedItemWithItemsApproved() {
        User salesRep = TestFactory.createGenericUser('Sales Rep');
        insert salesRep;

        User buyer1 = TestFactory.createGenericUser('Buyer');
        buyer1.ManagerId = salesRep.Id;
        User buyer2 = TestFactory.createGenericUser('Buyer');
        buyer2.ManagerId = salesRep.Id;
        User buyer3 = TestFactory.createGenericUser('Buyer');
        buyer3.ManagerId = salesRep.Id;
        insert new List<User> { buyer1, buyer2, buyer3 };

        Wished_Item__c wishedItem1 = TestFactory.createGenericWishedItem();
        wishedItem1.Price__c = 100;
        wishedItem1.Status__c = 'Requested';
        wishedItem1.Notify__c = true;
        wishedItem1.OwnerId = buyer1.Id;

        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.OwnerId = buyer2.Id;
        wishedItem2.Notify__c = true;
        Wished_Item__c wishedItem3 = TestFactory.createGenericWishedItem();
        wishedItem3.OwnerId = buyer3.Id;
        wishedItem3.Notify__c = true;
        insert new List<Wished_Item__c> { wishedItem1, wishedItem2, wishedItem3 };

        // Approval process update Status field to Not Approved
        Test.startTest();
        wishedItem1.Status__c = 'Approved';
        update wishedItem1;
        Test.stopTest();

        Item__c newItemCreated = [SELECT Name, Price__c, Car_Brand__r.Name, Type__c FROM Item__c LIMIT 1];
        List<Wished_Item__c> wishedItemsUpdated = [SELECT Name, Price__c, Car_Brand__c, Type__c, Item__c, Status__c FROM Wished_Item__c];

        System.assert(isEqual(newItemCreated, wishedItemsUpdated[0]));
        for (Wished_Item__c wishedItemUpdated : wishedItemsUpdated) {
            System.assert(newItemCreated.Id == wishedItemUpdated.Item__c);
        }
    }

    private static Boolean isEqual(Item__c item, Wished_Item__c wishedItem) {
        return item.Name == wishedItem.Name && item.Price__c == wishedItem.Price__c && item.Car_Brand__r.Name == wishedItem.Car_Brand__c && item.Type__c == wishedItem.Type__c;
    }
}
