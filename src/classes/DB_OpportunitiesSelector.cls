global virtual class DB_OpportunitiesSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Opportunity.amount,
                Opportunity.closeDate,
                Opportunity.id,
                Opportunity.name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Opportunity.sObjectType;
    }

    global virtual List<Opportunity> selectById(Set<Id> idSet) {
        return (List<Opportunity>) selectSObjectsById(idSet);
    }

    public virtual List<Opportunity> selectWithAccountsById(List<Id> idList) {
        fflib_QueryFactory queryFactory = newQueryFactory();
        new DB_AccountsSelector().configureQueryFactoryFields(queryFactory, 'accountId');
        return (List<Opportunity>) Database.query(
                queryFactory.setCondition('id IN :idList').toSOQL()
        );
    }  
}