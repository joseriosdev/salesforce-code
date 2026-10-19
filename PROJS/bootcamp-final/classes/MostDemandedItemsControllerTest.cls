@istest
public class MostDemandedItemsControllerTest {
    @testSetup
    static void setup(){
        List<Item__c> itemList = new List<Item__c>();
        for(Integer i = 1; i <= 20; i++) {
            Item__c item = new Item__c(Name = 'item ' + i, Price__c = i, Type__c = 'Accessory', Units__c = i);
            if(Math.mod(i, 2) == 0){
                item.From_Wishlist__c = true;
            }
            itemList.add(item);
        }
        insert itemList;
    }
    @istest
    private static void testMostDemandedItems(){
        List<Item__c> itemList = MostDemandedItemsController.findTop10();
        System.assert(itemList.size() == 20);
    }
}