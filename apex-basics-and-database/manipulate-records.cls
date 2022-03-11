// create account object
Account acct = new Account(Name='Acme', Phone='(415)555-1212', NumberOfEmployees=100);
// insert the account by using DML
insert acct;
// get new ID on the inserted sObject argument
ID acctID = acct.Id;
// display this id in the debug log
System.debug('ID = ' + acctId)

//
// bulk DML
// create a list of contacts
List<Contact> conList = new List<Contact> {
    new Contact(FirstName='Kathy',LastName='Smith',Department='Technology')
    new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
    new Contact(FirstName='Kim',LastName='Shain',Department='Education');
}
// bulk insert all contacts with one DML call
insert conList;
// List to hold the new contacts to update
List<Contact> listToUpdate = new List<Contact>();
// iterate thru list and add title only if dept is Finance
for (Contact con : conList) {
    if (con.Department = 'Finance') {
        con.Title = 'Financial Analyst';
        // add updated contact sObject to the list
        listToUpdate.add(con);
    }
}
// bulk update all contacts with one DML call
update listToUpdate;

//
// upsert
// to upsert MyExternalId field:
upsert sObjectList Account.Fields.MyExternalId;
// upsert uses primary key (ID), idLookupField, or external id field 
// to determine whether to insert or to update

// example that updates Josh and inserts Kathy:
// insert Josh contact
Contact josh = new Contact(FirstName='Josh',LastName='Kaplan',Department='Finance');
insert josh
// josh has been inserted, so the josh variable now has an id
josh.Description = 'Josh\'s record has been updated by the upsert operation.';
// now create kathy contact, but don't persist in db
Contact kathy = new Contact(FirstName='Kathy',LastName='Brown',Department='Technology');
// list to hold new object for upsertion
List<Contact> contacts = new List<Contact> {josh, kathy};
// call upsert
upsert contacts;
// josh is updated and kathy is inserted

// you can also specify a field to be used for matching:
Contact jane = new Contact(FirstName='Jane',
                         LastName='Smith',
                         Email='jane.smith@example.com',
                         Description='Contact of the day');
insert jane;
// 1. upsert using an idLookup field
// create a second sObject variable
// this variable doesn't have any id set
Contact jane2 = new Contact(FirstName='Jane',
                         LastName='Smith',  
                         Email='jane.smith@example.com',
                         Description='Prefers to be contacted by email.');
// upsert contact by using idLookup
upsert jane2 Contact.fields.Email;
// verify
System.assertEquals('Prefers to be contacted by email.', 
    [SELECT Description FROM Contact WHERE Id=:jane.Id].Description))

//
// delete
// delete all contacts with last name smith:
Contact[] contactsDel = [SELECT Id FROM Contact WHERE LastName='Smith']; 
delete contactsDel;

//
// dml exception - dml operation failure
try {
    // This causes an exception because 
    //   the required Name field is not provided.
    Account acct = new Account();
    // Insert the account 
    insert acct;
} catch (DmlException e) {
    System.debug('A DML exception has occurred: ' + e.getMessage());
}

//
// allOrNone
// calling insert with allOrNone set to false:
Database.insert(recordList, false);

//
// bulk dml example, but with db methods instead:
// Create a list of contacts
List<Contact> conList = new List<Contact> {
        new Contact(FirstName='Joe',LastName='Smith',Department='Finance'),
        new Contact(FirstName='Kathy',LastName='Smith',Department='Technology'),
        new Contact(FirstName='Caroline',LastName='Roth',Department='Finance'),
        new Contact()};
// Bulk insert all contacts with one DML call
Database.SaveResult[] srList = Database.insert(conList, false);
// Iterate through each returned result
for (Database.SaveResult sr : srList) {
    if (sr.isSuccess()) {
        // Operation was successful, so get the ID of the record that was processed
        System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
    } else {
        // Operation failed, so get all errors
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Contact fields that affected this error: ' + err.getFields());
	 }
    }
}

//
// insert related records by foreign key:
Account acct = new Account(Name='SFDC Account');
insert acct;
// Once the account is inserted, the sObject will be 
// populated with an ID.
// Get this ID.
ID acctID = acct.ID;
// Add a contact to this account.
Contact mario = new Contact(
    FirstName='Mario',
    LastName='Ruiz',
    Phone='415.555.1212',
    AccountId=acctID);
insert mario;

//
// update related records:
// Query for the contact, which has been associated with an account.
Contact queriedContact = [SELECT Account.Name 
                          FROM Contact 
                          WHERE FirstName = 'Mario' AND LastName='Ruiz'
                          LIMIT 1];
// Update the contact's phone number
queriedContact.Phone = '(415)555-1213';
// Update the related account industry
queriedContact.Account.Industry = 'Technology';
// Make two separate calls 
// 1. This call is to update the contact's phone.
update queriedContact;
// 2. This call is to update the related account's Industry field.
update queriedContact.Account; 

// 
// delete related record
Account[] queriedAccounts = [SELECT Id FROM Account WHERE Name='SFDC Account'];
delete queriedAccounts;