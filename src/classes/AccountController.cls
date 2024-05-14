/**
 * Created by HSJ on 2024-05-10.
 */

public with sharing class AccountController {

    @AuraEnabled(Cacheable=true)
    public static List<Account> getAccounts() {

        List<Account> listAcc = new List<Account>();
        listAcc = [
                SELECT Id, Name, AccountNumber, Phone, Description
                FROM Account
                LIMIT 10
        ];

        return listAcc;
    }

}