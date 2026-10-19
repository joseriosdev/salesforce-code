public with sharing class CompradorFiltroRestaurantesController {
    public List<Restaurante__c> restaurantsList {get; set;}
    
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
    public CompradorFiltroRestaurantesController() {
        this.inputRestaurantName = '';
        this.lim = 10;
        this.off = 0;
        this.index = 0;
        this.currentPag = this.index + 1;
        this.endPag = Math.round( ((Decimal)this.totalRestaurants.size() - 1) / (Decimal)this.lim);
        
        searchRestaurants();
    }
    
    
    // Methods...
    public void next() {
        if (this.restaurantsList.size() != this.lim) return;
        
        this.index++;
        this.off = this.index * this.lim;
        this.currentPag = this.index + 1;
        searchRestaurants();
    }
    
    public void nextAll() {
        this.index = this.endPag - 1;
        this.off = this.index * this.lim;
        this.currentPag = this.endPag;
        searchRestaurants();
    }
    
    public void previous() {
        if(this.index <= 0) return;
        
        this.index--;
        this.off = this.index * this.lim;
        this.currentPag = this.index + 1;
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
}