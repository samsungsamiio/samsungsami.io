---
title: "Device Simulator"
---

# Device Simulator

The SAMI Device Simulator is a command-line tool developed in Java. It is meant to help you send messages to SAMI on behalf of any device in the system. 

The Device Simulator's primary goal is to make it easy to connect to SAMI and send pre-recorded data to simulate an actual device. It also can send [Actions](/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions) to a simulated device. The Device Simulator makes it very easy to execute commands easily, such as listing devices for a user, looking at device types, etc.

![device simulator start screen](/images/docs/sami/libraries-examples/DeviceSimulatorStart.png){:.lightbox}




To use the commands in this article, [**download the Device Simulator.**](https://github.com/samsungsamiio/samsungsami.io/blob/master/source/sami/downloads/device-simulator20150529.zip?raw=true) <br /><br />Java JDK v8 update 25 or higher is required.
{:.info}



## Usage

~~~
java -jar device-simulator.jar -token=<access_token>
~~~

  |Parameter   |Description   
  |----------- |------------- 
  |`token`{:.param}   |The access token provided by SAMI after authentication. 

 The easiest way to capture an access token is by using our [API Console](https://api-console.samsungsami.io/sami) or creating a sample app or script (for example, with our [PHP SDK](/sami/native-SDKs/php-SDK.html)), authenticating with your Samsung Account credentials and capturing the token returned by SAMI.
 
 **Never** share your access token. This is unique to you, and if you share it, malicious users will be able to read and write data on your behalf! (And it will be your fault!)

The SAMI Device Simulator works in two main modes: 

- An interactive mode, where you can execute commands (such as listing devices) and see the results.
- An automated mode, in which pre-recorded scenarios are defined through a simple JSON configuration file and (when appropriate) pre-recorded data sets. Developers can enter real data or can use the Simulator to generate random data.

Type the "?" command to get a full list of the available commands supported in the Device Simulator. Some comands are used in an interactive mode while others are used in an anutmated mode.

![device simulator help screen](/images/docs/sami/demos-tools/device-simulator-help.png){:.lightbox}

## Interactive mode

In interactive mode, developers can execute individual commands in the simulator, for example, get a device ID, a device Type and a Manifest. The following are examples:

    list devices  
    # (or you can use "ld" as shortcut)

    get device <did>  
    # (or you can use "gd" as shortcut)

## Scenarios

A scenario is used when the Device Simulator works in an automated mode. This is how a very basic scenario looks:

~~~json
{
    "sdid": "89ac176847934e4384730d903ba28f2f",
    "deviceToken": "",
    "data": {
        "someNumber":"",
        "someText":"",
        "heartRate":"",
        "randomWord":"",
        "content":"constant stuff"
    },
    "config": {
        "someNumber":{"function":"cycle", "type":"Integer", "value":[1,2,3,4,5,6,7,8,9,10]},
        "someText":{"function":"cycle", "type":"String", "value":["text","css","json"]},
        "heartRate":{"function":"random", "type":"Integer", "min":0,"max":200},
        "randomWord":{"function":"random", "type":"String"}
    },
    "api": "POST",
    "period": 1000
}
~~~

  |Field name   |Description   |Accepted values
  |----------- |------------- |---------------
  |`sdid`{:.param}   |The device ID. use `ld` to get a list of your user's devices   |device ID 
  |`deviceToken`{:.param}   |The access token for the selected device ID. |If you want to force a specific token type it here or leave empty and the Simulator will get one
  |`data`{:.param}   |A complex object that defines the default values for each of the data fields that will be sent to SAMI   |A set of key/value pairs for each data point you want to send
  |`config`{:.param}   |A complex object describing how the Simulator should generated the data. See below for more information   |A set of JSON objects
  |`api`{:.param}   | HTTP POST or WebSocket APIs for sending data. | "POST" or "WS"
  |`period`{:.param}   |An Integer describing the amount of ms between requests   |0 to 32000

  
### Create an empty scenario

The easiest way to create a scenario is to start with an empty one. The Simulator helps doing this with a simple command. See below how to create a new scenario called `mytest` associated with the device ID `89ac176847934e4384730d903ba28f2f`.

	create scenario 89ac176847934e4384730d903ba28f2f mytest  
	# (or the shortcut: cs 89ac176847934e4384730d903ba28f2f mytest)

When executed, the command above creates a new JSON file on the computer and outputs the location. The file will look like this:

~~~json
{
    "sdid": "89ac176847934e4384730d903ba28f2f",
    "deviceToken": "",
    "data": {},
    "config": {},
    "api": "POST",
    "period": 1000
}
~~~

### The data object

The `data`{:.param} object is pretty simple in concept. Here you define the fields that the Simulator should set when sending data to SAMI, and you define the default value.

In the example below, we define five fields. Two are Integers for which we set a default value of `0`, two are Strings with an empty default value, and the last one is a String with a default text value.

~~~json
{
    "sdid": "89ac176847934e4384730d903ba28f2f",
    "deviceToken": "",
    "data": {
        "someNumber":0,
        "someText":"",
        "heartRate":0,
        "stepCount":0
        "randomWord":"",
        "content":"constant stuff"
    }
}
~~~

### The config object

The `config`{:.param} object is a little more complex. This is where you define how you want the Simulator to generate the data to be sent to SAMI. The whole point of the Simulator is to generate and send data to SAMI at a defined pace, so you will usually want to configure it so that it sends data for a given amount of time and according to certain patterns that make sense to you.

The following example is a continuation of the sample fields we defined in the previous paragraph.

~~~json
.... "config": {
      "someNumber":{"function":"cycle", "type":"Integer", "value":[1,2,3,4,5,6,7,8,9,10]},
      "someText":{"function":"cycle", "type":"String", "value":["text","css","json"]},
      "heartRate":{"function":"random", "type":"Integer", "min":0,"max":200},
      "stepCount":{"function":"increment", "type":"Integer", "min":1000, "max":10000, "increment":2, "period":5000},
      "randomWord":{"function":"random", "type":"String"}
  } ....
~~~

Each object can have up to six properties:

  |Field name   |Description   |Accepted values
  |----------- |------------- |---------------
  |`function`{:.param}   |Define how to generate data based on the other parameters |`random` (default), `constant`, `cycle`, `increment`
  |`type`{:.param}   |Describes the data type, the same that you defined in the Manifest |Refer to the Types you configured in the Manifest
  |`min`{:.param}   |If defined will set the minimum value for the generated data. If set **requires** that you also set the `max`{:.param} value. The default value is 0. |Any Integer
  |`max`{:.param}   |If defined will set the minimum value for the generated data. If set **requires** that you also set the `min`{:.param} value. The default value is 10000. |Any Integer higher than the `min`{:.param} value
  |`value`{:.param}   |Define one or more possible values, the actual values and use depend on the data type of the field and the `function`{:.param} you chose   |A set of values, can be numbers, strings, etc.
  |`increment`{:.param}   |Used when `function`{:.param} is `increment`.  The value increase by this amount each time. The default value is 1 if not provided. |Any Integer
  |`period`{:.param}   |Used when `function`{:.param} is `increment`. An Integer describing the minum amount of ms passed between consecutive increments. The default value is `period`{:.param} for the main simulation. |A positive Integer


As described, the Simulator currently supports four types of functions. These will actually generate the values to be sent to SAMI depending on the parameters you defined. The supported functions are:

 * **random (default)**: Creates random numbers or words. For numbers makes use of additional fields `min`{:.param} and `max`{:.param}.
 * **constant**: Makes use of a field `value`{:.param} to specify the constant value.
 * **cycle**: Loops through the values defined in the `value`{:.param} field.
 * **increment**: Increase the value by the amount defined by `increment`{:.param} per time defined by `period`{:.param}.

 The Device Simulator assumes that you know what you are doing. There are VERY limited controls on how what you enter in the `config`{:.param} object, so be careful and refer to the Manifest when in doubt.
 {:.warning}

### Running a scenario

You can execute a scenario at any point. To run a scenario, you can use the `run` command with the device ID and scenario name that you defined when creating it.

	run scenario 89ac176847934e4384730d903ba28f2f mytest  
	# (or the shortcut: rs 89ac176847934e4384730d903ba28f2f mytest)

 You can stop a scenario at any point pressing "s" or "stop" followed by the "Enter" key.
 {: .info}

### Guess scenario

Sometimes it's good to get a helping hand. The Device Simulator can help you scaffold your `config`{:.param} object. If the device you want to simulate sends data as JSON and only uses simple objects, you can use the Simulator to create a basic scenario.

Assuming you have a device called `demo_heartrate_monitor` and you want to create a scenario called "myBestGuess", you can execute the following command in the Device Simulator's interactive mode:

	gs demo_heartrate_monitor myBestGuess

This will generate a scenario like the following:

~~~json
{
    "sdid": "demo_heartrate_monitor",
    "deviceToken": "",
    "data": {
        "stepCount": 0,
        "heartRate": 0,
        "ecg": 0,
        "stress": 0,
        "calories": 0,
        "skinTemp": 0,
        "energyExpRate": 0,
        "dateMicro": 0,
        "respRateInt": 0,
        "respRate": 0,
        "posture": 0
    },
    "config": {
        "stepCount": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "heartRate": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "ecg": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "stress": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "calories": {
            "min": 0,
            "max": 10000,
            "type": "Double",
            "function": "random"
        },
        "skinTemp": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "energyExpRate": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "dateMicro": {
            "min": 0,
            "max": 10000,
            "type": "Long",
            "function": "random"
        },
        "respRateInt": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "respRate": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        },
        "posture": {
            "min": 0,
            "max": 10000,
            "type": "Integer",
            "function": "random"
        }
    },
    "period": 1000
}
~~~

Now all you have to do is open it in your favorite editor (ViM if you are old; Sublime Text if you are young and hip) and tweak the fields based on your needs. This should save you some time!

## Simulate sending data via WebSocket

You can use the Device Simulator to send data to SAMI via a [bi-directional WebSocket](https://developer.samsungsami.io/sami/sami-documentation/sending-and-receiving-data.html#setting-up-a-bi-directional-message-pipe) on behalf of a device. You just need to set `api`{:.param} to "WS" in the scenario JSON file of the simulated device as following:

~~~json
    "api": "WS",
~~~

Execute [run the scenario](#running-a-scenario) command in the Device Simulator. You should be able to see that the simulator connects to SAMI WebSocket and then sends the data to SAMI on behalf of the device, which ID is specified in the command. The following shows the example of the command and its output in the Device Simulator terminal:

    $ rs 6a5bb957531f4704a5e3509a727573a5 myGearFitSim
    Loading scenario from /Users/yujing.w/work/SAMItechToDeveloper/device-simulator/device-simulator20150528/6a5bb957531f4704a5e3509a727573a5/myGearFitSim.json
    Reading file: /Users/yujing.w/work/SAMItechToDeveloper/device-simulator/device-simulator20150528/6a5bb957531f4704a5e3509a727573a5/myGearFitSim.json
    $ Using this token to send the messages: c0bd117ae13243f092e45c93b59e33ff
    WS -> Connected to wss://api.samsungsami.io/v1.1/websocket?ack=true
    Register {"Authorization":"bearer c0bd117ae13243f092e45c93b59e33ff","sdid":"6a5bb957531f4704a5e3509a727573a5","type":"register","cid":1432861982567}
    Send #0 (+1ms. Elapsed: 1ms) {"stepCount":1000,"description":"bzytpnvxk","heartRate":70,"state":0,"activity":0}
    WS -> {"data":{"message":"OK","code":"200","cid":"1432861982567"}}
    WS -> {"data":{"mid":"06478a87a63f4c58b5a64eeaabe91c31","cid":"1432861982571"}}
    Send #1 (+1000ms. Elapsed: 1001ms) {"description":"ensshpy","heartRate":56,"state":0,"activity":2}
    WS -> {"data":{"mid":"068ed1e6726847599914bc074f36fa8c","cid":"1432861983572"}}
    Send #2 (+1000ms. Elapsed: 2001ms) {"description":"ddza","heartRate":24,"state":0,"activity":1}

Using another Device Simulator instance, you can listen to data messages that are sent to SAMI by the simulated device. You can use the same or different access token to start the 2nd Simulator instance. The following gives the example of the command and its output in the 2nd Device Simulator terminal:

    $ ll 6a5bb957531f4704a5e3509a727573a5
    Using this token to connect: 3118b86da4c343b28da89a1c56f18c18
    Opening live websocket on behalf of device 6a5bb957531f4704a5e3509a727573a5
    WS -> Connected to wss://api.samsungsami.io/v1.1/live?Authorization=bearer+3118b86da4c343b28da89a1c56f18c18&?sdid=6a5bb957531f4704a5e3509a727573a5
    WS -> {"mid":"d5a23adbd36d4484af1a34d7ea568398","data":{"state":0,"description":"fuzczpswec","stepCount":1000,"heartRate":10,"activity":0},"ts":1432844166847,"sdtid":"sami_gear_fit","cts":1432844166846,"uid":"650a7c8b6ca44730b077ce849af64e90","mv":1,"sdid":"6a5bb957531f4704a5e3509a727573a5"}

The command `ll` can be used to listen to messages that are sent using POST or WebSocket by the simulated device. To stop listening on the second Device Simulator, type `sll`.

## Simulate sending Actions

You can use the Device Simulator to simulate sending Actions to a target device. Lets use an example to explain. Assume that you have a  "SAMI Example Smart Light" device. Again we use two Device Simulators. The first one is used to send Actions to the smart light while the second one is used to listen on behalf of the smart light. In the first simulator, type command `ld` to list the devices, where you find the information of the smart light like the following:

  |did   |dtid   |name |manifestVersion   |manifestPolicy  |Token
  |----------- |------------- |--------------- |----------- |------------- |---------------
  |713f4298132943df957e87c1d0e43d7a |dt71c282d4fad94a69b22fa6d1e449fbbb  |My Smart Light | 1 | LATEST |

Use the device type ID (`dtid`) listed above to query what Actions the smart light supports. The following is the example of the command and the corresponding output:

    $ ga dt71c282d4fad94a69b22fa6d1e449fbbb
    setIntensity(Integer intensity)
    setOff()
    setColorAsRGB(Object colorRGB{Integer g, Integer b, Integer r}, Integer intensity)
    setOn

Now send an Action to the smart light. Use the command "tell", and pass in the device ID(`did`), the Action, and Action's parameters (if applicable). The following is the example of the command and the output

    $ tell 713f4298132943df957e87c1d0e43d7a setIntensity {"intensity":10}
    $ Sending : {"actions":[{"name":"setIntensity","parameters":{"intensity":10}}]}
    Got MID: 2713b144323c48ee8f7dd95044f31699

The Action has been sent to the target device and you get the message ID. Now start the second Device Simulator, where you can listen on behalf of the smart light. Run the command `lw` and pass in the device ID of the smart light. The command sets up a [bi-directional WebSocket connection](https://developer.samsungsami.io/sami/sami-documentation/sending-and-receiving-data.html#setting-up-a-bi-directional-message-pipe) between SAMI and the simulated smart light using the Device Simulator. The output indicates that the simulator connects and registers the smart light in the websocket pipe, and starts getting pings.

    $ lw 713f4298132943df957e87c1d0e43d7a
    Using this token to connect: ea2208ea61d045d5844de5dd246f8e22
    WS -> Connected to wss://api.samsungsami.io/v1.1/websocket?ack=true
    Register {"Authorization":"bearer ea2208ea61d045d5844de5dd246f8e22","sdid":"713f4298132943df957e87c1d0e43d7a","type":"register","cid":1432935445622}
    $ WS -> {"data":{"message":"OK","code":"200","cid":"1432935445622"}}

To listen to Actions or data messages received by the target device, you must use `lw` command not `ll` command. Command `ll` is used to listen to data message sent by the simulated source device.
{:.info}

Send an Action to the smart light in the first Device Simulator. You should be able to see that the Action is received in the second simulator like the following output:

    WS -> {"cts":1432936314494,"type":"action","ts":1432936314494,"mid":"82713b144323c48ee8f7dd95044f31699","sdid":"713f4298132943df957e87c1d0e43d7a","ddid":"713f4298132943df957e87c1d0e43d7a","data":{"actions":[{"name":"setIntensity","parameters":{"intensity":10}}]}}

To stop listening to the bi-directional WebSocket on the second Device Simulator, type `slw`. Type `?` to learn other commands related to Actions and WebSocket.