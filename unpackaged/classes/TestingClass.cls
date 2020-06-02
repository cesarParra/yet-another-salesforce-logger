public with sharing class TestingClass {
    @AuraEnabled
    public static void callLogger() {
        Logger.debug('Test message');
    }
}