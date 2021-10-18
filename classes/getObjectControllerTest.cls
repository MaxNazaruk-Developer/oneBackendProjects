@isTest
public with sharing class getObjectControllerTest {
    public class dataObject{        
        public String label;
        public String value;
        public String keyPrefix;
    }

    public class objectField{
        public String label;
        public String name;
        public Boolean accessible;
        public Boolean compound;
        public String type;
        public String relationshipName;
    }

    @isTest
    public static void getObjectTest() {
        Map<String, Schema.SObjectType> getAllObjectWithOrg = Schema.getGlobalDescribe();
        List<dataObject> arraySelectObject = new List<dataObject>();
        for (String nameObjcet : getAllObjectWithOrg.keySet()) {            
            SObjectType oneObject = Schema.getGlobalDescribe().get(nameObjcet);                        
            Schema.DescribeSObjectResult objectDescription = oneObject.getDescribe();              
            if(objectDescription.isSearchable() == true) {
                dataObject wrapperObj = new dataObject();
                wrapperObj.label = objectDescription.getLabel();
                wrapperObj.value = objectDescription.getName();
                wrapperObj.keyPrefix = objectDescription.getKeyPrefix();                               
                arraySelectObject.add(wrapperObj);                               
            }
        }                             
        String valueTest = JSON.serialize(arraySelectObject);       
            
        Test.startTest();
        String valueController = getObjectController.getObject();
        Test.stopTest();
            
        System.assertEquals(valueTest, valueController);
    }

    @IsTest
    public static void getInformationAbouttSobjectTest(){
        List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
        List<Schema.DescribeTabResult> tabDesc = new List<Schema.DescribeTabResult>();
        List<Schema.DescribeIconResult> iconDesc = new List<Schema.DescribeIconResult>();
        for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
            tabDesc.addAll(tsr.getTabs());
        }
        for(Schema.DescribeTabResult tr : tabDesc) {
            if (tr.getSobjectName() == 'Contact') {
                iconDesc.addAll(tr.getIcons());                
            }
        }
        String urlAddressImag;
        for (Schema.DescribeIconResult ir : iconDesc) {           
            if (ir.getContentType() == 'image/svg+xml'){
                urlAddressImag = ir.getUrl();
                urlAddressImag = urlAddressImag.substringBetween('https://maksdeveloper-dev-ed.my.salesforce.com','.svg');                 
                break;
            }
        }        
        String valueTest = urlAddressImag + '_120.png';
        Test.startTest();
        String valueController = getObjectController.getInformationAbouttSobject('Contact');
        Test.stopTest();
        System.assertEquals(valueTest, valueController);
    }

    @IsTest
    public static void getFieldsObjectTest(){
        SObjectType oneObject = Schema.getGlobalDescribe().get('Contact');
        Map<String,Schema.SObjectField> mapfields = oneObject.getDescribe().fields.getMap();
        List<objectField> listDescribField = new List<objectField>();       
        for (Schema.SObjectField field : mapfields.values()) {            
            Schema.DescribeFieldResult describingField = field.getDescribe();
            objectField fieldOneObject = new objectField();
            fieldOneObject.label = describingField.getLabel();
            fieldOneObject.name = describingField.getName();
            fieldOneObject.accessible = describingField.isAccessible();
            fieldOneObject.compound = describingField.isNameField();
            fieldOneObject.type = describingField.getType().name();
            fieldOneObject.relationshipName = describingField.getRelationshipName();
            listDescribField.add(fieldOneObject);            
        }                         
        String valueTest = JSON.serialize(listDescribField);
        Test.startTest();
        String valueController = getObjectController.getFieldsObject('Contact');
        Test.stopTest();
        System.assertEquals(valueTest, valueController);
    }
}
