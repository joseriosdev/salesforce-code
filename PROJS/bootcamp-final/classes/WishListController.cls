public with sharing class WishListController {

    public class ItemWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String CarBrand { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Manufacturer { get; set; }
        @AuraEnabled public String Status { get; set; }
        @AuraEnabled public Integer TimesRequested { get; set; }

        public ItemWrapper(String id, String carBrand, String name, String manufacturer, String Status) {
            this.Id = id;
            this.CarBrand = CarBrand;
            this.Name = name;
            this.Manufacturer = manufacturer;
            this.Status = Status;
            this.TimesRequested = 1;
        }

        public Boolean isEqual(ItemWrapper other) {
            return Carbrand == other.CarBrand && Name == other.Name && Manufacturer == other.Manufacturer;
        }
    }

    @AuraEnabled
    public static List<ItemWrapper> getWishedItems() {
        String managerId = UserInfo.getUserId();
        List<User> buyers = [SELECT ManagerId FROM User WHERE ManagerId = :managerId];
        if (buyers.isEmpty()) {
            throw new AuraHandledException('You do not have Buyers.');
        }
        
        Map<Id,User> buyersMap = new Map<Id,User>(buyers);
        Set<Id> buyersId = buyersMap.keySet();
        List<Wished_Item__c> wishedItems = [
            SELECT Name, Car_Brand__c, Manufacturer__c, Status__c, Item__c, OwnerId
            FROM Wished_Item__c
            WHERE OwnerId in :buyersId AND Item__c = ''
        ];
        if (wishedItems.isEmpty()) {
            throw new AuraHandledException('There are no wished items.');
        }
        
        List<ItemWrapper> items = new List<ItemWrapper>();
        for (Wished_Item__c wishedItem : wishedItems) {
            ItemWrapper newItem = new ItemWrapper(wishedItem.Id, wishedItem.Car_Brand__c, wishedItem.Name, wishedItem.Manufacturer__c, wishedItem.Status__c);

            Boolean found = false;
            for (ItemWrapper item : items) {
                if (item.isEqual(newItem)) {
                    found = true;
                    item.TimesRequested++;
                }
            }

            if (!found) {
                items.add(newItem);
            }
        }

        return items;
    }

    @AuraEnabled
    public static void sendApprovalRequest(String wishedItemId) {
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT ManagerId FROM User WHERE Id = :currentUserId];
        if (currentUser.ManagerId == null) {
            throw new AuraHandledException('You do not have a manager assigned, please contact with Application Administrator.');
        }

        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(wishedItemId);
        request.setSubmitterId(UserInfo.getUserId());
        request.setProcessDefinitionNameOrId('Convert_Wished_Item_Process');

        Approval.process(request);
    }
}
