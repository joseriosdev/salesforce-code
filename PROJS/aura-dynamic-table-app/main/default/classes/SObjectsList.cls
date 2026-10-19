global class SObjectsList extends VisualEditor.DynamicPickList {
    
    global override VisualEditor.DataRow getDefaultValue() {
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Account', 'Account');
        return defaultValue;
    }
    
    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows sobjectsInORG = new VisualEditor.DynamicPickListRows();
        
        for(Schema.SObjectType obj : Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult objRes = obj.getDescribe();
            VisualEditor.DataRow picklistItem = new VisualEditor.DataRow(objRes.getName(), objRes.getName());
            sobjectsInORG.addRow(picklistItem);
        }
        
        return sobjectsInORG;
    }
}