@istest
public class CatalogHistoryControllerTest {
    @testSetup
    static void setup(){
        List<Catalog__c> catalogList = new List<Catalog__c> ();
        for(Integer i = 0; i < 10 ; i++){
            Catalog__c catalog = new Catalog__c(Name = 'Catalog number ' + i);
            catalogList.add(catalog);            
        }
        insert catalogList;
    }
    @istest
    private static void testCatalogHistory(){
        List<Catalog__c> catalogList = CatalogHistoryController.getCatalogs();
        System.assert(catalogList.size() == 10);
    }
}