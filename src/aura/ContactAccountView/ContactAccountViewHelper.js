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
                console.log('returnValue :: ', returnValue);
                component.set("v.objAccount", returnValue);
            } else if(state === "ERROR") {
                this.showToast("error", "시스템 에러입니다.");
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
})