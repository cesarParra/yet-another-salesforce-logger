import {LightningElement} from 'lwc';

import callLogger from '@salesforce/apex/TestingClass.callLogger';

export default class TestingComponent extends LightningElement {
  invokeLogger() {
    callLogger()
      .then(data => console.log('Logger called'))
      .catch(error => console.log('An error occurred when calling the logger', error));
  }
}