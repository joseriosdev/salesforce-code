public class CatalogHistoryController {
    
    @AuraEnabled
    public static List<Catalog__c> getCatalogs () {
        List<Catalog__c> catList = [SELECT Name, CreatedDate 
                                    FROM Catalog__c
                                    ORDER BY CreatedDate DESC
                                    LIMIT 10];
        return catList;
    }
}