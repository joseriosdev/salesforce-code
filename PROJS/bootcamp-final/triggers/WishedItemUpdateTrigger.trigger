trigger WishedItemUpdateTrigger on Wished_Item__c (before update) {
    Boolean isApprovalProcess = Trigger.New.size() == 1 && Trigger.Old.size() == 1;
    Boolean isApproved = Trigger.New[0].Status__c == 'Approved' && Trigger.Old[0].Status__c == 'Requested';

    if (isApprovalProcess && isApproved) {
        Wished_Item__c wishedItem = Trigger.New[0];
        
        Car_Brand__c carBrand;
        Boolean carBrandExists = [SELECT COUNT() FROM Car_Brand__c WHERE Name = :wishedItem.Car_Brand__c] == 1;
        if (!carbrandExists) {
            carBrand = new Car_Brand__c(Name = wishedItem.Car_Brand__c);
            insert carBrand;
        } else {
            carBrand = [SELECT Name FROM Car_Brand__c WHERE Name = :wishedItem.Car_Brand__c LIMIT 1];
        }

        Item__c newItem = new Item__c(
            Name = wisheditem.Name,
            Car_Brand__c = carBrand.Id,
            Price__c = wishedItem.Price__c,
            Type__c = wishedItem.Type__c,
            Units__c = 100,
            From_Wishlist__c = true
        );
        insert newItem;

        if (checkWishedItems(wishedItem)) {
            List<Wished_Item__c> similarWishedItems = getSimilar(wishedItem);

            for (Wished_Item__c similarWishedItem : similarWishedItems) {
                similarWishedItem.Item__c = newItem.Id;
            }

            update similarWishedItems;
        }

        wishedItem.Item__c = newItem.Id;

        notifyToSalesRepByEmail(newItem, wishedItem);

        if (wishedItem.Notify__c) {
            notifyToBuyersByEmail(newItem, wishedItem);
        }
    }

    private static void notifyToSalesRepByEmail(Item__c newItem, Wished_Item__c wishedItem) {
        String body = NotifyUtils.NewItemBodyForSalesReps(newItem.Id);
        String subject = 'New Item Available';
        Id sender = getSalesManagerSender();
        Set<Id> receivers = getReceivers(wishedItem);
        NotifyUtils.sendEmailAsync(sender, receivers, subject, body);
    }

    private static void notifyToBuyersByEmail(Item__c newItem, Wished_Item__c wishedItem) {
        String body = NotifyUtils.NewItemBodyForBuyers(newItem.Id);
        String subject = 'New Item Available';
        Id sender = getSalesRepSender(wishedItem);
        Set<Id> receivers = getReceivers(wishedItem);
        NotifyUtils.sendEmailAsync(sender, receivers, subject, body);
    }

    private static List<Wished_Item__c> getSimilar(Wished_Item__c wishedItem) {
        return [
            SELECT Name, Car_Brand__c, Manufacturer__c FROM Wished_Item__c 
            WHERE Name = :wishedItem.Name AND Car_Brand__c = :wishedItem.Car_Brand__c
            AND Manufacturer__c = :wishedItem.Manufacturer__c AND Id != :wishedItem.Id
        ];
    }

    private static Boolean checkWishedItems(Wished_Item__c wishedItem) {
        return [
            SELECT COUNT() FROM Wished_Item__c 
            WHERE Name = :wishedItem.Name AND Car_Brand__c = :wishedItem.Car_Brand__c
            AND Manufacturer__c = :wishedItem.Manufacturer__c AND Id != :wishedItem.Id
        ] > 0;
    }

    private static Set<Id> getSalesReps() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Sales Rep'].Id;
        List<User> salesReps = [SELECT Id FROM User WHERE ProfileId = :profileId];
        Map<Id, User> salesRepsMap = new Map<Id, User>(salesReps);
        return salesRepsMap.keySet();
    }

    private static Id getSalesManagerSender() {
        return UserInfo.getUserId();
    }

    private static Id getSalesRepSender(Wished_Item__c wishedItem) {
        User sender = [SELECT ManagerId FROM User WHERE Id = :wishedItem.OwnerId];
        return sender.ManagerId;
    }

    private static Set<Id> getReceivers(Wished_Item__c wishedItem) {
        List<Wished_Item__c> wishedItems = [
            SELECT OwnerId FROM Wished_Item__c 
            WHERE Name = :wishedItem.Name AND Car_Brand__c = :wishedItem.Car_Brand__c
            AND Manufacturer__c = :wishedItem.Manufacturer__c
        ];
        Set<Id> owners = new Set<Id>();
        for (Wished_Item__c item : wishedItems) {
            owners.add(item.OwnerId);
        }
        return owners;
    }
}