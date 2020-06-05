public with sharing class PlatformEventLog extends LoggerBase {
  protected override void commitLogs() {
    List<LogEvent__e> events = new List<LogEvent__e>();

    for (SingleLog log : logs) {
      events.add(
        new LogEvent__e(
          ApexClass__c = log.LastTrace != null ? log.LastTrace.ClassName : null,
          ApexMethod__c = log.LastTrace != null ? log.LastTrace.MethodName : null,
          LineNumber__c = log.LastTrace != null ? log.LastTrace.LineNumber : null,
          ColumnNumber__c = log.LastTrace != null ? log.LastTrace.ColumnNumber : null,
          LoggingLevel__c = log.Level.name().toLowerCase().capitalize(),
          Body__c = log.Message,
          DisplayType__c = log.DisplayType,
          UserId__c = UserInfo.getUserId()
        )
      );
    }

    if (events.isEmpty()) {
      return;
    }
    publishEvents(events);
  }

  @TestVisible
  private Boolean eventPublished = false;
  private void publishEvents(List<LogEvent__e> events) {
    if (Test.isRunningTest()) {
      eventPublished = true;
      return;
    }
    EventBus.publish(events);
  }
}
