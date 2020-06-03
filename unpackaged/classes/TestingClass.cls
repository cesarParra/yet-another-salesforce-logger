public with sharing class TestingClass {
    @AuraEnabled
    public static void callLogger() {
        Logger.table(new List<SomeTestClass> { new SomeTestClass(), new SomeTestClass() });
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