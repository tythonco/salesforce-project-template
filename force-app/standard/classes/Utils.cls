/**
 * A class to store utility methods.
 */
public with sharing class Utils {
    /**
     * Return the object that stores criterion in the field name, returnning null if none
     * exist
     * @param  objects   A list of objects to search through
     * @param  field     The field to search
     * @param  criterion The data to look for
     * @return The first object that matches the criterion
     */
    public static SObject findObject(
        List<SObject> objects,
        String field,
        Object criterion
    ) {
        for (SObject obj : objects) {
            if (obj.get(field) == criterion) {
                return obj;
            }
        }
        return null;
    }
    
    /**
     * Tests are generically conduscted with triggers disabled, but trigger tests need triggers
     * enabled. This allows the insertion of a single record while ensuring that triggers are
     * enabled.
     * @param  obj obj description
     */
    public static void insertWithEnabledTriggers(SObject obj) {
        Triggers.disabled = false;
        Test.startTest();
        insert obj;
        Test.stopTest();
        Triggers.disabled = true;
    }
}