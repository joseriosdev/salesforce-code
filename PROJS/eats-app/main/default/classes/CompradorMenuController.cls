public with sharing class CompradorMenuController {
    // Default/temporal variables
    public List<Plato__c> defaultDishList {get; set;}
    
    public Boolean displayMenu {get; set;}
    public Boolean displayOrder {get; set;}
    public String fullName {get; set;}
    public Integer nit {get; set;}
    public String address {get; set;}
    public Date paymentDate {get; set;}
    public String restId {get; set;}
    public String inputDishName {get; set;}
    public String paymentMethod {get; set;}
    public List<SelectOption> paymentMethodList {get;set;}
    public Decimal grantTotal {get; set;}
    
    
    // Helper class variables
    public List<OrderHelperClass> uiDishesInfo {get; set;}
    public List<OrderHelperClass> orderTableInfo {get; set;}
    
    
    // <CONSTRUCTOR>
    public CompradorMenuController() {
        this.restId = ApexPages.currentPage().getParameters().get('restId');
        
        this.defaultDishList = [SELECT Id,Name,Descripcion__c,Disponibilidad__c,Tipo__c,Picture__c,Precio__c
                                FROM Plato__c
                                WHERE Restaurante__r.Id = :this.restId
                                AND Disponibilidad__c = true];
        
        // Second form, before submitting the order
        this.displayMenu = true;
        this.displayOrder = false;
        this.grantTotal = 0;
        this.paymentDate = Date.today();
        this.paymentMethodList = new List<SelectOption>();
        this.paymentMethodList.add(new SelectOption('Efectivo','Efectivo'));
        this.paymentMethodList.add(new SelectOption('Tarjeta de credito o debito','Tarjeta de crédito o débito'));
        
        // Generate 'OrderHelper' Instance for UI
        initUiDishesInfo();
    }
    
    private void initUiDishesInfo() {
        this.uiDishesInfo = new List<OrderHelperClass>();
        for (Plato__c dish : this.defaultDishList) {
            OrderHelperClass ohc = new OrderHelperClass();
            ohc.dish = dish;
            ohc.units = 0;
            ohc.disabled = false;
            this.uiDishesInfo.add(ohc);
        }
    }
    
    public void navigateNextComponent() {
        this.displayMenu = !this.displayMenu;
        this.displayOrder = !this.displayOrder;
        
        this.orderTableInfo = new List<OrderHelperClass>();
        
        for (OrderHelperClass ohc : this.uiDishesInfo) {
            if (ohc.units != 0) {
                this.orderTableInfo.add(ohc);
                this.grantTotal += ohc.total;
            }
        }
    }
    
    public PageReference submitOrder() {
        Pedido__c request = new Pedido__c();
        request.Nombre_Factura__c = this.fullName;
        request.NIT__c = this.nit;
        request.Direccion__c = this.address;
        request.Fecha__c = this.paymentDate;
        request.Metodo_de_pago__c = this.paymentMethod;
        request.Restaurante__c = this.restId;
        
        Pedido__c newPedido = createPedido(request);
        
        
        List<Orden__c> orders = new List<Orden__c>();
        for (OrderHelperClass ohc : this.orderTableInfo) {
            Orden__c order = new Orden__c();
            order.Cantidad__c = ohc.units;
            order.Plato__c = ohc.dish.Id;
            order.Pedido__c = newPedido.Id;
            order.Subtotal_final__c = ohc.total;
            insert order;
        }
        
        this.fullName = '';
        this.nit = null;
        this.address = '';
        
        PageReference redirect = new PageReference('/apex/PurchaseDone');
        redirect.setRedirect(true);
        return redirect;
    }
    
    private Pedido__c createPedido(Pedido__c pedido) {
        insert pedido;
        return pedido;
    }
    
    public void searchDishes() {
        String clause = 'SELECT Id,Name,Descripcion__c,Disponibilidad__c,Tipo__c,Picture__c,Precio__c ' +
        'FROM Plato__c ' +
        'WHERE (Restaurante__r.Id = \'' + this.restId + '\' ' +
        'AND Disponibilidad__c = true ' +
        'AND Name LIKE \'%' + this.inputDishName + '%\' )' +
        'OR Tipo__c = \'' + this.dishType + '\'';
        
        this.defaultDishList = Database.query(clause);
        for(integer i=0; i<10000;i++) {}
        initUiDishesInfo();
    }
    
    public CompradorMenuController getSelf() {
        return this;
    }
    
    
    
    // o------------> Helper Class <--------------o
    public class OrderHelperClass {
        public Plato__c dish {get; set;}
        public Integer units {get; set;}
        public Decimal total {get; set;}
        public Boolean disabled {get; set;}
        
        public OrderHelperClass() {}
        
        public OrderHelperClass(Plato__c dish, Integer unit, Boolean check) {
            this.dish = dish;
            this.units = unit;
            this.disabled = check;
            
            this.total = 0;
        }
        
        public void increase() {
            this.units++;
            this.total = this.units * this.dish.Precio__c;
        }
        
        public void decrease() {
            if (this.units == 0) return;
            this.units--;
            this.total = this.units * this.dish.Precio__C;
        }
        
        public void switchDisabled() {
            this.disabled = true;
        }
    }
}