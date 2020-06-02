@IsTest
private class SystemDebugLogTest {
  @IsTest
  private static void noLogs_nothingLogged() {
    SystemDebugLog log = new SystemDebugLog();
    TestDebugLogger logger = new TestDebugLogger();
    log.setDebugLogger(logger);

    log.flush();

    System.assert(!logger.DebugCalled);
  }

  @IsTest
  private static void withLogs_debugCalled() {
    SystemDebugLog log = new SystemDebugLog();
    log.log(new SingleLog(LoggingLevel.DEBUG, Tracer.newInstance().getLastTrace(), 'Test Message'));
    TestDebugLogger logger = new TestDebugLogger();
    log.setDebugLogger(logger);

    log.flush();

    System.assert(logger.DebugCalled);
  }

  private class TestDebugLogger implements SystemDebugLog.DebugLogger {
    public Boolean DebugCalled = false;
    public void debug(LoggingLevel level, Object message) {
      DebugCalled = true;
    }
  }
}
