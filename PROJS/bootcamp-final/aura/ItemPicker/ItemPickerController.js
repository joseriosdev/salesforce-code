({
	init : function(component, event, helper) {
		const queryOff = component.get('v.queryOff');
        helper.initializeTable(component);
        helper.getTableData(component, queryOff);
	}
    ,
    getItems : function(component, event, helper) {
        const queryOff = component.get('v.queryOff');
    	helper.getTableData(component, queryOff);
        component.set('v.inputSearch', '');
    }
    ,
    handleNext : function(component, event, helper) {
        let currentPag = component.get('v.currentPag');
        let finalPag = component.get('v.finalPag');
        let queryOff = component.get('v.queryOff');
        const queryLim = component.get('v.queryLim');
        
        if(currentPag === finalPag) return;
        
        queryOff += queryLim;
        currentPag++;
        
        component.set('v.queryOff', queryOff);
        component.set('v.currentPag', currentPag);
        
        helper.getTableData(component, queryOff);
    }
    ,
    handlePrev : function(component, event, helper) {
        let currentPag = component.get('v.currentPag');
        let finalPag = component.get('v.finalPag');
        let queryOff = component.get('v.queryOff');
        const queryLim = component.get('v.queryLim');
        
        if(currentPag === 1) return;
        
        queryOff -= queryLim;
        currentPag--;
        
        component.set('v.queryOff', queryOff);
        component.set('v.currentPag', currentPag);
        
        helper.getTableData(component, queryOff);
    }
    ,
    handleRowAction : function (component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        
        switch (action.name) {
            case 'increment':
                helper.addItemToShoppingCart(component, row);
                break;
            case 'decrement':
                helper.removeItemFromShoppingCart(component, row);
                break;
        }
    }
    ,
    handleRemoveItemFromCart : function(component, event, helper) {
        const queryOff = component.get('v.queryOff');
        let item = event.getParam('itemToRemove');
        let row = event.getParam('row');
        let clearAll = event.getParam('clearAll');
        
        if (clearAll) {
            helper.getTableData(component, queryOff);
            return;
        }
        
        helper.updateQuantityUI(component, item, row, clearAll);
    }
})