---
title: "API specification"

---
# API specification

## Introduction

The SAMI API provides access to the SAMI platform.

Every SAMI API call requires an access token. Read [**Authentication**](https://developer.samsungsami.io/sami/sami-documentation/authentication.html#use-an-access-token) to learn about obtaining and using access tokens.
{:.info}

The API is continually being developed and refined. Stay in touch with the SAMI team for any questions and updates.
 {: .warning}

See [**Validation and errors**](#validation-and-errors) for a list of error
codes that can be returned.
{:.info}

### Endpoints

~~~
https://api.samsungsami.io/v1.1
wss://api.samsungsami.io/v1.1
https://accounts.samsungsami.io
~~~

MQTT endpoints are described [here](#mqtt).

### Request parameters

For all the `POST`{:.param} and `PUT`{:.param} calls, pass request parameters as a JSON payload in the request body not as URL parameters.

### Timestamps

All timestamps are in milliseconds since epoch.

### Rate limits

The rate limits for the API calls are documented [here.](/sami/sami-documentation/rate-limiting.html)

### Message limits

Any message sent to SAMI may not be bigger than 10 KB.

Any message sent to SAMI via MQTT may not be bigger than 1 KB.

## MQTT

For implementation details, please refer to [this page](/sami/connect-the-data/mqtt.html).

### Establish MQTT session

|MQTT Components   |Required Value | Notes
|------|-----------|---------------------------------
|Security    |SSL                | SAMI device must be SSL-capable so that it can validate server certificate.
|Broker URL  |api.samsungsami.io | Needed for opening the connection to the broker.
|Broker port |8883 | Needed for opening the connection to the broker.
|username    |Device ID | A valid SAMI device ID used to login to establish a session.
|password    |Device Token |A valid SAMI device token used to login to establish a session.

A device uses the above MQTT parameters to connect to the SAMI MQTT broker, and then logs in to establish an MQTT session. The device can publish data-only messages and/or subscribe to receive Actions targeted to it within this session.

### Publish a message

`/v1.1/messages/<DEVICE ID>`{:.pa.param.http}

A device uses this path to publish a data-only message (a message with type `message`). An MQTT message contains only the value of the `data`{:.param} field in a [message sent via POST](#post-a-message-or-action). 

**Request parameters**

  |Parameter   |Description   |
  |----------- |--------------|
  |`DEVICE ID`{:.param}   | ID of the device publishing an MQTT message.|

**Example MQTT message**

~~~
{"onFire":false,"temperature":50}
~~~

### Subscribe to receive Actions

`/v1.1/actions/<DEVICE ID>`{:.pa.param.http}

A device subscribes at this path to receive Actions (a message with type `action`) that are targeted to it. When a source device or an application sends an Action to the subscribed device via REST or WebSocket, the device receives the Action. 

**Request parameters**

  |Parameter   |Description   |
  |----------- |--------------|
  |`DEVICE ID`{:.param}   | ID of the subscribing device.|

**Example recieved Action**

~~~
[{"name":"setOn","parameters":{}}]
~~~

The received Action only contains the value of the `actions` field in the `data` JSON object of a typical [SAMI message](#post-a-message-or-action).

## API Console

The SAMI API Console is found at [https://api-console.samsungsami.io/sami.](https://api-console.samsungsami.io/sami) In order to use the Console, you must first authenticate with your Samsung account. If you don’t have a Samsung account, you can create it during the process. 

After authentication, you can test each of the below calls using parameters returned in the Console and the [Developer Portal.](https://devportal.samsungsami.io/)


## Users

### Get the current user's profile

`GET /users/self`{:.pa.param.http}

Returns the current user's profile. The user must be authenticated with a bearer access token.

**Example response**

~~~~
{
  "data":{
    "id":"db2e64c653b94f519dbca8f157f73b79",
    "name":"tuser",
    "email":"tuser@ssi.samsung.com",
    "fullName":"Test User",
    "createdOn": 1403042304, // unix time in milliseconds
    "modifiedOn": 1403042305 // unix time in milliseconds
  }
}
~~~~

### Get a user's application properties

`GET /users/<userID>/properties`
{:.pa.param.http}

Returns the properties of a user's application.

The call must be authenticated with a valid Authorization header. The application for which the properties are searched is the application linked to the Authorization token.

**Request parameters**

  |Parameter   |Description
  |----------- |-------------
  |`userID`{:.param}   |User ID.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |-------------
  |`aid`{:.param}   |Application ID. String between 1 and 36 characters.

**Example response**

~~~~
{
  "data":{
    "uid":"03c99e714b78420ea836724cedcebd49",
    "aid":"181a0d34621f4a4d80a43444a4658150",
    "properties":"custom"
  }
}      
~~~~

### Create a user's application properties

`POST /users/<userID>/properties`
{:.pa.param.http}

Specifies the properties of a user's application.

The call must be authenticated with a valid Authorization header. The
application for which the properties are created is the application
linked to the Authorization token and MUST be the same as the `aid`{:.param}
parameter sent in the JSON Payload.

**Request parameters**

  |Parameter   |Description |
  |----------- |-------------|
  |`userID`{:.param}   |User ID. |

**Example request**

~~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "aid":"9628eef2a00d43d89b757b8d34373588",
  "properties":"{\"some\":[\"custom\",\"properties\"]}"
}   
~~~~

**Request body parameters**

  |Parameter      |Description |
  |-------------- |--------------------------------------------------------------------------------------------------------|
  |`uid`{:.param}         | (Optional) User ID. String representation of a User ID. |
  |`aid`{:.param}         |Application ID. String between 1 and 36 characters. |
  |`properties`{:.param}  |Custom properties for each user in the format that the application wants. String max 10000 characters. |

**Example response**

~~~~
{
  "data":{
    "uid":"03c99e714b78420ea836724cedcebd49",
    "aid":"9628eef2a00d43d89b757b8d34373588",
    "properties":"{\"some\":[\"custom\",\"properties\"]}"
  }
}
~~~~

### Update a user's application properties

`PUT /users/<userID>/properties`
{:.pa.param.http}

Modifies the properties of a user's application.

The call must be authenticated with a valid Authorization header. The
application for which the properties are updated is the application
linked to the Authorization token and MUST be the same as the `aid`{:.param} parameter sent in the JSON Payload.

**Request parameters**

  |Parameter   |Description
  |----------- |-------------
  |`userID`{:.param}   |User ID.

**Example request**

~~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "aid":"9628eef2a00d43d89b757b8d34373588",
  "properties":"{\"some\":[\"custom\",\"properties\",3],\"more\":\"props\"}"
}
~~~~

**Request body parameters**

  |Parameter      |Description
  |-------------- |---------------------------------------------------------------------------------------------------------------
  |`uid`{:.param}         | (Optional) User ID. String representation of a User ID. 
  |`aid`{:.param}         |Application ID. String between 1 and 36 characters.   
  |`properties`{:.param}  |Custom properties for each user in the format that the application wants. String max 10000 characters. 

**Example response**

~~~~
{
  "data":{
    "uid":"03c99e714b78420ea836724cedcebd49",
    "aid":"9628eef2a00d43d89b757b8d34373588",
    "properties":"{\"some\":[\"custom\",\"properties\",3],\"more\":\"props\"}"
  }
}
~~~~

### Delete a user's application properties

`DELETE /users/<userID>/properties`
{:.pa.param.http}

Deletes the properties of a user's application.

The call must be authenticated with a valid Authorization header. The
application for which the properties are deleted is the application
linked to the Authorization token.

**Request parameters**

  |Parameter   |Description   |
  |----------- |--------------|
  |`userID`{:.param}   | User ID.|

**Available URL query parameters**

  |Parameter   |Description
  |----------- |-------------
  |`aid`{:.param}   |Application ID. String between 1 and 36 characters.

**Example response**

~~~~
{
  "data":{
    "uid":"03c99e714b78420ea836724cedcebd49",
    "aid":"9628eef2a00d43d89b757b8d34373588",
    "properties":""
  }
}          
~~~~

### Get a user's devices

`GET /users/<userID>/devices`
{:.pa.param.http}

Returns the devices registered to a user.

**Request parameters**

  |Parameter   |Description
  |----------- |-------------
  |`userID`{:.param}   |User ID.

**Available URL query parameters**

  |Parameter |Descrption
  |--------- |-----------
  |`count`{:.param} |(Optional) Number of items to return per query.
  |`offset`{:.param} |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination).
  |`includeProperties`{:.param} |(Optional) Boolean (true/false). Returns device properties set by SAMI. If not specified, defaults to false.

**Example response**

~~~~
{
  "data": {
    "devices": [
      {
        "id": "SdP8UyrNdNBm",
        "dtid": "polestar_locator_v2",
        "name": "Polestar locator v2 Betty",
        "manifestVersion":2,
        "manifestVersionPolicy":"LATEST",
        "needProviderAuth": false
      },
      {
        "id": "e98fsEKW5cQp",
        "dtid": "polestar_locator_coord",
        "name": "Polestar Locator Coord Betty S2",
        "manifestVersion":5,
        "manifestVersionPolicy":"DEVICE",
        "needProviderAuth": true
      }
    ]
  },
  "total": 2,
  "offset": 0,
  "count": 2
}         
~~~~

**Response parameters**

|Parameter   |Description    |
|----------- |---------------|
|`id`{:.param}   | Device ID.  |
|`dtid`{:.param} | Device Type ID. |
|`name`{:.param} | Device name.    |
|`manifestVersion`{:.param} | Device's Manifest version that is used to parse the messages it sends to SAMI. |
|`manifestVersionPolicy`{:.param} | Device's policy that will be applied to the messages sent by this device. <ul><li> LATEST means it will use the most recent manifest created.</li><li>DEVICE means it will use a specific version of the manifest regardless if newer versions are available.</li></ul> |
|`needProviderAuth`{:.param} | If `false` the device needs authentication and is authenticated. If `true` the device needs authentication and is not authenticated.
|`total`{:.param} |Total number of items.
|`offset`{:.param} |String required for pagination.
|`count`{:.param} |Number of items returned on the page.

### Get a user's device types

`GET /users/<userID>/devicetypes`
{:.pa.param.http}

Returns the device types owned by a user.

**Request parameters**

  |Parameter         |Description
  |----------------- |-----------
  |`userID`{:.param}   |User ID.

**Available URL query parameters**

  |Parameter |Descrption
  |--------- |-----------
  |`count`{:.param} |(Optional) Number of items to return per query.
  |`offset`{:.param} |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination).
  |`includeShared`{:.param} |(Optional) Boolean (true/false). Also returns device types shared by other users. If not specified, defaults to false and returns only the user's device types. 

**Example response**

~~~~
{
  "data": {
    "deviceTypes": [
      {
        "id":"dta38d91dfd9164e96a5dc74ef2305af43",
        "uid": "12345",
        "name":"Samsung Web Camera XYZ",
        "published":true,
        "latestVersion":5,
        "uniqueName":"com.samsung.web.camera"
      },
      ...
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1  
}            
~~~~

**Response parameters**

  |Parameter         |Description
  |------------------|-----------
  |`id`{:.param}             |Device Type ID.
  |`uid`{:.param}            |Owner's user ID.
  |`name`{:.param}           |Device type name.
  |`published`{:.param}      |Device type published.
  |`latestVersion`{:.param}  |Device type latest Manifest version available.
  |`uniqueName`{:.param}     |Device type unique name in the system (used for Manifest package naming). Has to be a valid JAVA package name.
  |`total`{:.param} |Total number of items.
  |`offset`{:.param} |String required for pagination.
  |`count`{:.param} |Number of items returned on the page.

### Get a user's trials

`GET /users/<userID>/trials`
{:.pa.param.http}

Returns the trials of a participant or administrator.

**Request parameters**

  |Parameter         |Description
  |----------------- |-----------
  |`userID`{:.param}   |User ID.

**Available URL query parameters**

 |Parameter |Descrption
  |--------- |-----------
  |`count`{:.param} |(Optional) Number of items to return per query.
  |`offset`{:.param} |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination).
  |`role`{:.param} |Role of user. Can be `administrator` or `participant`.

**Example response**

~~~
{
  "data": {
    "trials": [
      {
        "id": "924228cf373b4e6ebc343cdf1366209e",
        "ownerId": "7b202300eb904149b36e9739574962a5",
        "name": "My First Trial",
        "description": "This is my first trial",
        "startDate": 1426868135000,
        "endDate": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

**Response parameters**

|Parameter         |Description
|--------- |-----------
|`id`{:.param} |Trial ID.
|`ownerId`{:.param} |User ID of trial creator.
|`name`{:.param} |Trial name.
|`description`{:.param} |Trial description. String max 1500 characters.
|`startDate`{:.param} |Start date of the trial (in milliseconds since epoch). Set to the current date-time when the trial is created.
|`endDate`{:.param} |End date of the trial (in milliseconds since epoch). Set to the current date-time when the trial is stopped.

## Devices

### Get a device

`GET /devices/<deviceID>`
{:.pa.param.http}

Returns a specific device.

**Request parameters**

  |Parameter    |Description |
  |------------ |-------------|
  |`deviceID`{:.param} | Device ID. |


**Available URL query parameters**

  |Parameter    |Description |
  |------------ |-------------|  
  |`properties`{:.param} | (Optional) Boolean (true/false). Returns device properties set by SAMI. If not specified, defaults to false.

**Example response**

~~~~
{
  "data":{
    "id":"d1d04e4cb18a4757b5481901e3665a34",
    "uid":"2",
    "dtid":"181a0d34621f4a4d80a43444a4658150",
    "name":"Office lamp 1",
    "manifestVersion":2,
    "manifestVersionPolicy":"LATEST",
    "needProviderAuth": false
  }
}
          
~~~~

**Response parameters**

|Parameter   |Description    |
|----------- |---------------|
|`id`{:.param}   | Device ID.  |
|`uid`{:.param}  | User ID.    |
|`dtid`{:.param} | Device Type ID. |
|`name`{:.param} | Device name.    |
|`manifestVersion`{:.param} | Device's Manifest version that is used to parse the messages it sends to SAMI. |
|`manifestVersionPolicy`{:.param} | Device's policy that will be applied to the messages sent by this device. <ul><li> `LATEST` means it will use the most recent manifest created.</li><li>`DEVICE` means it will use a specific version of the manifest regardless if newer versions are available.</li></ul>
|`needProviderAuth`{:.param} | If `false` the device needs authentication and is authenticated. If `true` the device needs authentication and is not authenticated.


### Create a device

`POST /devices`
{:.pa.param.http}

Adds a device.

**Example request**

~~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "dtid":"181a0d34621f4a4d80a43444a4658150",
  "name":"Office lamp 2",
  "manifestVersion":5,
  "manifestVersionPolicy":"DEVICE"
}
          
~~~~

**Request body parameters**

|Parameter   |Description
  |----------- |-------------
  |`uid`{:.param}  |User ID. String representation of a User ID.
  |`dtid`{:.param} |Device Type ID.
  |`name`{:.param} |Device name. Between 5 and 36 characters.
  |`manifestVersion`{:.param} | (Optional) Numeric greater than 0 (zero). Device's Manifest version that is used to parse the messages it sends to SAMI.
  |`manifestVersionPolicy`{:.param} |(Optional) String. Device's policy that will be applied to the messages sent by this device. Only 2 values available. If not sent, defaults to `LATEST`. <ul><li>`LATEST` means it will use the most recent manifest created.</li> <li>`DEVICE` means it will use a specific version of the manifest regardless if newer versions are available. `manifestVersion`{:.param} will stay with this version.

**Example response**

~~~~
{
  "data":{
    "uid":"03c99e714b78420ea836724cedcebd49",
    "dtid":"181a0d34621f4a4d80a43444a4658150",
    "name":"Office lamp 2",
    "manifestVersion":5,
    "manifestVersionPolicy":"LATEST",
    "needProviderAuth": false
  }
}
          
~~~~

### Update a device

`PUT /devices/<deviceID>`
{:.pa.param.http}

Modifies a device's parameters.

**Request parameters**

  |Parameter    |Description
  |------------ |-------------
  |`deviceID`{:.param} |Device ID.

**Example request**

~~~~
{
  "uid":"1111",
  "dtid":"181a0d34621f4a4d80a43444a4658150",
  "name":"New Office Samsung lamp 2",
  "manifestVersion":3,
  "manifestVersionPolicy":"DEVICE",
}
          
~~~~

**Request body parameters**

|Parameter   |Description
  |----------- |-------------
  |`uid`{:.param}  |User ID. String representation of a User ID.
  |`dtid`{:.param} |Device Type ID.
  |`name`{:.param} |Device name. Between 5 and 36 characters.
  |`manifestVersion`{:.param} |Numeric greater than 0 (zero). Device's Manifest version that is used to parse the messages it sends to SAMI.
  |`manifestVersionPolicy`{:.param} |(Optional) String. Device's policy that will be applied to the messages sent by this device. Only 2 values available. If not sent, defaults to `LATEST`. <ul><li>`LATEST` means it will use the most recent manifest created.</li> <li>`DEVICE` means it will use a specific version of the manifest regardless if newer versions are available. `manifestVersion`{:.param} will stay with this version.

**Example response**

~~~~
{
  "data":{
    "id":"d1d04e4cb18a4757b5481901e3665a34",
    "uid":"1111",
    "dtid":"181a0d34621f4a4d80a43444a4658150",
    "name":"New Office Samsung lamp 2",
    "manifestVersion":3,
    "manifestVersionPolicy":"DEVICE"
  }
}
          
~~~~

### Delete a device

`DELETE /devices/<deviceID>`
{:.pa.param.http}

Deletes a device.

**Request parameters**

  |Parameter    |Description
  |------------ |-------------
  |`deviceID`{:.param}  |Device ID.

**Example response**

~~~~
{
  "data":{
    "id":"d1d04e4cb18a4757b5481901e3665a34",
    "uid":"1111",
    "dtid":"181a0d34621f4a4d80a43444a4658150",
    "name":"New Office Samsung lamp 2",
    "manifestVersion":3,
    "manifestVersionPolicy":"DEVICE"
  }
}
          
~~~~

### Get a device's token

`GET /devices/<deviceID>/tokens`
{:.pa.param.http}

Returns the access token of a device.

**Request parameters**

  |Parameter    |Description
  |------------ |-------------
  |`deviceID`{:.param}  |Device ID.

**Example response**

~~~~
{
  "data": {
    "accessToken": "ac4ed92410fa4c4b86d4d5d30f21be22",
    "uid": "7b202300eb904149b36e9739574962a5",
    "did": "03fd772ae34b4b2a81db909898506146",
  }
}
~~~~

### Create device token

`PUT /devices/<deviceID>/tokens`
{:.pa.param.http}

Creates a new access token for a device.

**Request parameters**

  |Parameter    |Description
  |------------ |-------------
  |`deviceID`{:.param}  |Device ID.

**Example response**

~~~~
{
  "data": {
    "accessToken": "0b312ca200cc47fbab80994262eb03ad",
    "uid": "7b202300eb904149b36e9739574962a5",
    "did": "9a020ce80acb47de93255607006908cf",
  }
}
~~~~

### Delete a device's token

`DELETE /devices/<deviceID>/tokens`
{:.pa.param.http}

Deletes the access token of a device.

**Request parameters**

  |Parameter    |Description
  |------------ |-------------
  |`deviceID`{:.param}  |Device ID.

**Example response**

~~~~
{
  "data": {
    "accessToken": "ac4ed92410fa4c4b86d4d5d30f21be22",
    "uid": "7b202300eb904149b36e9739574962a5",
    "did": "03fd772ae34b4b2a81db909898506146",
  }
}
~~~~

## Device Types

### Get a device type

`GET /devicetypes/<deviceTypeID>`
{:.pa.param.http}

Returns the device type of a device.

**Request parameters**

  |Parameter        |Description
  |---------------- |----------------
  |`deviceTypeID`{:.param}  |Device Type ID.

**Example response**

~~~~
{
  "data": {
    "id": "dt71c282d4fad94a69b22fa6d1e449fbbb",
    "uid": "650a7c8b6ca44730b077ce849af64e90",
    "name": "SAMI Example Smart Light",
    "published": true,
    "approved": true,
    "latestVersion": 1,
    "uniqueName": "io.samsungsami.example.smart_light",
    "vid": "0",
    "rsp": false,
    "issuerDn": null,
    "description": null
  }
}
~~~~

**Response parameters**

  |Parameter         |Description
  |----------------- |-----------------------------------------------------------------------------------------------------------------------
  |`id`{:.param}             |Device Type ID.
  |`uid`{:.param}            |Owner's user ID.
  |`name`{:.param}           |Device Type name.
  |`published`{:.param}      |Device type published.
  |`approved`{:.param} |Device type latest Manifest approved by SAMI team.
  |`latestVersion`{:.param}  |Device type latest Manifest version available.
  |`uniqueName`{:.param}     |Device type unique name in the system (will be used for Manifest package naming). Has to be a valid JAVA package name.
  |`vid`{:.param} | Vendor ID.
  |`rsp`{:.param} | Boolean (true/false). Requires secure protocol. Defaults to `false` if not specified.
  |`issuerDn`{:.param} | Issuer of the client certificate. Used in conjunction with `rsp`.
  |`description`{:.param} | Custom description of the device type. String max 1500 characters.

### Get device types

`GET /devicetypes/`
{:.pa.param.http}

Returns a list of device types.

**Available URL query parameters**

  |Parameter    |Description
  |------------ |-------------
  |`name`{:.param}  |Name of the device type.
  |`count`{:.param} | (Optional) Number of items to return per query.  
  |`offset`{:.param} |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination). 

**Example response**

~~~~
{
  "data": {
    "deviceTypes": [
      {
        "id": "basis_watch",
        "uid": "10023",
        "name": "Basis Watch",
        "published": true,
        "approved": true,
        "latestVersion": 1,
        "uniqueName": "basis_watch",
        "vid": "0",
        "rsp": false,
        "issuerDn": null,
        "description": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param}             |Device Type ID.
|`uid`{:.param}            |Owner's user ID.
|`name`{:.param}           |Device Type name.
|`published`{:.param}      |Device type published.
|`approved`{:.param} |Device type latest Manifest approved by SAMI team.
|`latestVersion`{:.param}  |Device type latest Manifest version available.
|`uniqueName`{:.param}     |Device type unique name in the system (will be used for Manifest package naming). Has to be a valid JAVA package name.
|`vid`{:.param} | Vendor ID.
|`rsp`{:.param} | Boolean (true/false). Requires secure protocol. Defaults to `false` if not specified.
|`issuerDn`{:.param} | Issuer of the client certificate. Used in conjunction with `rsp`.
|`description`{:.param} | Custom description of the device type. String max 1500 characters.
|`total`{:.param} |Total number of items.
|`offset`{:.param} |String required for pagination.
|`count`{:.param} |Number of items returned on the page.

### Get latest Manifest properties

`GET /devicetypes/<deviceTypeID>/manifests/latest/properties`
{:.pa.param.http}

Returns the properties for the latest Manifest version. This will return metadata about the Manifest, such as the fields and the units they are expressed in.


**Request parameters**

  |Parameter        |Description
  |---------------- |----------------------------------------------------------------------------------
  |`deviceTypeID`{:.param}  |Device type ID.

**Example response**

~~~~
{
  "data":{
    "properties" : {
      "fields": {
        "calories": {
          "type": "Double",
          "unit": "J*4.184",
          "isCollection": false,
          "description": "calories"
        },
        "heartRate": {
          "type": "Integer",
          "unit": "b/min",
          "isCollection": false,
          "description": "heartRate"
        },
        ...
      }
    },
    "actions": {}
  }
}
~~~~

### Get Manifest properties

`GET /devicetypes/<deviceTypeID>/manifests/<version>/properties`
{:.pa.param.http}

Returns the properties for a specific Manifest version. This will return metadata about the Manifest, such as the fields and the units they are expressed in.


**Request parameters**

  |Parameter        |Description
  |---------------- |----------------------------------------------------------------------------------
  |`deviceTypeID`{:.param}  |Device type ID.
  |`version`{:.param}       |Manifest version number.

**Example response**

~~~~
{
  "data":{
    "properties" : {
      "fields": {
        "calories": {
          "type": "Double",
          "unit": "J*4.184",
          "isCollection": false,
          "description": "calories"
        },
        "heartRate": {
          "type": "Integer",
          "unit": "b/min",
          "isCollection": false,
          "description": "heartRate"
        },
        ...
      }
    },
    "actions": {}
  }
}
~~~~

### Get available Manifest version numbers

`GET /devicetypes/<deviceTypeID>/availablemanifestversions`
{:.pa.param.http}

Returns the available Manifest versions for a device type.


**Request parameters**

  |Parameter        |Description
  |---------------- |----------------
  |`deviceTypeID`{:.param}  |Device type ID.

**Example response**

~~~~
{
  "data":{
    "versions":[1,2,3,4]
  }
}
          
~~~~

## Messages

### Post a message or Action

`POST /messages`
{:.pa.param.http}

Sends a message or Action, using one of the following parameter combinations. If sending Actions, only "actions" should be contained in the payload.

|Combination |Required Parameters
|------------|---------
|Send message |`sdid`{:.param}, `type=message`{:.param}
|Send action |`ddid`{:.param}, `type=action`{:.param}
|Common parameters |`data`{:.param}, `ts`{:.param}

**Example request (message)**

~~~
{
  "sdid": "4697f11336c540a69ffd6f445061215e",
  "ddid": "9f06411ad3174a4f98444a374447fe10",
  "ts": 1388179812427,
  "type": "message",
  "data": [payload]
}         
~~~

**Example request (Action)**

~~~
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
  }
}
~~~

**Request body parameters**

  |Parameter   |Description
  |----------- |-----------
  |`sdid`{:.param}     |(Optional) Source device ID.
  |`data`{:.param}     |Data. Can be a simple text field, or a JSON document.
  |`ddid`{:.param}     |(Optional) Destination device ID. Can be used when sending a message to another device.
  |`ts`{:.param}       |(Optional) Message timestamp. Must be a valid time: past time, present or future up to the current server timestamp grace period. Current time if omitted.
  |`type`{:.param} |Type of message: `message` or `action` (default: `message`).
  |`token`{:.param}  |(Optional) Device token.

**Example response**

~~~~
{
  "data": {
    "mid": "7fb20d3809b54075af6bdfc22591c521"
  }
}           
~~~~

**Response parameters**

  |Parameter   |Description
  |----------- |-------------
  |`mid`{:.param}      |Message ID.


### Get normalized messages

`GET /messages`
{:.pa.param.http}

Returns normalized messages, according to one of the following parameter combinations:

|Combination |Required Parameters
|------------|---------
|Get by device |`sdid`{:.param}, `endDate`{:.param}, `startDate`{:.param}
|Get by message ID |`mid`{:.param}
|Get by device and field presence |`sdid`{:.param}, `fieldPresence`{:.param}
|Get by device, filter and date range |`sdid`{:.param}, `filter`{:.param}, `endDate`{:.param}, `startDate`{:.param}
|Common parameters |`order`{:.param}, `count`{:.param}, `offset`{:.param}

**Available URL query parameters**

|Parameter |Description
|----------|------------
| `count`{:.param}     | Number of items to return per query.
| `endDate`{:.param}   | (Optional) Time of latest (newest) item to return, in milliseconds since epoch.
| `fieldPresence`{:.param}      | (Optional) String representing a field from the specified device ID.
| `filter`{:.param} | (Optional) Filter messages by fields (attributes) and values separated by colon. Fields defined in Manifests should be lowercased when using filters, e.g., ecg:80, ecg:>=80.
| `mid`{:.param}   | (Optional) The SAMI message ID being searched.
| `offset`{:.param} | (Optional) A string that represents the starting item; should be the value of 'next' field received in the last response (required for pagination).
|`order`{:.param}     | (Optional) Desired sort order: `asc` or `desc` (default: `asc`).
| `sdid`{:.param}      | (Optional) Source device ID of the messages being searched.
| `startDate`{:.param} | (Optional) Time of earliest (oldest) item to return, in milliseconds since epoch.
| `uid`{:.param}       | (Optional) The owner's user ID of the messages being searched. If not specified, assume that of the current authenticated user. If specified, it must be that of a user for which the current authenticated user has read access to.


**Example response**

~~~~
{
  "uid": "7b202300eb904149b36e9739574962a5",
  "sdid": "4697f11336c540a69ffd6f445061215e",
  "startDate": 1421281794212,
  "endDate": 1421281794230,
  "count": 100,
  "order": "asc",
  "size": 1,
  "data": [
    {
      "mid": "057a407d4f814cbc874f3f7a0485af3b",
      "data": {
        "dateMicro": 1421281794211000,
        "ecg": -73
      },
      "ts": 1421281794212,
      "sdtid": "vitalconnect_module",
      "cts": 1421281794212,
      "uid": "7b202300eb904149b36e9739574962a5",
      "mv": 1,
      "sdid": "4697f11336c540a69ffd6f445061215e"
    }
  ]
}
~~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`uid`{:.param} |User ID.
|`sdid`{:.param} |Source device ID.
|`startDate`{:.param} |Time of earliest message requested.
|`endDate`{:.param} |Time of latest message requested.
|`count`{:.param} |Number of items requested.
|`order`{:.param} |Sort order.
|`size`{:.param} |Number of items received.
|`mid`{:.param} |Message ID.
|`ts`{:.param} |Timestamp from source.
|`sdtid`{:.param} |Source device type ID.
|`cts`{:.param} |Timestamp from SAMI.
|`mv`{:.param} |Manifest version.

### Get normalized message aggregates

`GET /messages/analytics/aggregates`
{:.pa.param.http}

Returns the sum, minimum, maximum, mean and count of message fields that are numerical. This call generates results on messages that are at least 1 minute old. Values for `startDate`{:.param} and `endDate`{:.param} are rounded to start of minute, and the date range between `startDate`{:.param} and `endDate`{:.param} is restricted to 31 days max.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`endDate`{:.param}    |Time of latest (newest) item to return, in milliseconds since epoch.
  |`field`{:.param}    |Message field being queried for analytics.
  |`sdid`{:.param} |Source device ID of the messages being queried.
  |`startDate`{:.param} |Time of earliest (oldest) item to return, in milliseconds since epoch.

**Example response**

~~~
{
  "sdid": "deea2ca077b94d2db337722e28b41287",
  "startDate": "1426441570303",
  "endDate": "1427049970303",
  "field": "stepcount",
  "size": 1,
  "data": [
    {
      "count": 83,
      "min": 23,
      "max": 17095,
      "mean": 5649.989,
      "sum": 468949.06,
      "variance": 28158896
    }
  ]
}
~~~

**Response parameters**

|Parameter |Description
|--------- |-----------
|`sdid`{:.param} |Source device ID.
|`startDate`{:.param} |Time of earliest message requested.
|`endDate`{:.param} |Time of latest message requested.
|`field`{:.param} |Message field.
|`size`{:.param} |Number of items received.
|`count`{:.param} |Number of items requested.
|`min`{:.param} |Lowest-value item.
|`max`{:.param} |Highest-value item.
|`mean`{:.param} |Mean value of items.
|`sum`{:.param} |Sum of items.
|`variance`{:.param} |Variance of items.

### Get normalized message histogram

`GET /messages/analytics/histogram`
{:.pa.param.http}

Returns message aggregates over equal intervals, which can be used to draw a histogram. This call generates results on messages that are at least 1 minute old. For each `interval`, the sum, minimum, maximum, mean, count and variance of message fields are returned.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`endDate`{:.param}    |End time of histogram in milliseconds. Should be beginning of the time `interval`.
  |`field`{:.param}    |Message field being queried for histogram aggregation (histogram Y-axis).
  |`sdid`{:.param} |Source device ID of the messages being queried.
  |`interval`{:.param} |Interval on histogram X-axis. Can be: `minute` (1-hour limit), `hour` (1-day limit), `day` (31-day limit), `month` (1-year limit) or `year` (1-year limit).
  |`startDate`{:.param} |Start time of histogram in milliseconds. Should be beginning of the time `interval`.

**Example response**

~~~
{
  "sdid": "1c1e46b708ff4cb5994e6332786adbc9",
  "startDate": "1429315200000",
  "endDate": "1429747200000",
  "field": "datemicro",
  "interval": "day",
  "size": 2,
  "data": [
    {
      "count": 12,
      "min": 1429471890000,
      "max": 1429471890000,
      "mean": 1429471890000,
      "sum": 17153663200000,
      "variance": 0,
      "ts": 1429401600000
    },
    {
      "count": 2,
      "min": 1429471890000,
      "max": 1429471890000,
      "mean": 1429471890000,
      "sum": 2858943770000,
      "variance": 0,
      "ts": 1429574400000
    }
  ]
}
~~~

**Response parameters**

|Parameter |Description
|--------- |-----------
|`sdid`{:.param} |Source device ID.
|`startDate`{:.param} |Time of earliest message requested.
|`endDate`{:.param} |Time of latest message requested.
|`field`{:.param} |Message field.
|`interval`{:.param} |Interval of histogram X-axis.
|`size`{:.param} |Number of histogram segments.
|`count`{:.param} |Number of items.
|`min`{:.param} |Lowest-value item.
|`max`{:.param} |Highest-value item.
|`mean`{:.param} |Mean value of items.
|`sum`{:.param} |Sum of items.
|`variance`{:.param} |Variance of items.
|`ts`{:.param} |Timestamp of the histogram segment.

### Get last normalized messages

`GET /messages/last`
{:.pa.param.http}

Returns the most recent normalized messages from a device or devices.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`sdids`{:.param}    |Comma-separated list of source device IDs (minimum: 1).
  |`count`{:.param}    |Number of items to return per query. Limited to 100.
  |`fieldPresence`{:.param} |(Optional) String representing a field from the specified device ID.

**Example response**

~~~~
{
  "sdids": "4697f11336c540a69ffd6f445061215e",
  "count": 2,
  "size": 2,
  "data": [
    {
      "mid": "fc344af3869d40ffb856824bbb6ee92a",
      "data": {
        "dateMicro": 1414692018449000,
        "ecg": -127
      },
      "ts": 1414692018448,
      "sdtid": "vitalconnect_module",
      "cts": 1414692018448,
      "uid": "7b202300eb904149b36e9739574962a5",
      "mv": 1,
      "sdid": "4697f11336c540a69ffd6f445061215e"
    },
    {
      "mid": "f70c58dd5d134d3095c6c796bc517d4e",
      "data": {
        "dateMicro": 1414692018439000,
        "ecg": -98
      },
      "ts": 1414692018438,
      "sdtid": "vitalconnect_module",
      "cts": 1414692018438,
      "uid": "7b202300eb904149b36e9739574962a5",
      "mv": 1,
      "sdid": "4697f11336c540a69ffd6f445061215e"
    }
  ]
}
~~~~


### Get normalized messages presence

`GET /messages/presence`
{:.pa.param.http}

Returns presence of normalized messages.

**Available URL query parameters**

  |Parameter         |Description
  |----------------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`sdid`{:.param}           |(Optional) Source device ID of the messages being searched.
  |`interval`{:.param}       |String representing grouping interval. One of: `minute` (1-hour limit), `hour` (1-day limit), `day` (31-day limit), `month` (1-year limit) or `year` (10-year limit).
  |`fieldPresence`{:.param}  |(Optional) String representing a field from the specified device ID.
  |`startDate`{:.param}      |Time of earliest (oldest) item to return, in milliseconds since epoch.
  |`endDate`{:.param}        |Time of latest (newest) item to return, in milliseconds since epoch.

**Example response**

~~~~
{
  "sdid": "4697f11336c540a69ffd6f445061215e",
  "fieldPresence": "ecg",
  "interval": "MINUTE",
  "startDate": 1414691892883,
  "endDate": 1414691893809,
  "size": 1,
  "data": [
    {
      "startDate": 1414691880000
    }
  ]
}
~~~~

## Export

### Create an export request

`POST /messages/export`
{:.pa.param.http}

Exports normalized messages from up to 30 days, according to one of the following parameter combinations. The maximum duration between `startDate`{:.param} and `endDate`{:.param} is 31 days. A confirmation message is emailed when the export request has been processed.

Data can be exported in JSON or "simple" CSV. CSV exports sort the message metadata into separate columns and the data payload into a unique column.

|Combination |Required Parameters
|------------|---------
|Get by users |`uids`{:.param}
|Get by devices |`sdids`{:.param}
|Get by device types |`uids`{:.param}, `sdtids`{:.param}
|Get by trial |`trialID`{:.param}
|Get by combination of parameters |`uids`{:.param}, `sdids`{:.param}, `sdtids`{:.param}
|Common parameters |`startDate`{:.param}, `endDate`{:.param}, `order`{:.param}, `format`{:.param}, `url`{:.param}, `csvHeaders`{:.param}

**Request body parameters**

|Parameter |Description
|----------|------------
|`csvHeaders`{:.param} |(Optional) Adds a header to a CSV export. Accepted values are `true`, `false`, `1`, `0`. Defaults to `true` if `format` = `csv1`.
|`endDate`{:.param}   | Time of latest (newest) item to return, in milliseconds since epoch.
|`format`{:.param}     | (Optional) Format the export will be returned as: `json` (JSON) or `csv1` (simple CSV). Defaults to `json` if not specified.
|`order`{:.param}     | (Optional) Desired sort order: `asc` or `desc` (default: `asc`).
|`sdids`{:.param}      | (Optional) Comma-separated list of source device IDs. Max 30 device IDs. For example, "egabbb,ffbcd87" for two device IDs.
|`startDate`{:.param} | Time of earliest (oldest) item to return, in milliseconds since epoch.
|`sdtids`{:.param} |(Optional) Comma-separated list of source device type IDs. Max 30 device type IDs. For example, "dtegabbb,dtffbcd87" for two device type IDs.
|`trialID`{:.param} |(Optional) Trial ID being searched for messages.
|`uids`{:.param}       | (Optional) Comma-separated list of user IDs. The current authenticated user must have read access to each user in the list. Max 30 user IDs. For example, "egabbb,ffbcd87" for two user IDs.
|`url`{:.param} |(Optional) URL to include in email confirmation message.

**Example response**

~~~
{
  "data":{
    "exportId": "f2fcf3e0-4425-11e4-be99-0002a5d5c51b",
    "uids": "7b202300eb904149b36e9739574962a5",
    "startDate": 1378425600000,
    "endDate": 2378425600000,
    "order": "asc",
    "format": "json"
  }
}
~~~

### Check export status

`GET /messages/export/<exportID>/status`
{:.pa.param.http}

Returns the status of the messages export.

**Request parameters**

  |Parameter   |Description
  |----------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`exportID`{:.param}     |The Export ID of the export query.

**Example response**

~~~
{
  "exportId": "52f921fac0f841e384de8bef438adf07",
  "status": "Served",
  "md5": "f73f0a2a69d0f2ca3f986f8b31f60b00",
  "expirationDate": 1426367261000,
  "fileSize": 189,
  "totalMessages": 0
}
~~~

**Response parameters**

|Parameter   |Description
|----------- |-------------
|`exportId`{:.param} | Export ID.
|`status`{:.param} | Status of the export query. Values include `Received`, `InProgress`, `Success`, `Failure`, `Served`, `Expired`.
|`md5`{:.param} |Checksum of the file returned.
|`expirationDate`{:.param} |Expiration date.
|`fileSize`{:.param} |File size in bytes.
|`totalMessages`{:.param} |Number of messages in the export.

### Get export result

`GET /messages/export/<exportID>/result`
{:.pa.param.http}

Returns the result of the export query. The result call returns the response in tgz format. 

**Request parameters**

  |Parameter   |Description
  |----------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`exportID`{:.param}     |The Export ID of the export query.

**Example response header**

~~~
{
  "access-control-allow-origin": "*",
  "x-rate-limit-limit": "100/1000",
  "x-sami-total-messages": "133744",
  "x-rate-limit-remaining": "96/984",
  "content-length": "4508385",
  "x-rate-limit-reset": "1426905929/1426982400",
  "content-type": "application/x-compressed",
  "content-disposition": "attachment; filename=\"84efe4d9030e490c9788ede466965011.tgz\""
}
~~~

|Field |Description
|----- |-----------
|`x-sami-total-messages`{:.param} | Total number of messages fetched from the database.
|`content-length`{:.param} | Size of the .tgz file in bytes.
|`content-disposition`{:.param} | Suggested filename to save. (Does not work on curl or older browsers.) 

The tar file may contain one or more files in the following format:

**Example response**

~~~
{
  "size": 1,
  "data": [
    {
      "mid": "b557fbb551f04987883e5b52fd589882",
      "data": 
        {
          "dateMicro": 1415753126779000, 
          "posture": 2, 
          "ecg": -80
        },
      "ts":1423880755000,
      "sdtid":"vitalconnect_module",
      "cts":1423881187801,
      "uid":"5533a9c7d2f84792a133328d1ddf713f",
      "mv":1,
      "sdid":"920937d451ec495e9aa869684d526e49"
    }
  ]
}
~~~

Each file in the tar file has the following format:  `id-date.json` or `id-date.csv` where `id` is either a `uid` or `sdid`, and `date` is a timestamp in milliseconds (the `ts` date of the first message in the file). If the result of a `uid` or `sdid` search is empty, the result will be a single file with the filename `id-0.json` or `id-0.csv` (`id` is either a `uid` or `sdid`).

### Get export history

`GET /messages/export/history`
{:.pa.param.http}

Returns a list of export queries that have been performed.

**Available URL query parameters**

|Parameter |Description
|--------- |-----------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".
|`trialId`{:.param} |(Optional) Trial ID.

**Example response**

~~~
{
  "count": 1,
  "offset": 0,
  "total": 1,
  "data": {
    "exports": [
      {
        "exportId": "52f921fac0f841e384de8bef438adf07",
        "request": {
          "requestDate": 1426280834731,
          "startDate": 1426273692267,
          "endDate": 1426277292267,
          "order": "asc",
          "format": "json"
        },
        "status": "Success",
        "md5": "f73f0a2a69d0f2ca3f986f8b31f60b00",
        "expirationDate": 1426367261000,
        "fileSize": 189,
        "totalMessages": 0
      }
    ]
  }
}
~~~


## WebSockets

By using WebSockets, you can set up a connection between SAMI and compatible devices or applications to receive and/or send messages in real-time.

There are two types of WebSockets: read-only and bi-directional. Your application uses a read-only WebSocket to listen to messages sent by the source devices that the application monitors. On the other hand, you would use a bi-directional WebSocket to receive messages targeted to your applications or devices. The bi-directional WebSocket also allows the applications or devices to send messages back to SAMI.

See [**WebSocket errors**](#websocket-errors) for a list of error
codes that can be returned for WebSockets.
{:.info}

### Read-only WebSocket

`WebSocket /live`
{:.pa.param.http}

This call sets up a one-directional data connection from SAMI to a WebSocket client. The read-only WebSocket is primarily used by applications with monitoring functionalities. The application, as the client, listens in real-time for any new messages sent to SAMI by the specified source devices.

Messages received at this WebSocket endpoint are not necessarily ordered based on the `ts` field.
{:.warning}

**Request parameters**

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

### Bi-directional message pipe

#### Setting up the pipe

This call opens a data connection between SAMI and a device or device list. 

`WebSocket /websocket`
{:.pa.param.http}

**Available URL query parameters**

| Parameter | Description
|-----------|--------------
|`ack`{:.param} |(Optional) Boolean (true/false). WebSocket returns ACK messages for each message sent by client. If not specified, defaults to false.

All client applications, including device proxies, must register after opening the connection. Otherwise client messages will be discarded and clients will not be sent messages.

If the client app does not register within 30 seconds of opening the connection, the WebSocket will be closed automatically.
{:.warning}

**Example registration message sent by client**

~~~
{
  "sdid": "DFKK234-JJO5",
  "Authorization": "bearer d77054a9b0874ba884499eef7768b7b9",
  "type": "register",
  "cid": "1234567890"
}         
~~~

**Request body parameters**

| Parameter | Description
|-----------|--------------
|`sdid`{:.param} |Source device ID.
|`Authorization`{:.param} |Access token with READ and WRITE access to `sdid`{:.param}. 
|`type`{:.param} |Type of message: must be `register` for registration message.
|`cid`{:.param} |(Optional) Client (application) ID. Can be used when `ack=true`.

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

##### Ping

SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the client must reconnect.

**Example ping message sent by server**

~~~
{
  "type": "ping"
}         
~~~

#### Sending messages

You can send a message with

 * `type`{:.param} as "message" to SAMI. 
 * `type`{:.param} as "action" to another device. You must specify `ddid`{:.param} in your request.

Sending a message via WebSockets differs from performing the REST call in that `cid`{:.param} can be included. Responses from SAMI include `cid`{:.param} to facilitate client side validations.

**Example request**

~~~
{
  "sdid": "d597a8ffb3364f98a904515cbc574cb2",
  "cid":"1234567890", 
  "type": "message",
  "data":{
    "someField": "someValue"
  }
}
~~~

**Request body parameters**

 |Parameter   |Description
  |----------- |-----------
  |`sdid`{:.param}     |(Optional) Source device ID. The ID of one of the devices registered on the bi-directional websocket.
  |`data`{:.param}     |Data. Can be a simple text field, or a JSON document.
  |`ddid`{:.param}     |(Optional) Destination device ID. Must be used when sending an Action to another device. Otherwise, only sends to SAMI to store.
  |`ts`{:.param}       |(Optional) Message timestamp. Must be a valid time: past time, present or future up to the current server timestamp grace period. Current time if omitted.
  |`type`{:.param} |Type of message: `message` or `action` (default: `message`).
  |`cid`{:.param} |(Optional) Client (application) ID. Can be used when `ack=true`. SAMI will return `cid`{:.param} (in addition to `mid`{:.param}) in its ACK messages to facilitate client side validations. This helps to clarify which response is for which message.

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

Devices connected to the bi-directional WebSocket receive messages that contain their corresponding `ddid`{:.param} (destination device ID) and have `type`{:.param} as "action".

**Example message received by client**

~~~
{
  "ddid": "<destination device ID = this client device ID>",
  "mid": "<message ID>",
  "type": "action",
  "data": {
    "actions": [
      {
        "name": "setOn",
        "parameters": {}
      }
    ]
  }
}    
~~~

## Subscriptions

### Create a subscription

`POST /subscriptions`
{:.pa.param.http}

Subscribes a client to receive notifications of messages for a user's devices. The devices are specified according to one of the following parameter combinations.

|Combination |Required Parameters |Message Type
|------------|---------|--------
|All user devices |`uid`{:.param} |`message`
|All user devices of a device type |`uid`{:.param}, `sdtid`{:.param}|`message`
|Specific user device |`uid`{:.param}, `sdid`{:.param}|`message`
|Destination device |`uid`{:.param}, `ddid`{:.param}|`action`

This call accepts application and user tokens as the access token.

**Example request**

~~~
{ 
   "messageType":"message",
   "uid":"5beb4e30be9145cb89742d0b315d391",
   "description":"This is a subscription to a user's devices",
   "callbackUrl":"https://api.example.com/messages?user=earl1234"
}
~~~

**Request body parameters**

|Parameter   |Description
|----------- |-------------
|`messageType`{:.param} | Message type to subscribe to. Can be `message` or `action`.
|`uid`{:.param} | User ID to subscribe to. Client will be notified for devices owned by this user.
|`sdtid`{:.param} | (Optional) Source device type ID to subscribe to. Client will be notified for all user-owned devices of this device type. Applicable when `messageType`{:.param} = `message`.
|`sdid`{:.param} | (Optional) Source device ID to subscribe to. Applicable when `messageType`{:.param} = `message`.
|`ddid`{:.param} | Destination device ID to subscribe to. Required when `messageType`{:.param} = `action`.
|`description`{:.param} | (Optional) Description of the subscription. String max 256 characters.
|`callbackUrl`{:.param} | Callback URL to be used (must be HTTPS). Can include query parameters.

**Example response**

~~~
{ 
  "data":{ 
    "id":"1673d7394737480d847023accc50c9d",
    "aid":"f9c81f2eb69343efb336ba2b7b7b7e2",
    "messageType":"message",
    "uid":"5beb4e30be9145cb89742d0b3f15d391",
    "description":"This is a subscription to a user's devices",
    "callbackUrl":"https://api.example.com/messages?user=earl1234",
    "status":"ACTIVE",
    "createdOn":1435191843948,
    "modifiedOn":1439489593485
  }
}
~~~

**Response parameters**

|Parameter   |Description
|----------- |-------------
|`id`{:.param} | Subscription ID.
|`aid`{:.param} | Application ID associated with the subscription. Derived from the access token.
|`messageType`{:.param} | Message type. Can be `message` or `action`.
|`uid`{:.param} | User ID.
|`sdtid`{:.param} | Source device type ID.
|`sdid`{:.param} | Source device ID.
|`ddid`{:.param} | Destination device ID.
|`description`{:.param} | Description of the subscription.
|`callbackUrl`{:.param} | Callback URL.
|`status`{:.param} | Status of the subscription.
|`createdOn`{:.param} | Timestamp that the subscription was created, in milliseconds since epoch. 
|`modifiedOn`{:.param} | Timestamp that the subscription was last modified, in milliseconds since epoch.

The subscription fields are further explained [**here**](/sami/connect-the-data/subscribe-and-notify.html#subscription-fields).
{:.info}

### Delete a subscription

`DELETE /subscriptions/<subscriptionID>`
{:.pa.param.http}

Removes a subscription.

This call accepts application and user tokens as the access token.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`subscriptionID`{:.param} | Subscription ID.

**Example response**

~~~
{ 
  "data":{ 
    "id":"1673d7394737480d847023acfcc509d",
    "aid":"f9c81f2eb69343efb336ba2b97bb7e2",
    "messageType":"message",
    "uid":"5beb4e30be9145cb89742d0b315d391",
    "description":"This is a subscription to a user's devices",
    "callbackUrl":"https://api.example.com/messages?user=earl1234",
    "status":"ACTIVE",
    "createdOn":1435191843948,
    "modifiedOn":1439489593485
  }
}
~~~

The call returns the subscription object, which is explained [**here**](/sami/connect-the-data/subscribe-and-notify.html#the-subscription-object).
{:.info}

### Get subscriptions

`GET /subscriptions`
{:.pa.param.http}

Returns all subscriptions for the current application.

This call accepts application tokens as the access token.

**Available URL query parameters**

|Parameter   |Description
|----------- |-------------
|`uid`{:.param} | (Optional) User ID.
|`offset`{:.param} | (Optional) Offset of results to start with. Used for pagination (default: `0`).
|`count`{:.param} | (Optional) Number of items to return per query. Can be `1`-`100` (default: `100`).

**Example response**

~~~
{
   "data":[
      {
         "id":"1673d7394737480d847023acfc50c9d",
         ...
      },
      {
         "id":"7dfb1e6290e848d9b798079651df11d",
         ...
      }
   ],
   "total":2,
   "offset":0,
   "count":2
}
~~~

### Get a subscription

`GET /subscriptions/<subscriptionID>`
{:.pa.param.http}

Returns a subscription.

This call accepts application and user tokens as the access token.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`subscriptionID`{:.param} | Subscription ID.

**Example response**

~~~
{ 
  "data":{ 
    "id":"1673d7394737480d847023acfc50c9d",
    "aid":"f9c81f2eb69343efb336ba297b7b7e2",
    "messageType":"message",
    "uid":"5beb4e30be9145cb89742db3f15d391",
    "description":"This is a subscription to a user's devices",
    "callbackUrl":"https://api.example.com/messages?user=earl1234",
    "status":"ACTIVE",
    "createdOn":1435191843948,
    "modifiedOn":1439489593485
  }
}
~~~

The call returns the subscription object, which is explained [**here**](/sami/connect-the-data/subscribe-and-notify.html#subscription-fields).
{:.info}

### Confirm a subscription

`POST /subscriptions/<subscriptionID>/validate`
{:.pa.param.http}

Validates a subscription with SAMI. If successful, subscription will be set to active status.

This call does not require an access token.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`subscriptionID`{:.param} | Subscription ID.

**Example request**

~~~
{
   "aid": "f9c82b97b78888b7e2",
   "nonce": "<nonce>"
}
~~~

**Request body parameters**

|Parameter   |Description
|----------- |-------------
|`aid`{:.param} | Application ID associated with the subscription.
|`nonce`{:.param} | Nonce for authentication.

**Example response**

~~~
{ 
   "data":{ 
      "id":"1673d888883acfcc50c9d",
      "aid":"f9c82b97b88888b7e2",
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

The call returns the subscription object, which is explained [**here**](/sami/connect-the-data/subscribe-and-notify.html#subscription-fields).
{:.info}

## Notifications

### Get messages in notification

`GET /notifications/<notificationID>/messages`
{:.pa.param.http}

Returns messages associated with a notification.

The notification ID is obtained from the [notification payload](/sami/connect-the-data/subscribe-and-notify.html#handle-notification-payload) sent to the client's callback URL.

This call accepts application and user tokens as the access token.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`notificationID`{:.param} | Notification ID.

**Request body parameters**

|Parameter   |Description
|----------- |-------------
|`order`{:.param} | (Optional) Desired sort order based on timestamp: `asc` or `desc` (default: `asc`).
|`offset`{:.param} | (Optional) Offset of results to start with. Used for pagination (default: `0`).
|`count`{:.param} | (Optional) Number of items to return per query. Can be `1`-`100` (default: `100`).

**Example response**

~~~
{ 
  "order":"asc",
  "total":1,
  "offset":0,
  "count":1,
  "data":[ 
    { 
       "mid":"057a407d4f814cbc87f3f7a0485af3b",
       "data":{ 
         "dateMicro":1421281794211000,
         "ecg":-73
       },
       "ts":1421281794212,
       "sdtid":"dtaeaf898b4db948ba",
       "cts":1421281794212,
       "uid":"7b202300eb90414936e9739574962a5",
       "mv":1,
       "sdid":"4697f11336c54069ffd6f445061215e"
    }
  ] 
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`order`{:.param} |Sort order.
|`total`{:.param} |Total number of items.
|`offset`{:.param} |String required for pagination. Default is "0".
|`count`{:.param} |Number of items requested.
|`mid`{:.param} |Message ID.
|`ts`{:.param} |Timestamp from source.
|`sdtid`{:.param} |Source device type ID.
|`cts`{:.param} |Timestamp from SAMI.
|`uid`{:.param} |User ID.
|`mv`{:.param} |Manifest version.
|`sdid`{:.param} |Source device ID.

## Rules

[**Develop Rules for devices**](/sami/advanced-features/develop-rules-for-devices.html) provides a description of the JSON Rule body.
{:.info}

### Get Rules

`GET /rules`
{:.pa.param.http}

Returns the user's Rules created by the current application. 

**Available URL query parameters**

|Parameter   |Description
|----------- |-------------
|`uid`{:.param} | (Optional) User ID. Can be used to specify user if not specified by the token.

**Example response**

~~~
{
  "total": 119,
  "offset": 0,
  "count": 100,
  "data": {
    "rules": [...]
  }
}
~~~

### Get a Rule

`GET /rules/<ruleId>`
{:.pa.param.http}

Returns a Rule.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

**Example response**

~~~
{
  "data": {
    "uid":"f0a3057950384215acf8ba25c2fbfcb7",
    "id":"f0a3057950384215acf8ba25c2fbfcb7",
    "name":"Test Rule",
    "description": "This is a test Rule",
    "languageVersion": 1,
    "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
    "enabled":true,
    "createdOn": 1234567890,
    "modifiedOn": 1234567890
  }
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`uid`{:.param} |User ID.
|`id`{:.param} |Rule ID.
|`name`{:.param} |Rule name. String max 64 characters.
|`description`{:.param} |Rule description. String max 1400 characters.
|`languageVersion`{:.param} |Version of the Rule body specification. 
|`rule`{:.param} |JSON-formatted Rule.
|`enabled`{:.param} |Boolean (true/false). Indicates whether Rule is enabled.
|`createdOn`{:.param} |Date Rule was created.
|`modifiedOn`{:.param} |Date Rule was last modified.

### Create a Rule

`POST /rules`
{:.pa.param.http}

Adds a Rule.

**Example request**

~~~
{
  "name":"Test Rule",
  "description": "This is a test Rule",
  "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
  "enabled":true
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`name`{:.param} |Rule name. String max 64 characters.
|`description`{:.param} |(Optional) Rule description. String max 1400 characters.
|`rule`{:.param} |JSON-formatted Rule.
|`enabled`{:.param} |(Optional) Boolean (true/false). Indicates whether Rule is enabled.

**Example response**

~~~
{
  "data": {
    "uid":"f0a3057950384215acf8ba25c2fbfcb7",
    "id":"f0a3057950384215acf8ba25c2fbfcb7",
    "name":"Test Rule",
    "description": "This is a test Rule",
    "languageVersion": 1,
    "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
    "enabled":true,
    "createdOn": 1234567890,
    "modifiedOn": 1234567890
  }
}
~~~

### Update a Rule

`PUT /rules/<ruleId>`
{:.pa.param.http}

Modifies a Rule's parameters.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

**Example request**

~~~
{
  "name":"Test Rule",
  "description": "This is a test Rule",
  "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
  "enabled":true
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`name`{:.param} |(Optional) Rule name. String max 64 characters.
|`description`{:.param} |(Optional) Rule description. String max 1400 characters.
|`rule`{:.param} |(Optional) JSON-formatted Rule.
|`enabled`{:.param} |(Optional) Boolean (true/false). Indicates whether Rule is enabled.

**Example response**

~~~
{
  "data": {
    "uid":"f0a3057950384215acf8ba25c2fbfcb7",
    "id":"f0a3057950384215acf8ba25c2fbfcb7",
    "name":"Test Rule",
    "description": This is a test Rule",
    "languageVersion": 1,
    "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
    "enabled":true,
    "createdOn": 1234567890,
    "modifiedOn": 1234567890
  }
}
~~~

### Delete a Rule

`DELETE /rules/<ruleId>`
{:.pa.param.http}

Deletes a Rule.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

**Example response**

~~~
 {
  "data": {
    "uid": "eee2fb1e88f245458520ed23661dead4",
    "id": "096ba7b27db54f73bbbe724d6c0bca22",
    "aid": "d18f11efb5244c8f99f1ac7aa4fb9bbc",
    "name": "Example rule",
    "languageVersion": 1,
    "rule": {"if":{"and":[{"sdid":"<BASIS_WATCH_ID>","field":"heartRate","operator":">=","operand":{"value":180}}]},"then":[{"ddid":"<SMART_THINGS_ON_OFF_CONTROL_ID>","action":"setState","parameters":{"state":{"value":"on"}}}]},
    "enabled": true,
    "createdOn": 1445440561132,
    "modifiedOn": 1445440561132,
    "description": "IF Basis Watch heartRate is more than or equal to 180\nTHEN send to SmartThingsOnOffControl the action setState with state=\"on\"‌"
  }
}
~~~

### Get a Rule's execution statistics

`GET /rules/<ruleId>/executions`
{:.pa.param.http}

Returns statistics for executions of a Rule.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

**Example response**

~~~
{
  "data": {
    "countApply": 3,
    "lastApply": 123456789,
  }
}
~~~

**Response parameters**

|Parameter   |Description
|----------- |-------------
|`countApply`{:.param} | Number of times Rule was triggered and sent Actions.
|`lastApply`{:.param} | Last time Rule was triggered, in milliseconds since epoch. Does not appear if Rule was not triggered.

### Test Actions

`POST /rules/<ruleId>/actions`
{:.pa.param.http}

Runs an Action.

Any testable Actions will actually be sent to your device, so be prepared!
{:.warning}

An Action is testable if the definition of the Action is static. See [this article](/sami/advanced-features/develop-rules-for-devices.html#testing-an-action) for more information.

In case any Action is not testable, the POST request returns a 400 error and no Action will be executed (including those which are testable).
{:.info}

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

### Test Actions available

`GET /rules/<ruleId>/actions`
{:.pa.param.http}

Checks whether at least one Action can be run for test.

**Request parameters**

|Parameter   |Description
|----------- |-------------
|`ruleId`{:.param} | Rule ID.

**Example response**

~~~
{ 
  "data": { 
    "testable": true 
  }
}
~~~

**Response parameters**

|Parameter   |Description
|----------- |-------------
|`testable`{:.param} | Boolean (true/false). Indicates whether it is possible to run an Action for the test.

## Trials

### Create a trial

`POST /trials`
{:.pa.param.http}

Adds a trial. 

Device types and invitations may be included in the call. See [Add a trial device type](/sami/api-spec.html#add-a-trial-device-type) and [Create a trial invitation](/sami/api-spec.html#create-a-trial-invitation) for the request formats.

**Example request**

~~~
{
  "name": "test trial",
  "description": "this is a test trial",
  "deviceTypes": [
    {
      "dtid": "181a0d34621f4a4d80a43444a4658150"
    },
    {
      "dtid": "vitalconnect_module"
    }
  ],
  "invitations": [
    {
      "email": "john@email.com",
      "invitationType": "participant"
    }
 ]
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`description`{:.param} |Description of the trial. String max 1500 characters.
|`name`{:.param} |Name of the trial.
|`deviceTypes`{:.param} |(Optional) Device types to add to the trial.
|`invitations`{:.param} |(Optional) Invitations to be sent for the trial.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "test trial",
    "description": "this is a test trial",
    "aid": "62bb65ceaa304f7989922fefb6a45814",
    "clientSecret": "e02a63d400b44d798b1f9962d7a8b09b",
    "startDate": 1396224000000,
    "endDate": null
  }
} 
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param} |Trial ID.
|`ownerId`{:.param} |User ID of trial creator.
|`name`{:.param} |Trial name.
|`description`{:.param} |Trial description. String max 1500 characters.
|`aid`{:.param} |Application ID of the associated application.
|`clientSecret`{:.param} |Client secret.
|`startDate`{:.param} |Start date of the trial (in milliseconds since epoch). Set to the current date-time when the trial is created.
|`endDate`{:.param} |End date of the trial (in milliseconds since epoch). Set to the current date-time when the trial is stopped.

### Delete a trial

`DELETE /trials/<trialID>`
{:.pa.param.http}

Deletes a trial and its invitations, administrators, participants and connected devices. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "test trial",
    "description": "this is a test trial",
    "aid": "62bb65ceaa304f7989922fefb6a45814",
    "clientSecret": "e02a63d400b44d798b1f9962d7a8b09b",
    "startDate": 1396224000000,
    "endDate": null
  }
}
~~~

### Find a trial

`GET /trials/<trialID>`
{:.pa.param.http}

Returns a trial.

Can be called by trial administrators and participants. Only administrators will see `aid` and `clientSecret`.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "test trial",
    "description": "this is a test trial",
    "aid": "62bb65ceaa304f7989922fefb6a45814",
    "clientSecret": "e02a63d400b44d798b1f9962d7a8b09b",
    "startDate": 1396224000000,
    "endDate": null
  }
}
~~~

### Update a trial

`PUT /trials/<trialID>`
{:.pa.param.http}

Modifies the parameters of a trial. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example request**

~~~
{
  "name": "new trial name",
  "description": "this is a new trial description"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`description`{:.param} |Description of the trial. String max 1500 characters.
|`name`{:.param} |Name of the trial.

The `status` field can be updated to `stop`. This sets the end date of the trial. Pending invitations for the trial will be deleted, and updates to the stopped trial are disallowed.

**Example request**

~~~
{
  "status": "stop"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`status`{:.param} |Trial invitation status. Must be `stop`.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "new trial name",
    "description": "this is a new trial description",
    "aid": "62bb65ceaa304f7989922fefb6a45814",
    "clientSecret": "e02a63d400b44d798b1f9962d7a8b09b",
    "startDate": 1396224000000,
    "endDate": 1426874500000
  }
}
~~~

### Update trial application

`PUT /trials/<trialID>/application`
{:.pa.param.http}

Updates the trial with a new application. This can be used if the client secret of the existing application is exposed. A new `aid`{:.param} and `clientSecret`{:.param} will be generated.

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "test trial",
    "description": "this is a test trial",
    "aid": "c619c96c78b14c6289ee4644be0625c4",
    "clientSecret": "a95f631146b14c589de82db47d8496ab",
    "startDate": 1396224000000,
    "endDate": null
  }
}
~~~

## Trials - Devices

### Add a trial device type

`POST /trials/<trialID>/devicetypes`
{:.pa.param.http}

Add a device type to the trial device types list. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example request**

~~~
{
  "dtid": "dta38d91dfd9164e96a5dc74ef2305af43" 
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`dtid`{:.param} |Device type ID.

**Example response**

~~~
{
  "data": {
    "tid": "unique_trial_id",
    "dtid": "dta38d91dfd9164e96a5dc74ef2305af43"
  }
}
~~~

### Connect a user device

`POST /trials/<trialID>/participants/<userID>/devices`
{:.pa.param.http}

Connects a participant device to the trial.

Can be called by a trial participant only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.
|`userID`{:.param} |User ID.

**Example request**

~~~
{
  "did": "4697f11336c540a69ffd6f445061215e"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`did`{:.param} |Participant device ID.

**Example response**

~~~
{
  "data":{
    "tid": "unique_trial_id",
    "uid": "7b202300eb904149b36e9739574962a5"
    "did": "4697f11336c540a69ffd6f445061215e"
  }
}
~~~

### Disconnect a user device

`DELETE /trials/<trialID>/participants/<userID>/devices/<deviceID>`
{:.pa.param.http}

Disconnects a participant device from the trial.

Can be called by a trial participant only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`deviceID`{:.param} |Participant device ID.
|`trialID`{:.param} |Trial ID.
|`userID`{:.param} |User ID.

**Example response**

~~~
{
  "data":{
    "tid": "unique_trial_id",
    "uid": "7b202300eb904149b36e9739574962a5"
    "did": "4697f11336c540a69ffd6f445061215e"
  }
}
~~~

### Get trial connected devices

`GET /trials/<trialID>/devices`
{:.pa.param.http}

Returns all devices connected to a trial.

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".

**Example response**

~~~
{ 
  "data":{ 
    "devices":[ 
      { 
        "id":"65ee0eae038b4f538d93faf97d044e12",
        "uid":"90cb4ef84c7d41d3b691241c392b2e42",
        "dtid":"dt11cfee3a5d294019b5e9afda11a93668",
        "name":"Device d8cb1e09b6b04fb",
        "manifestVersion":1,
        "manifestVersionPolicy":"LATEST",
        "connected_on":1411447202000
      }
   ]
 },
 "total":1,
 "offset":0,
 "count":1
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param}   | Device ID.  |
|`uid`{:.param}  | User ID.    |
|`dtid`{:.param} | Device type ID. |
|`name`{:.param} | Device name.    |
|`manifestVersion`{:.param} | Device's Manifest version that is used to parse the messages it sends to SAMI. |
|`manifestVersionPolicy`{:.param} | Device's policy that will be applied to the messages sent by this device. <ul><li> `LATEST` means it will use the most recent Manifest created.</li><li>`DEVICE` means it will use a specific version of the manifest regardless if newer versions are available.</li></ul>
|`connected_on`{:.param} | Date the device was connected to the trial (in milliseconds since epoch).
|`total`{:.param} |Total number of items.
|`offset`{:.param} |String required for pagination. Default is "0".
|`count`{:.param} |Number of items returned on the page. Default and max is "100".

### Get trial device types

`GET /trials/<trialID>/devicetypes`
{:.pa.param.http}

Returns all device types in a trial.

Can be called by trial administrators and participants.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".

**Example response**

~~~~
{
  "data": {
    "deviceTypes": [
      {
        "id":"dta38d91dfd9164e96a5dc74ef2305af43",
        "uid": "12345",
        "name":"Samsung Web Camera XYZ",
        "published":true,
        "latestVersion":5,
        "uniqueName":"com.samsung.web.camera"
      },
      ...
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1  
}            
~~~~

**Response parameters**

  |Parameter         |Description
  |------------------|-----------
  |`id`{:.param}             |Device type ID.
  |`uid`{:.param}            |Owner's user ID.
  |`name`{:.param}           |Device type name.
  |`published`{:.param}      |Device type published.
  |`latestVersion`{:.param}  |Device type latest Manifest version available.
  |`uniqueName`{:.param}     |Device type unique name in the system (used for Manifest package naming). Has to be a valid JAVA package name.
  |`total`{:.param} |Total number of items.
  |`offset`{:.param} |String required for pagination. Default is "0".
  |`count`{:.param} |Number of items returned on the page. Default and max is "100".

### Get user connected devices

`GET /trials/<trialID>/participants/<userID>/devices`
{:.pa.param.http}

Returns all devices connected by a participant to a trial.

Can be called by trial administrators and participants.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.
|`userID`{:.param} |User ID.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".

**Example response**

~~~
{ 
  "data":{ 
    "devices":[ 
      { 
        "id":"65ee0eae038b4f538d93faf97d044e12",
        "uid":"90cb4ef84c7d41d3b691241c392b2e42",
        "dtid":"dt11cfee3a5d294019b5e9afda11a93668",
        "name":"Device d8cb1e09b6b04fb",
        "manifestVersion":1,
        "manifestVersionPolicy":"LATEST",
        "connected_on":1411447202000
      }
   ]
 },
 "total":1,
 "offset":0,
 "count":1
}
~~~


## Trials - Members

### Create a trial invitation

`POST /trials/<trialID>/invitations`
{:.pa.param.http}

Sends a new trial invitation. The invitation will be active for 24 hours. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Example request**

~~~
{
  "email": "john@email.com",
  "invitationType": "participant"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`email`{:.param} |User's email address.
|`invitationType`{:.param} |User role. Can be `participant` or `administrator`.

**Example response**

~~~
{
  "data":{
    "id": "f252c2e77a68419eb6322a8fbae37bc9",
    "tid": "f5fc7af5fa6d4480b597e340bfff4450",
    "email": "john@email.com",
    "invitationType": "participant",
    "sentDate": "1395705600000",
    "acceptedDate": null,
    "expirationDate": "1395878400000",
    "revokedDate": null,
    "status": "sent"
  }
} 
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param} |Invitation ID.
|`tid`{:.param} |Trial ID.
|`email`{:.param} |User's email address.
|`invitationType`{:.param} |User role. Can be `participant` or `administrator`.
|`sentDate`{:.param} |Date the invitation was sent (in milliseconds since epoch).
|`acceptedDate`{:.param} |Date the invitation was accepted (in milliseconds since epoch).
|`expirationDate`{:.param} |Date the invitation expires (in milliseconds since epoch).
|`revokedDate`{:.param} |Date the invitation was revoked (in milliseconds since epoch). 
|`status`{:.param} |Invitation status. Can be `accepted`, `expired` or `sent`.

### Delete a trial administrator

`DELETE /trials/<trialID>/administrators/<userID>`
{:.pa.param.http}

Removes an administrator from a trial.

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.
|`userID`{:.param} |User ID.

**Example response**

~~~
{
  "data":{
    "tid":"unique_trial_id",
    "uid":"03c99e714b78420ea836724cedcebd49"
  }
}
~~~

### Delete a trial invitation

`DELETE /trials/<trialID>/invitations/<invitationID>`
{:.pa.param.http}

Removes an invitation from a trial. This only applies to invitations with a `status` of `sent`. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`invitationID`{:.param} |Invitation ID.
|`trialID`{:.param} |Trial ID.

**Example response**

~~~
{
  "data":{
    "id": "f252c2e77a68419eb6322a8fbae37bc9",
    "tid": "f5fc7af5fa6d4480b597e340bfff4450",
    "email": "john@email.com",
    "invitationType": "participant",
    "sentDate": "1395705600000",
    "acceptedDate": null,
    "expirationDate": "1395878400000",
    "revokedDate": null,
    "status": "sent"
  }
} 
~~~

### Delete a trial participant

`DELETE /trials/<trialID>/participants/<userID>`
{:.pa.param.http}

Removes a participant from a trial and disconnects their devices. Participant's data can no longer be accessed by trial administrators. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.
|`userID`{:.param} |User ID.

**Example response**

~~~
{
  "data":{
    "tid":"unique_trial_id",
    "uid":"03c99e714b78420ea836724cedcebd49"
  }
}
~~~

### Get trial administrators

`GET /trials/<trialID>/administrators`
{:.pa.param.http}

Returns all the administrators of a trial.

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination). Default is "0".

**Example response**

~~~
{
  "data":{
    "id":"db2e64c653b94f519dbca8f157f73b79",
    "name":"tuser",
    "email":"tuser@ssi.samsung.com",
    "fullName":"Test User",
    "createdOn":1403042304,
    "modifiedOn":1403042305
  }
},
"total":1,
"offset":0,
"count":1
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param} |User ID.
|`name`{:.param} |User name.
|`email`{:.param} |Administrator's email address.
|`fullName`{:.param} |Administrator's name.
|`createdOn`{:.param} |Date user was created.
|`modifiedOn`{:.param} |Date user was last modified.

### Find trial invitations

`GET /trials/<trialID>/invitations`
{:.pa.param.http}

Returns invitations for a trial that match a status. 

Can be called by a trial administrator only.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".
|`status`{:.param} |Trial invitation status. Can be `sent`, `accepted`, `revoked` or `expired`.
|`trialID`{:.param} |Trial ID.

**Example response**

~~~
{
  "data":{
    "invitations": [
      {
        "id": "f252c2e77a68419eb6322a8fbae37bc9",
        "tid": "f5fc7af5fa6d4480b597e340bfff4450",
        "email": "john@email.com",
        "invitationType": "participant",
        "sentDate": "1395705600000",
        "acceptedDate": "1395792000000",
        "expirationDate": "1395878400000",
        "revokedDate": null,
        "status": "accepted"
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

### Get trial participants

`GET /trials/<trialID>/participants`
{:.pa.param.http}

Returns all the participants of a trial. 

Can be called by a trial administrator only.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialID`{:.param} |Trial ID.

**Available URL query parameters**

|Parameter         |Description
|----------------- |------------------
|`count`{:.param} |(Optional) Number of items to return per query. Default and max is "100".
|`offset`{:.param} |(Optional) A string that represents the starting item. Should be the value of 'next' field received in the last response (required for pagination). Default is "0".

**Example response**

~~~
{
  "data":{
    "id":"db2e64c653b94f519dbca8f157f73b79",
    "name":"tuser",
    "email":"tuser@ssi.samsung.com",
    "fullName":"Test User",
    "createdOn":1403042304,
    "modifiedOn":1403042305
  }
},
"total":1,
"offset":0,
"count":1
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`id`{:.param} |User ID.
|`name`{:.param} |User name.
|`email`{:.param} |Participant's email address.
|`fullName`{:.param} |Participant's name.
|`createdOn`{:.param} |Date user was created.
|`modifiedOn`{:.param} |Date user was last modified.

### Update a trial invitation

`PUT /trials/<trialID>/invitations/<invitationID>`
{:.pa.param.http}

Modifies an invitation status.

Can be called by trial administrators and participants. Only administrators may revoke; only invitees may accept.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`invitationID`{:.param} |Invitation ID.
|`trialID`{:.param} |Trial ID.

**Example request**

~~~
{
  "status": "accepted"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`status`{:.param} |Trial invitation status. Can be `accepted` or `revoked`.

**Example response**

~~~
{
  "data":{
    "id": "f252c2e77a68419eb6322a8fbae37bc9",
    "tid": "f5fc7af5fa6d4480b597e340bfff4450",
    "email": "john@email.com",
    "invitationType": "participant",
    "sentDate": "1395705600000",
    "acceptedDate": null,
    "expirationDate": "1395878400000",
    "revokedDate": 1424802260000,
    "status": "revoked"
  }
} 
~~~

## Sessions

### Add session to trial

`POST /trials/sessions`
{:.pa.param.http}

Adds a session to a trial.

**Example request**

~~~
{
  "trialId": "b936c867117a4ae9a40bfb482682c1a8",
  "participantId": "b379322f43e641bd9ad6ee7787043fad",
  "devices": "a5c1cb6a35dc4387b722487982bcd6bc"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID to associate with the session.
|`participantId`{:.param} |Trial participant user ID to associate with the session.
|`devices`{:.param} |Comma-separated list of device IDs to associate with the session.

**Example response**

~~~
{
  "data": {
    "uuid": "03bb0612-4e10-4e20-b70a-c7d9b5f23489",
    "id": "03bb06124e104e20b70ac7d9b5f23489",
    "trialId": "b936c867117a4ae9a40bfb482682c1a8",
    "participantId": "b379322f43e641bd9ad6ee7787043fad",
    "devices": [
      {
        "uuid": "a8eeaeb5-7d2a-4cb1-b8ee-0327b8a9d52d",
        "id": "a8eeaeb57d2a4cb1b8ee0327b8a9d52d",
        "deviceId": "a5c1cb6a35dc4387b722487982bcd6bc"
      }
    ],
    "start": null,
    "end": null,
    "metadatas": [
      
    ],
    "exports": [
      
    ],
    "status": 200
  }
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`uuid`{:.param} |Universally unique identifier.
|`id`{:.param} |String representation of `uuid`{:.param}.
|`trialId`{:.param} |Trial ID.
|`participantId`{:.param} |Participant user ID.
|`devices`{:.param} |List of session devices.
|`start`{:.param} |Start date of the session (in milliseconds since epoch). 
|`end`{:.param} |End date of the session (in milliseconds since epoch). 
|`metadatas`{:.param} |List of session metadata.
|`exports`{:.param} |List of SAMI exports created for session.

### Delete session

`DELETE /trials/sessions/<sessionId>`
{:.pa.param.http}

Deletes a session.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`sessionId`{:.param} |Session ID.

**Example response**

~~~
{
  "uuid": null,
  "id": null,
  "trialId": "",
  "participantId": "",
  "devices": [
    
  ],
  "start": null,
  "end": null,
  "metadatas": [
    null
  ],
  "exports": [
    
  ],
  "status": null
}
~~~

### Get session

`GET /trials/sessions/<sessionId>`
{:.pa.param.http}

Returns a trial session.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`sessionId`{:.param} |Session ID.

**Example response**

~~~
{
  "data": {
    "uuid": "323952e7-e62b-4b55-970f-223ab85dc08d",
    "id": "323952e7e62b4b55970f223ab85dc08d",
    "trialId": "bea520d4c211447c8d1cc043429e380f",
    "participantId": "23b4853a78ba4490aabe709955834d4f",
    "devices": [
      {
        "uuid": "a2bea1b9-1f75-496e-a6b8-dc73e8092734",
        "id": "a2bea1b91f75496ea6b8dc73e8092734",
        "deviceId": "fdeeb6dc808045cbac7fe28b9d23a64b"
      }
    ],
    "start": null,
    "end": null,
    "metadatas": [
      
    ],
    "exports": [
      
    ],
    "status": null
  }
}
~~~

### Update session

`PUT /trials/sessions/<sessionId>`
{:.pa.param.http}

Updates an existing session.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`sessionId`{:.param} |Session ID.

**Example request**

~~~
{
  "start": 1438581333000,
  "end": 1444833634387
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`start`{:.param} |(Optional) Start date of the session (in milliseconds since epoch).
|`end`{:.param} |(Optional) End date of the session (in milliseconds since epoch).

**Example response**

~~~
{
  "data": {
    "uuid": "ecb987af-a140-491b-b1df-c0f5c4821b47",
    "id": "ecb987afa140491bb1dfc0f5c4821b47",
    "trialId": "b936c867117a4ae9a40bfb482682c1a8",
    "participantId": "b379322f43e641bd9ad6ee7787043fad",
    "devices": [
      {
        "uuid": "f31e7967-6f3d-4121-8baa-cf4fbb3fa9b5",
        "id": "f31e79676f3d41218baacf4fbb3fa9b5",
        "deviceId": "a5c1cb6a35dc4387b722487982bcd6bc"
      }
    ],
    "start": 1438581333000,
    "end": 1444833634387,
    "metadatas": [
      {
        "uuid": "3a315261-2a24-4411-b7eb-1ca5c1a938cc",
        "id": "3a3152612a244411b7eb1ca5c1a938cc",
        "key": "subject",
        "value": "b"
      },
      {
        "uuid": "a33b0348-48b2-4c43-bddd-8dad15791ba5",
        "id": "a33b034848b24c43bddd8dad15791ba5",
        "key": "age",
        "value": "45"
      }
    ],
    "exports": [
      
    ],
    "status": null
  }
}
~~~

### Find all ongoing sessions for this trial

`GET /trials/<trialId>/sessions/ongoing`
{:.pa.param.http}

Returns ongoing sessions for the trial.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.

**Example response**

~~~
{
  "data": {
    "sessions": [
      {
        "uuid": "ceb6c5e3-6cd7-47b5-a386-e3d318c1ac2e",
        "id": "ceb6c5e36cd747b5a386e3d318c1ac2e",
        "trialId": "b936c867117a4ae9a40bfb482682c1a8",
        "participantId": "b379322f43e641bd9ad6ee7787043fad",
        "devices": [
          {
            "uuid": "9400ebd8-666e-4692-b42d-79567c6505f8",
            "id": "9400ebd8666e4692b42d79567c6505f8",
            "deviceId": "a5c1cb6a35dc4387b722487982bcd6bc"
          }
        ],
        "start": 1447875816000,
        "end": null,
        "metadatas": [
          {
            "uuid": "8590276c-3e5d-4b86-ab4e-27d31a6b7fa3",
            "id": "8590276c3e5d4b86ab4e27d31a6b7fa3",
            "key": "subject",
            "value": "a"
          }
        ],
        "exports": [
          
        ],
        "status": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

### Find all trial's sessions

`GET /trials/<trialId>/sessions`
{:.pa.param.http}

Returns all sessions for the trial.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.

**Example response**

~~~
{
  "data": {
    "sessions": [
      {
        "uuid": "ceb6c5e3-6cd7-47b5-a386-e3d318c1ac2e",
        "id": "ceb6c5e36cd747b5a386e3d318c1ac2e",
        "trialId": "b936c867117a4ae9a40bfb482682c1a8",
        "participantId": "b379322f43e641bd9ad6ee7787043fad",
        "devices": [
          {
            "uuid": "9400ebd8-666e-4692-b42d-79567c6505f8",
            "id": "9400ebd8666e4692b42d79567c6505f8",
            "deviceId": "a5c1cb6a35dc4387b722487982bcd6bc"
          }
        ],
        "start": 1447875816000,
        "end": null,
        "metadatas": [
          {
            "uuid": "8590276c-3e5d-4b86-ab4e-27d31a6b7fa3",
            "id": "8590276c3e5d4b86ab4e27d31a6b7fa3",
            "key": "subject",
            "value": "a"
          }
        ],
        "exports": [
          
        ],
        "status": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

## Sessions - Metadata

### Get metadata key's values

`GET /trials/<trialId>/sessions/metadata/key/<key>`
{:.pa.param.http}

Returns all values given to the metadata key.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`key`{:.param} |Metadata key.

**Example response**

~~~
{
  "data": {
    "metadata": [
      {
        "uuid": "21a243b9-aa5f-43d1-8287-dee4eda42907",
        "id": "21a243b9aa5f43d18287dee4eda42907",
        "key": "subject",
        "value": "1"
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`uuid`{:.param} |Universally unique identifier.
|`id`{:.param} |String representation of `uuid`{:.param}.
|`key`{:.param} |Metadata's key.
|`value`{:.param} |Metadata's value.

### Create metadata

`POST /trials/<trialId>/sessions/metadata`
{:.pa.param.http}

Creates metadata for a trial session.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.

**Example request**

~~~
{
  "trialSession": {
    "id": "4be6caec17e948dc9b2e02506422ea96"
  },
  "key": "age",
  "value": "50"
}
~~~

**Example response**

~~~
{
  "trialSession": "4be6caec17e948dc9b2e02506422ea96",
  "key": "age",
  "value": "50"
}
~~~

### Get metadata

`GET /trials/<trialId>/sessions/metadata`
{:.pa.param.http}

Returns all metadata for the trial session.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.

**Example response**

~~~
{
  "data": {
    "metadata": [
      {
        "uuid": "075ca963-5eb8-4f0f-8abe-be0bfc8cb600",
        "id": "075ca9635eb84f0f8abebe0bfc8cb600",
        "key": "age",
        "value": "50"
      },
      {
        "uuid": "0c71ff37-84ea-439b-8c35-cd945ba4746a",
        "id": "0c71ff3784ea439b8c35cd945ba4746a",
        "key": "test",
        "value": "1"
      },
      {
        "uuid": "21a243b9-aa5f-43d1-8287-dee4eda42907",
        "id": "21a243b9aa5f43d18287dee4eda42907",
        "key": "subject",
        "value": "1"
      },
      {
        "uuid": "7934c4c0-794d-4397-8202-e274ef82e034",
        "id": "7934c4c0794d43978202e274ef82e034",
        "key": "12",
        "value": "12"
      }
    ]
  },
  "total": 4,
  "offset": 0,
  "count": 4
}
~~~

### Update metadata

`PUT /trials/<trialId>/sessions/metadata/<metadataId>`
{:.pa.param.http}

Updates a session's metadata.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`metadataId`{:.param} |Metadata ID.

**Example request**

~~~
{
 "key": "a", 
 "value": "c", 
 "trialSession": "b936c867117a4ae9a40bfb482682c1a8" 
}
~~~

**Example response**

~~~
{
  "data": {
    "uuid": "075ca963-5eb8-4f0f-8abe-be0bfc8cb600",
    "id": "075ca9635eb84f0f8abebe0bfc8cb600",
    "key": "a",
    "value": "c"
  }
}
~~~

### Remove metadata

`DELETE /trials/<trialId>/sessions/metadata/<metadataId>`
{:.pa.param.http}

Removes a session's metadata.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`metadataId`{:.param} |Metadata ID.

**Example response**

~~~
{
  "uuid": null,
  "id": null,
  "key": "",
  "value": ""
}
~~~

## Sessions - Rules

### Add session rules to trial

`POST /rules`
{:.pa.param.http}

Adds session rules to the trial.

Session rules define restrictions for metadata. They are different from the [**Rules**](/sami/sami-documentation/developer-user-portals.html#creating-a-rule) created in the User Portal for sending commands to devices.
{:.info}

**Example request**

~~~
{
  "trialId": "96f710575e01405fb67a8f1c7a4f8d61",
  "metadatas": [
    {
      "key": "subject",
      "type": "STRING",
      "choices": [
        
      ],
      "numericRangeStart": null,
      "numericRangeEnd": null,
      "required": true
    }
  ]
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`metadatas`{:.param} |List of rule metadata.

**Example response**

~~~
{
  "data": {
    "uuid": "c7cefd7f-7383-49b3-9391-1007bfd8e72f",
    "id": "c7cefd7f738349b393911007bfd8e72f",
    "trialId": "96f710575e01405fb67a8f1c7a4f8d61",
    "metadatas": [
      {
        "uuid": "63c05c43-4a32-4d22-9b18-0420c6de6d5f",
        "id": "63c05c434a324d229b180420c6de6d5f",
        "key": "subject",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": true,
        "choices": [
          
        ],
        "created": 1444851017086
      }
    ],
    "primeKey": null
  }
}
~~~

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`uuid`{:.param} |Universally unique identifier.
|`id`{:.param} |String representation of `uuid`{:.param}.
|`trialId`{:.param} |Trial ID.
|`metadatas`{:.param} |List of metadata (see below).
|`metadata.uuid`{:.param} |Metadata universally unique identifier.
|`metadata.id`{:.param} |String representation of `uuid`{:.param}.
|`metadata.key`{:.param} |Metadata's key.
|`metadata.value`{:.param} |Metadata's value.
|`metadata.type`{:.param} |Metadata's type. Can be `STRING`, `NUMERIC` or `CHOICES`.
|`metadata.numericRangeStart`{:.param} |Represents the minimum allowed value (if `metadata.type`{:.param} is `NUMERIC`).
|`metadata.numericRangeEnd`{:.param} |Represents the maximum allowed value (if `metadata.type`{:.param} is `NUMERIC`).
|`required`{:.param} |Boolean (true/false). Indicates whether this metadata must be added to a session.
|`choices`{:.param} |List of values that can be given for this metadata (if empty, any value can be given).
|`primeKey`{:.param} |"true" indicates this rule metadata is the prime key for all metadata that belong to the rule.

### Find session rules for trial

`GET /trials/<trialId>/sessions/rules`
{:.pa.param.http}

Returns session rules for the trial.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.

**Example response**

~~~
{
  "data": {
    "uuid": "5f46754e-aeeb-49aa-837b-2d7270258d9c",
    "id": "5f46754eaeeb49aa837b2d7270258d9c",
    "trialId": "b936c867117a4ae9a40bfb482682c1a8",
    "metadatas": [
      {
        "uuid": "ae3f1afa-7fe1-4217-911b-70809af4f57f",
        "id": "ae3f1afa7fe14217911b70809af4f57f",
        "key": "test",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": false,
        "choices": [
          
        ],
        "created": 1441377414000
      },
      {
        "uuid": "aed1eb41-7e01-4a65-ba79-60791cea7260",
        "id": "aed1eb417e014a65ba7960791cea7260",
        "key": "subject",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": true,
        "choices": [
          
        ],
        "created": 1444851000000
      }
    ],
    "primeKey": null
  }
}
~~~

### Export session rules

`GET /trials/<trialId>/sessions/rules/<ruleId>/sharing`
{:.pa.param.http}

Exports the session rules as a simplified JSON object (that can be imported to another trial).

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`ruleId`{:.param} |Rule ID.

**Example response**

~~~
{
  "data": {
    "trialId": "",
    "metadatas": [
      {
        "key": "subject",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": false,
        "choices": null
      }
    ]
  }
}
~~~

### Import session rules

`POST /trials/<trialId>/sessions/rules/<ruleId>/sharing`
{:.pa.param.http}

Replaces the session rules with the given imported rules JSON.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} |Trial ID.
|`ruleId`{:.param} |Rule ID.

**Example request**

~~~
{
  "data": {
    "trialId": "",
    "metadatas": [
      {
        "key": "subject",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": false,
        "choices": null
      }
    ]
  }
}
~~~

### Retrieve session rules

`GET /trials/sessions/rules/<ruleId>`
{:.pa.param.http}

Returns session rules by ID.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`ruleId`{:.param} |Rule ID.

**Example response**

~~~
{
  "data": {
    "uuid": "5f46754e-aeeb-49aa-837b-2d7270258d9c",
    "id": "5f46754eaeeb49aa837b2d7270258d9c",
    "trialId": "b936c867117a4ae9a40bfb482682c1a8",
    "metadatas": [
      {
        "uuid": "ae3f1afa-7fe1-4217-911b-70809af4f57f",
        "id": "ae3f1afa7fe14217911b70809af4f57f",
        "key": "test",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": false,
        "choices": [
          
        ],
        "created": 1441377414000
      },
      {
        "uuid": "aed1eb41-7e01-4a65-ba79-60791cea7260",
        "id": "aed1eb417e014a65ba7960791cea7260",
        "key": "subject",
        "value": null,
        "type": "STRING",
        "numericRangeStart": null,
        "numericRangeEnd": null,
        "required": true,
        "choices": [
          
        ],
        "created": 1444851000000
      }
    ],
    "primeKey": null
  }
}
~~~

### Add session rule metadata

`POST /trials/sessions/rules/metadata`
{:.pa.param.http}

Adds metadata to rule.

**Example request**

~~~
{
  "key": "age",
  "type": "NUMERIC",
  "choices": "1,2,3",
  "numericRangeStart": null,
  "numericRangeEnd": null,
  "required": true,
  "trialSessionRules": "c7cefd7f738349b393911007bfd8e72f"
}
~~~

**Request body parameters**

|Parameter         |Description
|----------------- |------------------
|`key`{:.param} |Metadata's key.
|`type`{:.param} |Metadata's type. Can be `STRING`, `NUMERIC` or `CHOICES`.
|`choices`{:.param} |Comma-separated string of allowed values (required if type is `CHOICES`).
|`numericRangeStart`{:.param} |Minimum number allowed for value (optionally needed if type is `NUMERIC`).
|`numericRangeEnd`{:.param} |Maximum number allowed for value (optionally needed if type is `NUMERIC`).
|`required`{:.param} |Boolean (true/false). Specifies whether metadata rule must be given a value.
|`trialSessionRules`{:.param} |Session rule ID.

**Example response**

~~~
{
  "data": {
    "uuid": "f66ec9fe-2792-4657-a389-aaf1a3dd4418",
    "id": "f66ec9fe27924657a389aaf1a3dd4418",
    "key": "age",
    "value": null,
    "type": "NUMERIC",
    "numericRangeStart": null,
    "numericRangeEnd": null,
    "required": false,
    "choices": [
      {
        "uuid": "6e0a034e-125c-4b5f-b177-a7df861224bd",
        "id": "6e0a034e125c4b5fb177a7df861224bd",
        "order": 0,
        "value": "1",
        "created": 1450453104471
      },
      {
        "uuid": "44b3da41-aba0-46a2-a82b-d591a82701e7",
        "id": "44b3da41aba046a2a82bd591a82701e7",
        "order": 1,
        "value": "2",
        "created": 1450453104472
      },
      {
        "uuid": "35570f55-77ff-4a0d-888d-1551dd888f82",
        "id": "35570f5577ff4a0d888d1551dd888f82",
        "order": 2,
        "value": "3",
        "created": 1450453104474
      }
    ],
    "created": 1450453104470
  }
}
~~~

### Remove session rule metadata

`DELETE /trials/sessions/rules/metadata/<metadataId>`
{:.pa.param.http}

Deletes the specified rule metadata.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`metadataId`{:.param} |Metadata ID.

**Example response**

~~~
{
  "data": {
    "uuid": null,
    "id": null,
    "key": null,
    "value": null,
    "type": "STRING",
    "numericRangeStart": 0,
    "numericRangeEnd": 1,
    "required": false,
    "choices": [
      
    ],
    "created": null
  }
}
~~~

### Update session rule metadata

`PUT /trials/sessions/rules/metadata/<metadataId>`
{:.pa.param.http}

Updates the specified rule metadata.

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`metadataId`{:.param} |Metadata ID.

**Example request**

~~~
{
  "key": "subject",
  "value": null,
  "type": "NUMERIC",
  "numericRangeStart": null,
  "numericRangeEnd": null,
  "required": true,
  "choices": "",
  "trialSessionRules": "c7cefd7f738349b393911007bfd8e72f"
}
~~~

**Example response**

~~~
{
  "data": {
    "uuid": "b10b4a6a-a7dc-40a9-8fa5-f2d5e39007d0",
    "id": "b10b4a6aa7dc40a98fa5f2d5e39007d0",
    "key": "age",
    "value": null,
    "type": "NUMERIC",
    "numericRangeStart": null,
    "numericRangeEnd": null,
    "required": true,
    "choices": [
      
    ],
    "created": 1444851955211
  }
}
~~~

## Sessions - Search

### Search sessions

`GET /trials/sessions/search`
{:.pa.param.http}

Returns sessions according to the specified parameters.

**Example request**

~~~
/trials/sessions/search?trialIds=b936c867117a4ae9a40bfb482682c1a8&participantIds=&start=1436681060043&end=1439186660043&deviceIds=&metadata=%22%22&count=10&offset=0
~~~

**Request parameters**

|Parameter         |Description
|----------------- |------------------
|`trialId`{:.param} | (Optional) Comma-separated string of trial IDs.
|`participantIds`{:.param} |(Optional) Comma-separated string of participant user IDs.
|`start`{:.param} |(Optional) Start date of the session (in milliseconds since epoch).
|`end`{:.param} |(Optional) End date of the session (in milliseconds since epoch).
|`deviceIds`{:.param} |(Optional) Comma-separated string of device IDs.
|`metadata`{:.param} |(Optional) JSON string of metadata (e.g., [{"key":"test key","value":"test value"}].
|`count`{:.param} |(Optional) Desired count of items in the result set.
|`offset`{:.param} |(Optional) Offset for pagination.

**Example response**

~~~
{
  "data": {
    "sessions": [
      {
        "uuid": "b9be25a0-764a-49ef-890f-5cb0a0e10d0c",
        "id": "b9be25a0764a49ef890f5cb0a0e10d0c",
        "trialId": "b936c867117a4ae9a40bfb482682c1a8",
        "participantId": "b379322f43e641bd9ad6ee7787043fad",
        "devices": [
          {
            "uuid": "f941157d-eca1-4230-bf5e-5a394b15607d",
            "id": "f941157deca14230bf5e5a394b15607d",
            "deviceId": "a5c1cb6a35dc4387b722487982bcd6bc"
          }
        ],
        "start": 1447875729000,
        "end": 1447875740000,
        "metadatas": [
          {
            "uuid": "cfee16c4-4942-4345-888e-af034acacb12",
            "id": "cfee16c449424345888eaf034acacb12",
            "key": "age",
            "value": "33"
          },
          {
            "uuid": "f23290f9-41e1-41ef-9755-289df2f875e6",
            "id": "f23290f941e141ef9755289df2f875e6",
            "key": "subject",
            "value": "1"
          }
        ],
        "exports": [
          {
            "uuid": "e8738377-b486-40b7-acb2-e843e4175aa8",
            "id": "e8738377b48640b7acb2e843e4175aa8",
            "exportId": "2636607af8de46a492a6a2764b4dcce2",
            "created": 1447875749000
          }
        ],
        "status": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

## Validation and errors


**Responses**

| Http Status | Code | Error message                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Condition                                                                               |
|-------------|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| `200`{:.param}         | -    | Request successful.                                                                                                                                                                                                                                                                                                                                                                                                                                                            |                                                                                     |
| `400`{:.param}         | 4001 | Possible messages:<ul><li>Invalid email</li><li>Minimum length {0}</li><li>Maximum length {0}</li><li>Numeric field only</li><li>Text field only</li><li>Boolean field only</li><li>Invalid user name (characters allowed: alphanumeric, ".", "-" and "_" - must start with a letter)</li><li>Required parameter</li><li>The manifest content is invalid</li><li>The manifest content is invalid - Details: {0}</li><li>The manifest content cannot be empty<li>Invalid rule</li><li>Minimum value {0}</li><li>Maximum value {0}</li><li>The rule identifier "{1}" does not match with the URL parameter "{0}"</li></ul> | Validation error.                                                                   |
| `401`{:.param}         | 401  | Please provide a valid authorization header                                                                                                                                                                                                                                                                                                                                                                                                                                   | You need to obtain an access token and provide an authorization header on the call. |
| `403`{:.param}         | 403  | You don't have the right permissions: [message will differ depending on the permission issue]                                                                                                                                                                                                                                                                                                                                                                                 | You don't have the required permissions to perform the requested action.            |
| `404`{:.param}         | 404  | Not Found                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | The requested object was not found.                                                 |
| `404`{:.param}         | 1101 | Device type does not exist.                                                                                                                                                                                                                                                                                                                                                                                                                                                   | The requested object was not found.                                                 |
| `404`{:.param}         | 1201 | User does not exist.                                                                                                                                                                                                                                                                                                                                                                                                                                                          | The requested object was not found.                                                 |
| `409`{:.param}         | 1202 | Email already registered.                                                                                                                                                                                                                                                                                                                                                                                                                                                     | You need to pass a different email address.                                         |
| `409`{:.param}         | 1203 | Username already registered.                                                                                                                                                                                                                                                                                                                                                                                                                                                  |  You need to request a different username.


## WebSocket errors

|Code |Error message |Condition
|-----|-------|-----
|400 | Bad Request |Invalid JSON
|400 | Missing sdid value |Missing `sdid`
|400 |Missing ddid value |Missing `ddid`
|400 |Registration timeout |Client connects and does not register
|400 |Invalid ts value |Invalid timestamp or timestamp less than 0
|400 |Invalid ts value (in future) |Timestamp greater than `FUTURE_GRACE_PERIOD`
|401 |Please provide a valid authorization header |Missing auth token
|401 |Device not registered |Unregistered sdid
|403 |You do not have the right permission: devices |No WRITE permission
|403 |Wrong cid |Mismatch `cid`
|429 |DAILY rate limit exceeded |Rate limit exceeded
