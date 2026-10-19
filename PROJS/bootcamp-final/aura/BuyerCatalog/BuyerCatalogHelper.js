({
	getData : function(component) {
        var action = component.get('c.findCatalogItems');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
                if (row.Car_Brand__r) row.BrandName = row.Car_Brand__r.Name;
                }
            	component.set('v.mydata', rows);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    getCatalog : function(component) {
        var action = component.get('c.latestCatalog');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.catalog', response.getReturnValue());
                console.log(response.getReturnValue());
                                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})