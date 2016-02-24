---
title: "An IoT remote control"

---

# An IoT remote control

In [Your first IoT device](/sami/demos-tools/your-first-iot-device.html), we built a device that sends sensor data to SAMI. In this tutorial, we will build the following system:

- An IoT device that acts on received commands and sends back its latest state.
- An Android application that sends commands to the device and displays the latest state of the device.

For the sake of clarity, we will develop both the device and the application here. As an open ecosystem, SAMI is designed to allow developers to build an application for any published devices on SAMI. The IoT device type we build here could easily be published in the Developer Portal by its manufacturer, allowing different vendors to build this whole system <a href="https://blog.samsungsami.io/iot/events/2015/11/20/your-questions-about-sami-continued.html" target="_blank">without the pain of integration</a>.

By following this tutorial, you will learn how to develop with SAMI **Actions** (device commands). You will also learn how to use the [**Device Simulator**](/sami/demos-tools/device-simulator.html) to decouple the development of the device and application subsystems.

## Basics

Before proceeding, you should be familar with the following Action basics:

- <a href="https://blog.samsungsami.io/development/data/2015/04/21/send-actions-to-devices.html" target="_blank">Send Actions to remote devices</a>
- [Posting an Action](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions)
- [Sending an Action via WebSocket](/sami/connect-the-data/rest-and-websockets.html#sending-messages)
- [Receiving an Action via WebSocket](/sami/connect-the-data/rest-and-websockets.html#receiving-messages)

These articles describe how to define and send Actions programmatically. Note also that you can define Actions via the [Developer Portal](/sami/tools/developer-user-portals.html#creating-a-device-type) when creating a Simple Manifest.

## Design overview

The diagram below shows the high-level architecture:

![SAMI IoT remote control architecture](/images/docs/sami/demos-tools/first-control-system-architecture.jpg){:.lightbox}

This system works as follows:

 1. Click the "Turn on" or "Turn off" button in the Android app, which sends to SAMI an Action via WebSocket 1.
 2. SAMI routes the Action to a Raspberry Pi that is connected to WebSocket 2. Raspberry Pi then sets the pin of the LED to the proper value according to the Action. As a result, the light is switched on or off.
 3. Raspberry Pi sends the latest state of the LED light to SAMI via WebSocket 2.
 4. SAMI notifies the Android app of the light state via WebSocket 3. The app displays the latest state of the light.
 
The system uses three WebSockets with two different endpoints: [**/live**](/sami/connect-the-data/rest-and-websockets.html#read-only-websocket) and [**/websocket**](/sami/connect-the-data/rest-and-websockets.html#bi-directional-websocket). Please refer to the linked documentation to learn the differences between the endpoints. Here is our reasoning about the design:

- Using WebSockets instead of REST, the application can send Actions in near-real-time. In order to send Actions or data, the application must use the `/websocket` endpoint instead of `/live`.
- Using the `/websocket` endpoint for WebSocket 2, the Raspberry Pi can receive the Actions targeted to it and also send the LED state back to SAMI.
- Using `/live` for WebSocket 3 is appropriate for the monitoring functionality. In near-real-time, the app is notified of changes to the LED state stored in SAMI. 

We use the following hardware components:

- Raspberry Pi with an Internet connection
- An LED light and a 270Ω resistor 
- A breadboard plus wiring 
- Android phone

We will write the following software:

- A Node.js script running on the Raspberry Pi
- An Android application running on the Android phone

You can check out the code of the above software on <a href="https://github.com/samsungsamiio/sample-iot-SAMILightController" target="_blank">**GitHub**</a>.

## Create and connect a new device type

Go to the Developer Portal to create a *private* device type. 

 1. First, sign into the SAMI <a href="https://devportal.samsungsami.io" target="_blank">Developer Portal</a>. If you don't have a Samsung account, you can create one at this step.
 1. Click "+ New Device Type".
 1. Name this device type "Smart Light" and give it a unique name such as "com.example.iot.light".
 1. Click "Create Device Type". This creates the device type and takes you to a page listing your device types.
 
 Now let's create a Manifest for our "Smart Light" device type. 

 1. Click "Smart Light" in the left column.
 1. Click "Manifest" and then "+ New MANIFEST".
 1. In "Device Fields" tab, choose "STATE" in the dropdown menu as the Field Name and "Boolean" for Data Type.
 1. Click "Save" and then navigate to "Device Actions" tab.
 1. Click "NEW ACTION" and then choose "SET_ON" in the dropdown menu for ACTION.
 2. Click "NEW ACTION" and then choose "SET_OFF" in the dropdown menu for ACTION.
 2. Navigate to the "Activate Manifest" tab. You should see the fields and Actions created as follows:
 ![Smart Light Manifest](/images/docs/sami/demos-tools/first-control-system-manifest.png){:.lightbox}
 3. Click the "ACTIVATE MANIFEST" button.

A Simple Manifest is automatically approved.
{:.info}

Do *not* publish this device type, since it is for tutorial purposes only. You are able to see this private device type when you login to the SAMI User Portal using the Samsung account credentials that you used to login to the SAMI Developer Portal.
{:.warning}

Finally go to the User Portal to connect a new "Smart Light" device:

 1. Sign into the SAMI <a href="https://portal.samsungsami.io" target="_blank">User Portal</a> using the same account that you used to sign into the SAMI Developer Portal.
 1. On the dashboard, click to connect a new device. Choose the "Smart Light" device type you just created. 
 ![Connect SAMI device](/images/docs/sami/demos-tools/first-control-system-connect-device.png)
 1. Click "Connect Device...". You're taken back to the dashboard.
 1. Click the Settings icon of the device you just added. In the pop-up, click "GENERATE DEVICE TOKEN...".
 1. Copy the device ID and device token on this screen. You will use these in the code.
 ![Generate SAMI device token](/images/docs/sami/demos-tools/first-control-system-device-token.png)

Every SAMI API call requires an access token. The device token is one of [**three types of access tokens**](/sami/sami-documentation/authentication.html#three-types-of-access-tokens). For the sake of simplicity, we use the device token in this tutorial.
{:.info}

## Develop a smart LED light

### Set up the hardware

The smart light includes a Raspberry Pi, LED light, 270Ω resistor, and breadboard. Let's wire these hardware components together.
![smart LED hardware](/images/docs/sami/demos-tools/first-control-system-hardware.jpg)

We connect the positive side of the LED light to the programmable GPIO pin GPIO17. In Raspberry Pi 2 Model B V1.1, this GPIO pin's physical location is pin 11. Below is a close-up of the wiring.
![Fritzing layout](/images/docs/sami/demos-tools/first-control-system-wire-layout.jpg){:.lightbox}

### Set up the software

Connect your Raspberry Pi to a monitor, mouse, and keyboard. Ensure that an Ethernet or WiFi connection is working, and make sure the OS is up-to-date:

~~~bash
$ sudo apt-get update
$ sudo apt-get upgrade
~~~

If not already installed, install <a href="https://github.com/nathanjohnson320/node_arm" target="_blank">Node.js for ARM</a>, then add the packages `rpi-gpio` and `ws` via npm:

~~~bash
$ npm install ws
$ npm install rpi-gpio
~~~

Finally, download the Node.js program `smart_light.js` under the `raspberrypi` directory at [**GitHub**](https://github.com/samsungsamiio/sample-iot-SAMILightController) to the Raspberry Pi. Replace the following placeholders in the code with the device token and device ID you collected after connecting the device in the <a href="https://portal.samsungsami.io" target="_blank">User Portal</a> in the [previous step](#create-and-connect-a-new-device-type).

~~~javascript
var device_id = "<YOUR DEVICE ID>";
var device_token = "<YOUR DEVICE TOKEN>";
~~~

To run the program in the console of the Raspberry Pi, change to the directory where the program is located:

~~~bash
$ sudo node smart_light.js
~~~

You must run the program as root or with sudo. Otherwise, the Raspberry Pi cannot output to the GPIO, which turns the LED on or off.
{:.warning}

### Explain the code

Lets take a close look at the Node.js program `smart_light.js`. It establishes a [bi-directional WebSocket](https://developer.samsungsami.io/sami/api-spec.html#bi-directional-message-pipe) connection between the Raspberry Pi and SAMI. After the WebSocket connection is open, `register()`{:.param} method registers the device with the WebSocket. Beyond setting up the WebSocket, the code also sets the GPIO pin for writing so that the LED light can be turned on or off. When the WebSocket connection is close, the GPIO pin is teared down. Below is the correspoding code snippet: 

~~~javascript
/**
 * Create a /websocket connection and setup GPIO pin
 */
function start() {
    //Create the WebSocket connection
    isWebSocketReady = false;
    ws = new WebSocket(webSocketUrl);
    ws.on('open', function() {
        console.log("WebSocket connection is open ....");
        register();
    });
    ws.on('message', function(data) {
         handleRcvMsg(data);
    });
    ws.on('close', function() {
         console.log("WebSocket connection is closed ....");
         exitClosePins();
    });

    gpio.setup(myPin, gpio.DIR_OUT, function(err) {
        if (err) throw err;
        myLEDState = false; // default to false after setting up
        console.log('Setting pin ' + myPin + ' to out succeeded! \n');
     });
}

/**
 * Sends a register message to /websocket endpoint
 */
function register(){
    console.log("Registering device on the WebSocket connection");
    try{
        var registerMessage = '{"type":"register", "sdid":"'+device_id+'", "Authorization":"bearer '+device_token+'", "cid":"'+getTimeMillis()+'"}';
        console.log('Sending register message ' + registerMessage + '\n');
        ws.send(registerMessage, {mask: true});
        isWebSocketReady = true;
    }
    catch (e) {
        console.error('Failed to register messages. Error in registering message: ' + e.toString());
    }    
}
~~~

When SAMI receives an Action targeted to this device, `handleRcvMsg`{:.param} below is called. The method parses the content of the Action and toggles the LED.

~~~javascript
/**
 * Handle Actions
   Example of the received message with Action type:

   {
   "type":"action","cts":1451436813630,"ts":1451436813631,
   "mid":"37e1d61b61b74a3ba962726cb3ef62f1",
   "sdid”:”xxxx”,
   "ddid”:”xxxx”,
   "data":{"actions":[{"name":"setOn","parameters":{}}]},
   "ddtid":"dtf3cdb9880d2e418f915fb9252e267051","uid":"650xxxx”,”mv":1
   }
 */
function handleRcvMsg(msg){
    var msgObj = JSON.parse(msg);
    if (msgObj.type != "action") return; //Early return;

    var actions = msgObj.data.actions;
    var actionName = actions[0].name; //assume that there is only one action in actions
    console.log("The received action is " + actionName);
    var newState;
    if (actionName.toLowerCase() == "seton") {
        newState = 1;
    }
    else if (actionName.toLowerCase() == "setoff") {
        newState = 0;
    } else {
        console.log('Do nothing since receiving unknown action ' + actionName);
        return;
    }
    toggleLED(newState);
}
~~~

Once the program writes a value to the GPIO pin, it wraps the latest light state in a message, and then sends the message to SAMI. Here is the code snippet: 

~~~javascript
function toggleLED(value) {
    gpio.write(myPin, value, function(err) {
        if (err) throw err;
        myLEDState = value;
        console.log('toggleLED: wrote ' + value + ' to pin #' + myPin);
        sendStateToSami();
    });

}

/**
 * Send one message to SAMI
 */
function sendStateToSami(){
    try{
        ts = ', "ts": '+getTimeMillis();
        var data = {
              "state": myLEDState
            };
        var payload = '{"sdid":"'+device_id+'"'+ts+', "data": '+JSON.stringify(data)+', "cid":"'+getTimeMillis()+'"}';
        console.log('Sending payload ' + payload + '\n');
        ws.send(payload, {mask: true});
    } catch (e) {
        console.error('Error in sending a message: ' + e.toString() +'\n');
    }    
}

~~~

As a best practice, the device should send its latest state back to SAMI after it acts on the received Action. This ensures that SAMI is up-to-date on the device state, which other applications may be monitoring.
{:.info}

### Test using Device Simulator

Thanks to the [**Device Simulator**](/sami/demos-tools/device-simulator.html), we can test the light before developing the Android app.

Recall that, in the [architecture diagram](#design-overview), the app maintains two WebSockets. We use two simulators to emulate the two aspects of the app. The first simulator [sends Actions](https://developer.samsungsami.io/sami/demos-tools/device-simulator.html#simulate-sending-actions) to the light via WebSocket 1, while the second simulator listens to the latest state change of the light at SAMI via WebSocket 3.

Please follow the steps to [start the two simulators](/sami/demos-tools/device-simulator.html#usage). You will need an access token, and we suggest using the [API Console](/sami/tools/api-console.html) to get the access token. (Use the same Samsung account to login to the API Console.)

In the first simulator, type the command `ld` to list the devices, where you find the information of the smart light as follows:

  |did   |dtid   |name |manifestVersion   |manifestPolicy  |Token
  |----------- |------------- |--------------- |----------- |------------- |---------------
  |fde8715961 |dtxxxxx  |My Smart Light | 1 | LATEST |

In the second simulator, type the command `ll` and pass in the device ID (`did`) of the smart light ([obtained above](#create-and-connect-a-new-device-type)). The command sets up WebSocket 3 between SAMI and this Device Simulator, which monitors the messages sent by the smart light.

    $ ll fde8715961
    Using this token to connect: 311c56f18c18
    Opening live websocket on behalf of device fde8715961
    WS -> Connected to wss://api.samsungsami.io/v1.1/live?Authorization=bearer+311c56f18c18&?sdid=fde8715961

Now in the first simulator, send an Action to the smart light. Use the command `tell` and pass in the device ID (`did`) of the light and the Action. The following is the command and the output.

    $ tell fde8715961 setOn
    $ Sending : {"actions":[{"name":"setOn","parameters":{}}]}
    Got MID: e3b88ee1ad8c412fbb18f228886683f1

Observe that the LED is lighted up. In addition, the device sent back the latest state to SAMI per the following output in the second simulator:

    WS -> {"mid":"d5a23adbd36d4484af1a34d7ea568398","data":{"state":true},"ts":1432844166847,"sdtid":"xxxx","cts":1432844166846,"uid":"12345","mv":1,"sdid":"fde8715961"}

Try another Action to turn off the light. The LED should be off and the proper status change is observed in the second simulator. So far, we have verified that the light works as expected—correctly acting on the received Actions and also sending back the latest state to SAMI.

In addition, you can login to the User Portal to see all historical messages (including Actions) received and sent by the smart light, and view the live data using <a href="https://blog.samsungsami.io/portals/datavisualization/2015/01/09/opening-the-user-portal.html" target="_blank">Data Visualization</a>.

Here is the Actions data log:
![data logs actions](/images/docs/sami/demos-tools/first-control-system-userportal-actions.png){:.lightbox}
And the messages data log:
![data logs messages](/images/docs/sami/demos-tools/first-control-system-userportal-msgs.png){:.lightbox}

Congratulations! The smart LED works. Now we are ready to move into the next phase of the development.

## Develop an Android app

Before diving into the implementation, Lets take a look at what the UI looks like. This simple Android app has only one screen:
![data logs actions](/images/docs/sami/demos-tools/first-control-system-androidui.png){:.retain-width}

There are three regions in the screen:

  1. The device information and buttons for turning on/off the light.
  2. The status of WebSocket 1 and the received ACK message after sending an Action.
  3. The status of WebSocket 3 and the latest received messages on WebSocket 3.

Upon bringing the application to the foreground, the two WebSockets will establish connections and show their respective statuses in the second and third regions. When the "Turn On" or "Turn Off" buttons in the first region are clicked, the second region shows any ACK received from SAMI, and shortly thereafter the third region displays the new message sent by the light to SAMI after it acts on the Action.

### Set up the Android project

Here are the prerequisites:

 - <a href="http://developer.android.com/sdk/index.html" target="_blank">Android Studio</a>
 - <a href="https://github.com/samsungsamiio/sami-android" target="_blank">SAMI Java/Android SDK</a>

Follow the steps below to build the Android application:

- Get the Android project under the `sample-android-SAMIIoTSimpleController` directory at <a href="https://github.com/samsungsamiio/sample-iot-SAMILightController" target="_blank">**GitHub**</a>.
- Build SAMI's [Java/Android SDK libraries.](/sami/native-SDKs/android-SDK.html) The library JAR files are generated under the `target` and `target/lib` directories of the SDK Maven project.
- Copy all above library JAR files to the directory `/app/libs` in the Android project. Import the project in Android Studio IDE.
- Replace the following placeholders in `SAMISession.java` with the device token and device ID you collected after connecting the device in the <a href="https://portal.samsungsami.io" target="_blank">User Portal</a> in the [previous step](#create-and-connect-a-new-device-type):

~~~java
private final static String DEVICE_ID = "<YOUR DEVICE ID>";
private final static String DEVICE_TOKEN = "<YOUR DEVICE TOKEN>";
~~~

The sample application uses Android SDK with API level 21.
{:.info}

You should be able to build and run the Android application. We'll explain the code in the following sections.

### Send Actions

The Android application sends Actions to the light via WebSocket 1, per the [architecture diagram](#design-overview). WebSocket 1 uses the [`/websocket` endpoint](/sami/sami-documentation/sending-and-receiving-data.html#bi-directional-websocket). The code snippet below shows the creation of such a WebSocket and the corresponding event handling:

~~~java
private void createWSWebSockets() {
    try {
        mWS = new DeviceChannelWebSocket(true, new SamiWebSocketCallback() {
            @Override
            public void onOpen(short i, String s) {
                Log.d(TAG, "Registering " + DEVICE_ID);
                final Intent intent = new Intent(WEBSOCKET_WS_ONOPEN);
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);

                RegisterMessage registerMessage = new RegisterMessage();
                registerMessage.setAuthorization("bearer " + DEVICE_TOKEN);
                registerMessage.setCid("myRegisterMessage");
                registerMessage.setSdid(DEVICE_ID);

                try {
                    Log.d(TAG, "DeviceChannelWebSocket::onOpen: registering" + DEVICE_ID);
                    mWS.registerChannel(registerMessage);
                } catch (JsonProcessingException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onMessage(MessageOut messageOut) {
                Log.d(TAG, "DeviceChannelWebSocket::onMessage(" + messageOut.toString());
                final Intent intent = new Intent(WEBSOCKET_WS_ONMSG);
                intent.putExtra("ack", messageOut.toString());
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }

            @Override
            public void onAction(ActionOut actionOut) {

            }

            @Override
            public void onAck(Acknowledgement acknowledgement) {
                Log.d(TAG, "DeviceChannelWebSocket::onAck(" + acknowledgement.toString());
                Intent intent;
                if (acknowledgement.getMessage() != null && acknowledgement.getMessage().equals("OK")) {
                    intent = new Intent(WEBSOCKET_WS_ONREG);
                } else {
                    intent = new Intent(WEBSOCKET_WS_ONACK);
                    intent.putExtra("ack", acknowledgement.toString());
                }
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }

            @Override
            public void onClose(int code, String reason, boolean remote) {
                final Intent intent = new Intent(WEBSOCKET_WS_ONCLOSE);
                intent.putExtra("error", "mWebSocket is closed. code: " + code + "; reason: " + reason);
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);

            }

            @Override
            public void onError(Error error) {
                final Intent intent = new Intent(WEBSOCKET_WS_ONERROR);
                intent.putExtra("error", "mWebSocket error: " + error.getMessage());
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }
        });
    } catch (URISyntaxException e) {
        e.printStackTrace();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
~~~
After the WebSocket connection is open, `mWS.registerChannel()`{:.param} registers the application with the WebSocket. Upon receiving ACK messages, the message displays in the second region on the [Android screen](#develop-an-android-app).

Construct an [Action JSON object](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions) and then send it over the WebSocket:

~~~java
/*
 * Example of Action sent to SAMI over /websocket endpoint
 *  {
    cid:  setOff
    data:  {
             actions: [
                        {
                          name:  setOff
                          parameter: {}
                        }
                      ]
           }
    ddid:  fde8715961f84798a841be23480b8ce5
    sdid:  null
    ts:   1451606965889
    }
 *
 */
private void sendActionInDeviceChannelWS(String actionName) {
    ActionIn actionIn = new ActionIn();
    ActionDetails action = new ActionDetails();
    ArrayList<ActionDetails> actions = new ArrayList<>();
    ActionDetailsArray actionDetailsArray = new ActionDetailsArray();

    action.setName(actionName);
    actions.add(action);
    actionDetailsArray.setActions(actions);
    actionIn.setData(actionDetailsArray);
    actionIn.setCid(actionName);
    actionIn.setDdid(DEVICE_ID);
    actionIn.setTs(BigDecimal.valueOf(System.currentTimeMillis()));

    try {
        mWS.sendAction(actionIn);
        Log.d(TAG, "DeviceChannelWebSocket sendAction:" + actionIn.toString());
    } catch (JsonProcessingException e) {
        e.printStackTrace();
    }

}
~~~

### Monitor light state

The Android application listens to the state change of the light via WebSocket 3, per the [architecture diagram](#design-overview). WebSocket 3 uses the [`/live` endpoint](/sami/sami-documentation/sending-and-receiving-data.html#read-only-websocket) to monitor each message sent by the smart light. The code snippet below shows the creation of such a WebSocket and the corresponding event handling:

~~~java
private void createLiveWebsocket() {
    try {
        mLive = new FirehoseWebSocket(DEVICE_TOKEN, DEVICE_ID, null, null, new SamiWebSocketCallback() {
            @Override
            public void onOpen(short i, String s) {
                Log.d(TAG, "connectLiveWebsocket: onOpen()");
                final Intent intent = new Intent(WEBSOCKET_LIVE_ONOPEN);
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }

            @Override
            public void onMessage(MessageOut messageOut) {
                Log.d(TAG, "connectLiveWebsocket: onMessage(" + messageOut.toString() + ")");
                final Intent intent = new Intent(WEBSOCKET_LIVE_ONMSG);
                intent.putExtra(SDID, messageOut.getSdid());
                intent.putExtra(DEVICE_DATA, messageOut.getData().toString());
                intent.putExtra(TIMESTEP, messageOut.getTs().toString());
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }

            @Override
            public void onAction(ActionOut actionOut) {
            }

            @Override
            public void onAck(Acknowledgement acknowledgement) {
            }

            @Override
            public void onClose(int code, String reason, boolean remote) {
                final Intent intent = new Intent(WEBSOCKET_LIVE_ONCLOSE);
                intent.putExtra("error", "mLive is closed. code: " + code + "; reason: " + reason);
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }

            @Override
            public void onError(Error ex) {
                final Intent intent = new Intent(WEBSOCKET_LIVE_ONERROR);
                intent.putExtra("error", "mLive error: " + ex.getMessage());
                LocalBroadcastManager.getInstance(ourContext).sendBroadcast(intent);
            }
        });
    } catch (URISyntaxException e) {
        e.printStackTrace();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
~~~

In the WebSocket constructor `FirehoseWebSocket()`{:.param}, the device ID and token of the smart light are passed in as the arguments. Therefore, via this WebSocket, the application can receive all messages sent by the smart light (as the source device).

Method `onMessage()`{:.param} parses a received message, and displays it in the third region on the [Android screen](#develop-an-android-app).

### Test using Device Simulators

Just as we [tested the light using two Device Simulators](#test-using-device-simulators), we can test the Android app using the Device Simulator instead of a real device. Refer again to the steps to [start the simulator](/sami/demos-tools/device-simulator.html#usage), running command `ld` to get the device ID of the smart light.

First, test the app's Action sending functionality. In the simulator, run command `lw` to emulate receiving Actions on WebSocket 2. The second parameter is the device ID of the smart light. Click the "Turn On" button in the Android app, and then check if the simulator receives the Action. The command and the output of the simulator are given below. From the last line of the output, you can see that the simulator receives the correct Action.

    $ lw fde8715961
    Using this token to connect: 225c5480f70743c09504751cab789f10
    WS -> Connected to wss://api.samsungsami.io/v1.1/websocket?ack=true
    Register {"Authorization":"bearer xxxxx","sdid":"fde8715961","type":"register","cid":1452633676448}
    
    WS -> {"type":"action","cts":1452633519957,"ts":1452633518719,"mid":"88fc7fb4c4354293b2a3095dbb375188","sdid":"fde8715961","ddid":"fde8715961","data":{"actions":[{"name":"setOn","parameters":{}}]},"ddtid":"xxxx","uid":"xxxx","mv":1}

Type `slw` to stop receiving Actions. Next, test the app's light state monitoring functionality.

The simulator [emulates sending light states](/sami/demos-tools/device-simulator.html#simulate-sending-data-via-websocket) to SAMI. Run the `gs` command to [generate the simulation scenario](/sami/demos-tools/device-simulator.html#guess-scenario). The scenario file is good to use without modification for this case. 

Then, run the command `rs` to start the simulation. Now the simulator sends one message to SAMI every one second, and each message has a random state value ("true" or "false"). The commands and the output of the simulator are given below. The second parameter in the commands is the device ID of the smart light.

    $ gs fde8715961 sendingLightStateSim
    Scenario saved to /home/someuser/device-simulator/fde8715961/sendingLightStateSim.json
    $
    $ rs fde8715961 sendingLightStateSim
    Loading scenario from /home/someuser/device-simulator/fde8715961/sendingLightStateSim.json
    Using this token to send the messages: 06192752a09041f8b7c2878fa460fedc
    Send #0 {"state":true}
    Got MID: 8532a9ff8b814ed8b68d82f95e1d903a

Once the simulator sends a message, you should see this new message in the third region of the screen in your Android app. This verifies that the app's monitoring functionality works as expected. In the simulator, enter `s` to stop sending messages to SAMI.

We have used the Device Simulator to decouple device development and application development. Once you have developed both the smart light and the Android app, you can easily do end-to-end testing without using the Device Simulator.