/**
 * Created by 한성진 on 2022-11-24.
 */

import { LightningElement, api } from 'lwc';

export default class ImageControl extends LightningElement {

    // url과 altText 라는 변수를 만들어주세요.
    // 실습 문서 상단에 있는 설명을 참조해서 만들어주세요

    @api
    url;

    @api
    altText;
}