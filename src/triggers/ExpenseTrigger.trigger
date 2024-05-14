trigger ExpenseTrigger on Expense__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new Expense_tr().run();
}