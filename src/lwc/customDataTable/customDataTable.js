/**
 * Created by 한성진 on 24. 5. 10..
 */

import LightningDatatable from 'lightning/datatable';
import imageContainer from './imageContainer.html';

export default class CustomDataTable extends LightningDatatable {

    static customTypes = {
        image: {
            template: imageContainer
        }
    };

}