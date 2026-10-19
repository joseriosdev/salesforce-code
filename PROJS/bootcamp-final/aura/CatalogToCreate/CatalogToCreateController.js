({
    init : function(component, event, helper) {
        component.set('v.mycolumns', [
            { label: 'Product', fieldName: 'Name', type: 'text'},
            { label: 'Brand', fieldName: 'BrandName', type: 'text'},
            { label: 'Price', fieldName: 'Price__c', type: 'currency'}
            
        ]);
    },
    handlePopulateCatalog : function(component, event, helper) {
        let CatalogItemListTop10 = event.getParam('selectedItemsTop10');
        component.set('v.mydata', CatalogItemListTop10);
    },
    createCatalog : function(component, event, helper) {
        var action = component.get('c.createNewCatalog');
        let catName = component.get('v.catalogName');
        let itemList = component.get('v.mydata');
        let itemIdList = [];
        if (!catName) {
            component.find('notifLib').showToast({
                "variant": "error",
                "title": "Error",
                "message": "Catalog Name cannot be empty"
            });
            
            return;
        }
        if (!itemList || !itemList.length) {
            component.find('notifLib').showToast({
                "variant": "error",
                "title": "Error",
                "message": "Please add items to your catalog"
            });
            
            return;
        }
        for (let i = 0; i < itemList.length; i++) {
            itemIdList.push(itemList[i].Id);
        }
        action.setParams({
            "name": catName,
            "itemObj": itemIdList
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Passed list ' + itemIdList );
                component.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Success!",
                    "message": catName + " catalog successfully created"
                });
                var a = component.get('c.refresh');
                $A.enqueueAction(a);
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    refresh : function(component,event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})