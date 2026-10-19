public class BuyerCatalogController {
    @AuraEnabled
    	public static List<Item__c> findCatalogItems () {
            Id catId = latestCatalog().Id;
            List<Item__c> ItemList = [SELECT Name, Car_Brand__r.Name,Price__c,Catalog__c FROM Item__c WHERE Catalog__c = :catId LIMIT 10];
            System.debug(ItemList);
            return ItemList;
		}
    @AuraEnabled
    public static Catalog__c latestCatalog(){
        Catalog__c catalog = [SELECT Name,Id FROM Catalog__c
                                       ORDER BY CreatedDate DESC LIMIT 1];
        return catalog;
    }

}