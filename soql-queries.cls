// to include SOQL query, wrap it all in square brackets and assign the return value 
//      to an array of sObjects
// retrieve all Account records with Name and Phone fields:
Account[] accts = [SELECT Name,Phone FROM Account];

// combining optional clauses in one query:
Account[] accts = [SELECT Name,Phone FROM Account 
                   WHERE (Name='SFDC Computing' AND NumberOfEmployees>25)
                   ORDER BY Name
                   LIMIT 10];
System.debug(accts.size() + ' account(s) returned.');
// Write all account array info
System.debug(accts);

//
// access variables in SOQL queries - precede them with : when writing inline 
String targetDepartment = 'Wingo';
Contact[] techContacts = [SELECT FirstName,LastName FROM Contact WHERE Department=:targetDepartment];

//
// query related records
// when accessing a child record related to a parent record, add an inner query for the child:
Account[] acctsWithContacts = [SELECT Name, (SELECT FirstName,LastName FROM Contacts)
                               FROM Account 
                               WHERE Name = 'SFDC Computing'];
// Get child records
Contact[] cts = acctsWithContacts[0].Contacts;
System.debug('Name of first associated contact: ' + cts[0].FirstName + ', ' + cts[0].LastName);

// traverse a relationship from child to parent with dot notation:
Contact[] cts = [SELECT Account.Name FROM Contact WHERE FirstName = 'Carol' AND LastName='Ruiz'];
Contact carol = cts[0];
String acctName = carol.Account.Name;
System.debug('Carol\'s account name is ' + acctName);