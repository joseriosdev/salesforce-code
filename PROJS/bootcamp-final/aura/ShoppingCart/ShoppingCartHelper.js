({
	setCols : function(cmp) {
		const tableCols = [
            {label: 'Brand', fieldName: 'CarBrand', type: 'text'},
            {label: 'Product', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'text'},
            {label: 'Price', fieldName: 'Price', type: 'currency'},
            {label: 'Units', fieldName: 'Quantity', type: 'number'},
            {label: 'Subtotal', fieldName: 'Subtotal', type: 'currency'},
            {label: '', type: 'button', fixedWidth: 60, typeAttributes: {
                label: 'X',
                name: 'remove',
                title: 'Remove from Shopping Cart',
                variant: 'destructive'
            }}
        ];
        cmp.set('v.tableCols', tableCols);
        
        const modalTableCols = Array.from(tableCols);
        modalTableCols.pop();
        cmp.set('v.modalTableCols', modalTableCols);
	}
    ,
    addItemToTable : function(cmp, item) {
        const data = cmp.get('v.tableData');
        
        if (data.length === 0) {
            data.push(item);
            cmp.set('v.tableData', data);
            this.updateTotalPrice(cmp);
            return;
        }
        
        for (let i = 0; i < data.length; i++) {
            if (data[i].ItemId === item.ItemId) {
                data.splice(i, 1, item);
                cmp.set('v.tableData', data);
                this.updateTotalPrice(cmp);
                return;
            }
        }
        
        data.push(item);
        cmp.set('v.tableData', data);
        this.updateTotalPrice(cmp);
    }
    ,
    updateTotalPrice : function(cmp) {
        let data = cmp.get('v.tableData');
        let total = 0;
        
        data.forEach(item => total += item.Subtotal);
        
        total = total.toFixed(2);
        cmp.set('v.totalPrice', total);
    }
    ,
    showToast : function(title, message, type) {
        let toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
    ,
    clearAllTableData : function(cmp) {
        cmp.set('v.tableData', []);
        this.checkTableVisibility(cmp);
        
        let cartEvt = $A.get('e.c:ShoppingCartRemoveEvt');
        cartEvt.setParams({ 'clearAll': true });
        cartEvt.fire();
    }
    ,
    checkTableVisibility : function(cmp) {
        let rows = cmp.get('v.tableData');
        if(rows.length === 0) {
            cmp.set('v.cmpContent', false);
            cmp.set('v.initialText', true);
        } else {
            cmp.set('v.initialText', false);
            cmp.set('v.cmpContent', true);
        }
    }
    ,
    deleteRow : function(cmp, row) {
        let rows = cmp.get('v.tableData');
        let rowIndex = -1;
        rows.some(function(current, i) {
            if (current.ItemId === row.ItemId) {
                rowIndex = i;
                return true;
            }
        });
        rows.splice(rowIndex, 1);
        cmp.set('v.tableData', rows);
        
        this.checkTableVisibility(cmp);
        
        let item = {
            ItemId: row.ItemId,
            Name: row.Name,
            Type: row.Type,
            CarBrand: row.CarBrand,
            Price: row.Price,
            Quantity: 0,
            Units: row.Units
        };
        
        let cartEvt = $A.get('e.c:ShoppingCartRemoveEvt');
        cartEvt.setParams({ 
            'itemToRemove': item,
            'row': row
        });
        cartEvt.fire();
    }
})