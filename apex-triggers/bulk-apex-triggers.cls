// single record trigger example:
trigger MyTriggerNotBulk on Account(before insert) {
    Account a = Trigger.New[0];
    a.Description = 'New description';
}

// bulkified version:
trigger MyTriggerBulk on Account(before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
    }
}

// the following should be AVOIDED - it runs a SOQL query inside a loop and thus could result in too many queries:
trigger SoqlTriggerNotBulk on Account(after update) {   
    for(Account a : Trigger.New) {
        // Get child records for each account
        // Inefficient SOQL query as it runs once for each account!
        Opportunity[] opps = [SELECT Id,Name,CloseDate 
                             FROM Opportunity WHERE AccountId=:a.Id];
        
        // Do some other processing
    }
}

// better practice - SOQL query outside of loop:
trigger SoqlTriggerBulk on Account(after update) {  
    // Perform SOQL query once.    
    // Get the accounts and their related opportunities.
    List<Account> acctsWithOpps = 
        [SELECT Id,(SELECT Id,Name,CloseDate FROM Opportunities) 
         FROM Account WHERE Id IN :Trigger.New];
  
    // Iterate over the returned accounts    
    for(Account a : acctsWithOpps) { 
        Opportunity[] relatedOpps = a.Opportunities;  
        // Do some other processing
    }
}

// all related opportunities using WHERE:
trigger SoqlTriggerBulk on Account(after update) {  
    // Perform SOQL query once.    
    // Get the related opportunities for the accounts in this trigger.
    List<Opportunity> relatedOpps = [SELECT Id,Name,CloseDate FROM Opportunity
        WHERE AccountId IN :Trigger.New];
  
    // Iterate over the related opportunities    
    for(Opportunity opp : relatedOpps) { 
        // Do some other processing
    }
}

// condensed further by combining SOQL query and loop:
trigger SoqlTriggerBulk on Account(after update) {  
    // Perform SOQL query once.    
    // Get the related opportunities for the accounts in this trigger,
    // and iterate over those records.
    for(Opportunity opp : [SELECT Id,Name,CloseDate FROM Opportunity
        WHERE AccountId IN :Trigger.New]) {
  
        // Do some other processing
    }
}

//
// new example - bulk dml:
// inefficient:
trigger DmlTriggerNotBulk on Account(after update) {   
    // Get the related opportunities for the accounts in this trigger.        
    List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
        WHERE AccountId IN :Trigger.New];          
    // Iterate over the related opportunities
    for(Opportunity opp : relatedOpps) {      
        // Update the description when probability is greater 
        // than 50% but less than 100% 
        if ((opp.Probability >= 50) && (opp.Probability < 100)) {
            opp.Description = 'New description for opportunity.';
            // Update once for each opportunity -- not efficient!
            update opp;
        }
    }    
}

// same, but with only one dml call:
trigger DmlTriggerBulk on Account(after update) {   
    // Get the related opportunities for the accounts in this trigger.        
    List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
        WHERE AccountId IN :Trigger.New];
          
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    // Iterate over the related opportunities
    for(Opportunity opp : relatedOpps) {      
        // Update the description when probability is greater 
        // than 50% but less than 100% 
        if ((opp.Probability >= 50) && (opp.Probability < 100)) {
            opp.Description = 'New description for opportunity.';
            oppsToUpdate.add(opp);
        }
    }
    
    // Perform DML on a collection
    update oppsToUpdate;
}