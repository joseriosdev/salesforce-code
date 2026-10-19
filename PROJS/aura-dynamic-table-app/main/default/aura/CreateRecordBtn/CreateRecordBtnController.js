({
	createNewRecord : function(component, event, helper) {
		let createRecordEvent = $A.get('e.force:createRecord');
        createRecordEvent.setParams({
            'entityApiName': component.get('v.sObject')
        });
        createRecordEvent.fire();
	}
})