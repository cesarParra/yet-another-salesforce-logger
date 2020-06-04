@IsTest
private class SingleLogTest {
  @IsTest
  private static void constructor_canConstruct() {
    Tracer.Trace lastTrace = Tracer.newInstance().getLastTrace();
    SingleLog log = new SingleLog(
      LoggingLevel.DEBUG,
      lastTrace,
      'Test message'
    );
    System.assertEquals(LoggingLevel.DEBUG, log.Level);
    System.assertEquals(lastTrace, log.LastTrace);
    System.assertEquals('Test message', log.Message);
    System.assertEquals('standard', log.DisplayType);
  }

  @IsTest
  private static void constructor_displayTypeOverload_canConstruct() {
    Tracer.Trace lastTrace = Tracer.newInstance().getLastTrace();
    SingleLog log = new SingleLog(
      LoggingLevel.DEBUG,
      lastTrace,
      'Test message',
      'table'
    );
    System.assertEquals(LoggingLevel.DEBUG, log.Level);
    System.assertEquals(lastTrace, log.LastTrace);
    System.assertEquals('Test message', log.Message);
    System.assertEquals('table', log.DisplayType);
  }
}
