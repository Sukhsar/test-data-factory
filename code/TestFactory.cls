@isTest 
public class TestFactory {    
    
    public static SObject createSObject(SObject sObj) {
        String objectName = String.valueOf(sObj.getSObjectType());
        String defaultClassName = 'TestFactory.' + 
            objectName.replaceAll('__e|__mdt|__c|__|_', '') + 'Defaults';
        if(Type.forName(defaultClassName) != null) {
            sObj = createSObject(sObj, defaultClassName);
        }
        return sObj;
    }
    
    public static SObject createSObject(SObject sObj, Boolean doInsert) {
        SObject retObject = createSObject(sObj);
        if(doInsert) {
            insert retObject;
        }
        return retObject;
    }
    
    public static SObject createSObject(SObject sObj, String defaultClassName) {
        Type t = Type.forName(defaultClassName);
        if(t == null) {
            throw new Error.InvalidClassException('Invalid default class.');
        } 
        FieldDefaults defaults = (FieldDefaults)t.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }
    
    public static SObject createSObject(SObject sObj, String defaultClassName, Boolean doInsert) {
        SObject retobject = createSObject(sObj, defaultClassName);
        if(doInsert) {
            insert retObject;
        }
        return retObject;
    }
    
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, (String) null);
    }
    
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, Boolean doInsert) {
        SObject[] retList = createSObjectList(sObj, numberOfObjects, (String)null);
        if(doInsert) {
            insert retList;
        }
        return retList;
    }
    
    public static SObject[] createSObjectList(SObject sObj, Integer numberOfObjects, String defaultClassName) {
        SObject[] sObjs = new SObject[] {};
        SObject newObj;
        if(DefaultClassName == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClassName);
        }
        // Get the name field for the object
        String nameField = nameFieldMap.get(String.valueOf(sObj.getSObjectType()));
        if(nameField == null) {
            nameField = 'Name';
        }
        Boolean nameIsAutoNumber = sObj.getSObjectType()
                .getDescribe()
                .fields.getMap()
                .get(nameField)
                .getDescribe()
                .isAutoNumber();
        // Clone the object the number of times requested. Increament the name field so each recode is unique
        for(Integer i = 1; i <= numberOfObjects; i++) {
            SObject clonedSObj  = newObj.clone(false, true);
            if (!nameIsAutoNumber) {
                clonedSObj.put(nameField, (String)clonedSObj.get(nameField) + '-' + i);
            }
            sObjs.add(clonedSObj);
        }
        return sObjs;
    }
    
    private static void addFieldDefaults(SObject sObj, Map<String, Object> defaults) {
        // Loop through the map of fields and if they are numm on the object, fill them.
        for(String field : defaults.keySet()) {
            if(sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
    }
    
    // When we create a list of SObjects, we need to
    private static Map<String, String> nameFieldMap = new Map<String, String> {
        String.ValueOf(Contact.SObjectType) => String.ValueOf(Contact.LastName),
        String.valueOf(Case.SObjectType) => String.valueOf(Case.Subject), //this is the autonumber field
        String.valueOf(User.SObjectType) => String.valueOf(User.LastName)
    };
        
	// Use the FieldDefaults inteface to set up values you want to default in for all objects.
	public interface FieldDefaults {
        Map<String, Object> getFieldDefaults();
    }    
    
    // To specify defautls for objects, use the naming convention [ObjectName]Defaults.
    // For custom objects, omit the __c from the Object Name
    
    public class AccountDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
				'Name' => 'Test Account',
                'Migration_Flag__c' => 'No',
                'Sector__c' => 'Pub',
                'customer_Type__c' => 'INDEPENDENT'
			};
        }
    }
    
    public class ContactDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
		
            return new Map<String, Object> {
				'LastName' => 'LastName',
                'Email' => 'test@test.com'    
			};
        }
    }
    
    public class LeadDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Company' => 'Test Lead',
                'FirstName' => 'TestFirstName',
                'LastName' => 'TestLastName',
                'Status' => 'New'
            };
        }
    }
    
    public class CampaignDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Campaign',
				'Status' => 'Planned'
            };
        }
    }
    
    public class Pricebook2Defaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Pricebook',
                'UnitPrice' => 100,
                'UseStandardPrice' => false,
                'IsActive' => true
            };
        }
    }
    
    public class PricebookEntryDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Pricebook2Id' => Test.getStandardPricebookId(),
                'UnitPrice' => 100,
                'UseStandardPrice' => false,
                'IsActive' => true
            };
        }
    }
    
    public class Product2Defaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
               'Name' => 'Test Product',
               'Description' => 'Test Product',
                'productCode' => 'ABC',
				'IsActive' => true
            };
        }
    }
    
    public class OpportunityDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
                'Name' => 'Test Opportunity',
				'StageName' => 'Closed Won',
				'CloseDate' => System.today().addDays(7)
            };
        }
    }
    
    public class CaseDefaults implements FieldDefaults {
        public Map<String, Object> getFieldDefaults() {
            return new Map<String, Object> {
				'Subject' => 'Test Case'
			};
        }
    }
}
