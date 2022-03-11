// trigger syntax:
trigger TriggerName on ObjectName (trigger_events) {
   code_block
}

// modified version of hello world trigger from exercise:
trigger HelloWorldTrigger on Account (before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
    }   
}
// before a new account is added, this trigger gives each item a Description

