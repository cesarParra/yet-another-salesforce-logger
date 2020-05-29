@IsTest
private class SingleLogTest {
  @IsTest
  private static void constructor_canConstruct() {
    SingleLog log = new SingleLog(
      LoggingLevel.DEBUG,
      'TestClassName',
      'Test message'
    );
    System.assertEquals(LoggingLevel.DEBUG, log.Level);
    System.assertEquals('TestClassName', log.ApexClass);
    System.assertEquals('Test message', log.Message);
  }
}
