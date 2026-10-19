public class MostDemandedItemsController {
     @AuraEnabled
    	public static List<Item__c> findTop10 () {
            List<Item__c> ItemList = [SELECT Name, Car_Brand__r.Name,RequestedTimes__c,Price__c FROM Item__c ORDER BY RequestedTimes__c DESC LIMIT 10];
            List<Item__c> NewStockItemList = [SELECT Name,Car_Brand__r.Name,Price__c,RequestedTimes__c,From_Wishlist__c FROM Item__c WHERE From_Wishlist__c = TRUE ORDER BY CreatedDate DESC LIMIT 10];
            List<Item__c> result = new List<Item__c>();
            result.addAll(ItemList);
            result.addAll(NewStockItemList);
            return result;
      }
}