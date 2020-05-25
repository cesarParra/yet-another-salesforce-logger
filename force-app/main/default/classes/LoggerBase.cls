public abstract class LoggerBase {
    private String MESSAGE_FORMAT  = '{0}: {1}';
    private String TRACE_SEPARATOR = '\n';

    protected List<SingleLog> logs = new List<SingleLog>();

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

    public virtual void log(SingleLog log) {
        logs.add(log);
    }

    public virtual void flush() {
        commitLogs();
        logs.clear();
    }

    protected abstract void commitLogs();

    public virtual void trace() {
        try {
            // getStackTraceString does not work for custom exception, so we are throwing a built-in one.
            //https://success.salesforce.com/issues_view?id=a1p300000008dVIAAY&title=exception-getstacktracestring-does-not-work-for-custom-exceptions-with-spring-16
            throw new StringException('TRACE EXCEPTION');
        } catch(Exception e) {
            List<String> traceCalls = e.getStackTraceString().split('\n');
            if (traceCalls.isEmpty()) {
                return;
            }

            if (traceCalls.size() > 2) {
                // We remove the first 2 items since that is the calls to .trace itself (the static entry-point
                // and the concrete implementation of the interface.
                traceCalls.remove(0);
                traceCalls.remove(0);
            }

            String trace = String.join(traceCalls, TRACE_SEPARATOR);
            trace = 'TRACE::' + trace;
            this.log(new SingleLog(LoggingLevel.DEBUG, null, trace));
        }
    }

    protected String getFormattedMessage(SingleLog log) {
        String apexClass = log.ApexClass == null ? '' : log.ApexClass;
        return String.format(MESSAGE_FORMAT, new List<String> { apexClass, log.Message });
    }
}