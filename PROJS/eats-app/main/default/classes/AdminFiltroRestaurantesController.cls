public with sharing class AdminFiltroRestaurantesController {
    public List<Restaurante__c> restaurantsList {get; set;}
    public Boolean showModal {get; set;}
    public String recordNameToDelete {get; set;}
    public String recordToSelect {get; set;}
    
    // Inputs
    public String inputRestaurantName {get; set;}
    
    // Pagination
    public Integer lim {get; set;}
    public Integer off {get; set;}
    public Integer index {get; set;}
    public Integer currentPag {get; set;}
    public Integer endPag {get; set;}
    private List<Restaurante__c> totalRestaurants = [SELECT Id FROM Restaurante__c];
    
    // Constructor
    public AdminFiltroRestaurantesController() {
        this.inputRestaurantName = '';
        this.lim = 2;
        this.off = 0;
        this.index = 0;
        this.currentPag = this.index + 1;
        this.endPag = (Integer)Math.ceil((Decimal)this.totalRestaurants.size() / (Decimal)this.lim);
        this.showModal = false;
        
        searchRestaurants();
    }
    
    
    // Methods...
    public void next() {
        if (this.currentPag == this.endPag) return;
        
        this.off += this.lim;
        this.currentPag++;
        searchRestaurants();
    }
    
    public void nextAll() {
        this.index = this.endPag - 1;
        this.off = this.index * this.lim;
        this.currentPag = this.endPag;
        searchRestaurants();
    }
    
    public void previous() {
        if (this.currentPag == 1) return;
        
        this.currentPag--;
        this.off -= this.lim;
        searchRestaurants();
    }
    
    public void previousAll() {
        this.off = 0;
        this.index = 0;
        this.currentPag = 1;
        searchRestaurants();
    }
    
    public void searchRestaurants() {
        String clause = 'SELECT Id,Name,Direccion__c,Telefono__c,Tipo__c,Picture__c ' +
        'FROM Restaurante__c ' +
        'WHERE Name LIKE \'%' + this.inputRestaurantName + '%\' ' +
        'LIMIT ' + this.lim + ' ' +
        'OFFSET ' + this.off;
        
        this.restaurantsList = Database.query(clause);
        this.endPag = Math.round( ((Decimal)this.totalRestaurants.size() - 1) / (Decimal)this.lim);
    }
    
    public void deleteRecord() {
        DELETE new Restaurante__c(Id=this.recordToSelect);
        searchRestaurants();
        toggleModal();
    }
    
    public void toggleModal() {
        this.recordToSelect = ApexPages.currentPage().getParameters().get('RestaurantIdToSelect');
        this.showModal = !this.showModal;
    }
    
    public PageReference createRestaurantRedirect() {
        PageReference redirectNewRestaurant = new PageReference('/apex/RestauranteForm?core.apexpages.request.devconsole=1');
        redirectNewRestaurant.setRedirect(true);
        return redirectNewRestaurant;
    }
    
    public PageReference editRestaurantRedirect() {
        this.recordToSelect = ApexPages.currentPage().getParameters().get('RestaurantToEdit');
        PageReference redirectEditRestaurant = new PageReference('/apex/RestauranteFormEdit?restID=' + this.recordToSelect);
        redirectEditRestaurant.setRedirect(true);
        return redirectEditRestaurant;
    }
}