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
    "saIdentity": "gut9amj3ld",
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
|`manifestVersion`{:.param} | Device's manifest version that is used to parse the messages it sends to SAMI. |
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
|`manifestVersion`{:.param} | Device's manifest version that is used to parse the messages it sends to SAMI. |
|`manifestVersionPolicy`{:.param} | Device's policy that will be applied to the messages sent by this device. <ul><li> `LATEST` means it will use the most recent manifest created.</li><li>`DEVICE` means it will use a specific version of the manifest regardless if newer versions are available.</li></ul>
|`needProviderAuth`{:.param} | If `false` the device needs authentication and is authenticated. If `true` the device needs authentication and is not authenticated.


### Create a device

~~~
POST /devices
~~~

Adds a device.

**Example Request**

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
  |`manifestVersion`{:.param} | (Optional) Numeric greater than 0 (zero). Device's manifest version that is used to parse the messages it sends to SAMI.
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

**Example Request**

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
  |`manifestVersion`{:.param} |Numeric greater than 0 (zero). Device's manifest version that is used to parse the messages it sends to SAMI.
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
  "data":{
    "id":"d1d04e4cb18a4757b5481901e3665a34",
    "uid":"1",
    "name":"Samsung Web Camera XYZ",
    "published":true,
    "approved":true,
    "latestVersion":5,
    "uniqueName":"com.samsung.web.camera"
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
                "uniqueName": "basis_watch"
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
        "location":{
          "x": { "type": "Double", "unit": ""},
          "y": { "type": "Double", "unit": ""}
        },
        "weight": {
          { "type": "Double", "unit": "kg"}
        }
      }
    },
    "version":5
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
        "location":{
          "x": { "type": "Double", "unit": ""},
          "y": { "type": "Double", "unit": ""}
        },
        "weight": {
          { "type": "Double", "unit": "kg"}
        }
      }
    },
    "version":2
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

### Post a message

~~~
POST /message
~~~

Sends data with a timestamp to SAMI or another device.

**Example Request**

~~~~
{
  "sdid": "HIuh2378jh",
  "ddid": "298HUI210987",
  "ts": 1388179812427,
  "data": [payload]
}           
~~~~

**Request parameters**

  |Parameter   |Description
  |----------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`sdid`{:.param}     |Source device ID.
  |`data`{:.param}     |Device data. Can be a simple text field, or a JSON document.
  |`ddid`{:.param}     |(Optional) Destination device ID. Only use when sending a message to another device.
  |`ts`{:.param}       |(Optional) Allows to specify a timestamp for the message. Must be a valid time: past time, present or future up to the current server timestamp grace period. Current time if omitted.
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
|Get by device and filter |`sdid`{:.param}, `filter`{:.param}
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
|`order`{:.param}     | (Optional) Desired sort order: `asc` or `desc` (default: `asc`)
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

Returns the sum, minimum, maximum, count or average of message fields that are numerical. This call generates results only on messages that are at least 2 hours old.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`endDate`{:.param}    |Time of latest (newest) item to return, in milliseconds since epoch.
  |`field`{:.param}    |Message field being queried for analytics.
  |`sdid`{:.param} |Source device ID of the messages being searched.
  |`startDate`{:.param} |Time of earliest (oldest) item to return, in milliseconds since epoch.

### Get last normalized messages

~~~
GET /messages/last
~~~

Returns the most recent normalized messages from a device or devices.

**Available URL query parameters**

  |Parameter   |Description
  |----------- |---------------------------------------------------------
  |`sdids`{:.param}    |Comma separated list of source device IDs (minimum: 1).
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

### Export normalized messages

~~~
GET /messages/export
~~~

Exports normalized messages from up to 30 days, according to one of the following parameter combinations. The maximum duration between `startDate`{:.param} and `endDate`{:.param} is 30 days.

|Combination |Required Parameters
|------------|---------
|Get by user |`uid`{:.param}, `endDate`{:.param}, `startDate`{:.param}
|Get by device |`sdid`{:.param}, `endDate`{:.param}, `startDate`{:.param}
|Common parameters |`order`{:.param}, `format`{:.param}


**Available URL query parameters**

|Parameter |Description
|----------|------------
| `endDate`{:.param}   | Time of latest (newest) item to return, in milliseconds since epoch.
|`order`{:.param}     | (Optional) Desired sort order: `asc` or `desc` (default: `asc`)
| `format`{:.param}     | (Optional) Format the export will be returned as: `json`, `csv` or `xml` (currently `json` is implemented)
| `sdid`{:.param}      | (Optional) Source device ID of the messages being searched.
| `startDate`{:.param} | Time of earliest (oldest) item to return, in milliseconds since epoch.
| `uid`{:.param}       | (Optional) The owner's user ID of the messages being searched. If not specified, defaults to the current authenticated user (if the current authentication context is not an application). If specified, it must be that of a user to which the current authenticated user (or the application) has read access.

**Example response**

~~~
{
  "exportId":"f2fcf3e0-4425-11e4-be99-0002a5d5c51b",
  "sdid":"heart_monitor_123",
  "startDate":1378425600000,
  "endDate": 2378425600000,
  "order": "asc",
  "format": "json"
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
  "exportId":"f2fcf3e0442511e4be990002a5d5c51b",
  "status":"Served",
  "md5": "12345",
  "ttl": "1234567890"
  "expirationDate": 1234567890
}
~~~

**Response parameters**

|Parameter   |Description
|----------- |-------------
|`exportId`{:.param} | Export ID.
|`status`{:.param} | Status of the export query. Values include `Received`, `In-progress`, `Success`, `Failure`, `Served`, `Expired`.
|`md5`{:.param} |Checksum of the file returned.
|`ttl`{:.param} |Expiration date.
|`expirationDate`{:.param} |Expiration date.

### Get export result

~~~
GET /messages/export/<exportID>/result
~~~

Returns the result of the export query. The result call returns the response in tgz format. 

**Request parameters**

  |Parameter   |Description
  |----------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`exportID`{:.param}     |The Export ID of the export query.

The tar file may contain one or more files in the following format:

**Example response**

~~~
{
  "size": 1,
  "data": [
    {
    "ts": 1377206303000,
    "cts": 1377206303000,
    "sdid": "hueID_dev_2",
    "mid": "20442c0b-70b5-4670-b712-32f8b78393bf",
    "data": "{\"status\":{\"state\":{\"bri\":254}}}"
    }
  ]
}
~~~

Each file in the tar file has the following format:  `id-date.json` where `id` is either a `uid` or `sdid`, and `date` is a timestamp in milliseconds (the `ts` date of the first message in the file). If the result of a `uid` or `sdid` search is empty, the result will be a single file with the filename `id0.json` (`id` is either a `uid` or `sdid`).


### Get raw messages

~~~
GET /messages/raw
~~~

Returns raw (original format) messages.

**Available URL query parameters**

  |Parameter         |Description
  |----------------- |--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  |`sdid`{:.param}           |Source device ID of the messages being searched.
  |`startDate`{:.param}      |(Optional) Time of earliest (oldest) item to return, in milliseconds since epoch.
  |`endDate`{:.param}        |(Optional) Time of latest (newest) item to return, in milliseconds since epoch.
  |`order`{:.param}          |(Optional) Desired sort order: `asc` or `desc` (default: `asc`)
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


