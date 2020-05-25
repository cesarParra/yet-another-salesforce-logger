@IsTest
private class LoggerTest {
    private class TestLogger extends LoggerBase {
        public Boolean CommitCalled { get; private set; }
        public SingleLog Log { get; private set; }
        public TestLogger() {
            CommitCalled = false;
        }

        public override void log(SingleLog log) {
            this.Log = log;
        }

        public override void commitLogs() {
            CommitCalled = true;
        }
    }

    @IsTest
    private static void debug_withClass_expectLogged() {
        TestLogger loggerImpl = new TestLogger();
        Logger.setLoggers(new List<LoggerBase> { loggerImpl });

        Logger.debug(LoggerTest.class, 'Test message');

        System.assert(loggerImpl.CommitCalled);
        System.assertNotEquals(null, loggerImpl.Log);
        System.assertEquals(LoggerTest.class.getName(), loggerImpl.Log.ApexClass);
        System.assertEquals(LoggingLevel.DEBUG, loggerImpl.Log.Level);
        System.assertEquals('Test message', loggerImpl.Log.Message);
    }
}