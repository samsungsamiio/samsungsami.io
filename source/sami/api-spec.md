---
title: "API specification"

---
# API specification

## Introduction

The SAMI API provides access to the SAMI platform.

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

### Requests parameters and payload

All the `POST`{:.param} and `PUT`{:.param} calls expect a JSON payload as an input or a value
in the path.

### Timestamps

All timestamps are in milliseconds since epoch.

### Rate limits

The rate limits for the API calls are documented [here.](/sami/sami-documentation/rate-limiting.html)

### Message limits

Any message sent to SAMI may not be bigger than 10 KB.

## API Console

The SAMI API Console is found at [https://api-console.samsungsami.io/sami.](https://api-console.samsungsami.io/sami) In order to use the Console, you must first authenticate with your Samsung account. If you don’t have a Samsung account, you can create it during the process. 

After authentication, you can test each of the below calls using parameters returned in the Console and the [Developer Portal.](https://devportal.samsungsami.io/)


## Users

### Get the current user's profile

~~~
  GET /users/self
~~~

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

~~~
  GET /users/<userID>/properties
~~~

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

~~~
  POST /users/<userID>/properties
~~~

Specifies the properties of a user's application.

The call must be authenticated with a valid Authorization header. The
application for which the properties are created is the application
linked to the Authorization token and MUST be the same as the `aid`{:.param}
parameter sent in the JSON Payload.

**Request parameters**

  |Parameter   |Description |
  |----------- |-------------|
  |`userID`{:.param}   |User ID. |

**Example Request**

~~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "aid":"9628eef2a00d43d89b757b8d34373588",
  "properties":"{\"some\":[\"custom\",\"properties\"]}"
}
          
~~~~

**Request parameters**

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

~~~
  PUT /users/<userID>/properties
~~~

Modifies the properties of a user's application.

The call must be authenticated with a valid Authorization header. The
application for which the properties are updated is the application
linked to the Authorization token and MUST be the same as the `aid`{:.param} parameter sent in the JSON Payload.

**Request parameters**

  |Parameter   |Description
  |----------- |-------------
  |`userID`{:.param}   |User ID.

**Example Request**

~~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "aid":"9628eef2a00d43d89b757b8d34373588",
  "properties":"{\"some\":[\"custom\",\"properties\",3],\"more\":\"props\"}"
}
~~~~

**Request parameters**

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

~~~
  DELETE /users/<userID>/properties
~~~

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

~~~
GET /users/<userID>/devices
~~~

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

~~~
GET /users/<userID>/devicetypes
~~~

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

~~~
GET /users/<userID>/trials
~~~

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

~~~
GET /devices/<deviceID>
~~~

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

~~~
POST /devices
~~~

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

**Request parameters**

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

~~~
PUT /devices/<deviceID>
~~~

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

**Request parameters**

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

~~~
DELETE /devices/<deviceID>
~~~

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

~~~
GET /devices/<deviceID>/tokens
~~~

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

~~~
PUT /devices/<deviceID>/tokens
~~~

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

~~~
DELETE /devices/<deviceID>/tokens
~~~

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

~~~
GET /devicetypes/<deviceTypeID>
~~~

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

~~~
GET /devicetypes/
~~~

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

~~~
GET /devicetypes/<deviceTypeID>/manifests/latest/properties
~~~

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

~~~
GET /devicetypes/<deviceTypeID>/manifests/<version>/properties
~~~

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

~~~
GET /devicetypes/<deviceTypeID>/availablemanifestversions
~~~

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

~~~
POST /messages
~~~

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

**Example request (action)**

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

**Request parameters**

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

~~~
GET /messages
~~~

Returns normalized messages, according to one of the following parameter combinations:

|Combination |Required Parameters
|------------|---------
|Get by user |`uid`{:.param}, `endDate`{:.param}, `startDate`{:.param}
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

~~~
GET /messages/analytics/aggregates
~~~

Returns the sum, minimum, maximum, mean and count of message fields that are numerical. This call generates results on messages that are at least 1 minute old. Values for `startDate`{:.param} and `endDate`{:.param} are rounded to start of minute, and the date range between `startDate`{:.param} and `endDate`{:.param} is restricted to 31 days max.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`endDate`{:.param}    |Time of latest (newest) item to return, in milliseconds since epoch.
  |`field`{:.param}    |Message field being queried for analytics.
  |`sdid`{:.param} |Source device ID of the messages being searched.
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

### Get last normalized messages

~~~
GET /messages/last
~~~

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

~~~
GET /messages/presence
~~~

Returns presence of normalized messages.

**Available URL query parameters**

  |Parameter         |Description
  |----------------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`sdid`{:.param}           |(Optional) Source device ID of the messages being searched.
  |`interval`{:.param}       |String representing grouping interval. One of: `minute` (1 hour limit), `hour` (1 day limit), `day` (31 days limit), `month` (1 year limit) or `year` (10 years limit).
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

### Get raw messages

~~~
GET /messages/raw
~~~

Returns raw (original format) messages, according to one of the following parameter combinations.

|Combination |Required Parameters
|------------|---------
|Get messages by source device |`sdid`{:.param}, `endDate`{:.param}, `startDate`{:.param}
|Get Actions by destination device |`ddid`{:.param}, `endDate`{:.param}, `startDate`{:.param}

**Available URL query parameters**

  |Parameter         |Description
  |----------------- |-------------------------
  |`sdid`{:.param}           |(Optional) Source device ID of the messages being searched.
  |`ddid`{:.param}           |(Optional) Destination device ID of the Actions being searched.
  |`startDate`{:.param}      |(Optional) Time of earliest (oldest) item to return, in milliseconds since epoch.
  |`endDate`{:.param}        |(Optional) Time of latest (newest) item to return, in milliseconds since epoch.
  |`order`{:.param}          |(Optional) Desired sort order: `asc` or `desc` (default: `asc`).
  |`count`{:.param}          |Number of items to return per query. 
  |`offset`{:.param}         |(Optional) A string that represents the starting item, should be the value of 'next' field received in the last response (required for pagination). 


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

**Response parameters**

|Parameter         |Description
|----------------- |------------------
|`sdid`{:.param} |Source device ID.
|`startDate`{:.param} |Time of earliest message requested.
|`endDate`{:.param} |Time of latest message requested.
|`count`{:.param} |Number of items requested.
|`order`{:.param} |Sort order.
|`size`{:.param} |Number of items received.
|`cts`{:.param} |Timestamp from SAMI.
|`ts`{:.param} |Timestamp from source.
|`mid`{:.param} |Message ID.

## Export

### Create an export request

~~~
POST /messages/export
~~~

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

**Request parameters**

|Parameter |Description
|----------|------------
|`csvHeaders`{:.param} |(Optional) Adds a header to a CSV export. Accepted values are `true`, `false`, `1`, `0`. Defaults to `true` if `format` = `csv1`.
|`endDate`{:.param}   | Time of latest (newest) item to return, in milliseconds since epoch.
|`format`{:.param}     | (Optional) Format the export will be returned as: `json` (JSON) or `csv1` (simple CSV). Defaults to `json` if not specified.
|`order`{:.param}     | (Optional) Desired sort order: `asc` or `desc` (default: `asc`).
|`sdids`{:.param}      | (Optional) Comma-separated list of source device IDs. Max 30 device IDs.
|`startDate`{:.param} | Time of earliest (oldest) item to return, in milliseconds since epoch.
|`sdtids`{:.param} |(Optional) Comma-separated list of source device type IDs. Max 30 device type IDs.
|`trialID`{:.param} |(Optional) Trial ID being searched for messages.
|`uids`{:.param}       | (Optional) Comma-separated list of user IDs. The current authenticated user must have read access to each user in the list. Max 30 user IDs.
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

~~~
GET /messages/export/<exportID>/status
~~~

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

~~~
GET /messages/export/<exportID>/result
~~~

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

~~~
GET /messages/export/history
~~~

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

See [**WebSocket errors**](#websocket-errors) for a list of error
codes that can be returned for WebSockets.
{:.info}

### Read-only WebSocket

~~~
WebSocket /live
~~~

Read-only WebSocket that listens for new messages according to one of the following URL query parameter combinations:

| Combination | Required Parameters|
|-------------|-----------|
|Get by user | `uid`{:.param}, `Authorization`{:.param}
|Get by device | `sdid`{:.param}, `Authorization`{:.param}
|Get by device type | `sdtid`{:.param}, `uid`{:.param}, `Authorization`{:.param}

**Available URL query parameters**

| Parameter | Description
|-----------|--------------
|`Authorization`{:.param} |Access token.
|`sdid`{:.param} |(Optional) Source device ID.
|`sdtid`{:.param} |(Optional) Source device type ID.
|`uid`{:.param} |(Optional) User ID of the target stream. If not specified, defaults to the user ID of the supplied access token.

The below example uses [Tyrus](https://tyrus.java.net/), a Java API for WebSocket suitable for Web applications.
{:.info}

**Example**

~~~
java -jar tyrus-client-cli-1.3.3.jar "wss://api.samsungsami.io/v1.1/live?uid=2&Authorization=bearer+1c20060d9b9f4ad09ee16919a45c71b7"
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

#### Ping

SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the client must reconnect.

**Example ping message sent by server**

~~~
{
  "type": "ping"
}         
~~~

### Bi-directional message pipe
  
Establishes a data connection to SAMI and allows to register as a device or device list.

~~~
WebSocket /websocket
~~~

#### Registration

All client applications, including device proxies, must register after opening the WebSocket connection. Otherwise client messages will be discarded and clients will not be sent messages. 

Register messages can set `ack`{:.param} to "true" to receive an acknowledgment message from SAMI for each message sent.

**Available URL query parameters**

| Parameter | Description
|-----------|--------------
|`ack`{:.param} |(Optional) Boolean (true/false). WebSocket returns ACK messages for each message sent by client. If not specified, defaults to false.

**Example registration message sent by client**

~~~
{
  "sdid": "DFKK234-JJO5",
  "Authorization": "bearer d77054a9b0874ba884499eef7768b7b9",
  "type": "register",
  "cid": "1234567890"
}         
~~~

**Request parameters**

| Parameter | Description
|-----------|--------------
|`sdid`{:.param} |Source device ID.
|`Authorization`{:.param} |Access token. 
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

#### Ping

SAMI sends a ping every 30 seconds to the client. If a ping is not received, the connection has stalled and the client must reconnect.

**Example ping message sent by server**

~~~
{
  "type": "ping"
}         
~~~

### Sending messages

Posting a message via WebSockets differs from performing the REST call in that `cid`{:.param} can be included. Responses from SAMI include `cid`{:.param} to facilitate client side validations.

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

**Request parameters**

 |Parameter   |Description
  |----------- |-----------
  |`sdid`{:.param}     |(Optional) Source device ID.
  |`data`{:.param}     |Data. Can be a simple text field, or a JSON document.
  |`ddid`{:.param}     |(Optional) Destination device ID. Can be used when sending a message to another device.
  |`ts`{:.param}       |(Optional) Message timestamp. Must be a valid time: past time, present or future up to the current server timestamp grace period. Current time if omitted.
  |`type`{:.param} |Type of message: `message` or `action` (default: `message`).
  |`cid`{:.param} |(Optional) Client (application) ID. Can be used when `ack=true`.

**Example ACK message**

~~~
{
  "data":{
    "mid": "6d002024824746649766743582c9f005", 
    "cid": "1234567890"
  }
}
~~~

### Receiving messages

Devices connected to the WebSocket receive messages that contain their corresponding `ddid`{:.param} (destination device ID).

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

## Trials

### Create a trial

~~~
POST /trials
~~~

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

**Request parameters**

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

~~~
DELETE /trials/<trialID>
~~~

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

~~~
GET /trials/<trialID>
~~~

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

~~~
PUT /trials/<trialID>
~~~

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

**Request parameters**

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

**Request parameters**

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

~~~
PUT /trials/<trialID>/application
~~~

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

~~~
POST /trials/<trialID>/devicetypes
~~~

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

**Request parameters**

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

~~~
POST /trials/<trialID>/participants/<userID>/devices
~~~

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

**Request parameters**

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

~~~
DELETE /trials/<trialID>/participants/<userID>/devices/<deviceID>
~~~

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

~~~
GET /trials/<trialID>/devices
~~~

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

~~~
GET /trials/<trialID>/devicetypes
~~~

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

~~~
GET /trials/<trialID>/participants/<userID>/devices
~~~

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

~~~
POST /trials/<trialID>/invitations
~~~

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

**Request parameters**

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

~~~
DELETE /trials/<trialID>/administrators/<userID>
~~~

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

~~~
DELETE /trials/<trialID>/invitations/<invitationID>
~~~

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

~~~
DELETE /trials/<trialID>/participants/<userID>
~~~

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

~~~
GET /trials/<trialID>/administrators
~~~

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

~~~
GET /trials/<trialID>/invitations
~~~

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

~~~
GET /trials/<trialID>/participants
~~~

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

~~~
PUT /trials/<trialID>/invitations/<invitationID>
~~~

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

**Request parameters**

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
