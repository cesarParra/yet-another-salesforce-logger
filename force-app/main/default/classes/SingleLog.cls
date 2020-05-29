public class SingleLog {
  public LoggingLevel Level { get; private set; }
  public String ApexClass { get; private set; }
  public String Message { get; private set; }

  public SingleLog(LoggingLevel level, String apexClass, String message) {
    this.Level = level;
    this.ApexClass = apexClass;
    this.Message = message;
  }
}
