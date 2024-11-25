trigger totalContacts on Contact (after insert,after delete, after update) {
    Set<Id> IdsToUpdate = new Set<Id>();
    if(trigger.isInsert || trigger.isUpdate){
        for(Contact con : trigger.new){
            if(con.AccountId != null){
                IdsToUpdate.add(con.AccountId);
            }
        }
    }
    if(trigger.isDelete){
        for(Contact con : trigger.old){
            if(con.AccountId != null){
                IdsToUpdate.add(con.AccountId);
            }
        }
    }
    List<Account> accToUpdate = new List<Account>();
    for(Account acc : [SELECT Id , Total_Contacts_Count__c , (SELECT Id FROM Contacts) FROM Account WHERE Id IN : IdsToUpdate]){
        Integer contactCount = acc.Contacts.size();
        acc.Total_Contacts_Count__c = contactCount;
        accToUpdate.add(acc);
    }
    if(!accToUpdate.isEmpty()){
        update accToUpdate;
    }
}