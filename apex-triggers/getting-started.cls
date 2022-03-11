// trigger syntax:
trigger TriggerName on ObjectName (trigger_events) {
   code_block
}

// modified version of hello world trigger with context variables (Trigger.New/Old):
trigger HelloWorldTrigger on Account (before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
    }   
}
// before a new account is added, this trigger gives each item a Description

// Boolean context variables (Trigger.isInsert/isBefore/isAfter/isDelete):
trigger ContextExampleTrigger on Account (before insert, after insert, after delete) {
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            // Process before insert
        } else if (Trigger.isAfter) {
            // Process after insert
        }        
    }
    else if (Trigger.isDelete) {
        // Process after delete
    }
}