@IsTest
private class TracerTest {
    @IsTest
    private static void getTrace_expectNonEmptyString() {
        String trace = Tracer.newInstance().getTrace();
        System.assertNotEquals(null, trace);
    }

    @IsTest
    private static void getTraces_expectTraces() {
        List<Tracer.Trace> traces = Tracer.newInstance().getTraces();
        System.debug(traces);
        System.assertEquals(1, traces.size());
    }

    @IsTest
    private static void getLastTrace_expectCorrectlyFormedTrace() {
        Tracer.Trace trace = Tracer.newInstance().getLastTrace();
        System.assertEquals(TracerTest.class.getName(), trace.ClassName);
        System.assertEquals('getLastTrace_expectCorrectlyFormedTrace', trace.MethodName);
    }
}