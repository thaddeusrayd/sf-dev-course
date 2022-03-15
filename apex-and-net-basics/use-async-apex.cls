// async method for a web service callout
public class MyFutureClass {
    // Include callout=true when making callouts
    @future(callout=true)    
    static void myFutureMethod(Set<Id> ids) {
        // Get the list of contacts in the future method since
        // you cannot pass objects as arguments to future methods
        List<Contact> contacts = [SELECT Id, LastName, FirstName, Email
            FROM Contact WHERE Id IN :ids];
        // Loop through the results and call a method
        // which contains the code to do the actual callout
        for (Contact con: contacts) {
            String response = anotherClass.calloutMethod(con.Id,
                con.FirstName,
                con.LastName,
                con.Email);
            // May want to add some code here to log
            // the response to a custom object
        }
    }
}

//
// batch/scheduled apex
global class MyBatchableClass implements
            Database.Batchable<sObject>,
            Database.Stateful {  
    // Used to record the total number of Accounts processed
    global Integer numOfRecs = 0;
    // Used to gather the records that will be passed to the interface method
    // This method will only be called once and will return either a
    // Database.QueryLocator object or an Iterable that contains the records
    // or objects passed to the job.            
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');                
    }
    // This is where the actual processing occurs as data is chunked into
    // batches and the default batch size is 200.
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            // Do some processing here
            // and then increment the counter variable
            numOfRecs = numOfRecs + 1;
        }     
    }
    // Used to execute any post-processing that may need to happen. This
    // is called only once and after all the batches have finished.
    global void finish(Database.BatchableContext bc) {
        EmailManager.sendMail('someAddress@somewhere.com',
                              numOfRecs + ' Accounts were processed!',
                              'Meet me at the bar for drinks to celebrate');            
    }
}

// execution:
MyBatchableClass myBatchObject = new MyBatchableClass();
Database.executeBatch(myBatchObject);
