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

// if using a callout with a trigger, it must be done asynchronously, using @future():
public class CalloutClass {
    @future(callout=true)
    public static void makeCallout() {
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'http://yourHost/yourService';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        HttpResponse response = new HTTP().send(request);
    }
}

// and here is the trigger for it:
trigger CalloutTrigger on Account (before insert, before update) {
    CalloutClass.makeCallout();
}