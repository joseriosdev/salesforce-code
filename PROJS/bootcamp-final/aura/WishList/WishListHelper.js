({
    COLUMNS: [
        { label: 'Item', fieldName: 'Name', type: 'text' },
        { label: 'Brand', fieldName: 'CarBrand', type: 'text' },
        { label: 'Manufacturer', fieldName: 'Manufacturer', type: 'text' },
        { label: 'Times Requested', fieldName: 'TimesRequested', type: 'text' },
        { label: 'Status', type: 'button', initialWidth: 160, typeAttributes: {
            label: { fieldName: 'Status'}, title: 'Request', name: 'send_request', disabled: { fieldName: 'Disabled' }, iconName: { fieldName: 'Icon'}
        }},
    ],
    initializeComponent : function(component) {
        component.set('v.columns', this.COLUMNS);
        this.fetchData(component);
    },
    fetchData : function(component) {
        let loading = component.get('v.loading');
        if (loading) return;

        component.set('v.loading', true);            
        
        let action = component.get("c.getWishedItems");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let data = response.getReturnValue();
                data = data.map(function(item) {
                    switch(item.Status) {
                        case 'Approved':
                            item.Disabled = true;
                            item.Icon = 'utility:check'
                            break
                        case 'Not Approved':
                            item.Icon = 'utility:close'
                            break;
                        case 'Requested':
                            item.Icon = 'utility:clock'
                    }
                    return item;
                })
                component.set('v.data', data);
            } else {
                let errors = response.getError();
                if (errors && errors.length > 0) {
                    component.set('v.error', errors[0].message);
                }
            }
            component.set('v.loading', false);        
        });
        $A.enqueueAction(action);
    },
    sendRequest : function(component) {
        let wishedItemId = component.get('v.wishedItemId');
        let action = component.get("c.sendApprovalRequest");
        action.setParams({ wishedItemId: wishedItemId });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let toastEvent = $A.get('e.force:showToast');

            let title = 'Success!';
            let type = 'success';
            let message = 'The wished item has been requested for approval.'

            if (state !== 'SUCCESS') {
                let errors = response.getError();
                if (errors && errors.length > 0) {
                    title = 'Error!';
                    type = 'error';
                    message = errors[0].message;
                }
            }
            toastEvent.setParams({
                title: title, type: type, message: message
            });
            toastEvent.fire();

            this.fetchData(component);
        });
        $A.enqueueAction(action);
    }
})
