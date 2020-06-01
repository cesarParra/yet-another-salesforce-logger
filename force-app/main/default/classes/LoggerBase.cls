public abstract class LoggerBase {
  @TestVisible
  protected List<SingleLog> logs = new List<SingleLog>();

  public virtual void log(SingleLog log) {
    logs.add(log);
  }

  public virtual void flush() {
    commitLogs();
    logs.clear();
  }

  protected abstract void commitLogs();

  public virtual void trace() {
    String trace = Tracer.newInstance().getTrace(new Set<String> { Logger.class.getName(), LoggerBase.class.getName() });
    trace = 'TRACE::' + trace;
    this.log(new SingleLog(LoggingLevel.DEBUG, null, trace));
  }
}
