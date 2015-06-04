---
title: "Quick start"
---

# Quick start

Let's connect a simulated device to SAMI that sends and receives data. In doing so, we will introduce some key SAMI developer tools.

## Create your SAMI account and connect a device

Navigate to the SAMI [User Portal](https://portal.samsungsami.io) and log in. [This page](https://developer.samsungsami.io/sami/sami-documentation/developer-user-portals.html) runs through the steps to create an account.

Now create a new [Samsung Gear Fit](http://www.samsung.com/us/mobile/wearable-tech/SM-R3500ZKAXAR) device. 
- Click "+ Connect another device..."
- Type "gear fit" into the search box. This calls up the [device type](https://developer.samsungsami.io/sami/sami-documentation/sami-basics.html#device-id-and-device-type) "SAMI Gear Fit".
- Name the Gear Fit device you are connecting to SAMI (e.g., "My GearFit Device").

tkscreenshots for the above

## Get an access token

Navigate to the [API Console](https://api-console.samsungsami.io) and log in with your new user account.

- Under the Users API, toggle the method `GET /users/self`{:.param.http} to "Get current user profile" .
- Click the "TRY IT!" button.
- Copy the access token from the "Request Headers" block. The token is the string next to the word "Bearer ". 

Example: tk****Yujing comment: show it using a screenshot  
{
    "Content-Type": "application/json",
    "Authorization": "Bearer 1c49e70b628240cc22dde4c6b3f70e82"
}

In the above example, the access token is: 1c49e70b628240cc22dde4c6b3f70e82. **Stay logged in to the API Console.** Otherwise the token becomes invalid and you cannot perform the following operations in the Device Simulator. 

## Open the Device Simulator and configure the simulation

Download the [Device Simulator](/sami/downloads/device-simulator.zip?raw=true). In a terminal, cd to the directory containing the Simulator, and run the following command to start it. Note you need to use the token obtained above.

~~~
java -jar device-simulator.jar -token=1c49e70b628240cc22dde4c6b3f70e82
~~~

Now enter `list devices` (or its shortcut `ld`) to display the device list, including your Gear Fit device. The list will look like this:

    did                                 dtid                              name                              manifestVersion   manifestPolicy      Token                         
    b7bcb7ae180b46a781b1a9b1de845882    sami_gear_fit                       My GearFit Device                 1                 LATEST 

[Create a scenario template](/sami/demos-tools/device-simulator.html#guess-scenario) to configure the simulation that generates data from My GearFit Device in SAMI.

~~~
gs b7bcb7ae180b46a781b1a9b1de845882 myGearFitSim
~~~

The output will display the location of the created scenario file:

    Scenario saved to /home/someuser/device-simulator/b7bcb7ae180b46a781b1a9b1de845882/myGearFitSim.json

## tk

Open the JSON file with your preferred text editor. Copy the contents of the [file]() and paste it into the scenario file. Please note do not change sdid in your original scenario template file. Finally Your file should like the following except that there is no explanation:

{
    "api": "POST", <== Add this for choosing between HTTP or websockets API. Set it to "WS" for websockets
    "sdid": "b7bcb7ae180b46a781b1a9b1de845882”,
    "deviceToken": "",
    "data": {  <== These fields will be simulated, with this default value
        "stepCount": 0,
        "description": "",
        "heartRate": 0,
        "state": 0,
        "activity": 0
    },
    "config": { <== This is the configuration to calculate the values for each field on each simulation loop.
        "stepCount": {
            "min": 1000, <== The min value this field can have
            "max": 10000, <== The max value this field can have
            "type": "Integer", <== Field's data type, as specified in the device's manifest. 
            "function": "increment", <== simulation method: increment, random, cycle and constant 
            "increment": 2, <== Value will increment by 2, on each sample: 1000, 1002, 1004
            "period": 5000 <== This field will be included in the payload each 5 seconds, instead of all samples.
        },
        "description": {
            "type": "String",
            "function": "random" <== Given the type is String, this will cause the simulator to create random words
        },
        "heartRate": {
            "min": 0,
            "max": 200, <== heart beat max set to 200, typical human being limit
            "type": "Integer",
            "function": "random"
        },
        "state": {
            "min": 0,
            "max": 1, <== the Fit reports few wearing states as a number, ex. wearing(1), not wearing(0)
            "type": "Integer",
            "function": "random"
        },
        "activity": {
            "type": "Integer",
            "function": "cycle"
            "value": [0,2,1,2,1,1,1,0] <== the Fit reports few activities as a number, ex: walk(1), run(2), unknown(0)
        }
    },
    "period": 1000 <== This is the main simulation clock, in milliseconds. It will loop each 1 second.
}


Save the file and we're ready to start the simulation. 

## Start the device simulation

Enter:

~~~
rs a7aca7ae180b46a781b1a9b1de84588e myGearFitSim
~~~

The Simulator makes an HTTP [POST](https://developer.samsungsami.io/sami/api-spec.html#post-a-message-or-action) to send each message. The output looks like:

~~~
Loading scenario from /home/someuser/device-simulator/target/a7aca7ae180b46a781b1a9b1de84588e/gearfit.json
Reading file: /home/someuser/device-simulator/target/a7aca7ae180b46a781b1a9b1de84588e/myGearFitSim.json
$ Using this token to send the messages: 4e711b43499047c39f44d8ebcb82d908
Send #0 {"stepCount":1008,"description":"jbt","heartRate":39,"state":0,"activity":2}
Got MID: bb7d02c0181d4445b04f6b0575e78d04
Send #1 {"description":"afvu","heartRate":165,"state":0,"activity":1}
Got MID: 5771ec32ee8b41949cfd3c0b9b417886
Send #2 {"description":"zkxl","heartRate":185,"state":0,"activity":1}
Got MID: ff691299577c42b19e7f2fa927394fbc
Send #3 {"description":"hqmtwyvcpk","heartRate":195,"state":0,"activity":1}
Got MID: 7dc2faf9c0a9431fbf918a41b342df04
Send #4 {"stepCount":1010,"description":"elbn","heartRate":179,"state":0,"activity":0}
Got MID: 8aa1a183895c42efb905223b3cb5f918
...
~~~

## Visualize the simulated data

Go back to the [User Portal](https://portal.samsungsami.io) to visualize the data sent to SAMI by the Device Simulator. Remember, this data is sent on behalf of My GearFit Device. Click the magnifying glass by the device name. 

![device simulator quick start magnifying glass](/images/docs/sami/sami-documentation/ds_magnifying_glass.png){:.lightbox}

Click "+/- CHARTS" and check the data fields for your Gear Fit sensors: `heartRate`, `stepCount`, `state`, `activity`. Close the popup.

![device simulator select charts](/images/docs/sami/sami-documentation/ds_select_charts.png){:.lightbox}

Now you can view your simulation data in real-time!

 ![device simulator realtime data](/images/docs/sami/sami-documentation/ds_data_charts.png){:.lightbox}

Click "VIEW TABLE" to view the messages sent from the simulation. 

 ![device simulator data table](/images/docs/sami/sami-documentation/ds_data_table.png){:.lightbox}

Stop your simulation by entering `s` or `stop` in the Simulator. You can also enter `?` for more help. 

## That's it!

Now you have a feel for the SAMI basics: connecting a device, sending data to SAMI, and viewing and visualizing that data.

The Device Simulator lets you play with advanced SAMI features without writing a single line of code. For example, using the Simulator, you can send data over [WebSockets](/sami/sami-documentation/sending-and-receiving-data.html#live-streaming-data-with-websocket-api) or send [Actions](https://developer.samsungsami.io/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions) to a target device. 

Read on to learn about SAMI concepts in-depth, or jump ahead to [learn about using the Device Simulator](/sami/demos-tools/device-simulator.html).
