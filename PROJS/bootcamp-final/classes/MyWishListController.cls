public class MyWishListController {
    @AuraEnabled
    	public static List<Wished_Item__c> findWishItems () {
            
            id userID = UserInfo.getUserId();
            //system.debug('userID' + userID);
            List<Wished_Item__c> WishedItemList = [SELECT Name, Car_Brand__c,Manufacturer__c,Status__c FROM Wished_Item__c WHERE CreatedById = :userID];
            return WishedItemList;
		}
}