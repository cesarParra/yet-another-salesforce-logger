public with sharing class TestingClass {
    @AuraEnabled
    public static void callLogger() {
        Logger.warn('Some warning');
    }

    public class SomeTestClass {
        public String Name { get; private set; }
        public Integer TestInt { get; private set; }

        public SomeTestClass() {
            this.Name = 'some name';
            this.TestInt = 5;
        }
    }
}