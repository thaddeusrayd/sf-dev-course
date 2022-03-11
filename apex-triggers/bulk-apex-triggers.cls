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