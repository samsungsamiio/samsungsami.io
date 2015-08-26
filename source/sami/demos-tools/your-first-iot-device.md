---
title: "Your first IoT device"

---

# Your first IoT device

Let's build an IoT device that sends flame sensor data to SAMI using SAMI's [WebSockets](/sami/api-spec.html#websockets). The IoT device consists of an off-the-shelf sensor, Arduino UNO and Raspberry Pi. 

In this implementation, a [Simple Manifest](https://blog.samsungsami.io/portals/development/data/2015/03/26/the-simple-manifest-device-types-in-1-minute.html) is used to create a new device type quickly. Then you can easily connect the IoT device to SAMI, and start to send sensor data from the device to SAMI. 

For this tutorial you should be familiar with the [**basic SAMI APIs**](/sami/sami-documentation/sending-and-receiving-data.html) and have read [**Your first Web app.**](/sami/demos-tools/your-first-application.html) 
{:.info}

## Architecture
The diagram below shows the high-level architecture:

![Architecture](/images/docs/sami/demos-tools/first-iot-architecture.jpg)

We use the following hardware components:

- Raspberry Pi with a network connection
- Arduino UNO with a breadboard
- <a href="http://www.dx.com/p/arduino-flame-sensor-for-temperature-detection-blue-dc-3-3-5v-118075?tc=USD&gclid=CPX6sYCRrMACFZJr7AodewsA-Q#.VcAOUzBVhHy" target="_blank">IR flame sensor</a>
- USB and power cables, plus wiring for the breadboard

We will write the following software:

- A <a href="https://www.arduino.cc/en/Guide/Environment#toc2" target="_blank">Sketch</a> program running on the Arduino
- A Node.js script running on the Raspberry Pi

If you do not have a Raspberry Pi, you may still work through this tutorial. Connect your Arduino UNO to your computer that has an Internet connection and run the Node.js script on the computer instead of the Raspberry Pi.  
{:.info}

## Step 1: Create and connect a new device type

Go to the Developer Portal to create a *private* device type. 

 1. First, sign into the SAMI [Developer Portal](https://portal.samsungsami.io). If you don't have a Samsung account, you can create one at this step.
 1. Click "+ New Device Type".
 1. Name this device type "Flame Sensor" and give it the unique name such as "com.example.iot.flame".
 1. Click "Create Device Type". This creates the device type and takes you to the device types page.
 
 Now let's create a Manifest for our "Flame Sensor" device type. 

 1. Click "Flame Sensor" in the left column.
 1. Click "Manifest" and then "+ New Version".
 1. Enter "onFire" as the Field Name and "Boolean" for Data Type.
 ![Flame Sensor](/images/docs/sami/demos-tools/first-iot-manifest.png)
 1. Click "Save" and then "Next: Actions".
 1. Bypass [Actions](/sami/demos-tools/manifest-advanced-example.html#manifest-that-supports-actions) for this tutorial and click "Save New Manifest".

A Simple Manifest is automatically approved.
{:.info}

Do *not* publish this device type, since it is for tutorial purposes only.
{:.warning}

Finally go to the User Portal to connect a new Flame Sensor device:

 1. Sign into the SAMI [User Portal](https://portal.samsungsami.io).
 1. On the dashboard, click to connect a new device. Choose the "Flame Sensor" device type you just created.
 ![Connect SAMI device](/images/docs/sami/demos-tools/first-iot-connect-device.png)
 1. Click "Connect Device...". You're taken back to the dashboard.
 1. Click the Settings icon of the device you just added. In the pop-up, click "GENERATE DEVICE TOKEN...".
 1. Copy the device ID and device token on this screen. You will use these in the code.
 ![Generate SAMI device token](/images/docs/sami/demos-tools/first-iot-device-token.png)

## Step 2: Set up the Arduino

Now let's wire the sensors to the Arduino.

![Arduino and sensors](/images/docs/sami/demos-tools/first-iot-arduino-breadboard.jpg)

The two sensors are wired as follows:

![Fritzing](/images/docs/sami/demos-tools/first-iot-sensors-connect-arduino.jpg)

Next, upload the Sketch program (`read_flame_sensor.ino`) to the Arduino UNO using the [Arduino IDE](https://www.arduino.cc/en/Main/Software). This code reads one digital value from the IR flame sensor, and then sends it to the serial port every 5 seconds (you can change this parameter in the code later, since SAMI has [rate limits](https://developer.samsungsami.io/sami/sami-documentation/rate-limiting.html#websocket-limits) for the number of messages per day).  For the digital readings, "0" means that a fire is detected and "1" means no fire. 

Here is `read_flame_sensor.ino`. The code is straightforward.

~~~c
// Delay between reads
const int delayBetweenReads = 5000;//5s

// For flame detector senso
const int flameDigitalPinIn = 2; 

void setup() {
  // initialize serial communication @ 9600 baud:
  Serial.begin(9600);
  pinMode(flameDigitalPinIn, INPUT);
}

void loop() {
  // HIGH(1) means no fire is detected
  // LOW (0) means fire is detected
  int flameDigitalReading = digitalRead(flameDigitalPinIn);
  
  Serial.println(String(flameDigitalReading));

  delay(delayBetweenReads);
}
~~~

## Step 3: Set up the Raspberry Pi

Connect your Raspberry Pi to a monitor, mouse and keyboard. Ensure that an Ethernet or WiFi connection is working, and make sure the OS is up-to-date:

~~~bash
$ sudo apt-get update
$ sudo apt-get upgrade
~~~

If not already installed, install <a href="https://github.com/nathanjohnson320/node_arm" target="_blank">Node.js for ARM</a>, then add the packages `serialport` and `ws` via npm:

~~~bash
$ npm install serialport
$ npm install ws
~~~

Now connect the serial port from the Arduino to the USB on the Raspberry Pi.

![Arduino and Raspberry Pi](/images/docs/sami/demos-tools/first-iot-raspberrypi-arduino-breadboard.jpg)

Finally, download the [Node.js code](/sami/downloads/send_data_to_sami.js) (`send_data_to_sami.js`) to the Raspberry Pi. Replace the placeholders in the code with the device token and device ID you collected from the [User Portal](https://portal.samsungsami.io).

The Node.js code is also given below. It establishes a [bi-directional WebSocket](https://developer.samsungsami.io/sami/api-spec.html#bi-directional-message-pipe) connection between the Raspberry Pi and SAMI. After the WebSocket connection is open, `register()` method registers the device with the WebSocket. Each time, the code reads one data point from the serial port, and then wraps it in a message and sends the message to SAMI via WebSocket. 

~~~javascript
var webSocketUrl = "wss://api.samsungsami.io/v1.1/websocket?ack=true";
var device_id = "<YOUR DEVICE ID>";
var device_token = "<YOUR DEVICE TOKEN>";

var isWebSocketReady = false;
var ws = null;

var serialport = require("serialport")
var SerialPort = serialport.SerialPort;
var sp = new SerialPort("/dev/ttyACM0", {
    baudrate: 9600,
    parser: serialport.parsers.readline("\n")
});

var WebSocket = require('ws');

/**
 * Gets the current time in millis
 */
function getTimeMillis(){
    return parseInt(Date.now().toString());
}

/**
 * Create a /websocket bi-directional connection 
 */
function start() {
    //Create the websocket connection
    isWebSocketReady = false;
    ws = new WebSocket(webSocketUrl);
    ws.on('open', function() {
        console.log("Websocket connection is open ....");
        register();
    });
    ws.on('message', function(data, flags) {
        console.log("Received message: " + data + '\n');
    });
    ws.on('close', function() {
        console.log("Websocket connection is closed ....");
    });
}

/**
 * Sends a register message to the websocket and starts the message flooder
 */
function register(){
    console.log("Registering device on the websocket connection");
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

/**
 * Send one message to SAMI
 */
function sendData(onFire){
    try{
        ts = ', "ts": '+getTimeMillis();
        var data = {
            "onFire": onFire
        };
        var payload = '{"sdid":"'+device_id+'"'+ts+', "data": '+JSON.stringify(data)+', "cid":"'+getTimeMillis()+'"}';
        console.log('Sending payload ' + payload);
        ws.send(payload, {mask: true});
    } catch (e) {
        console.error('Error in sending a message: ' + e.toString());
    }   
}

/**
 * All start here
 */
start(); // create websocket connection

sp.on("open", function () {
    sp.on('data', function(data) {
            if (!isWebSocketReady){
                console.log("Websocket is not ready. Skip sending data to SAMI (data:" + data +")");
                return;
            }
            console.log("Serial port received data:" + data);
            var flameDigitalValue = parseInt(data);

            // flameDigitalValue = 1 ==> no fire is detected
            // flameDigitalValue = 0 ==> fire is detected
            var onFire = false;
            if (flameDigitalValue == 0) {
               onFire = true;
            }
            sendData(onFire);
    });
});
~~~

## Step 4: Fire it up and view the data!

Let's start the Node.js program on the Raspberry Pi from the terminal:  

~~~bash
$ node send_data_to_sami.js
~~~

In the terminal, you should see the payload of the message sent to SAMI and the corresponding response from SAMI as follows:

~~~bash
Serial port received data:84,1003,1
Sending payload {"sdid":"45176de99e424d98b1a3c42558bfccf4", "ts": 1438722871167, "data": {"onFire":false}, "cid":"1438722871167"}
Received message: {"data":{"mid":"77b89ba8d8fb41a296403044698de3ac","cid":"1438722871167"}}
~~~

Log into the SAMI [User Portal](https://portal.samsungsami.io) once again.

View your device data as it's generated by clicking the device name in the device box. This takes you to Data Visualization. From there, click the "+/- CHARTS" button and check "onFire" to visualize a chart for each field. ([Read this post](https://blog.samsungsami.io/portals/datavisualization/2015/01/09/opening-the-user-portal.html) for more information on Data Visualization.) If you light up a lighter, you will see that "onFire" turns to red like the following:

![data visualization](/images/docs/sami/demos-tools/first-iot-userportal-chart.png){:.lightbox}