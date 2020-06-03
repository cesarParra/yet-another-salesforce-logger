# yet-another-salesforce-logger

Surfaces server-side (Apex) logging through the browser's console.

## Installation

Yet Another Salesforce Logger (YASL) can be installed as an unlocked package.

### By SFDX

`sfdx force:package:install --package 04t5w000005qobQAAQ`

### By installation URL

Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005qobQAAQ

## Usage

1. On the page you want the debugger to run, use the App Builder to drag in the `Logger Status`
   LWC.
2. Add logs to the desired Apex code
3. Use the UI to interact with the code that will eventually call the Apex code
4. See the logs in the browser's console