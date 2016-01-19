---
title: "Administrative APIs"
---

# Administrative APIs

The information on this page will get you started with managing a list of users and devices. After reading, you will be able to manage a user, set up a device, and have it talking to SAMI.

See [**Authentication**](/sami/sami-documentation/authentication.html) for instructions on using OAuth2.
{:.info}

Through the SAMI API, you have the ability to retrieve a user's profile, update applications for a user, and retrieve a list of a user's device types and devices, as well as the data they have sent to SAMI. 

Creating applications and device types is even simpler, because it's done through our web interface. [Read about the Developer and User Portals.](/sami/sami-documentation/developer-user-portals.html)


## Managing users

SAMI users create Samsung accounts with a username and password. Once a profile has been created, SAMI assigns a user ID to that user. 

### Getting the current user's profile

This call returns the current authenticated user's profile.

~~~
  GET /users/self
~~~

It will return a response that looks like the following. `id`{:.param} specifies your [user ID.](/sami/sami-documentation/sami-basics.html#user-id)

~~~~
{
  "data":{
    "id":"db2e64c653b94f519dbca8f157f73b79",
    "name":"tuser",
    "email":"tuser@ssi.samsung.com",
    "fullName":"Test User",
    "saIdentity": "gut9amj3ld",
    "createdOn": 1403042304, // unix time in seconds
    "modifiedOn": 1403042305 // unix time in seconds
  }
}
~~~~

### Creating a user's application properties

This call allows you to specify properties for a user's application. You need the user ID.

The call must first be authenticated with a valid Authorization header. The application for which the properties are created is the application linked to the Authorization token and *must* be the same as the `aid`{:.param} parameter sent in the JSON payload. This parameter specifies the [application ID.](/sami/sami-documentation/sami-basics.html#application-id)

~~~
  POST /users/<userID>/properties
~~~

The following parameters can be specified in the JSON payload.

  |Parameter      |Description |
  |-------------- |--------------------------------------------------------------------------------------------------------|
  |`uid`{:.param}         | (Optional) User ID. String representation of a user ID. |
  |`aid`{:.param}         |Application ID. String between 1 and 36 characters. |
  |`properties`{:.param}  |Custom properties for each user in the format that the application wants. String max 10000 characters. |


## Managing devices

There are two parameters used to identify devices in SAMI.

The **device type ID** is a unique identifier assigned by SAMI. A device type, consisting of a name, description and Manifest, defines a device in SAMI. Manufacturers and developers can create device types, which are usually associated with a physical device. However, a device type may also be virtual, such as an application or a service that analyzes and stores data.

To create a device type, use the [**Developer Portal.**](/sami/sami-documentation/developer-user-portals.html)
{:.info}

The **device ID**, assigned by SAMI when a device is connected, is a unique instance of a device type. Each user owns or uses one or more devices. When reading or writing data in SAMI, you always need to have a device ID.

### Requesting a list of devices

This request returns a list of a user's devices that have been connected to SAMI. You need the user ID.

~~~
GET /users/<userID>/devices
~~~

**Example Response**

~~~
{
    "data": {
      "devices": [
        {
          "id": "SdP8UyrNdNBm",
          "dtid": "polestar_locator_v2",
          "name": "Polestar locator v2 Betty",
          "manifestVersion":2,
          "manifestVersionPolicy":"LATEST"
        },
        {
          "id": "e98fsEKW5cQp",
          "dtid": "polestar_locator_coord",
          "name": "Polestar Locator Coord Betty S2",
          "manifestVersion":5,
          "manifestVersionPolicy":"DEVICE"
        }
      ]
    },
    "total": 2,
    "offset": 0,
    "count": 2
}
~~~

In the above response, `id`{:.param} refers to the device ID and `dtid`{:.param} is the device type ID. (A device ID is a unique instance of a device type. See below.)

The [API specification](/sami/api-spec.html#get-a-users-devices) explains `manifestVersion`{:.param} and `manifestVersionPolicy`{:.param}. The Manifest is a program that converts the original data from a device into a normalized format for SAMI. [Learn more about writing Manifests.](/sami/sami-documentation/the-manifest.html)

### Requesting a list of device types

This request returns a list of a user's registered device types. You need the user ID.

~~~
GET /users/<userID>/devicetypes
~~~

**Example Response**

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

The device type's `uniqueName`{:.param} is used for Manifest package naming, and must be a valid JAVA package name.

### Creating a device

This call lets you add a device to a user's account.

Users can add their own devices through the [**User Portal**.](/sami/sami-documentation/developer-user-portals.html)
{:.info}

~~~
POST /devices
~~~

**Example response**

~~~
{
  "uid":"03c99e714b78420ea836724cedcebd49",
  "dtid":"181a0d34621f4a4d80a43444a4658150",
  "name":"Office lamp 2",
  "manifestVersion":5,
  "manifestVersionPolicy":"DEVICE"
}
~~~

`uid`{:.param} is the user ID and `dtid`{:.param} is the device type ID.

### Getting a device's access token

~~~
GET /devices/<deviceID>/tokens
~~~

This call provides a device's generated access token. You will need the device ID.

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

`did`{:.param} refers to the device ID and `uid`{:.param} is the associated user ID.

### Getting a device's latest Manifest properties

~~~
GET /devicetypes/<deviceTypeID>/manifests/latest/properties
~~~

This call returns metadata about the device type's latest Manifest, such as the fields and the units they are expressed in. You need the device type ID.

**Example response**

~~~~
{
  "data":{
    "manifest":"import com.samsung.sami.manifest.Manifest
                import com.samsung.sami.manifest.fields.Field
                import com.samsung.sami.manifest.fields.FieldDescriptor
                public class SamsungCamManifest implements Manifest {
                  @Override
                  List<Field> normalize(String input) {
                    return []
                  }
                  @Override
                  List<FieldDescriptor> getFields() {
                    return []
                  }
                }",
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

### Deleting a device

~~~
DELETE /devices/<deviceID>
~~~

Deletes a particular device. You need the device ID.

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


[1]:	/sami/sami-documentation/sami-basics/requesting-an-application-id.html
[2]:	https://accounts.samsungsami.io/authorize?client_id=9628eef2a00d43d89b757b8d34373588&response_type=code&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write
[3]:	https://myapp.com/callback?code=0ee7fcd0abed470182b02cd649ec1c98&state=abcdefgh
[4]:	https://accounts.samsungsami.io/token?client_id=9628eef2a00d43d89b757b8d34373588&client_secret=0ea24090297b4108ae1338c39f25c118&grant_type=authorization_code&code=0ee7fcd0abed470182b02cd649ec1c98&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write