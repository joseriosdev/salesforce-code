@isTest
class ItemsPerBrandControllerTest {
    @isTest
    static void getOptionsTest() {
        Car_Brand__c carbrand = TestFactory.createGenericCarBrand();
        insert carbrand;

        List<ItemsPerCarBrandController.ComboBoxItem> carbrands = ItemsPerCarBrandController.getOptions();

        Integer expected = 1;
        Integer actual = carbrands.size();

        System.assert(expected == actual);
    }

    @isTest
    static void getItemsTest() {
        Car_Brand__c carbrand = TestFactory.createGenericCarBrand();
        insert carbrand;

        List<Item__c> items = new List<Item__c>();

        Integer count = 3;
        for (Integer i = 0; i < count; i++) {
            Item__c item = TestFactory.createGenericItem();
            item.Car_Brand__c = carbrand.Id;
            items.add(item);
        }
        insert items;

        ItemsPerCarBrandController.DataTable newItems = ItemsPerCarBrandController.getItems(carbrand.Name, 10, 0);

        System.assert(count == newItems.count);
        System.assert(carbrand.Id == newItems.data[0].Car_Brand__c);
    }
}
