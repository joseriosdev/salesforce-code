@istest
public class CatalogToCreateControllerTest {
    @testSetup
    static void setup(){
        List<Item__c> itemList = new List<Item__c>();
        for(Integer i = 1; i <= 10; i++) {
            Item__c item = new Item__c(Name = 'item ' + i, Price__c = i, Type__c = 'Accessory', Units__c = i);
            if(Math.mod(i, 2) == 0){
                item.From_Wishlist__c = true;
            }
            itemList.add(item);
        }
        insert itemList;
    }
    @istest
    private static void testCatalogCreator(){
        String catName = 'The Final Catalog';
        List<Item__c> itemList = [SELECT Id FROM Item__c LIMIT 10];
        List<Id> newIdList = new List<Id>();
        for(Integer i=0; i<itemList.size(); i++){
            newIdList.add(itemList[i].Id);
        }
        CatalogToCreateController.createNewCatalog(catName, newIdList);
        Catalog__c latestCatalog = [SELECT Name FROM Catalog__c WHERE Name = :catName];
        System.assert(latestCatalog != NULL);
        List<Item__c> newItemList = [SELECT Name FROM Item__c WHERE Catalog__c = :latestCatalog.Id];
        System.assert(newItemList.size() == 10);
    }
}