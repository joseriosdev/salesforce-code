public with sharing class RestauranteFormController {
    public List<SelectOption> items {get;set;}
    public List<String> types {get;set;}
    public Restaurante__c newRest{get;set;}
    public Id restId{get;set;}
    public String createOrEdit {get;set;}
    public String cancelLink {get;set;}
    
    public RestauranteFormController() {
        this.types = new List<String>() {'Comida Rápida', 'Comida Tradicional', 'Postres'};
        this.newRest = new Restaurante__c();
        this.restId = ApexPages.currentPage().getParameters().get('restId');
        
        if (restId != null){
            newRest = [SELECT Name,Direccion__c,Picture__c,Telefono__c,Coordenadas__longitude__s,Coordenadas__latitude__s,Descripcion__c
                        FROM Restaurante__c
                        WHERE Id = :restId ];
            this.createOrEdit = 'Update';
            this.cancelLink = '/apex/RestauranteView?restId='+restId;
        } else {
            this.createOrEdit = 'Create';
            this.cancelLink = '/apex/AdminFiltroRestaurantes';
        }
    }
    
    public PageReference CreateRestaurante() {
        String RestCategory = String.join(types,';');
        System.debug(RestCategory);
        this.newRest.Tipo__c = 	RestCategory;
        this.newRest.Id=restId;
        upsert newRest;
        
        // After successful Save, navigate to the new restaurante view page
        PageReference redirectSuccess = new PageReference('/apex/RestauranteView?restId=' + newRest.Id);
        redirectSuccess.setRedirect(true);
        return (redirectSuccess);   
    }
}