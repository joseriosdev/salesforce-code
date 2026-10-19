public class NotifyUtils {

    public static String NewItemBodyForBuyers(Id newItemId) {
        Item__c newItem = [SELECT Name, Price__c, Car_Brand__r.Name, Type__c FROM Item__c WHERE Id = : newItemId];
        String itemsListBody = '</br>Name: ' + newItem.Name + 
        '</br>Brand: ' + newItem.Car_Brand__r.Name + 
        '</br>Type: ' + newItem.Type__c + 
        '</br>Price: ' + newItem.Price__c + '</br>';

        return 'Hey!</br>' + 
                'The Item you wanted is in stock!</br>' +
                itemsListBody + 
                '</br>Best, </br>Carshop Team';
    }

    public static String NewItemBodyForSalesReps(Id newItemId) {
        Item__c newItem = [SELECT Name, Price__c, Car_Brand__r.Name, Type__c FROM Item__c WHERE Id = : newItemId];
        String itemsListBody = '</br>Name: ' + newItem.Name + 
        '</br>Brand: ' + newItem.Car_Brand__r.Name + 
        '</br>Type: ' + newItem.Type__c + 
        '</br>Price: ' + newItem.Price__c + '</br>';

        return 'Hey!</br>' + 
                'A new Wished Item is available in stock!</br>' +
                itemsListBody + 
                '</br>Best, </br>Carshop Team';
    }

    @future
    public static void sendEmailAsync(Id sender, Set<Id> receivers, String subject, String body) {
        List<User> sendToUsers = [SELECT email FROM User WHERE Id in :receivers];
        List<String> sendToEmails = new List<String>();
        for (User user : sendToUsers) {
            sendToEmails.add(user.Email);
        }

        User senderUser = [SELECT FirstName, LastName, Email FROM User WHERE Id = :sender];

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(sendToEmails);
        email.setReplyTo(senderUser.Email);
        email.setSenderDisplayName(senderUser.FirstName + ' ' + senderUser.LastName);
        email.setSubject(subject);
        email.setHtmlBody(body);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
    }
}
