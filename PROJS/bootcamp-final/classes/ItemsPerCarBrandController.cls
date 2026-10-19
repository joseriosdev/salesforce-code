public with sharing class ItemsPerCarBrandController {

    public class DataTable {
        @AuraEnabled public List<Item__c> data { get; set; }
        @AuraEnabled public Integer count { get; set; }

        public DataTable(List<Item__c> data, Integer count) {
            this.data = data;
            this.count = count;
        }
    }

    @AuraEnabled
    public static DataTable getItems(String carBrand, Integer lim, Integer off) {
        List<Item__c> items = [
            SELECT Name, Car_Brand__c, Price__c, Units__c, Type__c
            FROM Item__c 
            WHERE Car_Brand__r.Name = :carBrand
            LIMIT :lim
            OFFSET :off
        ];

        Integer count = [SELECT COUNT() FROM Item__c WHERE Car_Brand__r.Name = :carbrand];

        return new DataTable(items, count);
    }

    public class ComboBoxItem {
        @AuraEnabled public String label { get; set; }
        @AuraEnabled public String value { get; set; }

        public ComboBoxItem(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    @AuraEnabled
    public static List<ComboBoxItem> getOptions(){
        List<Car_Brand__c> carbrands = [SELECT Name FROM Car_Brand__c];

        List<ComboBoxItem> brands = new List<ComboBoxItem>();
        for(Car_Brand__c c : carbrands) {
            brands.add(new ComboBoxItem(c.Name, c.Name));
        }

        return brands;
    }
}
