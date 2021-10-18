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
        Test.startTest();
        String valueController = getObjectController.getObject();
        Test.stopTest();
        
        List<dataObject> allObject = (List<dataObject>) JSON.deserialize(valueController, List<dataObject>.class);
        for (dataObject variable : allObject) {
            if (variable.value == 'Account') {
                System.assertEquals(variable.label, 'Account', 'Verification of received objects');                          
            }
        }      
    }

    @IsTest
    public static void getInformationAbouttSobjectTest(){
        Test.startTest();
        String valueControllerContact = getObjectController.getInformationAbouttSobject('Contact');
        String valueControllerTask = getObjectController.getInformationAbouttSobject('Task');        
        Test.stopTest();

        System.assertEquals(valueControllerContact, '/img/icon/t4v35/standard/contact_120.png');
        System.assertEquals(valueControllerTask, 'null_120.png');
    }

    @IsTest
    public static void getFieldsObjectTest(){
        Test.startTest();
        String valueController = getObjectController.getFieldsObject('Account');
        Test.stopTest();
        
        List<objectField> contactFields = (List<objectField>) JSON.deserialize(valueController, List<objectField>.class);         
        for (objectField variable : contactFields) {
            if (variable.name == 'Id') {
                System.assertEquals(variable.label, 'Account ID', 'Checking the received object fields');
                
            }
        }       
    }
}
