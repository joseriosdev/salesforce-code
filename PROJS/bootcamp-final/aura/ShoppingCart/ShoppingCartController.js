({
	init : function(component, event, helper) {
		helper.setCols(component);
	}
    ,
    handleRowAction : function(component, event, helper) {
        let row = event.getParam('row');
        helper.deleteRow(component, row);
        helper.updateTotalPrice(component);
    }
    ,
    handlePopulateShoppingCart : function(component, event, helper) {
        let item = event.getParam('item');
        helper.addItemToTable(component, item);
        helper.checkTableVisibility(component);
        
        if (item.Quantity === 0) 
            helper.deleteRow(component, item);
    }
    ,
    toggleModal : function(component) {
        let bool = component.get('v.displayModal');
        component.set('v.displayModal', !bool);
    }
    ,
    createOrder : function(component, event, helper) {
        let buyer = component.get('v.buyer');
        let totalPrice = Number.parseFloat(component.get('v.totalPrice'));
        let data = component.get('v.tableData');
        let shoppingRows = [];
        data.forEach(function(item) {
            let shoppingRow = {};
            shoppingRow.itemId = item.ItemId;
            shoppingRow.units = item.Quantity;
            shoppingRows.push(shoppingRow);
        });

        let action = component.get('c.submitOrder');
        action.setParams({
            'buyerName': buyer.Buyer_Name__c,
            'buyerPhone': buyer.Buyer_Phone__c,
            'buyerAddress': buyer.Buyer_Address__c,
            'totalPrice': totalPrice,
            'rows': shoppingRows
        });
        
        action.setCallback(this, function(response) {
            let bool = component.get('v.displayModal');
            component.set('v.displayModal', !bool);
            
            let state = response.getState();
            
            if (state === 'SUCCESS') {
                let order = response.getReturnValue();
                helper.showToast('Success!', 'Order Submited', 'success');
                helper.clearAllTableData(component);
            } else {
                console.log('cannot generate order: ' + state);
                let errors = response.getError();
                helper.showToast('Error,', errors[0].message, 'error');
            }
        });
        $A.enqueueAction(action);
    }
})