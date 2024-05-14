public with sharing class AccountViewController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Account> getAcc(Id recordId){

        List<Account> listAcc = new List<Account>();

        listAcc = [
            SELECT Id, Name, AccountNumber, Phone, Description, Image__c
            FROM Account
            WHERE Id =: recordId
        ];

        return listAcc;

    }

    @AuraEnabled
    public static List<Account> searchAcc(String accNm){

        List<Account> listAcc = new List<Account>();

        listAcc = [
                SELECT Id, Name, AccountNumber, Phone, Description, Image__c
                FROM Account
                WHERE Name LIKE: '%' + accNm + '%'
        ];

        return listAcc;

    }

}