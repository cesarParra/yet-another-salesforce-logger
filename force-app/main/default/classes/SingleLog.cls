public class SingleLog {
  public LoggingLevel Level { get; private set; }
  public Tracer.Trace LastTrace { get; private set; }
  public String Message { get; private set; }

  public SingleLog(LoggingLevel level, Tracer.Trace lastTrace, String message) {
    this.Level = level;
    this.LastTrace = lastTrace;
    this.Message = message;
  }
}
