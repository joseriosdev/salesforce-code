({
    init : function(component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Product', fieldName: 'Name', type: 'text'},
            { label: 'Brand', fieldName: 'BrandName', type: 'text'},
            { label: 'Units Sold', fieldName: 'RequestedTimes__c', type: 'text'},
            { label: 'Remarks', fieldName: 'Remarks', type: 'text'},
            
        ]);
        helper.getData(component);
    },
    updateSelectedRow: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        let fillCatalogEvt = $A.get('e.c:RegisterItemRow');
        fillCatalogEvt.setParams({ 'selectedItemsTop10': selectedRows});
        fillCatalogEvt.fire(); 
    }
})