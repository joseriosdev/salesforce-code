({
	initializeTable : function(cmp) {
        // GENERATE COLS
        const tableCols = [
            {label: 'Brand', fieldName: 'CarBrand', type: 'text'},
            {label: 'Product', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'text'},
            {label: 'Price', fieldName: 'Price', type: 'currency'},
            {label: 'Stock', fieldName: 'Units', type: 'number'},
            {label: '', type: 'button', fixedWidth: 60, typeAttributes: {
                label: '—',
                name: 'decrement',
                title: 'Remove from Shopping Cart',
                class: 'sum-and-rest-btns',
                variant: 'brand'
            }},
            {label: '', fieldName: 'Quantity', type: 'number', fixedWidth: 50},
            {label: '', type: 'button', fixedWidth: 60, typeAttributes: {
                label: '+',
                name: 'increment',
                title: 'Add to Shopping Cart',
                class: 'sum-and-rest-btns',
                variant: 'brand'
            }}
        ];
        
        cmp.set('v.tableCols', tableCols);
    }
    ,
    getTableData : function(cmp, queryOff) {
        let inputType = cmp.get('v.inputType');
        const inputSearch = cmp.get('v.inputSearch');
        const queryLim = cmp.get('v.queryLim');
        
        if(inputType === 'All') inputType = '';
        
        if(inputSearch !== '') {
            queryOff = 0;
            cmp.set('v.queryOff', queryOff);
            cmp.set('v.currentPag', 1);
        }
        
        // GENERATE TABLE DATA ROWS
        cmp.set('v.isLoading', true);
        let action = cmp.get('c.fetchItems');
        action.setParams({
            'queryLim': queryLim,
            'queryOff': queryOff,
            'inputType': inputType,
            'inputSearch': inputSearch
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if(state === 'SUCCESS') {
                let dataTable = response.getReturnValue();
                cmp.set('v.tableData', dataTable.data);
                cmp.set('v.finalPag', Math.ceil(dataTable.count / queryLim));
            } else {
                console.log('Cannot fetch sObject -> ' + state);
            }
            cmp.set('v.isLoading', false);
        });
        $A.enqueueAction(action);
    }
    ,
    addItemToShoppingCart : function(cmp, row) {
        if(row.Quantity === row.Units) {
            this.showToast('Oops, ', 'STOCK LIMIT REACHED', 'info');
            return;
        }
        row.Quantity++;
        
        this.updateShoppingCart(cmp, row);
    }
    ,
    removeItemFromShoppingCart : function(cmp, row) {
        if(row.Quantity === 0) return;
        row.Quantity--;
        
        this.updateShoppingCart(cmp, row);
    }
    ,
    updateShoppingCart : function(cmp, row) {
     	let item = {
            ItemId: row.ItemId,
            Name: row.Name,
            Type: row.Type,
            CarBrand: row.CarBrand,
            Price: row.Price,
            Quantity: row.Quantity,
            Subtotal: row.Price * row.Quantity,
            Units: row.Units
        };
        
        let fillCartEvt = $A.get('e.c:PopulateShoppingCartEvt');
        fillCartEvt.setParams({ 'item': item });
        fillCartEvt.fire();
        
        this.updateQuantityUI(cmp, item, row);   
    }
    ,
    updateQuantityUI : function(cmp, item, row) {
        let rows = cmp.get('v.tableData');
        let rowIndex = this.getRowIndex(rows, row);
        
        // Diff between List of items vs list of selected items
        // * one has subtotal, the other don't
        delete item.Subtotal;
        rows.splice(rowIndex, 1, item);
        cmp.set('v.tableData', rows);
    }
    ,
    getRowIndex : function(rows, row) {
        let rowIndex = -1;
        rows.some(function(current, i) {
            if (current.ItemId === row.ItemId) {
                rowIndex = i;
                return true;
            }
        });
        return rowIndex;
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
})