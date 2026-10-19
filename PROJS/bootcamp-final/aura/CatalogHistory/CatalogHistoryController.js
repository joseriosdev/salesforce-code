({
	init : function(component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Name', fieldName: 'Name', type: 'text'},
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'date'}
        ]);
        helper.getData(component);
    }
})