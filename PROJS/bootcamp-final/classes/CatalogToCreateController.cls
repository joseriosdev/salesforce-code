public class CatalogToCreateController {
    
    @AuraEnabled
    public static void createNewCatalog(String name, List<Id> itemObj) {
        Catalog__c newCat = new Catalog__c(Name = name);
        insert newCat;
        List<Item__c> itemList = [SELECT Id,Catalog__c FROM Item__c
                                 WHERE Id IN :itemObj];
        for (Integer i=0; i<itemList.size(); i++) {
            itemList[i].Catalog__c = newCat.Id;
        }
        upsert itemList;
    }
}