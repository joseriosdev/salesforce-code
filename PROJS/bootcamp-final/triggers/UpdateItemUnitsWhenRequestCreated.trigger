trigger UpdateItemUnitsWhenRequestCreated on Request__c (after insert) {
	List<Item__c> items = new List<Item__c>();
    for (Request__c request : Trigger.New) {
        Item__c item = [SELECT Units__c FROM Item__c WHERE Id = :request.Item__c];
        item.Units__c -= request.Selected_Items_Quantity__c;
        items.add(item);
    }
    update items;
}