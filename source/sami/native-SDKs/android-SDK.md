---
title: "Java/Android SDK"

---

# Java/Android SDK (beta)

This SDK helps you connect your Android apps to SAMI. The SDK helps authenticating with SAMI, exposes a number of methods to easily execute REST API calls to SAMI, and supports a WebSockets controller.

## Prerequisites

- [Eclipse](https://www.eclipse.org/)
- [Maven Integration for Eclipse](https://www.eclipse.org/m2e/) or [Maven](http://maven.apache.org/)
- Wordnik
- Jackson JSON Processor 2.1.4
- JUnit 4.8.1
- Apache HTTP Client 4.0

The SDK was developed with Eclipse and Maven and tested with Android 4.4.2. Building Maven will fetch the correct libraries. You might be able to build the SDK in a different environment and we would be happy to hear about your (success) stories.

## Source code

The source code for the Java/Android SDK is located [on GitHub.](https://github.com/samsungsamiio/sami-android)

## Installation

In Eclipse,

- Import the SDK library project as "Existing Maven Projects".
- Right-click the project and choose "Run As", then "Maven install".

After the installation succeeds, you can use the generated libraries in one of the following ways depending on your scenario:

- To use them in an Android project, copy libraries under `target` and `target/lib` directories of the imported Maven project to `libs` directory in your Android project.
- To use them in your Maven project, modify `pom.xml` file in your project to add dependency to `sami-android-xxx.jar` under `target` of the imported Maven project as follows:

~~~
<dependency>
   <groupId>io.samsungsami</groupId>
   <artifactId>sami-android</artifactId>
   <version>the actual version number</version>
</dependency>
~~~

Finally, in your Android project's `AndroidManifest.xml`, add the permissions required by the SDK library. You could accomplish this automatically if you are using Manifest merger (`manifestmerger.enabled`, requires SDK tools rev 20 or above).

~~~
<uses-permission android:name="android.permission.INTERNET" />
~~~

You're ready to go.

## Usage

The easiest way to start using the SAMI Android SDK is to look at our sample applications at:

 - [Your first Android app](/sami/demos-tools/your-first-android-app.html)
 - [https://github.com/samsungsamiio/sami-android-demo](https://github.com/samsungsamiio/sami-android-demo)
 - [https://github.com/samsungsamiio/sample-android-SAMInBLE](https://github.com/samsungsamiio/sample-android-SAMInBLE)
 - [https://github.com/samsungsamiio/sample-android-SAMInBLEws](https://github.com/samsungsamiio/sample-android-SAMInBLEws)
 - [https://github.com/samsungsamiio/sample-android-SAMIRemoteControl](https://github.com/samsungsamiio/sample-android-SAMIRemoteControl)

## OAuth2 flow - Android

Android apps require the use of Implicit Grant flows for authentication. This involves launching a `WebView` and submitting a `GET` request to the authorization endpoint. 

~~~
https://accounts.samsungsami.io/authorize
~~~

|Name |Value
|--- |---
|`client`{:.param} |mobile
|`client_id`{:.param} |[Get Application ID from admin.samsungsami.io]
|`response_type`{:.param} |token
|`redirect_uri`{:.param} |[Get Redirect URL from admin.samsungsami.io]
|`client`{:.param} |mobile

After the request is submitted via the WebView, the Android app needs to implement a callback to capture the accessToken.

## Get user info

The first task is to use the access token to obtain the user's information: ID, full name, email, etc.

This is accomplished using the `SamiUsersApi` class in the SAMI Android/Java library, as below:

**SamiUserTest.java**

~~~
import io.samsungsami.api.UsersApi;
import io.samsungsami.model.UserEnvelope;
 
...
 
 UsersApi api = new UsersApi();
 api.getInvoker().addDefaultHeader("Authorization", "Bearer " + this.accessToken);
     
 // GET /users/self
 UserEnvelope userEnvelope = api.self();
 System.out.println(userEnvelope.getData());
~~~

## Register device

After obtaining the user's ID, other user information like the user's devices, device types and properties can be retrieved. 

To 'register' the Android phone as a device, the Android app needs to use the `com.samihub.api.DevicesApi.java` addDevice call, passing the appropriate device type ID, below:

**SamiUserDevicesTest.m**

~~~
import io.samsungsami.api.DevicesApi;
import io.samsungsami.model.Device;
import io.samsungsami.model.DeviceEnvelope;
 
void registerPhoneAsDevice() {
    DevicesApi api = new DevicesApi();
    api.getInvoker().addDefaultHeader("Authorization", "Bearer " + this.accessToken);
  
    Device device = new Device();
    device.name = "<Phone UDID>";
    device.uid = "<Sami User ID>";
    device.dtid = "<Sami Phone Device Type ID>";
 
    DeviceEnvelope output = api.addDevice(device);
    System.out.println("Registered Device with ID: " + out.data._id);
}
~~~

## Post messages

Once the device is created and the device ID is known, the Android app can post messages. The message data needs to match the Manifest information. The message data needs to be marshaled using a `HashMap<String, Object>`.
 
**PostMessagesTest.java**

~~~
import io.samsungsami.api.MessagesApi;
import io.samsungsami.model.Message;
import io.samsungsami.model.MessageIDEnvelope;
import java.util.HashMap;
 
void addMessage() {
    String deviceId = "<SAMI Device ID>";
    String authorizationHeader = "Bearer " + self.accessToken;
     
    MessagesApi api = new MessagesApi();
    api.getInvoker().addDefaultHeader("Authorization", "Bearer " + this.accessToken);
     
    Message message = new Message();
    message.sdid = deviceId;
    message.data = new java.util.HashMap<String, Object>();
    message.data.put("numberOfSteps", 1000);
    message.data.put("floorsAscended", 20);
    message.data.put("floorsDescended", 1);
    message.data.put("distance", 0.5);
 
    MessageIDEnvelope output = api.postMessage(message);
    system.out.println("Message added with ID: " + output.data.mid);   
}
~~~

In the code block above, the data of the message represents the pedometer data using a `HashMap` by 'putting' 4 numerical fields:

- numberOfSteps
- floorsAscended
- floorsDescended
- distance

Other API calls can be similarly invoked.

## Logging out

The Java/Android app can log out the user (invalidate the access token) by accessing this endpoint.

~~~
https://accounts.samsungsami.io/logout?redirect_uri
~~~

## License and copyright

Licensed under the APACHE license. See [LICENSE.](https://github.com/samsungsamiio/sami-android/blob/master/LICENSE)

Copyright (c) 2014 Samsung Electronics Co., Ltd.
