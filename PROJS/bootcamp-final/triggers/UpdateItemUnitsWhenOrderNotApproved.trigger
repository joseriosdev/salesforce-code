trigger UpdateItemUnitsWhenOrderNotApproved on Order__c (after update) {
    List<Item__c> items = new List<Item__c>();
    
    for (Order__c order : Trigger.New) {
        if (order.Status__c == 'Not Aproved') {
            List<Request__c> requests = [SELECT Selected_Items_Quantity__c, Item__c
                                         FROM Request__c
                                         WHERE Order__c = :order.Id];
            for (Request__c req : requests) {
                Item__c item = [SELECT Units__c FROM Item__c WHERE Id = :req.Item__c];
                item.Units__c += req.Selected_Items_Quantity__c;
                items.add(item);
            }
        }
    }
    
    update items;
}