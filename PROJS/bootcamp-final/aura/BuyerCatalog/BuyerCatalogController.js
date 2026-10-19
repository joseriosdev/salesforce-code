({
	init : function(component, event, helper) {
         component.set('v.mycolumns', [
            { label: 'Product', fieldName: 'Name', type: 'text'},
            { label: 'Brand', fieldName: 'BrandName', type: 'text'},
            { label: 'Price', fieldName: 'Price__c', type: 'currency'}
        ]);
        helper.getData(component);
        helper.getCatalog(component);
	}
})