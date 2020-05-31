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

  global static void debug(Type apexClass, String message) {
    log(LoggingLevel.DEBUG, apexClass, message);
  }

  global static void debug(String message) {
    log(LoggingLevel.DEBUG, null, message);
  }

  global static void info(Type apexClass, String message) {
    log(LoggingLevel.INFO, apexClass, message);
  }

  global static void info(String message) {
    log(LoggingLevel.INFO, null, message);
  }

  global static void warn(Type apexClass, String message) {
    log(LoggingLevel.WARN, apexClass, message);
  }

  global static void warn(String message) {
    log(LoggingLevel.WARN, null, message);
  }

  global static void error(Type apexClass, String message) {
    log(LoggingLevel.ERROR, apexClass, message);
  }

  global static void error(String message) {
    log(LoggingLevel.ERROR, null, message);
  }

  global static void trace() {
    for (LoggerBase logger : loggerImplementations) {
      logger.trace();

      if (immediate) {
        logger.flush();
      }
    }
  }

  global static void flush() {
    for (LoggerBase logger : loggerImplementations) {
      logger.flush();
    }
  }

  private static void log(LoggingLevel level, Type apexClass, String message) {
    // TODO: Dynamically figure out the place of the call by using trace
    String apexClassName = apexClass == null ? '' : apexClass.getName();
    for (LoggerBase logger : loggerImplementations) {
      logger.log(new SingleLog(level, apexClassName, message));

      if (immediate) {
        logger.flush();
      }
    }
  }
}
