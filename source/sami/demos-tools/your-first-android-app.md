---
title: "Your first Android app"

---

# Your first Android app

Let's build an Android application that communicates to SAMI using SAMI's [Java/Android SDK.](/sami/native-SDKs/android-SDK.html) This tutorial is meant to help you understand how to use the SDK to perform basic operations in SAMI. 

You should be familiar with the [**basic SAMI APIs**](/sami/sami-documentation/sending-and-receiving-data.html) and have read [**Your first Web app.**](/sami/demos-tools/your-first-application.html) 
{:.info}

## Prerequisites

- Eclipse
- Maven Integration for Eclipse
- Wordnik
- Jackson JSON Processor 2.1.4
- JUnit 4.8.1
- Apache HTTP Client 4.0

## Initial setup

### Set up at SAMI

Perform the following three steps outlined in the [initial setup][1] of "Your first Web app" if you have not done them before:

- [Create an application][2]
- [Connect a device][3]
- [Use the API Console][4]

The end goal of the above steps is to create an application with the redirect URL that works with this sample app, and get the client ID (application ID) and device ID to set up the Android project below.

### Set up your Android project

- Download the [sample application Android project.](/sami/downloads/sami-demo-first-android-app.zip)
- Build SAMI's [Java/Android SDK libraries.](/sami/native-SDKs/android-SDK.html) The library JAR files are generated under the `target` and `target/lib` directories of the SDK Maven project.
- Add the above library JAR files to the Android project. For example, to do it in [Eclipse](https://www.eclipse.org/): 
  - Create a directory `/libs` in the root of the Andriod application project. Copy all JAR files of the libraries into that directory.
- Change `CLIENT_ID`{:.param} to your client ID (application ID) at the following line in `MainActivity.java` of the sample application:

~~~html
private static final String CLIENT_ID = "xxxx";
~~~

- Change `DEVICE_ID`{:.param} to your device ID at the following line in `MessageActivity.java` of the sample application:

~~~php
public static final String DEVICE_ID = "xxxx";
~~~

- Build the Android project of the sample application.

The sample application uses Android SDK with API level 21.
{:.info}

## Demo

Before we dig in, let's preview how our simple Android application will work.

- Launch the app on the [Android Emulator.](http://developer.android.com/tools/help/emulator.html)
- Login using your account. <br />
![SAMI first Android app](/images/docs/sami/demos-tools/firstAndroidAppLoginScreen.png)
- You are redirected to a new page where you can play with SAMI as follows:
![SAMI first Android app](/images/docs/sami/demos-tools/firstAndroidAppPlayWithSAMIScreen_1.png)
- Click "Send a message" to send a message to SAMI on behalf of your device.
- Click "Get a message" to get the latest message from your device on SAMI. Note that it may take up to a few seconds for your message to appear since the called API is not intended for real-time data streaming. 
- After sending and receiving messages, your screen should look like this:
![SAMI first Android app](/images/docs/sami/demos-tools/firstAndroidAppPlayWithSAMIScreen_2.png)

## Implementation Details

We will use two Java files. 

- `MainActivity.java` handles login to SAMI to get the access token. 
- `MessageActivity.java` gets your name, sends a message on behalf of the device, and gets the device's latest message from SAMI.

### Login to obtain access token

`MainActivity.java` uses a `WebView` to present the login screen. After login succeeds, the activity catches the SAMI callback and then extracts the access token from the callback URL. 

Here is the code that forms the SAMI Authentication URL:

~~~java
public String getAuthorizationRequestUri() {
  //https://accounts.samsungsami.io/authorize?client=mobile&client_id=xxxx&response_type=token&client=mobile&client_id=xxxx&response_type=token&redirect_uri=REDIRECT_URL
  return SAMI_AUTH_BASE_URL + "/authorize?client=mobile&response_type=token&" +
                     "client_id=" + CLIENT_ID + "&redirect_uri=" + REDIRECT_URL;
  }
~~~

And here is the code that loads the URL into the `WebView`:

~~~java
String url = getAuthorizationRequestUri();
mWebView.loadUrl(url);
~~~

In order to catch the SAMI callback, provide a `WebViewClient` to the `WebView`and override `shouldOverrideUrlLoading()` method as follows:

~~~java
mWebView.setWebViewClient(new WebViewClient() {
  @Override
  public boolean shouldOverrideUrlLoading(WebView view, String uri) {
    if ( uri.startsWith(REDIRECT_URL) ) {
      // Redirect URL has format http://localhost:81/samidemo/index.php#expires_in=1209600&token_type=bearer&access_token=xxxx
      // Extract OAuth2 access_token in URL
      if( uri.indexOf("access_token=") != -1 ) {
        String[] sArray = uri.split("access_token=");
        String accessToken = sArray[1];
        startMessageActivity(accessToken);
        }
        return true;
    }
    // Load the web page from URL (login and grant access)
    return super.shouldOverrideUrlLoading(view, uri);
    }
});
~~~

After obtaining the access token, `MainActivity.java` starts `MessageActivity.java` and passes the token to it.

### Call SAMI APIs

`MessageActivity.java` uses the access token to communicate to SAMI to:

- Get the user's information.
- Send a message on behalf of the device.
- Get the latest message sent by the device.

It performs the above operations by calling API methods of SAMI's SDK library in background threads.

To faciliate using API methods of the SDK later, `MessageActivity.java` first performs the following setup:

~~~java
private void setupSamihubApi() {
   mUsersApi = new UsersApi();
   mUsersApi.setBasePath(SAMIHUB_BASE_PATH);
   mUsersApi.addHeader("Authorization", "bearer " + mAccessToken);
        
   mMessagesApi = new MessagesApi();       
   mMessagesApi.setBasePath(SAMIHUB_BASE_PATH);
   mMessagesApi.addHeader("Authorization", "bearer " + mAccessToken);
}
~~~

Note that the access token is added to the authorization header above. This ensures that every request sent to SAMI contains the correct authorization header. 
{:.info}

#### Get the user's name from SAMI

At the conceptual level, getting the user's information from SAMI is as simple as the following code:

~~~java
mUsersApi.self();
~~~

However, the method call has to be in a background thread, so it becomes a little bit complicated. Create an `AsyncTask`{:.param} subclass in `MessageActivity.java` as follows:

~~~java
class CallUsersApiInBackground extends AsyncTask<UsersApi, Void, UserEnvelope> {
  @Override
  protected UserEnvelope doInBackground(UsersApi... apis) {
  UserEnvelope retVal = null;
  try {
    retVal= apis[0].self();
  } catch (Exception e) {
    e.printStackTrace();
  }
  return retVal;
}
        
  @Override
  protected void onPostExecute(UserEnvelope result) {
    mWelcome.setText("Welcome " + result.getData().getFullName());
  }
}
~~~

Now `MessageActivity.java` makes a one line call to get the user's name and show it on the screen:

~~~java
new CallUsersApiInBackground().execute(mUsersApi);
~~~

#### Send a message to SAMI

Likewise, sending a message to SAMI on behalf of the demo device is as simple as:

~~~java
mMessagesApi.postMessage(msg);
~~~

Again, it has to be called in a background thread. `MessageActivity.java` uses an `AsyncTask` to perform that call. 

First, set up a button in `MessageActivity.java` to initiate sending upon clicking.

~~~java
sendMsgBtn.setOnClickListener(new View.OnClickListener() {
  public void onClick(View v) {
    try {
      mSendResponse.setText("Response:");
      new PostMsgInBackground().execute(mMessagesApi);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
});
~~~

Now create an `AsyncTask`{:.param} subclass in `MessageActivity.java` as follows:

~~~java
class PostMsgInBackground extends AsyncTask<MessagesApi, Void, MessageIDEnvelope> {
  @Override
  protected MessageIDEnvelope doInBackground(MessagesApi... apis) {
    MessageIDEnvelope retVal = null;
    try {
      HashMap<String, Object> data = new HashMap<String, Object>();
      data.put("stepCount", 4393);
      data.put("heartRate", 110);
      data.put("description", "Run");
      data.put("activity", 2);

      Message msg = new Message();
      msg.setSdid(DEVICE_ID);
      msg.setData(data);
      
      // Now send the message
      retVal= apis[0].postMessage(msg);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return retVal;
  }

  @Override
  protected void onPostExecute(MessageIDEnvelope result) {
    if (result == null) {
      // log issue
      return;
    }
    mSendResponse.setText("Response: " + result.getData().toString());
  }
}
~~~

To make a `POST` /message call, you need to set the source device ID and data fields in the `Message` object. The SDK library constructs the payload of a `POST` request based on the object. 

The data format depends entirely on the device type you're using to send data to SAMI. The provided data is for the device with type "SAMI Gear Fit".
{:.info}

As a result of sending a message, you'll get a message ID (or [errors](/sami/api-spec.html#validation-and-errors)) that you could use to query that message later. 

#### Get a message from SAMI

Now get the latest message on SAMI that was sent by the demo device. The sample app sends a `GET` request to SAMI. 

`MessageActivity.java` sets up a button to initiate getting a message from SAMI upon clicking.

~~~java
getLatestMsgBtn.setOnClickListener(new View.OnClickListener() {
  public void onClick(View v) {
    try {
      // Reset UI
      mGetLatestResponseId.setText("id:");
      mGetLatestResponseData.setText("data:");
      
      // Now get the message
      new GetLatestMsgInBackground().execute(mMessagesApi);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
});
~~~

Again, `MessageActivity.java` uses an `AsyncTask` to call `MessagesApi.getLastNormalizedMessages()`{:.param}, which sends a `GET` request to SAMI. Create an `AsyncTask`{:.param} subclass in `MessageActivity.java` as follows:

~~~java
class GetLatestMsgInBackground extends AsyncTask<MessagesApi, Void, NormalizedMessagesEnvelope> {
  @Override
  protected NormalizedMessagesEnvelope doInBackground(MessagesApi... apis) {
    NormalizedMessagesEnvelope retVal = null;
    try {
      int messageCount = 1;
      retVal= apis[0].getLastNormalizedMessages(messageCount, DEVICE_ID, null);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return retVal;
  }
    
  @Override
  protected void onPostExecute(NormalizedMessagesEnvelope result) {
    if (result == null || result.getData() == null || result.getData().size() == 0) {
      mGetLatestResponseId.setText("id:" + " null");
      mGetLatestResponseData.setText("data:" + " null");
      return;
    }
    mGetLatestResponseId.setText("id:" + result.getData().get(0).getMid());
    mGetLatestResponseData.setText("data:" + result.getData().get(0).getData().toString());
  }
}
~~~

As shown above, to make the call to get the latest messages, pass the message count and the source device ID. The source device ID is the device ID of the demo device. If the call succeeds, the information of the latest message from SAMI will be shown on the screen.

[1]: /sami/demos-tools/your-first-application.html#initial-setup "Initial setup to use sample apps"
[2]: /sami/demos-tools/your-first-application.html#create-an-application "Create an application"
[3]: /sami/demos-tools/your-first-application.html#connect-a-device "Connect a device"
[4]: /sami/demos-tools/your-first-application.html#use-the-api-console "Use the API Console"
