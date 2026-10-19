public with sharing class ItemPickerController {
    public class ItemWrapper {
        @AuraEnabled public String CarBrand { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String ItemId { get; set; }
        @AuraEnabled public String Type { get; set; }
        @AuraEnabled public Decimal Units { get; set; }
        @AuraEnabled public Decimal Price { get; set; }
        @AuraEnabled public Integer Quantity { get; set; }
        
        public ItemWrapper(String carBrand, String name, String type, Decimal units, Decimal price, String itemId, Integer quantity) {
            this.ItemId = itemId;
            this.CarBrand = CarBrand;
            this.Name = name;
            this.Type = type;
            this.Units = units;
            this.Price = price;
            this.Quantity = quantity;
        }
    }

    public class DataTable {
        @AuraEnabled public List<ItemWrapper> data { get; set; }
        @AuraEnabled public Integer count { get; set; }

        public DataTable(List<Item__c> data, Integer count) {
            this.data = new List<ItemWrapper>();
            for (Item__c item : data) {
                this.data.add(new ItemWrapper(item.Car_Brand__r.Name, item.Name, item.Type__c, item.Units__c, item.Price__c, item.Id, 0));
            }
            this.count = count;
        }
    }
    
	@AuraEnabled
    public static DataTable fetchItems(Integer queryLim, Integer queryOff, String inputType, String inputSearch) {
        List<Item__c> items = new List<Item__c>();
        Integer count = 0;
        
        // Search when an item type is selected
        if(inputSearch == '' && inputType != '') {
            items = [
                SELECT Id,Name,Price__c,Units__c,Type__c,Car_Brand__r.Name
                FROM Item__c
                WHERE Type__c = :inputType
                AND Units__c > 0
                ORDER BY Name
                LIMIT :queryLim
                OFFSET :queryOff
            ];
            count = [
                SELECT count()
                FROM Item__c
                WHERE Type__c = :inputType
                AND Units__c > 0
            ];
        }
        // Search when item name AND item type are filled
        else if(inputSearch != '' && inputType != '') {
            inputSearch = '%' + inputSearch + '%';
            
            items = [
                SELECT Id,Name,Price__c,Units__c,Type__c,Car_Brand__r.Name
                FROM Item__c
                WHERE Name LIKE :inputSearch
                AND Type__c = :inputType
                AND Units__c > 0
                LIMIT :queryLim
                OFFSET :queryOff
            ];
            count = [
                SELECT count()
                FROM Item__c
                WHERE Name LIKE :inputSearch
                AND Type__c = :inputType
                AND Units__c > 0
            ];
        }
        // Search when name OR type are filled
        else {
            inputSearch = '%' + inputSearch + '%';
            
            items = [
                SELECT Id,Name,Price__c,Units__c,Type__c,Car_Brand__r.Name
                FROM Item__c
                WHERE (Name LIKE :inputSearch
                      AND Units__c > 0)
                OR Type__c = :inputType
                LIMIT :queryLim
                OFFSET :queryOff
            ];
            count = [
                SELECT count()
                FROM Item__c
                WHERE (Name LIKE :inputSearch
                      AND Units__c > 0)
                OR Type__c = :inputType
            ];
        }
        return new DataTable(items, count);
    }
}