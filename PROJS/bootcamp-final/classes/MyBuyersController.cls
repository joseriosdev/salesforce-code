public with sharing class MyBuyersController {
    
	@AuraEnabled
    public static List<User> getMyBuyers() {
        List<User> buyers = [SELECT FirstName,LastName,Alias
                             FROM User
                             WHERE ManagerId = :UserInfo.getUserId()];
        return buyers;
    }
}