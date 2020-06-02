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
