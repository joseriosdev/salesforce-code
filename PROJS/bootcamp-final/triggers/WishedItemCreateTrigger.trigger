trigger WishedItemCreateTrigger on Wished_Item__c (before insert) {
    Set<String> nameSet = new Set<String>();
    for (Wished_Item__c wishedItem : Trigger.New) {
        nameSet.add(wishedItem.Name);
    }

    List<Item__c> currentItems = [SELECT Name, Car_Brand__r.Name FROM Item__c WHERE Name in :nameSet];
    for (Item__c currentItem : currentItems) {
        for (Wished_Item__c wishedItem : Trigger.New) {
            Boolean isEqual = 
                currentItem.Name.toLowerCase() == wishedItem.Name.toLowerCase() &&
                currentItem.Car_Brand__r.Name.toLowerCase() == wishedItem.Car_Brand__c.toLowerCase();

            if (isEqual) {
                wishedItem.addError('Wished Item already exists in stock.');
            }
        }
    }

    List<Wished_Item__c> currentWishedItems = [SELECT Name, Car_Brand__c, Manufacturer__c, OwnerId FROM Wished_Item__c WHERE Name in :nameSet];
    for (Wished_Item__c currentWishedItem : currentWishedItems) {
        for (Wished_Item__c newWishedItem : Trigger.New) {
            Boolean isEqual = 
                currentWishedItem.Name.toLowerCase() == newWishedItem.Name.toLowerCase() &&
                currentWishedItem.Manufacturer__c.toLowerCase() == newWishedItem.Manufacturer__c.toLowerCase() &&
                currentWishedItem.Car_Brand__c.toLowerCase() == newWishedItem.Car_Brand__c.toLowerCase() &&
                currentWishedItem.OwnerId == UserInfo.getUserId();

            if (isEqual) {
                newWishedItem.addError('Wished Item already exists in wish list.');
            }

            System.debug('new: ' + newWishedItem);
        }
    }


    System.debug('Nameset: ' + nameSet);
    System.debug('Trigger Wished items: ' + Trigger.New);
    System.debug('All Wished items: ' + [SELECT Name, Car_Brand__c, Manufacturer__c FROM Wished_Item__c]);
    System.debug('Wished items: ' + currentWishedItems);
}
