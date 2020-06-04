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

  global static void debug(Object message) {
    log(LoggingLevel.DEBUG, JSON.serialize(message));
  }

  global static void info(String message) {
    log(LoggingLevel.INFO, JSON.serialize(message));
  }

  global static void warn(String message) {
    log(LoggingLevel.WARN, JSON.serialize(message));
  }

  global static void error(String message) {
    log(LoggingLevel.ERROR, JSON.serialize(message));
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

  global static void table(Object tableList) {
    log(LoggingLevel.DEBUG, JSON.serialize(tableList), 'table');
  }

  global static void flush() {
    for (LoggerBase logger : loggerImplementations) {
      logger.flush();
    }
  }

  private static void log(LoggingLevel level, String message) {
    log(level, message, 'standard');
  }

  private static void log(LoggingLevel level, String message, String displayType) {
    for (LoggerBase logger : loggerImplementations) {
      logger.log(new SingleLog(level, Tracer.newInstance().getLastTrace(), message, displayType));

      if (immediate) {
        logger.flush();
      }
    }
  }
}
