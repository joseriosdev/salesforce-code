({
	next : function(component, event, helper) {
		let paginationFirstPage = component.get("v.paginationFirstPage");
        const paginationLastPage = component.get("v.paginationLastPage");
        let queryOffset = component.get("v.queryOffset");
        const queryLimit = component.get("v.queryLimit");
        
        if(paginationFirstPage === paginationLastPage) return;
        
        queryOffset += queryLimit;
        paginationFirstPage++;
        
        component.set('v.queryOffset', queryOffset);
        component.set('v.paginationFirstPage', paginationFirstPage);
        
        let updateEvent = component.getEvent('updatePagination');
        updateEvent.setParams({
            'queryOffset': queryOffset,
            'paginationFirstPage': paginationFirstPage,
            'paginationLastPage': paginationLastPage
        });
        updateEvent.fire();
	}
    ,
    prev : function(component, event, helper) {
		let paginationFirstPage = component.get("v.paginationFirstPage");
        const paginationLastPage = component.get("v.paginationLastPage");
        let queryOffset = component.get("v.queryOffset");
        const queryLimit = component.get("v.queryLimit");
        
        if(paginationFirstPage === 1) return;
        
        queryOffset +- queryLimit;
        paginationFirstPage--;
        
        component.set('v.queryOffset', queryOffset);
        component.set('v.paginationFirstPage', paginationFirstPage);
        
        let updateEvent = component.getEvent('updatePagination');
        updateEvent.setParams({
            'queryOffset': queryOffset,
            'paginationFirstPage': paginationFirstPage,
            'paginationLastPage': paginationLastPage
        });
        updateEvent.fire();
	}
})