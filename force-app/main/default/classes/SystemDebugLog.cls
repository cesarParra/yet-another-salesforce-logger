public class SystemDebugLog extends LoggerBase {
    public override void commitLogs() {
        for (SingleLog log : logs) {
            System.debug(log.Level, getFormattedMessage(log));
        }
    }
}