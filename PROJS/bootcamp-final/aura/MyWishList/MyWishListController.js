({
	init : function(component, event, helper) {
        
        component.set('v.mycolumns', [
            { label: 'Product', fieldName: 'Name', type: 'text'},
            { label: 'Brand', fieldName: 'Car_Brand__c', type: 'text'},
            { label: 'Manufacturer', fieldName: 'Manufacturer__c', type: 'text'},
            { label: 'Status', fieldName: 'Status__c', type: 'text'}
            
        ]);
        helper.getData(component);
		
	}
})