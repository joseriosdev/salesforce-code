@isTest
private class MyWishListControllerTest {
    @testSetup
    static void setup(){
        List<Wished_Item__c> wishlist = new List<Wished_Item__c>();
        for(Integer i = 1; i <= 50; i++) {
            Wished_Item__c wishedItem = new Wished_Item__c(Name = 'item ' + i, Car_brand__c = 'Brand ' + i, Manufacturer__c = 'China ' + i);
            wishlist.add(wishedItem);
			
        }
        insert wishlist;
    }
    @istest
    static void checkWishList(){
        List<Wished_Item__c> wishlistTest = MyWishListController.findWishItems();
        System.assert(wishlistTest.size() == 50);
    }
}