public with sharing class C_MenuCardCompradorController {
    public Integer units {get; set;}
    public Decimal total {get; set;}
    public Plato__c currentDish {get; set;}
    
    public void increase() {
        this.units++;
        this.total = this.units * this.currentDish.Precio__c;
    }
    
    public void decrease() {
        if (this.units == 0) return;
        this.units--;
        this.total = this.units * this.currentDish.Precio__C;
    }
}