({
    fnInit : function(component, event, helper){
        component.set("v.vfPageUrl" , "/apex/PrintOrderProduct?recordId=" + component.get("v.recordId"));
    },

    fnCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    },

    fnSave : function(component, event, helper){
        console.log("call Save");
        helper.saveAction(component, false);
    }
});