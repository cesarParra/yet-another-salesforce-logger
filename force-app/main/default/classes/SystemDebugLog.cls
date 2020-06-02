public class SystemDebugLog extends LoggerBase {
  private String MESSAGE_FORMAT = '{0}.{1}: {2}';
  private DebugLogger loggerImplementation = new SystemDebugLogger();

  public override void commitLogs() {
    for (SingleLog log : logs) {
      loggerImplementation.debug(log.Level, getFormattedMessage(log));
    }
  }

  private String getFormattedMessage(SingleLog log) {
    return String.format(
      MESSAGE_FORMAT,
      new List<String>{ log.LastTrace.ClassName, log.LastTrace.MethodName, log.Message }
    );
  }

  @TestVisible
  private void setDebugLogger(DebugLogger logger) {
    this.loggerImplementation = logger;
  }

  public interface DebugLogger {
    void debug(LoggingLevel level, Object message);
  }

  private class SystemDebugLogger implements DebugLogger {
    public void debug(LoggingLevel level, Object message) {
      System.debug(level, message);
    }
  }
}
