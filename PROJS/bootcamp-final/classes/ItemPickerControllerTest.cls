@isTest
private class ItemPickerControllerTest {
	@testSetup
    static void setup() {
        List<Item__c> items = new List<Item__c>();
        
        for(Integer i = 1; i <= 50; i++) {
            Item__c item = new Item__c();
            item.Name = 'Test Sample ' + i;
            item.Price__c = i * 10;
            item.Units__c = i * 12;
            
            if(Math.mod(i, 2) == 0)
                item.Type__c = 'Spare';
            else
                item.Type__c = 'Accessory';
            
            items.add(item);
        }
        insert items;
    }
    
    @isTest
    static void fetchItemsTest() {
        ItemPickerController.DataTable testIf = ItemPickerController.fetchItems(10, 0, 'Spare', '');
        System.assert(testIf.data.size() == 10);
        System.assertEquals('Spare', testIf.data[0].Type);
        
        ItemPickerController.DataTable testElseIf = ItemPickerController.fetchItems(5, 0, 'Accessory', 'Test Sample 7');
        System.assert(testElseIf.count == 1);
        System.assertEquals('Accessory', testElseIf.data[0].Type);
        System.assertEquals('Test Sample 7', testElseIf.data[0].Name);
        
        ItemPickerController.DataTable testElseIf2 = ItemPickerController.fetchItems(50, 0, 'Spare', 'Test Sample');
        System.assert(testElseIf2.data.size() == 25);
        System.assertEquals('Spare', testElseIf2.data[0].Type);
        System.assertEquals('Spare', testElseIf2.data[testElseIf2.data.size() - 1].Type);
        
        ItemPickerController.DataTable testElse = ItemPickerController.fetchItems(20, 0, '', 'Test Sample');
        System.assert(testElse.count == 50);
        System.assert(testElse.data.size() == 20);
        System.assertEquals('Test Sample 1', testElse.data[0].Name);
    }
}