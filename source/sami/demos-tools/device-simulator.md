---
title: "Device Simulator"
---

# Device Simulator

The SAMI Device Simulator is a command-line tool developed in Java. It is meant to help you send messages to SAMI on behalf of any device in the system. 

The Device Simulator's primary goal is to make it easy to connect to SAMI and send pre-recorded data to simulate an actual device. The Device Simulator also makes it very easy to execute commands easily, such as listing devices for a user, looking at device types, etc.

![device simulator start screen](/images/docs/sami/libraries-examples/DeviceSimulatorStart.png){:.lightbox}




To use the commands in this article, [**download the Device Simulator.**](https://github.com/samiio/samsungsami.io/blob/master/source/sami/downloads/device-simulator20141028.zip) <br /><br />Java JDK v8 update 25 or higher is required.
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

## Scenarios

The SAMI Device Simulator works in two main modes: 

- An interactive mode, where you can execute commands (such as listing devices) and see the results.
- An automated mode, in which pre-recorded scenarios are defined through a simple JSON configuration file and (when appropriate) pre-recorded data sets. Developers can enter real data or can use the Simulator to generate random data.

This is how a very basic scenario looks:

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
    "period": 1000
}
~~~

  |Field name   |Description   |Accepted values
  |----------- |------------- |---------------
  |`sdid`{:.param}   |The device ID. use `ld` to get a list of your user's devices   |device ID 
  |`deviceToken`{:.param}   |The access token for the selected device ID. |If you want to force a specific token type it here or leave empty and the Simulator will get one
  |`data`{:.param}   |A complex object that defines the default values for each of the data fields that will be sent to SAMI   |A set of key/value pairs for each data point you want to send
  |`config`{:.param}   |A complex object describing how the Simulator should generated the data. See below for more information   |A set of JSON objects
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
      "randomWord":{"function":"random", "type":"String"}
  } ....
~~~

Each object can have up to four properties:

  |Field name   |Description   |Accepted values
  |----------- |------------- |---------------
  |`function`{:.param}   |Define how to generate data based on the other parameters |`random` (default), `constant`, `cycle`
  |`type`{:.param}   |Describes the data type, the same that you defined in the Manifest |Refer to the Types you configured in the Manifest
  |`min`{:.param}   |If defined will set the minimum value for the generated data. If set **requires** that you also set the `max`{:.param} value.   |Any Integer
  |`max`{:.param}   |If defined will set the minimum value for the generated data. If set **requires** that you also set the `min`{:.param} value.   |Any Integer higher than the `min`{:.param} value
  |`value`{:.param}   |Define one or more possible values, the actual values and use depend on the data type of the field and the `function`{:.param} you chose   |A set of values, can be numbers, strings, etc.

As described, the Simulator currently supports three types of functions. These will actually generate the values to be sent to SAMI depending on the parameters you defined. The supported functions are:

 * **random (default)**: Creates random numbers or words. For numbers makes use of additional fields `min`{:.param} and `max`{:.param}.
 * **constant**: Makes use of a field `value`{:.param} to specify the constant value.
 * **cycle**: Loops through the values defined in the `value`{:.param} field.

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

## Interactive mode

In interactive mode developers can launch the Simulator and execute individual commands such as the following:

	list devices  
	# (or you can use "ld" as shortcut)

## Do more with the Simulator

The Device Simulator supports many other commands that we did not describe in detail here. You can get a device ID, a device Type and a Manifest. Learn how to do more simply typing the "?" command and get a full list of the available commands.

![device simulator help screen](/images/docs/sami/libraries-examples/device-simulator20140926.png){:.lightbox}
