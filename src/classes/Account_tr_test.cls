/************************************************************************************
 * Description :
 *
 * Ver      Date           Author          Modification
 * ===================================================================================
   1.0      2024-05-09        yr.lee         Create
*************************************************************************************/

@IsTest
private class Account_tr_test {
    @TestSetup
    static void Account_tr_testSetup() {
        //code_block
    }

    @IsTest
    static void Account_tr_test () {

        Test.startTest();
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;

        objAccount.Rating = 'Hot';
        update objAccount;

        objAccount.Rating = 'Warm';
        update objAccount;

        delete objAccount;

        Test.stopTest();
    }
}