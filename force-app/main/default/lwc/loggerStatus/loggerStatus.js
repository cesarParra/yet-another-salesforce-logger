import { LightningElement } from "lwc";
import { subscribe, unsubscribe } from "lightning/empApi";

export default class LoggerStatus extends LightningElement {
  channelName = "/event/LogEvent__e";
  isSubscribeDisabled = false;
  isUnsubscribeDisabled = !this.isSubscribeDisabled;

  subscription = {};

  handleSubscribe() {
    const messageCallback = function(response) {
      console.log("New message received : ", JSON.stringify(response));
    };

    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then(response => {
      // Response contains the subscription information on successful subscribe call
      console.log("Logging started");
      this.subscription = response;
      this.toggleSubscribeButton(true);
    });
  }

  handleUnsubscribe() {
    this.toggleSubscribeButton(false);

    // Invoke unsubscribe method of empApi
    unsubscribe(this.subscription, response => {
      console.log("Logging stopped");
    });
  }

  toggleSubscribeButton(enableSubscribe) {
    this.isSubscribeDisabled = enableSubscribe;
    this.isUnsubscribeDisabled = !enableSubscribe;
  }
}
