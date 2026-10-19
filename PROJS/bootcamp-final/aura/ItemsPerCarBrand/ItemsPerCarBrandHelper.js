({
    fetchData : function(component, carBrand) {
        let loading = component.get('v.isLoading');
        if (loading) return;

        let limit = component.get('v.limit');
        let offset = component.get('v.offset')
        let action = component.get("c.getItems");
        action.setParams({
            carBrand: carBrand, lim: limit, off: offset
        });

        component.set('v.isLoading', true);            

        action.setCallback(this, function(response) {
            let datatable = response.getReturnValue();         
            component.set('v.tableData', datatable.data);
            component.set('v.total', Math.ceil(datatable.count / limit));

            component.set('v.isLoading', false);        
        });
        $A.enqueueAction(action);
    },
    setCols : function(component) {
        component.set('v.tableCols', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Price', fieldName: 'Price__c', type: 'currency'},
            {label: 'Stock', fieldName: 'Units__c', type: 'number'}
        ]);
    },
    fetchCarBrandOptions : function(component) {
        let action = component.get("c.getOptions");
        action.setCallback(this, function(response) {
            let options = response.getReturnValue();
            component.set('v.tableOptions', options);
        });
        $A.enqueueAction(action);
    }
})
