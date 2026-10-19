({
    initializeTable : function(cmp) {
        const sobjectFieldsLabel = cmp.get('v.sobjectFieldsLabel');
        const sobjectFields = cmp.get('v.sobjectFields');
        
        // GENERATE COLS
        let colFieldName = sobjectFields.split(',');
        let colFieldLabel = sobjectFieldsLabel.split(',');
        let tableCols = [];
        
        for(let field = 0; field < colFieldName.length; field++) {
            let obj = {
                label: colFieldLabel[field],
                fieldName: colFieldName[field],
                type: 'text'
            };
            
            tableCols.push(obj);
        }
        
        // Create table buttons
        let actions = [
            { label: 'View', name: 'view', iconName: 'utility:preview' },
            { label: 'Edit', name: 'edit', iconName: 'utility:edit' },
            { label: 'Delete', name: 'delete', iconName: 'utility:clear' }
        ];
        let actionsBtn = {
            type: 'action',
            typeAttributes: { rowActions: actions }
        };
        
        tableCols.push(actionsBtn);
        cmp.set('v.tableCols', tableCols);
    }
    ,
    getTableData : function(cmp, queryOffset) {
        const sobjectFields = cmp.get('v.sobjectFields');
        const sobjectType = cmp.get('v.customSObject');
        const queryLimit = cmp.get('v.tableLimit');
        
        // GENERATE TABLE DATA ROWS
        cmp.set('v.isLoading', true);
        let tableRows = [];
        let action = cmp.get('c.populateDynamicTable');
        action.setParams({
            'sobjectType': sobjectType,
            'sobjectFields': sobjectFields,
            'queryLimit': queryLimit,
            'queryOffset': queryOffset
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if(state === 'SUCCESS') {
                tableRows = response.getReturnValue();
                cmp.set('v.tableData', tableRows);
            } else {
                console.log('Cannot fetch sObject -> ' + state);
            }
            cmp.set('v.isLoading', false);
        });
        $A.enqueueAction(action);
    }
    ,
    setLastPagePagination : function(cmp) {
        const sobjectType = cmp.get('v.customSObject');
        const queryLimit = cmp.get('v.tableLimit');
        
        let action = cmp.get('c.totalNumbersObjects');
        action.setParams({
            'sobjectType': sobjectType
        });
        
        action.setCallback(this, function(response) {
            let state = response.getState();
            
            if(state === 'SUCCESS') {
                let result = response.getReturnValue();
                result = Math.ceil(result / queryLimit);
                cmp.set('v.paginationLastPage', result);
            } else {
                console.log('Cannot retrieve numbers of records for table -> ' + state);
            }
        });
        $A.enqueueAction(action);
    }
    ,
    viewRowAction : function(cmp, recordId) {
        const sobjectType = cmp.get('v.customSObject');
        const redirectEvt = $A.get('e.force:navigateToURL');
        redirectEvt.setParams({
            url: `/lightning/r/${sobjectType}/${recordId}/view`
        });
        redirectEvt.fire();
        
        const queryOffset = cmp.get('v.queryOffset');
        this.getTableData(cmp, queryOffset);
    }
    ,
    editRowAction : function(cmp, recordId) {        
        let editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": recordId
        });
        editRecordEvent.fire();
    }
    ,
    openConfirmDelete : function(cmp, recordToDeleteId) {
        console.log(recordToDeleteId)
        let displayModal = cmp.get('v.displayModal');
        cmp.set('v.displayModal', !displayModal);
        cmp.set('v.recordToDeleteId', recordToDeleteId);
    }
    ,
    alertMessage : function(cmp, innerMsn, classColor) {
        const sObj = cmp.get('v.customSObject');
        const alertElmt = document.getElementById('alert-message'+sObj);
        
        alertElmt.innerHTML = innerMsn;
        alertElmt.classList.add(classColor);
        
        setTimeout(() => { alertElmt.classList.remove(classColor) }, 2500);
    }
})