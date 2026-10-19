({
	init : function(component, event, helper) {
        helper.fetchCarBrandOptions(component);
        helper.setCols(component);
        helper.fetchData(component);
	},
    handleChange: function (component, event, helper) {
        let carBrand = event.getParam('value');
        component.set('v.tableCarBrand', carBrand);
        helper.fetchData(component, carBrand);
    },
    handleNext: function (component, event, helper) {
        let carBrand = component.get('v.tableCarBrand');
        let index = component.get('v.index');
        let limit = component.get('v.limit');
        let count = component.get('v.total');

        index += 1;
        if (index >= count) return;
        
        component.set('v.offset', index * limit);
        component.set('v.index', index);

        helper.fetchData(component, carBrand);
    },
    handlePrevious: function (component, event, helper) {
        let carBrand = component.get('v.tableCarBrand');
        let index = component.get('v.index');
        let limit = component.get('v.limit');
        let count = component.get('v.total');

        index -= 1;
        if (index < 0) return;
        
        component.set('v.offset', index * limit);
        component.set('v.index', index);

        helper.fetchData(component, carBrand);
    },
})