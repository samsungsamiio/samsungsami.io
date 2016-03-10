---
title: "MQTT"
---

# MQTT

MQTT is a lightweight messaging protocol. It is suitable for IoT, since it is bandwidth-efficient and uses little battery power. SAMI devices can communicate to SAMI via MQTT. 

In an MQTT session, SAMI acts as the MQTT broker and SAMI devices act as MQTT clients. A SAMI device can [publish a data-only message](#publish-data-only-messages) to SAMI or [subscribe to receive Actions](#subscribe-to-receive-actions) from SAMI. 

A device ID and device token are used to connect to SAMI via MQTT. A device ID is also used in the publish and subscription paths.
{:.info}

## Key concepts

|MQTT Components   |Required Value | Notes
|------|-----------|---------------------------------
|Security    |SSL                | SAMI device must be SSL-capable so that it can validate server certificate.
|Broker URL  |api.samsungsami.io | Needed for opening the connection to the broker.
|Broker port |8883 | Needed for opening the connection to the broker.
|username    |Device ID | A valid SAMI device ID used to login to establish a session.
|password    |Device token |A valid SAMI device token used to login to establish a session.
|Publish Path (MQTT topic)|/v1.1/messages/<code>&lt;</code>DEVICE ID<code>&gt;</code>|Publish "data" to SAMI for the specified device.
|Subscription Path (MQTT topic)|/v1.1/actions/<code>&lt;</code>DEVICE ID<code>&gt;</code>|Subscribe to receive "action" sent to the specified device.

To establish an MQTT session, a SAMI device must use a **device token** (one of the three [token types](/sami/introduction/authentication.html#three-types-of-access-tokens) normally used to transfer messages [via REST or WebSockets](/sami/connect-the-data/rest-and-websockets.html)). 

Similar to the SAMI REST/WebSocket API connection, the SAMI MQTT connection requires an encrypted communication channel. A SAMI device must be SSL-capable in order to connect to the SAMI MQTT endpoints.

## Establish an MQTT session

A SAMI device connects to SAMI using the broker URL and port specified in the above table, with SAMI acting as the MQTT broker. The device then logs in with its username (device ID) and password (device token). 

An MQTT session is now established between this device and SAMI. The device can publish data-only messages and/or subscribe to receive Actions targeted to it within this session.

## Publish data-only messages

Data-only messages have type "message". A SAMI device uses the following publish path:

~~~
/v1.1/messages/<DEVICE ID>
~~~

The content of an MQTT message differs from that of a message sent to SAMI [via REST or WebSockets](/sami/connect-the-data/rest-and-websockets.html#posting-a-message). Normally a SAMI message is a JSON object with multiple fields indicating values such as source device ID, message type, and timestamp:

~~~
{
  "sdid": "cff2127dc",
  "ts": 1388179812427,
  "type": "message",
  "data": {"onFire":false,"temperature":50}
}           
~~~

An MQTT message contains only the value of the `data`{:.param} field. The above message's corresponding MQTT message would be:

~~~
{"onFire":false,"temperature":50}
~~~

Once an MQTT message is successfully published to SAMI, it will be stored as a normal SAMI message with fields such as `sdid`{:.param} (source device ID), `type`{:.param} (message type), and `ts`{:.param} (timestamp). You can view this message using the [Data Logs](https://blog.samsungsami.io/development/portals/2015/06/18/an-eye-toward-usability.html#data-logs) or [Charts](https://blog.samsungsami.io/development/portals/2015/06/18/an-eye-toward-usability.html#charts) features of the [User Portal](https://portal.samsungsami.io). Should the publish run into any error, the developer of the corresponding device can see the error in the <a href="https://devportal.samsungsami.io" target="_blank">Developer Portal</a>.

For publishing messages, the SAMI MQTT broker supports <a href="https://www-01.ibm.com/support/knowledgecenter/SSFKSJ_7.1.0/com.ibm.mq.doc/tt60340_.htm" target="_blank">Qualities of Service 0, 1, or 2</a> specified by a client.

Only messages with type `message` can be published via MQTT.
{:.warning}

Any message sent to SAMI may not be bigger than 1 KB.
{:.info}

## Subscribe to receive actions

A SAMI device can subscribe to the SAMI MQTT broker to receive Actions targeted to it using the following subscription path:

~~~
/v1.1/actions/<DEVICE ID>
~~~

When another device or an application sends an Action to the subscribed device via REST or WebSocket, this device receives the Action as follows:

~~~
[
  {
     "name": "setOn",
     "parameters": {}
  },
  {
     "name": "setColorRGB",
     "parameters": {
        "colorRGB": {
          "r": 192,
          "g": 180,
           "b": 45
         },
         "intensity": 55
    }
  }
]
~~~

This received MQTT message contains two Actions: `setOn` and `setColorRGB`. As you can see, the received message only contains the value of the `actions` field in the `data` JSON object of a [typical SAMI message](/sami/connect-the-data/rest-and-websockets.html#posting-a-message-with-actions). 

When sending Actions back to the client, SAMI uses <a href="https://www-01.ibm.com/support/knowledgecenter/SSFKSJ_7.1.0/com.ibm.mq.doc/tt60340_.htm" target="_blank">QoS 0</a>, which is also called "fire and forget". The Actions are sent once, regardless of whether or not the client receives them.

A device should send its latest state to SAMI after acting on an Action. The device can achieve this by publishing its state in the same MQTT session it uses to subscribe and receive Actions.
{:.info}

## Example

The section describes how to publish and subscribe to the SAMI MQTT broker using <a href="http://mqttfx.jfx4ee.org/" target="_blank">MQTT.fx</a>, one of the many open source MQTT clients. The goal is to show you how to interact with the SAMI MQTT broker using the above concepts.

After understanding the basics, you will need to develop your own MQTT client for your devices. There are open source MQTT client libraries available for different platforms/languages. You may find these handy when developing MQTT functionality for your devices.

Beyond MQTT.fx, you will also use the [SAMI Device Simulator](/sami/tools/device-simulator.html) to send Actions to the MQTT client and monitor the state change after the client publishes its new state.

For this example, MQTT.fx publishes and subscribes on behalf of a "SAMI Example Simple Smart Light" device. The device type has simple fields and Actions, as seen below:

![Simple Smart Light Manifest](/images/docs/sami/connect-the-data/mqtt-simple-smart-light-manifest.png)

Before establishing the MQTT session, first [connect the device](/sami/tools/developer-user-portals.html#connecting-a-device) to your SAMI account in the User Portal, and then [obtain the device ID and token](/sami/tools/developer-user-portals.html#managing-a-device-token) to use later.

### Establish a session

Start MQTT.fx and create a new connection profile. Fill in the SAMI MQTT broker address and port and user credentials as follows:
![MQTT fx connection profile](/images/docs/sami/connect-the-data/mqtt-fx-connection-profile.png){:.lightbox}

[**Remember**](#key-concepts) that the username and password are the device ID and device token you obtained from the User Portal.
{:.info}

Click the "SSL/TLS" tab to enable SSL. The SAMI MQTT broker uses a CA signed certificate. Select “Enable SSL/TLS” and choose "CA signed server certifcate", as below:
![MQTT fx SSL](/images/docs/sami/connect-the-data/mqtt-fx-ssl.png){:.lightbox}

Save this profile and click the "Connect" button: 
![MQTT fx connect](/images/docs/sami/connect-the-data/mqtt-fx-connect.png)

Now MQTT.fx connects to the SAMI MQTT broker and establishes a session.

### Publish state of the smart light

Before publishing a message, [start the Device Simulator](https://developer.samsungsami.io/sami/tools/device-simulator.html#usage) and then run the `ll` command in the simulator to listen to messages sent by the smart light. SAMI will notify the simulator of all messages sent by the light. Below is the corresponding display in the Simulator:

    $ ll 0f8b45555555555555555
    Using this token to connect: 3118b86da4c343b28da89a1c56f18c18
    Opening live websocket on behalf of device 6a5bb957531f4704a5e3509a727573a5
    WS -> Connected to wss://api.samsungsami.io/v1.1/live?Authorization=bearer+3118b86da4c343b28da89a1c56f18c18&?sdid=0f8b45555555555555555

Fill in the publish path and MQTT message payload according [as described above](#publish-data-only-messages). Recall that you should use the device ID in the publish path. Your "Publish" tab should look like this:
![MQTT fx publish](/images/docs/sami/connect-the-data/mqtt-fx-publish.png)

Click the "Publish" button. The message should be sent to SAMI. SAMI will notify the Device Simulator, which displays the message as follows:

    WS -> {"mid":"d5a23adbd36d4484af1a34d7ea568398","data":{"state":false},"ts":1432844166847,"sdtid":"xxx","cts":1432844166846,"uid":"someuidxxx","mv":1,"sdid":"0f8b45555555555555555"}

Enter `sll` in the Device Simulator to stop listening.

### Subscribe to receive on/off actions

In MQTT.fx, fill in [the subscription path](#subscribe-to-receive-actions) to start receiving Actions targeted to this smart light. Recall that you need to use the device ID of the light in the subscription path.
![MQTT fx subscribe](/images/docs/sami/connect-the-data/mqtt-fx-subscribe.png)

In the Device Simulator, type the command `tell <DEVICE ID>` (the device ID is the ID of the light) to send an Action to the smart light as follows:

    $ tell 0f8b45555555555555555 setOn
    $ Sending : {"actions":[{"name":"setOn","parameters":{}}]}
    Got MID: 2713b144323c48ee8f7dd95044f31699

Then you should see the corresponding MQTT message received by MQTT.fx as follows:
![MQTT fx receive action](/images/docs/sami/connect-the-data/mqtt-fx-receive-actions.png){:.lightbox}

Consult <a href="https://blog.samsungsami.io/data/rules/iot/2015/09/23/sami-rules-make-your-devices-work-together.html" target="_blank">Publishing to SAMI </a> to learn how to send data from Artik board to SAMI via MQTT.

## Best practices

A MQTT client cannot send Actions to SAMI. To support a use case where an MQTT client triggers Actions on another MQTT client, we suggest that you set up SAMI Rules using the <a href="https://blog.samsungsami.io/data/rules/iot/2015/09/23/sami-rules-make-your-devices-work-together.html" target="_blank">Rules UI in the User Portal</a> or by [programmatically calling Rules APIs](/sami/connect-the-data/develop-rules-for-devices.html). 

Let's illustrate the point with example MQTT source and destination clients. The source MQTT client is a fire detector. It sends Boolean data "onFire" to SAMI. The destination MQTT client is a smart light that can [receive on/off actions](#subscribe-to-receive-onoff-actions). 

To send Actions from the fire detector to the light, you would create a pair of Rules in SAMI. The "TURN ON" Rule turns on the smart light if the fire detector detects the flame (i.e., "onFire" is true). The "TURN OFF" rule does the opposite. Then the MQTT fire detector can trigger Actions on the MQTT light when sending a new piece of data.

If the source device is not limited to MQTT, you have more options. For example, the source device can send Actions directly to the destination MQTT client using [REST](/sami/connect-the-data/rest-and-websockets.html#posting-a-message-with-actions) or [WebSockets](/sami/connect-the-data/rest-and-websockets.html#sending-messages).

## Limitations

At this point, the SAMI MQTT broker has the following limitations:

 1. Only supports [clean sessions](https://www-01.ibm.com/support/knowledgecenter/SSFKSJ_7.1.0/com.ibm.mq.doc/tt60370_.htm). This means that SAMI does not maintain MQTT state information between sessions. Therefore, a client that intends to receive Actions needs to resubscribe after establishing a new session.
 2. Does not retain Actions sent to a device when the device is disconnected. This means that SAMI does not send the undelivered Actions to the device even after the device resumes the MQTT connection. As a workaround, the reconnected device can make a REST API call to [get Actions from SAMI](/sami/api-spec.html#get-last-normalized-messages).

SAMI's MQTT functionality is continuously being developed and refined. Please check back to see when the above limitations have been removed.