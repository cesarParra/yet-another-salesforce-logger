public with sharing class Tracer {
    private String TRACE_SEPARATOR = '\n';

    /**
     * @description Creates an instance of Tracer.
     * @return New instance of Tracer.
     */
    public static Tracer newInstance() {
        return new Tracer();
    }

    public String getTrace() {
        return this.getTrace(new Set<String>());
    }

    public String getTrace(Set<String> classNamesToSkip) {
        classNamesToSkip.add(Tracer.class.getName());
        try {
            // getStackTraceString does not work for custom exception, so we are throwing a built-in one.
            //https://success.salesforce.com/issues_view?id=a1p300000008dVIAAY&title=exception-getstacktracestring-does-not-work-for-custom-exceptions-with-spring-16
            throw new StringException('TRACE EXCEPTION');
        } catch (Exception e) {
            List<String> traceCalls = e.getStackTraceString().split('\n');
            if (traceCalls.isEmpty()) {
                return '';
            }

            List<String> validCalls = new List<String>();
            for (String currentTrace : traceCalls) {
                if (traceContainsAny(currentTrace, classNamesToSkip)) {
                    // Skip the call to this class
                    continue;
                }
                validCalls.add(currentTrace);
            }

            String trace = String.join(validCalls, TRACE_SEPARATOR);
            return trace;
        }
    }

    public List<Trace> getTraces() {
        String traceString = this.getTrace();
        List<Trace> traces = new List<Trace>();
        if (String.isBlank(traceString)) {
            return traces;
        }

        List<String> traceStrings = traceString.split(TRACE_SEPARATOR);
        for (String currentTraceString : traceStrings) {
            traces.add(new Trace(currentTraceString));
        }
        return traces;
    }

    public Trace getLastTrace() {
        List<Trace> traces = this.getTraces();
        return traces[traces.size() - 1];
    }

    private Boolean traceContainsAny(String trace, Set<String> classNamesToMatch) {
        for (String currentClassName : classNamesToMatch) {
            if (trace.containsIgnoreCase('Class.' + currentClassName + '.')) {
                return true;
            }
        }
        return false;
    }

    public class Trace {
        public String ClassName { get; private set; }
        public String MethodName { get; private set; }
        public Integer LineNumber { get; private set; }
        public Integer ColumnNumber { get; private set; }

        public Trace(String traceString) {
            // Parsing string into method
            if (String.isBlank(traceString)) {
                return;
            }

            traceString = traceString.remove('Class.');
            List<String> traceSections = traceString.split(':');
            String classMethodSection = traceSections[0];
            List<String> classMethodSplit = classMethodSection.split('\\.');
            if (classMethodSplit.size() > 1) {
                // TODO: Support anonymous blocks which fall outside of this if
                // Last one will always be the method
                this.MethodName = classMethodSplit[classMethodSplit.size() - 1];

                // The rest compose the class (Namespace.Class.InnerClass)
                classMethodSplit.remove(classMethodSplit.size() - 1);
                this.ClassName = String.join(classMethodSplit, '.');
            }

            String lineColumnSection = traceSections[1];
            List<String> lineColumnSplit = lineColumnSection.split(',');
            String lineSection = lineColumnSplit[0];
            lineSection = lineSection.remove('line');
            lineSection = lineSection.trim();
            this.LineNumber = Integer.valueOf(lineSection);

            String columnSection = lineColumnSplit[1];
            columnSection = columnSection.remove('column');
            columnSection = columnSection.trim();
            this.ColumnNumber = Integer.valueOf(columnSection);
        }
    }
}