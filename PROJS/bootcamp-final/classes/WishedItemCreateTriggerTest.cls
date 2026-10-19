@isTest
class WishedItemCreateTriggerTest {

    @isTest 
    static void testCreateNewItemDoesNotExistsInStock() {
        Wished_Item__c wishedItem1 = TestFactory.createGenericWishedItem();
        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.Name = 'Item2';

        List<Wished_Item__c> wishedItems = new List<Wished_Item__c> { wishedItem1, wishedItem2 };

        Test.startTest();
        List<Database.SaveResult> saveResults = Database.insert(wishedItems);
        Test.stopTest();

        for (Database.SaveResult result : saveResults) {
            System.assert(result.isSuccess());
        }
        
        List<Wished_Item__c> wishedItemsAdded = [SELECT Name FROM Wished_Item__c];
        System.assert(wishedItemsAdded.size() == 2);
    }

    @isTest 
    static void testCreateNewItemAlreadyExistsInStock() {
        Car_Brand__c carbrand = TestFactory.createGenericCarBrand();
        insert carbrand;

        Item__c item = TestFactory.createGenericItem();
        item.Car_Brand__c = carbrand.Id;
        insert item;

        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.Name = 'Item3';

        List<Wished_Item__c> wishedItems = new List<Wished_Item__c> { wishedItem, wishedItem2 };

        Test.startTest();
        List<Database.SaveResult> saveResults = Database.insert(wishedItems, false);
        Test.stopTest();

        System.assert(!saveResults[0].isSuccess());
        System.assert(saveResults[1].isSuccess());
        
        List<Wished_Item__c> wishedItemsAdded = [SELECT Name FROM Wished_Item__c];

        System.assert(wishedItemsAdded.size() == 1);
    }

    @isTest 
    static void testCreateNewItemAlreadyExistsInWishList() {
        Wished_Item__c wishedItem = TestFactory.createGenericWishedItem();
        insert wishedItem;
        
        Wished_Item__c wishedItem1 = TestFactory.createGenericWishedItem();
        Wished_Item__c wishedItem2 = TestFactory.createGenericWishedItem();
        wishedItem2.Name = 'Item1';

        List<Wished_Item__c> wishedItems = new List<Wished_Item__c> { wishedItem1, wishedItem2 };

        Test.startTest();
        List<Database.SaveResult> saveResults = Database.insert(wishedItems, false);
        Test.stopTest();

        System.assert(!saveResults[0].isSuccess());
        System.assert(saveResults[1].isSuccess());
        
        List<Wished_Item__c> wishedItemsAdded = [SELECT Name FROM Wished_Item__c];
        System.assert(wishedItemsAdded.size() == 2);
    }
}
