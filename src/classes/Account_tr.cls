public with sharing class Account_tr extends TriggerHandler{
    private List<Account> listNew {get; set;}
    private List<Account> listOld {get; set;}
    private Map<Id, Account> mapNew {get; set;}
    private Map<Id, Account> mapOld {get; set;}

    public Account_tr(){
        listNew = (List<Account>)Trigger.new;
        listOld = (List<Account>)Trigger.old;
        mapNew = (Map<Id,Account>)Trigger.newMap;
        mapOld = (Map<Id,Account>)Trigger.oldMap;
    }
    public override void beforeInsert(){
        doInsertAccount();
    }

    public override void afterInsert(){
    }

    public override void beforeUpdate(){
       doUpdateAccount();
    }

    public override void afterUpdate(){
    }

    public override void beforeDelete(){
        doDeleteAccount();
    }

    public void doInsertAccount(){
        for(Account objNew : listNew){
            if(objNew.Rating == null){
                objNew.Rating = 'Cold';
            }
        }
    }

    public void doUpdateAccount(){
        for(Account objNew : listNew){
            if(objNew.Rating == 'Cold' && mapOld.get(objNew.Id).Rating == 'Hot'){
                objNew.addError('Hot에서 Cold로 변경 하실 수 없습니다.');
            }
        }
    }

    public void doDeleteAccount(){
        for(Account objOld : listOld){
            if(objOld.Rating == 'Hot'){
                objOld.addError('Hot일 때는 삭제할 수 없습니다.');
            }
        }
    }


}