/************************************************************************************
 * Description :
 *
 * Ver      Date           Author          Modification
 * ===================================================================================
   1.0      2024-05-03        yr.lee         Create
*************************************************************************************/

public with sharing class PrintExpenseController {
    public String recordId { get; set; }
    public List<Expense__c> listExpense { get; set; }
    public List<List<Expense__c>> listWrapperExpense { get; set; }

    public PrintExpenseController() {
        recordId = ApexPages.currentPage().GetParameters().get('recordId');
        listExpense = new List<Expense__c>();
        listWrapperExpense = new List<List<Expense__c>>();
        listExpense = [
                SELECT Id, Name, Spending__c, Description__c
                FROM Expense__c
                WHERE Project__c = :recordId
        ];

        List<Expense__c> listTemp = new List<Expense__c>();
        for(Integer i = 0; i < listExpense.size(); i++){
            //30의 배수 마다 listTemp 초기화 및 listWrapperStudent에 추가
            if(i != 0 && (Math.Mod(i, 20) == 0 || i == listExpense.size() - 1)){
                if(i == listExpense.size() - 1){
                    listTemp.add(listExpense[i]);
                }
                listWrapperExpense.add(listTemp);
                listTemp = new List<Expense__c>();
                listTemp.add(listExpense[i]);
            }
            else{
                listTemp.add(listExpense[i]);
            }
        }
    }

}