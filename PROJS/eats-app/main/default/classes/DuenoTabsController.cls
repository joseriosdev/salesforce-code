public with sharing class DuenoTabsController {
    public String restId {get; set;}
    public Restaurante__c defaultRestaurant {get; set;}
    public List<Plato__c> defaultDishList {get; set;}
    public String selectDishId {get; set;}
    public String deleteDishName {get; set;}
    public String inputDishName {get; set;}
    
    public Boolean displayModal {get; set;}
    
    // Constructor
    public DuenoTabsController() {
        this.restId = 
            ApexPages.currentPage().getParameters().get('restId') == null ?
            'a005f000001on3fAAA' :
        	ApexPages.currentPage().getParameters().get('restId');
        
        this.defaultRestaurant = [SELECT Id,Name,Direccion__c,Telefono__c,Tipo__c,Picture__c,Descripcion__c FROM Restaurante__c WHERE Id=:this.restId LIMIT 1];
        getDefaultDishList();
        
        this.displayModal = false;
    }
    
    // Methods
    public void toggleModal() {
        this.selectDishId = ApexPages.currentPage().getParameters().get('delete-dish-id');
        this.displayModal = !this.displayModal;
    }
    
    public void deleteDish() {
        delete new Plato__c(Id=this.selectDishId);
        toggleModal();
        getDefaultDishList();
    }
    
    public void getDefaultDishList() {
        this.defaultDishList = [SELECT Id,Name,Descripcion__c,Disponibilidad__c,Tipo__c,Picture__c,Precio__c FROM Plato__c WHERE Restaurante__r.Id = :this.restId];
    }
    
    public PageReference editDishRedirect() {
        this.selectDishId = ApexPages.currentPage().getParameters().get('edit-dish-id');
        PageReference redirect = new PageReference('/apex/PlatoForm?restID='+ restID +'&platoID=' + this.selectDishId);
        redirect.setRedirect(true);
        return redirect;
    }
    
    public void searchDishes() {
        String clause = 'SELECT Id,Name,Descripcion__c,Disponibilidad__c,Tipo__c,Picture__c,Precio__c ' +
        'FROM Plato__c ' +
        'WHERE (Restaurante__r.Id = \'' + this.restId + '\' ' +
        'AND Disponibilidad__c = true ' +
        'AND Name LIKE \'%' + this.inputDishName + '%\' )';
        
        this.defaultDishList = Database.query(clause);
    }
}