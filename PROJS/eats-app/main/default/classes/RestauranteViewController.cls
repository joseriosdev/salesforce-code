public with sharing class RestauranteViewController {
    public Restaurante__c Restaurante{get;set;}
    public Id restId {get;set;}
    public String coordinates {get;set;}
    
    public RestauranteViewController() {
        // grab the rest ID from the end of the URL
        this.restId = 
            ApexPages.currentPage().getParameters().get('restId') == null ?
            'a005f000001on3fAAA' :
        	ApexPages.currentPage().getParameters().get('restId');
        System.debug(restId);
        this.Restaurante = new Restaurante__c();
        findRestaurante();
    }
    
    public void findRestaurante() {
        Restaurante__c currentRest =  [SELECT Name,
                                             Tipo__c,
                                             Direccion__c,
                                             Telefono__c,
                                       		 Picture__c,
                                             Descripcion__c,
                                             Coordenadas__Latitude__s,
                                             Coordenadas__Longitude__s
                                        FROM Restaurante__c
                                        WHERE Id = :this.restId];
        
        this.Restaurante = currentRest;
        this.coordinates = currentRest.Coordenadas__Latitude__s + ',' + currentRest.Coordenadas__Longitude__s;
    }
}