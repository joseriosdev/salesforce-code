({
    init : function(component, event, helper) {
        const queryOffset = component.get('v.queryOffset');
        
        component.set('v.isLoading', true);
        helper.initializeTable(component);
        helper.getTableData(component, queryOffset);
        helper.setLastPagePagination(component);
	}
    ,
    handleRowAction : function(component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');

        switch (action.name) {
            case 'view':
                helper.viewRowAction(component, row.Id);
                break;
            case 'edit':
                helper.editRowAction(component, row.Id);
                break;
            case 'delete':
                helper.openConfirmDelete(component, row.Id);
                break;
        }
    }
    ,
    handleUpdatePagination : function(component, event, helper) {
        let queryOffset = event.getParam('queryOffset');
        component.set('v.queryOffset', queryOffset);
        component.set('v.paginationFirstPage', event.getParam('paginationFirstPage'));
        component.set('v.paginationLastPage', event.getParam('paginationLastPage'));
        
        helper.getTableData(component, queryOffset);
    }
    ,
    confirmDeleteRow : function(component, event, helper) {
        const recordToDelete = component.get('v.recordToDeleteId');
        console.log(recordToDelete)
        const sobject = component.get('v.customSObject');
        console.log(sobject)
        
        let action = component.get('c.deleteRecord');
        action.setParams({
            'recordId': recordToDelete,
            'sobjectType': sobject
        });
        
        action.setCallback(this, function(response) {
            const queryOffset = component.get('v.queryOffset');
            let state = response.getState();
            if(state === 'SUCCESS') {
            	let objDeleted = response.getReturnValue();
            	helper.getTableData(component, queryOffset);
            	helper.alertMessage(component, `The record ${objDeleted.Name.toUpperCase()} was deleted`, 'success');
            } else {
                console.log('Unable to delete sobject -> ' + state);
        		helper.alertMessage(component, 'Unable to delete record', 'error');
            }
        });
        $A.enqueueAction(action);

		helper.setLastPagePagination(component);

		let displayModal = component.get('v.displayModal');
        component.set('v.displayModal', !displayModal);
    }
    ,
    toggleModalDelete : function(component, event, helper) {
        let displayModal = component.get('v.displayModal');
        component.set('v.displayModal', !displayModal);
    }
})