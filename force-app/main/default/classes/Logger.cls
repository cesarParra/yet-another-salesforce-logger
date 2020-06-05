/**
 * @description Provides a generic logging framework. By default you can use it to log server side code through
 *              the browser's debugging console (e.g. the Web Console in Firefox or Chrome) by leveraging
 *              Platform Events.
 */
global with sharing class Logger {
  private static List<LoggerBase> loggerImplementations;
  /**
   * @description Allows you to change if the logs should be immediately sent out, or if they should be stored until
   *              `Logger.flush()` is called. Use this to defer the Platform Events being published when logging
   *              code that makes external API calls.
   */
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

  /**
   * @description Outputs a message to the web console at the "debug" log level.
   * @param message The message to output.
   * @example
   * yasl.Logger.debug('This is a string message');
   * yasl.Logger.debug(new ExampleObject()); | Can debug any object.
   */
  global static void debug(Object message) {
    log(LoggingLevel.DEBUG, JSON.serialize(message));
  }

  /**
   * @description Outputs a message to the web console at the "info" log level.
   * @param message The message to output.
   * @example
   * yasl.Logger.info('This is a string message');
   * yasl.Logger.info(new ExampleObject()); | Can debug any object.
   */
  global static void info(Object message) {
    log(LoggingLevel.INFO, JSON.serialize(message));
  }

  /**
   * @description Outputs a message to the web console at the "warn" log level.
   * @param message The message to output.
   * @example
   * yasl.Logger.warn('This is a string message');
   * yasl.Logger.warn(new ExampleObject()); | Can debug any object.
   */
  global static void warn(Object message) {
    log(LoggingLevel.WARN, JSON.serialize(message));
  }

  /**
   * @description Outputs a message to the web console at the "error" log level.
   * @param message The message to output.
   * @example
   * yasl.Logger.error('This is a string message');
   * yasl.Logger.error(new ExampleObject()); | Can debug any object.
   */
  global static void error(Object message) {
    log(LoggingLevel.ERROR, JSON.serialize(message));
  }

  /**
   * @description Outputs a stack trace.
   * @example
   * Given the following code
   * void func1() {
   *     func2();
   * }
   *
   * void func2() {
   *     yasl.Logger.trace();
   * }
   *
   * func1();
   *
   * Outputs:
   * TRACE::AnonymousBlock: line 6, column 1
   * AnonymousBlock: line 2, column 1
   * AnonymousBlock: line 9, column 1
   */
  global static void trace() {
    for (LoggerBase logger : loggerImplementations) {
      logger.trace();

      if (immediate) {
        logger.flush();
      }
    }
  }

  /**
   * @description Logs the number of times that this particular call to count() has been called.
   *              This endpoint tracks the count number under the 'default' label.
   * @example
   * yasl.Logger.count(); | Logs 'default: 1'
   * yasl.Logger.count(); | Logs 'default: 2'
   */
  global static void count() {
    count('default');
  }

  private static Map<String, Integer> countTracker = new Map<String, Integer>();
  /**
   * @description Logs the number of times that this particular call to count() has been called.
   *              This endpoint tracks the count number under the provided label.
   * @example
   * yasl.Logger.count(); | Logs 'default: 1'
   * yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
   * yasl.Logger.count('customLabel'); | Logs 'customLabel: 2'
   * yasl.Logger.count(); | Logs 'default: 2'
   */
  global static void count(String label) {
    Integer counter = 1;
    if (countTracker.containsKey(label)) {
      counter = countTracker.get(label);
      counter++;
    }
    debug(String.format('{0}: {1}', new List<String> { label, String.valueOf(counter) }));
    countTracker.put(label, counter);
  }

  /**
   * @description Resets counter used with `console.count()`;
   * @example
   * yasl.Logger.count(); | Logs 'default: 1'
   * yasl.Logger.countReset();
   * yasl.Logger.count(); | Logs 'default: 1'
   */
  global static void countReset() {
    countReset('default');
  }

  /**
   * @description Resets counter used with `console.count(String label)`;
   * @example
   * yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
   * yasl.Logger.countReset('customLabel');
   * yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
   */
  global static void countReset(String label) {
    if (!countTracker.containsKey(label)) {
      return;
    }

    countTracker.remove(label);
  }

  /**
   * @description Displays tabular data as a table.
   * @param tableList Iterator to display as a table.
   */
  global static void table(Object tableList) {
    log(LoggingLevel.DEBUG, JSON.serialize(tableList), 'table');
  }

  /**
   * @description When the Logger is not set as immediate, call this method to get all of the previously logged
   *              information.
   */
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
