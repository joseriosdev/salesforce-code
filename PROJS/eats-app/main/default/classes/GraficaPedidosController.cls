public with sharing class GraficaPedidosController {
    public Id restId {get;set;}
    public List<Orden__c> ordenList {get;set;}
    public List<Plato__c> platoList {get;set;}
    public List<Data> data {get;set;}
    
    public class Data {
        public String name {get;set;}
        public Double data1 {get;set;}
        
        public Data (String name, Double data1){
            this.name = name;
            this.data1=data1;
        }
    }
    
    public GraficaPedidosController() {
        this.restId = ApexPages.currentPage().getParameters().get('restId') == null ? 'a005f000001on3fAAA' : ApexPages.currentPage().getParameters().get('restId');
        this.platoList = new List<Plato__c>();
        this.data = new List<Data>();
        ReadPlatos();
        calcQuantity ();  
    }
    
    public void ReadPlatos() {
        this.ordenList = [SELECT Plato__c, Cantidad__c FROM Orden__c WHERE Plato__r.Restaurante__c = :this.restId AND Pedido__r.Fecha__c = THIS_MONTH];
        List<Id> platoIdList = new List<Id>();
        for (Orden__c orden:ordenList) {
            platoIdList.add(orden.Plato__c);
        }
        this.platoList  = [SELECT Name,(SELECT Cantidad__c FROM Ordenes__r WHERE Pedido__r.Fecha__c = THIS_MONTH) FROM Plato__c WHERE Id IN :(platoIdList)];
    }
    
    public void calcQuantity (){
        for (Plato__c plato:platoList){
            Double cantidadTotal = 0;
            for (Integer i=0; i<plato.Ordenes__r.size();i++){
                cantidadTotal = cantidadTotal + plato.Ordenes__r[i].Cantidad__c;
            }
            data.add(new Data (plato.Name,cantidadTotal));
        }
    }
}