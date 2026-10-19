public class TestFactory {
    public static User createGenericUser(String role) {
        return new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            LastName = 'testlastname',
            Email = 'test.carshop@jala-foundation.org',
            UserName = 'test.carshop.' + DateTime.now().getTime() + '@jala-foundation.org',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
          );
    }

    public static Order__c createGenericOrder() {
        return new Order__c(
            Buyer_Address__c = 'Address',
            Buyer_Name__c = 'Name',
            Buyer_Phone__c = 'Phone',
            Status__c = 'Approved',
            Total_Price__c = 100
        );
    }

    public static Item__c createGenericItem() {
        return new Item__c(
            Name = 'Item',
            Price__c = 100,
            Type__c = 'Spare',
            Units__c = 1
        );
    }

    public static Wished_Item__c createGenericWishedItem() { 
        return new Wished_Item__c(
            Car_Brand__c = 'Brand',
            Name = 'Item',
            Manufacturer__c = 'Manufacturer',
            Type__c = 'Spare'
        );
    }

    public static Car_Brand__c createGenericCarBrand() {
        return new Car_Brand__c(Name = 'Brand');
    }

    public static void AssignPermissionSet(String permission, User user) {
        Id permissionId = [SELECT Id, Name FROM PermissionSet WHERE Name = :permission].Id;
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permissionId, AssigneeId = user.Id);
        insert psa; 
    }
}
