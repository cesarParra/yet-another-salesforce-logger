public class SystemDebugLog extends LoggerBase {
  private String MESSAGE_FORMAT = '{0}.{1}: {2}';
  private DebugLogger loggerImplementation = new SystemDebugLogger();

  public override void commitLogs() {
    for (SingleLog log : logs) {
      loggerImplementation.debug(log.Level, getFormattedMessage(log));
    }
  }

  private String getFormattedMessage(SingleLog log) {
    if (log.LastTrace == null) {
      return log.Message;
    }

    String className = log.LastTrace.ClassName == null ? '' : log.LastTrace.ClassName;
    String methodName = log.LastTrace.MethodName == null ? '' : log.LastTrace.MethodName;
    String message = log.Message == null ? '' : log.Message;
    return String.format(
      MESSAGE_FORMAT,
      new List<String>{ className, methodName, message }
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
