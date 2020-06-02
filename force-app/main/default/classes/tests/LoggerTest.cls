@IsTest
private class LoggerTest {
  private class TestLogger extends LoggerBase {
    public Boolean CommitCalled { get; private set; }
    public SingleLog Log { get; private set; }
    public Boolean TraceCalled { get; private set; }
    public TestLogger() {
      CommitCalled = false;
      TraceCalled = false;
    }

    public override void log(SingleLog log) {
      this.Log = log;
    }

    public override void trace() {
      this.TraceCalled = true;
    }

    public override void commitLogs() {
      CommitCalled = true;
    }
  }

  private static TestLogger setupMockLogger() {
    TestLogger loggerImpl = new TestLogger();
    Logger.setLoggers(new List<LoggerBase>{ loggerImpl });
    return loggerImpl;
  }

  private static void assertWithLevel(
    TestLogger loggerImpl,
    LoggingLevel expectedLevel
  ) {
    System.assert(loggerImpl.CommitCalled);
    System.assertNotEquals(null, loggerImpl.Log);
    System.assertEquals(expectedLevel, loggerImpl.Log.Level);
    System.assertEquals('Test message', loggerImpl.Log.Message);
  }

  @IsTest
  private static void debug_withMessage_expectLogged() {
    TestLogger loggerImpl = setupMockLogger();

    Logger.debug('Test message');

    assertWithLevel(loggerImpl, LoggingLevel.DEBUG);
  }

  @IsTest
  private static void info_withMessage_expectLogged() {
    TestLogger loggerImpl = setupMockLogger();

    Logger.info('Test message');

    assertWithLevel(loggerImpl, LoggingLevel.INFO);
  }

  @IsTest
  private static void warn_withMessage_expectLogged() {
    TestLogger loggerImpl = setupMockLogger();

    Logger.warn('Test message');

    assertWithLevel(loggerImpl, LoggingLevel.WARN);
  }

  @IsTest
  private static void error_withMessage_expectLogged() {
    TestLogger loggerImpl = setupMockLogger();

    Logger.error('Test message');

    assertWithLevel(loggerImpl, LoggingLevel.ERROR);
  }

  @IsTest
  private static void trace_expectLoggerTraceCalled() {
    TestLogger loggerImpl = setupMockLogger();

    Logger.trace();

    System.assert(loggerImpl.TraceCalled);
  }
}
