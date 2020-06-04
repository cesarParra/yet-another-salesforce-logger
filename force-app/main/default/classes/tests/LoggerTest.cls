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
    assertWithLevelAndMessage(loggerImpl, expectedLevel, 'Test message');
  }

  private static void assertWithLevelAndMessage(
    TestLogger loggerImpl,
    LoggingLevel expectedLevel,
    Object expectedMessage
  ) {
    String serializedMessage = JSON.serialize(expectedMessage);
    System.assert(loggerImpl.CommitCalled);
    System.assertNotEquals(null, loggerImpl.Log);
    System.assertEquals(expectedLevel, loggerImpl.Log.Level);
    System.assertEquals(serializedMessage, loggerImpl.Log.Message);
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

  @IsTest
  private static void count_noLabel_expectCountedTowardsDefault() {
    TestLogger loggerImpl = setupMockLogger();
    Logger.count();
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'default: 1');
    Logger.count();
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'default: 2');
  }

  @IsTest
  private static void count_withLabel_expectCountedTowardsLabel() {
    TestLogger loggerImpl = setupMockLogger();
    Logger.count('test');
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'test: 1');
    Logger.count('test');
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'test: 2');
  }

  @IsTest
  private static void countReset_noLabel_defaultReset() {
    TestLogger loggerImpl = setupMockLogger();
    Logger.count();
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'default: 1');
    Logger.countReset();
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'default: 1');
  }

  @IsTest
  private static void countReset_withLabel_expectLabelReset() {
    TestLogger loggerImpl = setupMockLogger();
    Logger.count('test');
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'test: 1');
    Logger.countReset('test');
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, 'test: 1');
  }

  @IsTest
  private static void table_expectLoggerCalled() {
    TestLogger loggerImpl = setupMockLogger();
    List<String> testStrings = new List<String> { 'test' };
    Logger.table(testStrings);
    assertWithLevelAndMessage(loggerImpl, LoggingLevel.DEBUG, testStrings);
  }
}
