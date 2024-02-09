@IsTest
public with sharing class UtilsTest {
    @IsTest
    public static void testFindObject() {
        List<Account> loans = new List<Account>{
            new Account(Name = 'one', AccountNumber = 'uno'),
            new Account(Name = 'two', AccountNumber = 'dos'),
            new Account(Name = 'three', AccountNumber = 'tres')
        };
        Loan__c retrieved = (Loan__c) Utils.findObject(loans, 'Name', 'two');
        System.assertEquals('dos', retrieved.AccountNumber);
        retrieved = (Loan__c) Utils.findObject(loans, 'Name', 'four');
        System.assertEquals(null, retrieved);
    }
}
