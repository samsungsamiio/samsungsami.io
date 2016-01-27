---
title: "Subscribe and notify"
---

# Subscribe and notify

In the [WebSockets documentation](/sami/sami-documentation/sending-and-receiving-data.html#live-streaming-data-with-websocket-api), we explain how your application or device can use one of two WebSocket types to:

* Listen to messages sent by devices or applications that interest you.
* Receive messages targeted to your devices or applications.

However, WebSockets may not be your best solution, due to one of the following reasons:

 * You cannot use WebSockets. For example, your application framework may not provide you such an option.
 * Maintaining a WebSocket connection (which is primarily for high-frequency messages) is not worthwhile. For example, you might be expecting a low frequency of messages (including Actions).

To support these use cases, SAMI provides *subscription* and *notification* services for your applications or devices (called *clients* in this document).

A client calls an API to create a **subscription** to SAMI, and then receives **notifications** on pertinent messages or [Actions](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions) through callbacks. The high-level workflow is illustrated below.

![SAMI Subscription highlevel](/images/docs/sami/sami-documentation/notifyservice-highlevel.png)

In the subscription, the client specifies the message type for which it wants to be notified (messages or Actions), a filter (for a user and any specific devices or device types), and additional configurations (callback URL, batching of notifications, etc).

Every time a message or Action is available in SAMI that matches the criteria defined in the subscription, SAMI calls the callback URL of the client to notify it.

The client can later unsubscribe by calling an API to delete the subscription.

## Subscribe to SAMI

![SAMI Subscription sequence diagram](/images/docs/sami/sami-documentation/notifyservice-subscription-sqd.png){:.lightbox}

The above subscription sequence diagram is divided into two phases:

1. [Creating a subscription](#create-a-subscription) (Steps 1-3).
2. [Confirming a subscription](#confirm-a-subscription) (Steps 4-7).

### The subscription object

When APIs are called to *create*, *get*, or *delete* a subscription, SAMI returns the subscription as a JSON object in the HTTP response, as below:

~~~json
{ 
   "data":{ 
      "id":"1673d8888883acfcc50c9d",
      "aid":"f9c82b97b788888b7e2",
      "messageType":"message",
      "uid":"2455g888888",
      "description":"This is a subscription to a user's devices",
      "callbackUrl":"https://api.example.com/messages?user=earl1234",
      "status":"ACTIVE",
      "createdOn":1435191843948,
      "modifiedOn":1439489593485
   }
}
~~~

Let's take a closer look at the subscription object.

**Subscription fields**

|Field   |Description |Notes
|------|-----------|---------------------------------
|`id`{:.param}   |Subscription ID. Returned upon creation. |
|`aid`{:.param}  |Client ID associated with the subscription. Derived from the access token. |
|`messageType`{:.param}   |Type of message to subscribe to. |*Required for subscription creation.*<br><br>Can be `message` or `action`.
|`uid`{:.param}   |User ID to subscribe to. This will notify for all user-owned devices that have granted permissions to the client. |*Required for subscription creation.*
|`sdtid`{:.param}   |Source device type ID to subscribe the user to. This will notify for all user-owned devices of this device type. |Message type must be `message`.<br><br>Client must have been granted `DEVICE_READ` for this device type.<br><br>Can't be specified with `sdid`{:.param}.
|`sdid`{:.param}   |Source device ID to subscribe to. |Message type must be `message`.<br><br>Client must have been granted `DEVICE_READ` for this device's device type.<br><br>Can't be specified with `sdtid`{:.param}.
|`ddid`{:.param}   |Destination device ID to subscribe to. Used when listening for Actions. |*Required for subscription creation if the message type is* `action`.
|`description`{:.param}   |Description of the subscription. Intended for display purposes. |
|`callbackUrl`{:.param}   |Callback URL to be used. Can include query parameters. |*Required for subscription creation.*<br><br>Must be HTTPS.
|`status`{:.param}   |Status of the subscription. |`PENDING_CALLBACK_VALIDATION` or `ACTIVE`.
|`createdOn`{:.param}   |Timestamp that the subscription was created. In milliseconds since epoch. |READ-ONLY.
|`modifiedOn`{:.param}   |Timestamp that the subscription was last modified. In milliseconds since epoch. |READ-ONLY.

The above table indicates which request parameters are mandatory when creating a subscription. 

You can include `sdtid`{:.param} or `sdid`{:.param} when listening for message type `message`.  
You must include `ddid`{:.param} when listening for message type `action`. 

### Create a subscription

At Step 1 of the [subscription sequence](#subscribe-to-sami), the client makes an HTTP POST call to create a subscription.

`POST /subscriptions`
{:.pa.param.http}

Refer to the table of [subscription fields](#the-subscription-object) to determine which parameters you should include in your request body. 

In the below example request, the client intends to receive notifications from SAMI when devices owned by the specified user ID send a message of type `message` to SAMI. 

~~~json
{ 
   "messageType":"message",
   "uid":"2455g88888",
   "description":"This is a subscription to a user's devices",
   "callbackUrl":"https://callback.example.com/messages?user=earl1234"
}
~~~

The access token provided in the POST call must have at least Read permissions over the devices. Either application or user tokens can be used with this POST call. To learn more about these token types, [**click here**](/sami/introduction/authentication.html#three-types-of-access-tokens).
{:.info}

Each notification is delivered by calling the `callbackUrl`{:.param} defined in the request.

At Step 2 of the [subscription sequence](#subscribe-to-sami), SAMI validates the callback URL in the request to ensure it has the same domain as the application redirect URL. (Recall that you provided the redirect URL when [creating an application in the Developer Portal](/sami/sami-documentation/developer-user-portals.html#creating-an-application).) 

SAMI compares the top two levels of the two domains. For example, when comparing "notifications.callback.company.com" with "redirect.company.com", validation will pass since both URLs end in "company.com". Validation does not use the protocol and port in the URL. If validation of the callback URL fails, no subscription will be created (Step 3.1).

In a successful case, SAMI creates a subscription with status `PENDING_CALLBACK_VALIDATION` at Step 3.2. SAMI changes the subscription status to `ACTIVE` if the subscription is confirmed within 24 hours (see the following section).

SAMI will delete this subscription if it is not confirmed within 24 hours.
{:.warning}

### Confirm a subscription

Confirming a subscription comprises Steps 4 to 7 in the [subscription sequence](#subscribe-to-sami). 

At Step 4, SAMI makes the following HTTP POST call to the callback URL of the client.

`POST <callback url>`
{:.pa.param.http}

The request has the following JSON payload in the body:

~~~json
{
   "aid": "<CLIENT ID>",
   "subscriptionId": "<SUBSCRIPTION ID>",
   "nonce": "<NONCE>"
}
~~~

There is no authorization header in the above HTTP request. The client callback endpoint should not authenticate this request.
{:.info}

The client retrieves the subscription ID and the nonce from the above HTTP request. 

(SAMI ignores the HTTP response from the client at Step 5.)

At Step 6 of the [subscription sequence](#subscribe-to-sami), the client makes the following HTTP POST call to SAMI to confirm the subscription.

`POST /subscriptions/:subscriptionID/validate`
{:.pa.param.http}

The request should contain the following JSON payload in the body:

~~~json
{
   "aid": "<CLIENT ID>",
   "nonce": "<NONCE>"
}
~~~

SAMI does not authenticate this HTTP POST call. Therefore an access token is not required in the call.
{:.info}

After receiving the above HTTP request as the confirmation, SAMI changes the subscription status from `PENDING_CALLBACK_VALIDATION` to `ACTIVE`. 

At Step 7, SAMI sends the HTTP response with the [subscription JSON object](#the-subscription-object) to the client. This completes the subscription process.

## Receive notifications from SAMI

Upon receving a notification at the callback URL, the client authenticates it and then extracts a notification ID. It retrieves messages related to this notification by making [follow-up GET calls](#get-messages-in-a-notification) to SAMI.

The following diagram illustrates how a client handles a notification.

![SAMI notification sequence diagram](/images/docs/sami/sami-documentation/notifyservice-notification-sqd.png){:.lightbox}

### Authenticate notifications

In Step 1 of the [notification sequence](#receive-notifications-from-sami), SAMI sends an authenticated POST request to the client's callback URL. The request is built based on <a href="http://tools.ietf.org/html/rfc5849#section-3.1" target="_blank">Making Requests in OAuth 1.0</a>. 

The client should verify that each SAMI notification is from SAMI, and the authorization header of the request contains the necessary information. Here is an example header:

~~~
Authorization   OAuth oauth_consumer_key="f32cb82256184b2ea0c4ab30ee08186b",
                oauth_nonce="2981717297499358590",
                oauth_signature="8zA9B5yjIOQcNyhOi%2Fz%2BoxgITOM%3D", 
                oauth_signature_method="HMAC-SHA1", 
                oauth_timestamp="1443815778", 
                oauth_token="f32cb82256184b2ea0c4ab30ee08186b", 
                oauth_version="1.0"
~~~

The client follows <a href="http://tools.ietf.org/html/rfc5849#section-3.2" target="_blank">Verifying Requests in OAuth 1.0</a> to verify the request.

SAMI only implements <a href="http://tools.ietf.org/html/rfc5849#page-14" target="_blank">**Authenticated Requests**</a> instead of the full OAuth 1.0 workflow. During notification authentication, SAMI acts as an OAuth 1.0 client and a SAMI client acts as an OAuth 1.0 server.
{:.info} 

Steps 2 to 4 of the [notification sequence](#receive-notifications-from-sami) follow <a href="http://tools.ietf.org/html/rfc5849#section-3.2" target="_blank">OAuth 1.0 request verification</a>. At Step 2, the client follows <a href="http://tools.ietf.org/html/rfc5849#section-3.4" target="_blank">Signature</a> to verify `oauth_signature`{:.param} in the authorization header of a received request. The client compares the signature generated locally with the one received. It uses the following information when generating the signature locally:

~~~
consumer key = CLIENT ID
consumer secret = CLIENT SECRET
token = CLIENT ID
token secret = CLIENT SECRET
~~~

Recall that `CLIENT ID`{:.param} and `CLIENT SECRET`{:.param} for your SAMI application can be found on the [Developer Portal](/sami/sami-documentation/developer-user-portals.html#creating-an-application).

### Handle the notification payload

After a SAMI notification passes authentication, the client extracts the notification ID from the payload. This is Step 5 of the [notification sequence](#receive-notifications-from-sami).

In the below example, `id`{:.param} is the notification ID.

~~~json
{
  "id": "4e8ab4fda0a444d1876099e3ad3sb77e",   
  "ts": 1434754443650,
  "type": "action",
  "subscriptionId": "dd66b5a1b35c428a8ede4966db73s1d9",
  "subscriptionQuery": {"uid":"johndoe", "ddid":"frontdoor_hue"},
  "startDate": 1434754443630,
  "endDate": 1434754443630
}
~~~

**Notification payload fields**

|Parameter   |Description
|----------- |-------------
|`id`{:.param} | Notification ID.
|`ts`{:.param} | Timestamp that the notification was created, in milliseconds since epoch.
|`type`{:.param} | Message type. Can be `message` or `action`.
|`subscriptionId`{:.param} | Subscription ID.
|`subscriptionQuery`{:.param} | Subscription query.
|`startDate`{:.param} | Timestamp of the first message, in milliseconds since epoch.
|`endDate`{:.param} | Timestamp of the last message, in milliseconds since epoch.

Note that `startDate`{:.param} and `endDate`{:.param} will be identical if a notification contains only one message.

## Get messages in a notification

The client makes HTTP GET calls to get the messages associated with the notification ID extracted from the [notification payload](#handle-the-notification-payload). 

`GET /notifications/<notificationID>/messages`
{:.pa.param.http}

Refer to the [notification API specification](/sami/api-spec.html#get-messages-in-notification) for the details of the request and response. Below is an example response containing a message.

~~~json
{ 
  "order":"asc",
  "total":1,
  "offset":0,
  "count":1,
  "data":[ 
    { 
       "mid":"057a407d4f814cbc874f3f7a0485af3b",
       "data":{ 
         "dateMicro":1421281794211000,
         "ecg":-73
       },
       "ts":1421281794212,
       "sdtid":"dtaeaf898b4db941gba",
       "cts":1421281794212,
       "uid":"7b202300eb904149b36e9739574s62a5",
       "mv":1,
       "sdid":"4697f11336c540a69ffd6s445061215e"
    }
  ]
}
~~~

Due to [notification batching](#batch-notifications), one notification could include multiple messages sent within a short time period. Since one GET call can only return a maximum of 100 messages, it is the client's responsibility to use a proper algorithm to retrieve all messages associated with one notification. 

For example, the client could check if `count`{:.param} in the response reaches the maximum number. If so, it then tracks the accumulative count of messages received for this notification and makes another GET call with the same notification ID, but with the increased `offset`{:.param} value. Specifically, the `offset`{:.param} value is equal to the accumlative count plus one. The client repeats this process until `count`{:.param} is less than 100. 

## Batch notifications

To avoid flooding a client with a large number of notifications, SAMI queues notifications for each subscription based on the following principles:

* If a notification is triggered by a message with type `action`, it is sent to the client immediately.
* If a notification is the first notification of a given subscription, it is sent immediately.
* For subsequent notifications for the same subscription, SAMI queues them. Every 30 seconds, SAMI aggregates all notifications arrived in this time period into one notification, and sends this notification to the client. This means sending a notification for message type `message` could be delayed up to 30 seconds after SAMI detects the triggering event.

## Two types of callbacks

There are two separate cases where SAMI makes HTTP POST calls to a client callback URL. The client is responsible for differentiating them. 

* When confirming a subscription (Step 4 of the [subscription sequence](#subscribe-to-sami)). This only happens once for one subscription.
* When sending notifications (Step 1 of the [notification sequence](#receive-notifications-from-sami)). 

Below are two suggestions for differentiating the SAMI requests:

* Check if a `nonce`{:.param} field is in the HTTP request body. If it exists, it is a [subscription confirmation request](#confirm-a-subscription). Otherwise, it is a notification. 
* Check if an [OAuth authorization header](#authenticate-notifications) exists. If it exists, it is a notification. Otherwise, it is a subscription confirmation request.