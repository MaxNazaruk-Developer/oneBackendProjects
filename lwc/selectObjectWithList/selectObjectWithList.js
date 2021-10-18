import { LightningElement, wire, track } from 'lwc';
import getObject from '@salesforce/apex/getObjectController.getObject';
import getInformationAbouttSobject from '@salesforce/apex/getObjectController.getInformationAbouttSobject';
import getFieldsObject from '@salesforce/apex/getObjectController.getFieldsObject';

const columns = [
    { label: 'Label', fieldName: 'label' },
    { label: 'Name', fieldName: 'name'},
    { label: 'Accessible', fieldName: 'accessible'},
    { label: 'Compound', fieldName: 'compound'},
    { label: 'Type', fieldName: 'type'},
    { label: 'Relationship Name', fieldName: 'relationshipName'},
];
export default class SelectObjectWithList extends LightningElement {
    @track dataCombobox =[];
    showIconBlock = false;
    urlIcon;
    @track data = [];
    columns = columns;
    showIcon = true;   

    value;    
    dataResultGetObject = [];       
    editObject;

    get options() {        
        return this.dataCombobox;        
    }

    @wire(getObject) 
    objectData(result) {       
        const {data,error} = result;
        if (data) {                      
            this.dataResultGetObject = JSON.parse(data);            
            let currentData = [];            
            this.dataResultGetObject.forEach( row => {
                let rowData = {};                                
                rowData={
                    label : row.label,
                    value : row.value,
                    keyPrefix : row.keyPrefix
                };              
                currentData.push(rowData);                
            });            
            this.dataCombobox = currentData.sort(function(a, b) {
                if (a.label > b.label) {
                  return 1; }
                if (a.label < b.label) {
                  return -1; }
                return 0;
            });                        
        }       
    }

    handleChange(event) {               
        this.editObject = this.dataCombobox.find(
            item => item.value == event.detail.value
        );        
        getInformationAbouttSobject({ 
            nameSelectObject: this.editObject.value 
        }).then(result => {            
                if (result == "null_120.png") {
                    this.showIcon = false;
                    this.urlIcon = result;
                } else {                    
                    this.urlIcon = result;
                    this.showIcon = true;
                }                
            })            
        this.callControllerForDataGetFields(this.editObject.value);
        this.showIconBlock = true;                    
    }     

    callControllerForDataGetFields(valueObject) {        
        getFieldsObject({ 
            nameSelectObjectForField: valueObject
        }).then(result => {            
            this.data = JSON.parse(result).sort(function(a, b) {
                if (a.label > b.label) {
                  return 1; }
                if (a.label < b.label) {
                  return -1; }
                return 0;
            });                                    
        })        
    }
}