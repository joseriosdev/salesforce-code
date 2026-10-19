public class DynamicTableController {
	@AuraEnabled
    public static List<sObject> populateDynamicTable(String sobjectType, String sobjectFields, Integer queryLimit, Integer queryOffset) {
        String clause = 'SELECT ' + sobjectFields + ' ' +
            'FROM ' + sobjectType + ' ' +
            'LIMIT ' + queryLimit + ' ' +
            'OFFSET ' + queryOffset;
        
        
        List<sObject> data = Database.query(clause);
        
        return data;
    }
    
    @AuraEnabled
    public static Integer totalNumbersObjects(String sobjectType) {
        String query = 'SELECT Id FROM ' + sobjectType;
        List<sObject> arr = Database.query(query);
        return arr.size();
    }
    
    @AuraEnabled
    public static sObject deleteRecord(String recordId, String sobjectType) {
        String clause = 'SELECT Id,Name FROM ' +sobjectType+ ' WHERE Id=\'' +recordId+ '\' LIMIT 1';
        sObject record = Database.query(clause);
    	delete record;
        return record;
    }
}