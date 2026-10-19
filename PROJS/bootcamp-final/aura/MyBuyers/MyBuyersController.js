({
    init : function(cmp) {
        cmp.set('v.isLoading', true);
        cmp.set('v.tableCols', [
            {label: 'First Name', fieldName: 'FirstName', type: 'text'},
            {label: 'Last Name', fieldName: 'LastName', type: 'text'},
            {label: 'Alias', fieldName: 'Alias', type: 'text'}
        ]);
        
        let action = cmp.get('c.getMyBuyers');
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if (state == "SUCCESS") {
                cmp.set('v.tableData', response.getReturnValue());
            } else {
                let toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    title: 'Oops',
                    message: 'Cannot retrieve info about your buyers',
                    type: 'error'
                });
                toastEvent.fire();
            }
            cmp.set('v.isLoading', false);
        });
        $A.enqueueAction(action);
    }
})