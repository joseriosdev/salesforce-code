@isTest
private class MyBuyersControllerTest {
	
    @isTest
    static void getMyBuyersTest() {
        User salesRep = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Sales Rep'].Id,
            LastName = 'Sales Rep',
            Email = 'salesrep.carshop@jala-foundation.org',
            UserName = 'salesrep.carshop.' + DateTime.now().getTime() + '@jala-foundation.org',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert salesRep;
        
        User buyer = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Carshop Buyer'].Id,
            LastName = 'Buyer',
            ManagerId = salesRep.Id,
            Email = 'buyer.carshop@jala-foundation.org',
            UserName = 'buyer.carshop.' + DateTime.now().getTime() + '@jala-foundation.org',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert buyer;
        
        System.runAs(salesRep) {
            List<User> myBuyers = MyBuyersController.getMyBuyers();
            System.assertEquals(buyer.Id, myBuyers[0].Id);
        }
    }
}