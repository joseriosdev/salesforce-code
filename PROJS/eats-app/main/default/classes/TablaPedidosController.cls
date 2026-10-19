public with sharing class TablaPedidosController {
    public Id restId {get; set;}
    public List<Pedido__c> pedidosList {get; set;}
    public Double Total {get; set;}
   
    public TablaPedidosController() {
        // grab restID from the end of the URL
        this.restId = ApexPages.currentPage().getParameters().get('restId') == null ? 'a005f000001on3fAAA' : ApexPages.currentPage().getParameters().get('restId');
        this.pedidosList = new List<Pedido__c>();
        this.Total=0;
        
        ReadPedidos();
        CalcTotal();
    }
    
    public void ReadPedidos () {
        this.pedidosList = [SELECT Name,
                           Direccion__c,
                           Fecha__c,
                           NIT__c,
                           Nombre_Factura__c,
                           Precio_Total__c
                           FROM Pedido__c
                           WHERE Restaurante__c = : this.restId
                           AND Fecha__c = THIS_MONTH AND Precio_Total__c > 0];
    }
    
    public void CalcTotal() {
        for (Pedido__c pedido:pedidosList) {
            this.Total = this.Total + pedido.Precio_Total__c;
        }
    }
}