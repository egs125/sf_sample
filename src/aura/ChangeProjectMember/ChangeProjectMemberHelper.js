/**
 * Created by yerin on 2022-09-14.
 */

({
    getInitData : function(component) {
        var action = component.get("c.getInitData");

        action.setParams({
            recordId : component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log(returnValue);
                var listEmployee = [];
                var listMember = [];
                component.set("v.ListMember", returnValue['member']);
                component.set("v.ListEmployee", returnValue['employee']);
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                } else {
                    this.showToast("error", "Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    doCheckPosition : function(component) {
        var action = component.get("c.doCheckPosition");

        action.setParams({
            recordId : component.get("v.recordId"),
            memberId : component.get("v.ChangedMember")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log(returnValue);
                if(returnValue == false){
                    this.showToast("Error", "PM은 교체될 수 없습니다.");
                    component.set("v.ChangedMember", "");
                }
                else{
                    component.set("v.ShowEmployeeOption", true);
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                } else {
                    this.showToast("error", "Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    doChangeMember : function(component) {
        var action = component.get("c.doChangeMember");

        action.setParams({
            memberId : component.get("v.ChangedMember"),
            employeeId : component.get("v.SelectedEmployee")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                console.log(returnValue);
                if(returnValue == 'Success'){
                    this.showToast("Success", "프로젝트 멤버가 교체되었습니다.");
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
            } else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) this.showToast("error", errors[0].message);
                } else {
                    this.showToast("error", "Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(type, message) {
        var evt = $A.get("e.force:showToast");
        evt.setParams({
            key : "info_alt"
            , type : type
            , message : message
        });
        evt.fire();
    }
});