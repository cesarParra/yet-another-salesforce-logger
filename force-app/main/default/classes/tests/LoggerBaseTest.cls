@IsTest
private class LoggerBaseTest {
  private class TestLog extends LoggerBase {
    public Boolean CommitCalled { get; private set; }

    public TestLog() {
      this.CommitCalled = false;
    }

    protected override void commitLogs() {
      this.CommitCalled = true;
    }
  }

  @IsTest
  private static void log_expectLogAdded() {
    TestLog logImpl = new TestLog();
    SingleLog logToAdd = new SingleLog(
      LoggingLevel.DEBUG,
      Tracer.newInstance().getLastTrace(),
      'Test Message'
    );
    logImpl.log(logToAdd);

    System.assertEquals(1, logImpl.logs.size());
    System.assertEquals(logToAdd, logImpl.logs[0]);
  }

  @IsTest
  private static void flush_expectCommitCalledAndLogsCleared() {
    TestLog logImpl = new TestLog();
    SingleLog logToAdd = new SingleLog(
      LoggingLevel.DEBUG,
      Tracer.newInstance().getLastTrace(),
      'Test Message'
    );
    logImpl.log(logToAdd);

    logImpl.flush();

    System.assert(logImpl.CommitCalled);
    System.assert(logImpl.logs.isEmpty());
  }

  @IsTest
  private static void trace_expectLog() {
    TestLog logImpl = new TestLog();
    logImpl.trace();

    System.assertEquals(1, logImpl.logs.size());
  }
}
