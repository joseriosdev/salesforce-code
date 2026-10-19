({
    init : function(component, event, helper) {
		helper.initializeComponent(component);
	},
    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');

        component.set('v.wishedItemId', row.Id);
        component.set('v.requested', row.Status === 'Requested');

        if (action.name === 'send_request') {
            component.set('v.isOpen', true);
        }
    },
    closeModal : function(component) {
        component.set('v.isOpen', false);
    },
    handleSuccess : function(component, event, helper)  {
        helper.sendRequest(component);
        component.set('v.isOpen', false);
    }
})
