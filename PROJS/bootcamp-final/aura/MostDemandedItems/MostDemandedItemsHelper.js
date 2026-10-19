({
	getData : function(component) {
        var action = component.get('c.findTop10');
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Car_Brand__r) row.BrandName = row.Car_Brand__r.Name;
                    if (row.From_Wishlist__c) {
                        row.Remarks = 'New Item from Wishlist';
                    } else {
                        row.Remarks = 'Best Seller';
                    }
                }
                component.set('v.mydata', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})