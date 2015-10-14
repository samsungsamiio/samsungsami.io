---
title: "Sending and receiving data"
---

# Sending and receiving data

This is an overview of how your devices and applications can send and receive messages on SAMI, using both REST and WebSocket APIs. Using this information, you will be able to post messages to SAMI, retrieve historical data, and use WebSockets to set up a real-time data stream. When sending messages via REST or WebSocket, you could put Actions in messages so that destination devices can perform the specified Actions. 

Any message sent to SAMI may not be bigger than 10 KB.
{:.info}

You can use the [**Device Simulator**](/sami/demos-tools/device-simulator.html) to simulate sending messages and Actions to SAMI via REST and WebSockets.
{:.info}

## REST API

With SAMI's REST API, you can send and retrieve historical data according to a specific timestamp or range. This allows you to perform analytics on various scenarios and contexts. You also can send Actions to SAMI, which will be routed to the destination device to perform these Actions.

## Posting a message

~~~
POST /messages
~~~

When sending a message that contains only data and no Actions, only the source device ID (`sdid`{:.param}) and payload are required. If you plan to send data to another device, you must also include the destination device ID (`ddid`{:.param}). The `type`{:.param} field defaults to value "message". However, we strongly suggest that you explicitly set `type`{:.param} to `message` so that your app is future-proof. 

Using the timestamp parameter (`ts`{:.param}), you can specify a timestamp for the message in milliseconds. Values up to the current server timestamp grace period are valid. If you omit `ts`{:.param}, the message defaults to the current time.

**Example Request**

~~~
{
  "sdid": "HIuh2378jh",
  "ddid": "298HUI210987",
  "ts": 1388179812427,
  "type": "message",
  "data": [payload]
}           
~~~

You'll then receive a message ID (`mid`{:.param}) that you can use to query this message in other calls:

**Example response**

~~~
{
  "data": {
    "mid": "7fb20d3809b54075af6bdfc22591c521"
  }
}     
~~~

## Posting a message with Actions

~~~
POST /messages
~~~

When sending a message with Actions, you must include the destination device ID (`ddid`{:.param}) and a payload that contains Actions. In addition, you must set the value of `type`{:.param} to "action". By default, its value is "message". The source device ID (`sdid`{:.param}) is optional.

**Example Request**

~~~json
{
  "ddid": "9f06411ad3174a4f98444a374447fe10",
  "ts": 1388179812427,
  "type": "action",
  "data": {
    "actions": [
      {
        "name": "setOn",
        "parameters": {}
      },
      {
        "name": "setColorAsRGB",
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
  }
}
~~~

In the above example, the message contains two Actions, `setOn` and `setColorAsRGB`. You'll then receive a response that is similar to the response of a message that does not contain Actions.

Any message with Actions should only contain "actions" in the payload.
{:.info}

## Getting normalized messages

For this call, you can use different URL query parameter combinations to get historical data by message ID or by device.

~~~
GET /messages
~~~

### Get by message ID

| Parameter | Description                                                |
|-----------|------------------------------------------------------------|
| `mid`{:.param}       | The SAMI message ID being searched.                                  |
| `uid`{:.param}       | (Optional) user ID of a user who has granted read access. If not specified, this defaults to the current authenticated user.                              |

### Get by device

| Parameter | Description                                                |
|-----------|------------------------------------------------------------|
| `sdid`{:.param}      | Source device ID of the messages being searched.            |
| `startDate`{:.param} | Time of earliest item to return (milliseconds since epoch). |
| `endDate`{:.param}   | Time of latest item to return (milliseconds since epoch).   |

Common parameters include `order`{:.param} to specify the sort order, `count`{:.param} to specify the number of items to return, and `offset`{:.param}, a string required for pagination. See the [API spec](/sami/api-spec.html) for more information and parameter combinations.

**Example response**

~~~
{
  "uid":"10022",
  "sdid":"cf1b01690f7c41df80e01482c6246a6e",
  "order": "asc",
  "startDate": 1,
  "endDate": 1402434042000,
  "count": 1,
  "size": 1,
  "offset": "",
  "next": "",
  "data": [
    {
      "sdtid": "dt6172aca4919f40a4a96afbd27cee09c8",
      "sdid":"cf1b01690f7c41df80e01482c6246a6e",
      "data": {
        "state": "off"
      },
      "mid": "80bff72064614fd5b5b05cb66c1ccfda",
      "ts": 1377303199000,
      "cts": 1377303199000,
      "uid": "10022"
    }
  ]
}    
~~~

## Getting last normalized messages

This is a simple way to retrieve the most recent messages sent by devices. You must include as query parameters `count`{:.param} to specify the number of items to return, and `sdids`{:.param} to specify at least one source device ID. You may include more than one source device ID in a comma-separated list.

~~~
GET /messages/last
~~~

## Live-streaming data with WebSocket API

By using WebSockets, you can set up a connection between SAMI and compatible devices or applications to receive and/or send messages in real-time.

There are two types of WebSockets: read-only and bi-directional. Your application uses a read-only WebSocket to listen to messages sent by the source devices that the application monitors. On the other hand, you would use a bi-directional WebSocket to receive messages targeted to your applications or devices. The bi-directional WebSocket also allows the applications or devices to send messages back to SAMI.

### Read-only WebSocket

~~~
WebSocket /live
~~~

This call sets up a one-directional data connection from SAMI to a WebSocket client. The read-only WebSocket is primarily used by applications with monitoring functionalities. The application, as the client, listens in real-time for any new messages sent to SAMI by the specified source devices.

**Request Parameters**

| Parameter | Description                                                |
|-----------|------------------------------------------------------------|
|`Authorization`{:.param} |Access token ([user](/sami/sami-documentation/authentication.html#user-token), [device](/sami/sami-documentation/authentication.html#device-token), or [application](/sami/sami-documentation/authentication.html#application-token) token)
|`sdids`{:.param} |(Optional) A list of source device IDs seperated by commas. Accepts a single device ID.
|`sdtids`{:.param} |(Optional) A list of source device type IDs seperated by commas. Accepts a single device type ID.
|`uid`{:.param} | User ID of the target stream. 

You can use different URL query parameter combinations to get messages by device, by device type, or by user.

| Combination | Required Parameters |
|-------------|-----------|
|Get by devices | `sdids`{:.param}, `uid`{:.param}, `Authorization`{:.param} |
|Get by device type | `sdtids`{:.param}, `uid`{:.param}, `Authorization`{:.param}
|Get by user | `uid`{:.param}, `Authorization`{:.param}

We do not support "Get by device type" when a [device token](/sami/sami-documentation/authentication.html#device-token) is provided as the access token.
{:.warning}

For better performance, we suggest being as specific as possible when passing API call parameters. For example, the "Get by devices" combination returns the result more quickly than the "Get by user" combination.
{:.info}

In the following example we use [Tyrus](https://tyrus.java.net/), a Java API for WebSockets suitable for web applications. We listen to the messages sent to SAMI by the two source devices. In this specific example, the provided access token could be an [application token](/sami/sami-documentation/authentication.html#application-token) or a [user token](/sami/sami-documentation/authentication.html#user-token).

**Example**

~~~
java -jar tyrus-client-cli-1.3.3.jar "wss://api.samsungsami.io/v1.1/live?sdids=12345,6789&uid=10022&Authorization=bearer+1c20060d9b9f4ad09ee16919a45c71b7"
~~~

In the below example, the client receives a copy of the message that one of the source devices sends to SAMI.

**Example message received by client**

~~~
{
  "sdtid":"nike_fuelband",
  "data":{
    "stepCount":5000
  },
  "mid":"c7f88d4367394fb696eee413666c83d9",
  "ts":1377793344153,
  "cts":1377793344153,
  "uid":"10022",
  "sdid":"12345"
} 
~~~

#### Ping

SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the WebSocket client must reconnect.

**Example ping message sent by server**

~~~
{
  "type": "ping"
}         
~~~

### Bi-directional WebSocket

#### Setting up a bi-directional message pipe

This call opens a data connection between SAMI and a device or device list. 

~~~
WebSocket /websocket
~~~

Setting `ack`{:.param} to "true" in the above URL query string will cause SAMI to return an ACK message for each message sent. Otherwise, this defaults to "false" and you will not receive ACK messages.

All client applications, including device proxies, must register after opening the connection. Otherwise client messages will be discarded and clients will not be sent messages.

If the client app does not register within 30 seconds of opening the connection, the WebSocket will be closed automatically.
{:.warning}

The registration message `type`{:.param} must be "register". `Authorization`{:.param} refers to the authorization token with READ and WRITE access to `sdid`{:.param}. The `cid`{:.param} parameter is discussed in [Sending messages](#sending-messages).

**Example registration message sent by client**

~~~
{
  "sdid": "DFKK234-JJO5",
  "Authorization": "bearer d77054a9b0874ba884499eef7768b7b9",
  "type": "register",
  "cid": "1234567890"
}         
~~~

**Example ACK message**

~~~
{
  "data":{
    "message":"OK",
    "code":"200",
    "cid":"1234567890"
  }
}
~~~

You could send multiple messages to register more than one device. Then you can send and receive messages for these devices over a single bi-directional WebSocket.
{:.info}

As with /live, SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the client must reconnect.

#### Sending messages

When sending a message to SAMI or another device, you may specify `type`{:.param} as "message" or "action". Additionally, if `ack`{:.param} was set to "true" when opening the WebSocket connection, you may optionally include `cid`{:.param}—the client ID. SAMI will return `cid`{:.param} (in addition to `mid`{:.param}) in its ACK messages to facilitate client side validations. This helps to clarify which response is for which message. 

When sending a message to another device, you should specify `ddid`{:.param}. Otherwise, the message is only sent to SAMI to be stored. In the following example, `sdid`{:.param} refers to the device ID of the device registered on the bi-directional WebSocket. 

The example request at [**Posting a message with Actions**](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions) shows how Actions are formatted in a message.
{:.info}

**Example request**

~~~
{
  "sdid": "DFKK234-JJO5",
  "ddid": "<destination device ID>",
  "cid":"1234567890", 
  "type": "message",
  "data":{
    "someField": "someValue"
  }
}
~~~

**Example ACK message**

~~~
{
  "data":{
    "mid": "6d002024824746649766743582c9f005", 
    "cid": "1234567890"
  }
}
~~~

#### Receiving messages

In the below example, `ddid`{:.param} refers to the device ID of the device connected to the WebSocket. Connected devices will receive messages containing their corresponding `ddid`{:.param}.

A destination device must be connected to SAMI via a bi-directional WebSocket in order to receive Actions in real-time.
{:.info}

**Example message received by client**

~~~
{
  "ddid": "<destination device ID = this client device ID>",
  "mid": "<message ID>",
  "data": {
    "command": "unlock",
    "level": 3
  }
}       
~~~

See the API spec for a table of [**WebSocket errors**](https://developer.samsungsami.io/sami/api-spec.html#websocket-errors).
{:.info}