// create an sObject - declare a variable and assign an sObject to it
Account acct = new Account(Name='Acme'); // sObject of type Account with name Acme and assigned to <acct>

// dot notation to add fields to an sObject
acct.Phone = '(415)555-1212';
acct.NumberOfEmployees = 100;

// generic sObject data type can reference any salesforce record, regardless of type:
sObject sobj1 = new Account(Name='Trailhead');
sObject sobj2 = new Book__c(Name='Workbook 1');

// note: dot notation not availabel on generic sObject
// but you can *cast* a generic to a specific:
Account acct = (Account)myGenericSObject;
// Now, you can use the dot notation to access fields on Account
String name = acct.Name;
String phone = acct.Phone;

// the fields of generic sObjects can only be accessed with put() and get()