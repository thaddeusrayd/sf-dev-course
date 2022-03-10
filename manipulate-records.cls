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