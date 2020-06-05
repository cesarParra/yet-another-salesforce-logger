# Logger class

Provides a generic logging framework. By default you can use it to log server side code through the browser's debugging console (e.g. the Web Console in Firefox or Chrome) by leveraging Platform Events.

---
## Properties

### `immediate` → `Boolean`

Allows you to change if the logs should be immediately sent out, or if they should be stored until `Logger.flush()` is called. Use this to defer the Platform Events being published when logging code that makes external API calls.

---
## Methods
### `count()` → `void`

Logs the number of times that this particular call to count() has been called. This endpoint tracks the count number under the 'default' label.
#### Example
```
yasl.Logger.count(); | Logs 'default: 1'
yasl.Logger.count(); | Logs 'default: 2'
```

### `count(String label)` → `void`

Logs the number of times that this particular call to count() has been called. This endpoint tracks the count number under the provided label.
#### Example
```
yasl.Logger.count(); | Logs 'default: 1'
yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
yasl.Logger.count('customLabel'); | Logs 'customLabel: 2'
yasl.Logger.count(); | Logs 'default: 2'
```

### `countReset()` → `void`

Resets counter used with `console.count()`;
#### Example
```
yasl.Logger.count(); | Logs 'default: 1'
yasl.Logger.countReset();
yasl.Logger.count(); | Logs 'default: 1'
```

### `countReset(String label)` → `void`

Resets counter used with `console.count(String label)`;
#### Example
```
yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
yasl.Logger.countReset('customLabel');
yasl.Logger.count('customLabel'); | Logs 'customLabel: 1'
```

### `debug(Object message)` → `void`

Outputs a message to the web console at the "debug" log level.
#### Parameters
|Param|Description|
|-----|-----------|
|`message` |  The message to output. |

#### Example
```
yasl.Logger.debug('This is a string message');
yasl.Logger.debug(new ExampleObject()); | Can debug any object.
```

### `error(Object message)` → `void`

Outputs a message to the web console at the "error" log level.
#### Parameters
|Param|Description|
|-----|-----------|
|`message` |  The message to output. |

#### Example
```
yasl.Logger.error('This is a string message');
yasl.Logger.error(new ExampleObject()); | Can debug any object.
```

### `flush()` → `void`

When the Logger is not set as immediate, call this method to get all of the previously logged information.
### `info(Object message)` → `void`

Outputs a message to the web console at the "info" log level.
#### Parameters
|Param|Description|
|-----|-----------|
|`message` |  The message to output. |

#### Example
```
yasl.Logger.info('This is a string message');
yasl.Logger.info(new ExampleObject()); | Can debug any object.
```

### `table(Object tableList)` → `void`

Displays tabular data as a table.
#### Parameters
|Param|Description|
|-----|-----------|
|`tableList` |  Iterator to display as a table. |

### `trace()` → `void`

Outputs a stack trace.
#### Example
```
Given the following code
void func1() {
    func2();
}
void func2() {
    yasl.Logger.trace();
}
func1();
Outputs:
TRACE::AnonymousBlock: line 6, column 1
AnonymousBlock: line 2, column 1
AnonymousBlock: line 9, column 1
```

### `warn(Object message)` → `void`

Outputs a message to the web console at the "warn" log level.
#### Parameters
|Param|Description|
|-----|-----------|
|`message` |  The message to output. |

#### Example
```
yasl.Logger.warn('This is a string message');
yasl.Logger.warn(new ExampleObject()); | Can debug any object.
```

---
