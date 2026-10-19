trigger UpdateItemUnitsTrigger on Order__c (after insert, after update) {
    System.debug('Tirgger fired');
    List<Item__c> itemsToUpdate = new List<Item__c>();
    List<Request__c> requests = [SELECT Selected_Items_Quantity__c, Item__c
                                 FROM Request__c
                                 WHERE Order__c = :Trigger.New[0].Id];
    System.debug(itemsToUpdate);
    System.debug(Trigger.New[0]);
    System.debug(requests);
    switch on Trigger.New[0].Status__c {
        when 'Pending' {
            System.debug('Pending Status, order ' + Trigger.New[0].Name);
            for (Request__c req : requests) {
                System.debug('insidde for 1');
                Item__c item = [SELECT Units__c FROM Item__c WHERE Id = :req.Item__c];
                item.Units__c -= req.Selected_Items_Quantity__c;
                itemsToUpdate.add(item);
            }
        }	
        when 'Not Approved' {
            System.debug('Not Approved Status, order ' + Trigger.New[0].Name);
            for (Request__c req : requests) {
                System.debug('insidde for 2');
                Item__c item = [SELECT Units__c FROM Item__c WHERE Id = :req.Item__c];
                item.Units__c += req.Selected_Items_Quantity__c;
                itemsToUpdate.add(item);
            }
        }
        when else {
            return;
        }
    }
    System.debug(itemsToUpdate);
    update itemsToUpdate;
}