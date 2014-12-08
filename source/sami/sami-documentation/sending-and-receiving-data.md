---
title: "Sending and receiving data"
---

# Sending and receiving data

This is an overview of how your devices and applications can send and receive messages on SAMI, using both REST and WebSocket APIs. Using this information, you will be able to post messages to SAMI, retrieve historical data, and use WebSockets to set up a real-time data stream.

## REST API

With SAMI's REST API, you can send and retrieve historical data according to a specific timestamp or range. This allows you to perform analytics on various scenarios and contexts.

## Posting a message

~~~
POST /message
~~~

When sending a message, only the source device ID (`sdid`{:.param}) and payload are required. If you plan to send data to another device, you must also include the destination device ID (`ddid`{:.param}).

Using the timestamp parameter (`ts`{:.param}), you can specify a timestamp for the message in milliseconds. Values up to the current server timestamp grace period are valid. If you omit `ts`{:.param}, the message defaults to the current time.

**Example Request**

~~~
{
  "sdid": "HIuh2378jh",
  "ddid": "298HUI210987",
  "ts": 1388179812427,
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

## Getting normalized messages

For this call, you can use different URL query parameter combinations to get historical data by user, by message ID, or by device.

~~~
GET /messages
~~~

### Get by user

| Parameter | Description                                                |
|-----------|------------------------------------------------------------|
| `uid`{:.param}       | user ID of the owner of the messages being searched.        |
| `startDate`{:.param} | Time of earliest item to return (milliseconds since epoch). |
| `endDate`{:.param}   | Time of latest item to return (milliseconds since epoch).   |

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

## Getting raw messages

This call retrieves messages in their original format. You may filter the messages by querying `sdid`{:.param}, `startDate`{:.param} and `endDate`{:.param}.

**Example response**

~~~~
{
    "sdid": "4697f11336c540a69ffd6f445061215e",
    "startDate": 1414691893755,
    "endDate": 1414691893765,
    "count": 100,
    "order": "asc",
    "size": 2,
    "data": [
        {
            "cts": 1414691893755,
            "ts": 1414691893755,
            "mid": "566409a96ca64f5c9e04fbbc32eb5f6f",
            "sdid": "4697f11336c540a69ffd6f445061215e",
            "data": "{\"dateMicro\":1414691893753000,\"ecg\":-54}"
        },
        {
            "cts": 1414691893765,
            "ts": 1414691893765,
            "mid": "2d6946758c5f43139d62e010e471194e",
            "sdid": "4697f11336c540a69ffd6f445061215e",
            "data": "{\"dateMicro\":1414691893762000,\"ecg\":-78}"
        }
    ]
}
~~~~

## Live-streaming data with WebSocket API

By using WebSockets, you can set up a connection between the server and compatible devices to receive messages in real-time.

~~~
WebSocket /live
~~~

This is a read-only WebSocket that allows the developer to listen for any new messages related to a user ID and access token.

**Request Parameters**

| Parameter | Description                                                |
|-----------|------------------------------------------------------------|
|`Authorization`{:.param} |User access token.
|`sdid`{:.param} |(Optional) Source device ID.
|`sdtid`{:.param} |(Optional) Source device type ID.
|`uid`{:.param} |(Optional) User ID of the target stream. If not specified, defaults to the user ID of the supplied access token.

You can use different URL query parameter combinations to get messages by user, by device, or by device type.

| Combination | Required Parameters|
|-------------|-----------|
|Get by user | `uid`{:.param}, `Authorization`{:.param}
|Get by device | `sdid`{:.param}, `Authorization`{:.param}
|Get by device type | `sdtid`{:.param}, `uid`{:.param}, `Authorization`{:.param}



In the following example we use [Tyrus](https://tyrus.java.net/), a Java API for WebSocket suitable for web applications.

**Example**

~~~
java -jar tyrus-client-cli-1.3.3.jar "wss://api.samsungsami.io/v1.1/live?userId=2&Authorization=bearer+1c20060d9b9f4ad09ee16919a45c71b7"
~~~

**Example response**

~~~
{
  "sdtid":"nike_fuelband",
  "data":{
    "stepCount":5000
  },
  "mid":"c7f88d4367394fb696eee413666c83d9",
  "ts":1377793344153,
  "uid":"10022",
  "sdid":"nike_fuelband_123"
}           
~~~

### Setting up a bi-directional message pipe

This call is for setting up a data connection between SAMI and a device or device list. Connected devices will receive messages containing the corresponding `ddid`{:.param} field.

~~~
WebSocket /websocket
~~~

#### Registration

All client applications, including device proxies, must register after opening the WebSocket connection. Otherwise client messages will be discarded and clients will not be sent messages.

In the below example, `Authorization`{:.param} refers to the authorization token with READ and WRITE access to `sdid`{:.param}.

**Example registration message sent by client**

~~~
{
  "sdid": "DFKK234-JJO5",
  "Authorization": "bearer d77054a9b0874ba884499eef7768b7b9",
  "type": "register"
}         
~~~

#### Ping

SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the client must reconnect.

**Example ping message sent by server**

~~~
{
  "type": "ping"
}         
~~~

### Sending messages

Sending a message to SAMI or another device works as it does in the [REST API.](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message)

### Receiving messages

In the below example, `ddid`{:.param} refers to the device ID of the device connected to the WebSocket. 

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

### WebSocket errors

|Code |Error message |Condition
|-----|-------|-----
|400 | Bad Request |Invalid JSON
|400 | Missing sdid value |Missing `sdid`
|400 |Missing ddid value |Missing `ddid`
|400 |Invalid ts value |Invalid timestamp or timestamp less than 0
|400 |Invalid ts value (in future) |Timestamp greater than `FUTURE_GRACE_PERIOD`
|401 |Please provide a valid authorization header |Missing auth token
|401 |Device not registered |Unregistered sdid
|403 |You do not have the right permission: devices |No WRITE permission
|403 |Wrong cid |Mismatch `cid`
|429 |Rate limit exceeded |Rate limit exceeded
