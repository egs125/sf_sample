/************************************************************************************
 * Description :
 *
 * Ver      Date           Author          Modification
 * ===================================================================================
   1.0      2024-05-09        yr.lee         Create
*************************************************************************************/
public with sharing class ChangeProjectMemberController {
    @AuraEnabled
    public static Map<String, List<Map<String, String>>> getInitData(String recordId){
        Map<String, List<Map<String, String>>> mapReturn = new Map<String, List<Map<String, String>>>();
        //현재 진행중인 프로젝트에 있는 직원은 제외해야하므로 현재 진행중인 프로젝트 멤버의 직원(Employee__c) 정보를 추출한다.
        List<ProjectMember__c> listMemberInProject = new List<ProjectMember__c>();
        listMemberInProject = [
                SELECT Id, Employee__c
                FROM ProjectMember__c
                WHERE Project__r.EndDate__c > :Date.today()
        ];

        Set<Id> setInProjectMemberId = new Set<Id>();
        for(ProjectMember__c objEmployee : listMemberInProject){
            setInProjectMemberId.add(objEmployee.Employee__c);
        }

        //현재 진행중인 프로젝트에 있는 직원을 제외한 직원의 Id와 직원명을 조회
        List<Employee__c> listEmployee = new List<Employee__c>();
        listEmployee = [
                SELECT Id, EmployeeName__c
                FROM Employee__c
                WHERE Id NOT IN :setInProjectMemberId
        ];

        List<Map<String, String>> listMapTemp = new List<Map<String, String>>();
        Map<String, String> mapTemp;
        for(Employee__c objEmployee : listEmployee){
            mapTemp = new Map<String, String>();
            mapTemp.put('label', objEmployee.EmployeeName__c);
            mapTemp.put('value', objEmployee.Id);
            listMapTemp.add(mapTemp);
        }
        mapReturn.put('employee', listMapTemp);

        //해당프로젝트 멤버 조회
        List<ProjectMember__c> listProjectMember = new List<ProjectMember__c>();
        listProjectMember = [
                SELECT Id, Employee__r.EmployeeName__c
                FROM ProjectMember__c
                WHERE Project__c = :recordId
        ];

        listMapTemp = new List<Map<String, String>>();
        for(ProjectMember__c objMember : listProjectMember) {
            mapTemp = new Map<String, String>();
            mapTemp.put('label', objMember.Employee__r.EmployeeName__c);
            mapTemp.put('value', objMember.Id);
            listMapTemp.add(mapTemp);
        }
        mapReturn.put('member', listMapTemp);

        return mapReturn;

    }

    @AuraEnabled
    public static Boolean doCheckPosition(String memberId){
        //멤버가 PM 역할인지 확인하려면 해당멤버 Id로 역할(Position__c)을 조회하여 검사한다.
        ProjectMember__c objMember = [
                SELECT Id, Position__c
                FROM ProjectMember__c
                WHERE Id = :memberId
        ];

        if(objMember.Position__c == 'PM'){
            return false;
        }
        else{
            return true;
        }
    }

    @AuraEnabled
    public static String doChangeMember(String memberId, String employeeId){
        ProjectMember__c objMemberUpdate = new ProjectMember__c();
        objMemberUpdate.Id = memberId;
        objMemberUpdate.Employee__c = employeeId;
        update objMemberUpdate;

        return 'Success';
    }
}