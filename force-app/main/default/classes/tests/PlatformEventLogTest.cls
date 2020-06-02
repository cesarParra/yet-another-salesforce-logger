@IsTest
private class PlatformEventLogTest {
  @IsTest
  private static void noLogs_expectNothingPublished() {
    PlatformEventLog log = new PlatformEventLog();
    log.flush();

    System.assert(!log.eventPublished);
  }

  @IsTest
  private static void withLogs_expectEventsPublished() {
    PlatformEventLog log = new PlatformEventLog();
    log.log(new SingleLog(LoggingLevel.DEBUG, Tracer.newInstance().getLastTrace(), 'Test Message'));
    log.flush();

    System.assert(log.eventPublished);
  }
}
