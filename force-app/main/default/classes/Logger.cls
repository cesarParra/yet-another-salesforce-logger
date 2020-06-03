global with sharing class Logger {
  private static List<LoggerBase> loggerImplementations;
  global static Boolean immediate = true;

  static {
    loggerImplementations = new List<LoggerBase>{
      new SystemDebugLog(),
      new PlatformEventLog()
    };
  }

  @TestVisible
  private static void setLoggers(List<LoggerBase> loggers) {
    loggerImplementations = loggers;
  }

  global static void debug(String message) {
    log(LoggingLevel.DEBUG, message);
  }

  global static void info(String message) {
    log(LoggingLevel.INFO, message);
  }

  global static void warn(String message) {
    log(LoggingLevel.WARN, message);
  }

  global static void error(String message) {
    log(LoggingLevel.ERROR, message);
  }

  global static void trace() {
    for (LoggerBase logger : loggerImplementations) {
      logger.trace();

      if (immediate) {
        logger.flush();
      }
    }
  }

  global static void count() {
    count('default');
  }

  private static Map<String, Integer> countTracker = new Map<String, Integer>();
  global static void count(String label) {
    Integer counter = 1;
    if (countTracker.containsKey(label)) {
      counter = countTracker.get(label);
      counter++;
    }
    debug(String.format('{0}: {1}', new List<String> { label, String.valueOf(counter) }));
    countTracker.put(label, counter);
  }

  global static void countReset() {
    countReset('default');
  }

  global static void countReset(String label) {
    if (!countTracker.containsKey(label)) {
      return;
    }

    countTracker.remove(label);
  }

  // TODO: Accept set of objects
  // TODO: Unit tests
  // TODO: Parse on the JS side
  // TODO: Ability to specify which properties to include during serialization
  global static void table(List<Object> tableList) {
    debug(JSON.serialize(tableList));
  }

  global static void flush() {
    for (LoggerBase logger : loggerImplementations) {
      logger.flush();
    }
  }

  private static void log(LoggingLevel level, String message) {
    for (LoggerBase logger : loggerImplementations) {
      logger.log(new SingleLog(level, Tracer.newInstance().getLastTrace(), message));

      if (immediate) {
        logger.flush();
      }
    }
  }
}
