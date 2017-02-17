public class DB_AccountsSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Account.name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
}