public with sharing class PlatoFormController {
    public String platoNombre {get;set;}
    public Integer platoPrecio {get;set;}
    public String platoDesc {get;set;}
    public Boolean platoDisp {get;set;}
    public String platoImg {get;set;}
    
    public Id restID{get;set;}
    public Id platoID{get;set;}
    
    public List<String> types {get;set;}
    public Plato__c newPlato{get;set;}
    public String createOrEdit {get;set;}
    public String cancelLink {get;set;}
    
    
    public PlatoFormController(){
        this.platoNombre = '';
        this.platoPrecio = 0;
        this.platoDesc = '';
        this.platoImg = '';
        this.platoDisp = false;
        this.types = new List<String>() {'Comida Rápida', 'Comida Tradicional', 'Postres'};
        this.newPlato = new Plato__c();
        this.restId = ApexPages.currentPage().getParameters().get('restId');
        this.platoId = ApexPages.currentPage().getParameters().get('platoId');
        
        if (platoId != null) {
            newPlato = [SELECT Name,Precio__c,Picture__c,Descripcion__c FROM Plato__c WHERE Id = :platoId ];
            this.createOrEdit = 'Update';
            this.cancelLink = '/apex/RestauranteView?restId='+restId;
        } else {
            this.createOrEdit = 'Create';
            this.cancelLink = '/apex/AdminFiltroRestaurantes';
        }
    }
    public PageReference CreatePlato() {
        String platoCategory = String.join(types,';');
        this.newPlato.Tipo__c = platoCategory;
        this.newPlato.Disponibilidad__c = platoDisp;
        
        //Write lookup field only if creating a new Plato
        if (platoId == null){
            this.newPlato.Restaurante__c = restId;
        }
        this.newPlato.Id=platoId;
        
        upsert newPlato;
        
        PageReference redirectSuccess = new PageReference('/apex/DuenoTabs?restId=' + this.restId);
        redirectSuccess.setRedirect(true);
        return (redirectSuccess);
    }
}