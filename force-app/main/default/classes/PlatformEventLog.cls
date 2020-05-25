/**
 * @description
 */
public with sharing class PlatformEventLog extends LoggerBase {
    protected override void commitLogs() {
        List<LogEvent__e> events = new List<LogEvent__e>();

        for (SingleLog log : logs) {
            events.add(new LogEvent__e(
                    ApexClass__c = log.ApexClass,
                    LoggingLevel__c = log.Level.name().toLowerCase().capitalize(),
                    Body__c = log.Message,
                    UserId__c = UserInfo.getUserId()
            ));
        }

        EventBus.publish(events);
    }
}