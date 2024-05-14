/************************************************************************************
 * Description : 경비(Expense__c) Trigger 참고 소스
 * (ExpenseTrigger.trigger는 AccountTrigger.trigger 파일과 마찬가지로 생성 해주셔아합니다.)
 *
 * Ver      Date           Author          Modification
 * ===================================================================================
   1.0     2024-05-09      yr.lee         Create
*************************************************************************************/
public with sharing class Expense_tr extends TriggerHandler{
    private List<Expense__c> listNew {get; set;}
    private List<Expense__c> listOld {get; set;}
    private Map<Id, Expense__c> mapNew {get; set;}
    private Map<Id, Expense__c> mapOld {get; set;}

    public Expense_tr(){
        listNew = (List<Expense__c>)Trigger.new;
        listOld = (List<Expense__c>)Trigger.old;
        mapNew = (Map<Id,Expense__c>)Trigger.newMap;
        mapOld = (Map<Id,Expense__c>)Trigger.oldMap;
    }
    public override void beforeInsert(){
    }

    public override void afterInsert(){
        doInsertExpense();
    }

    public override void beforeUpdate(){
    }

    public override void afterUpdate(){
    }

    public override void beforeDelete(){
    }

    public void doInsertExpense() {
        Set<Id> setProjectId = new Set<Id>();
        
        for(Expense__c objNew : listNew){
            setProjectId.add(objNew.Project__c);
        }

        if(!setProjectId.isEmpty()){
            Date today = Date.today();
            List<Project__c> listProject = new List<Project__c>();
            listProject = [
                SELECT Id, EndDate__c
                FROM Project__c
                WHERE Id IN :setProjectId
                AND EndDate__c >= :today
            ];

            if(!listProject.isEmpty()){
                for(Project__c objProject : listProject){
                    objProject.LastExpenseDate__c = today;
                }
                update listProject;
            }
        }
    }
}