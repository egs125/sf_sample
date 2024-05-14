import { LightningElement, api, wire } from 'lwc';
import getAcc from '@salesforce/apex/AccountViewController.getAcc';
import searchAcc from '@salesforce/apex/AccountViewController.searchAcc';


import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {updateRecord} from 'lightning/uiRecordApi';
import {refreshApex} from "@salesforce/apex";

const columns = [
    { label: '회사명', fieldName: 'Name', editable: true },
    { label: '기업번호', fieldName: 'AccountNumber', type: 'text', editable: true },
    { label: '전화번호', fieldName: 'Phone', type: 'phone', editable: true },
    { label: '설명', fieldName: 'Description', type: 'text', editable: true },
    { label: '로고', fieldName: 'Image__c', type: 'image' }
];

export default class AccountDataView extends LightningElement {

    @api
    recordId;

    @wire(getAcc, {recordId : '$recordId'})
    wiredAccounts;

    searchResults = null;

    draftValues = [];

    columns = columns;

    accNm = '';

    fnSetKeyword(event) {
        this.accNm = event.target.value;
        if(event.key === 'Enter'){
            if(!this.accNm){
                this.fnSetToast('오류','검색어를 입력해주세요', 'warning');
                return;
            }
            this.fnSearch();
        }
    }

    fnSearch() {
        console.dir('버튼 클릭');
        searchAcc({ accNm: this.accNm })
            .then(data => {
                if(!data.length){
                    this.searchResults  = null;
                    this.fnSetToast('검색 결과가 없습니다','다시 검색해주세요', 'warning');
                }else{
                    this.searchResults  = data;
                }
            })
            .catch(error => {
                this.fnSetToast('에러발생', error.body.message, 'error');
                this.searchResults  = null;
            });
    }

    get tableData() {
        if(this.searchResults){
            return this.searchResults;
        }else{
            return this.wiredAccounts.data;
        }
    }

    async handleSave(event) {
        let draftValues = event.detail.draftValues;

        console.dir(draftValues);

        /*
        updateRecord를 하기 위해선

        {
          fields: {
            Id: '001xx000003DHP0AAO',
            Name: '포스코',
            .
            .
            .

          }
        }

         이 형식으로 데이터를 맞춰줘여함. 그리고 다건 수정이 있을 수 있으므로 프로미스
         배열을 하나 만들음

        */

        let updatePromises = draftValues.map(item => {
            let fields = {};

            Object.keys(item).forEach(key => {
                fields[key] = item[key];
            });

            return updateRecord({ fields });
        });

        // 프로미스의 배열이 다 실행되었는지 여부에 따라서 분기처리
        await Promise.all(updatePromises)
            .then(data =>{

                this.draftValues = [];

                this.fnSetToast('수정완료', '데이터 수정 완료', 'info');

                // @wire로 이은 데이터 refresh
                refreshApex(this.wiredAccounts);

                if(this.searchResults){
                    let tempArray = [];
                    data.forEach(function(item,idx){
                        let tempObj = {};
                        Object.keys(item.fields).forEach(key => {
                            tempObj[key] = item.fields[key].value;
                        });
                        tempObj.Id = item.id;
                        tempArray.push(tempObj);
                    })

                    this.searchResults = tempArray;
                }

            })
            .catch(error => {
                this.fnSetToast('에러발생', error.body.message, 'error');
            })
    }

    fnSetToast(title, message, variant){
        dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        )
    }
}