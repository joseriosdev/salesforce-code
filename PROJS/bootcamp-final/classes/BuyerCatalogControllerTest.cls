@istest
public class BuyerCatalogControllerTest {
    @testSetup
    static void setup(){
        Catalog__c catalog = new Catalog__c(Name = 'Current Catalog');
        insert catalog;
        List<Item__c> itemList = new List<Item__c>();
        for(Integer i = 1; i <= 10; i++) {
            Item__c item = new Item__c(Name = 'item ' + i, Price__c = i, Type__c = 'Accessory', Units__c = i, Catalog__c = catalog.Id);
            itemList.add(item);
        }
        insert itemList;
    }
    @istest
    private static void checkCatalog(){
        List<Item__c> itemList = BuyerCatalogController.findCatalogItems();
        System.assert(itemList.size() == 10);
        Catalog__c latestCatalog = BuyerCatalogController.latestCatalog();
        System.assert(itemList[Integer.valueOf(Math.random() * 10)].Catalog__c == latestCatalog.Id);
    }
}