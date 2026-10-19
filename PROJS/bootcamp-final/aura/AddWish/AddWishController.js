({
	init : function(component, event, helper) {
		  //component.find('Add_Wish').reloadRecord(true) 
	},
    saveSuccessHandle : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Item added to wish list",
            "message": "We'll notify you when we have it available for purchase "
        });
        var a = component.get('c.refresh');
        $A.enqueueAction(a);
    },
    refresh : function(component,event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})