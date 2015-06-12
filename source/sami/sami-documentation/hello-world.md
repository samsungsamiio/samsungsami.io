---
title: "Hello, World!"
---

# Hello, World!

Time To First Hello World (TTFHW) is 4 minutes.
{:.info}

This article is a hands-on introduction to several SAMI concepts we covered in [Basics](/sami/sami-documentation/sami-basics.html). We will connect a simulated device to SAMI that sends and receives data. In doing so, you'll get a tangible understanding of SAMI without writing a single line of code. 

We will also demonstrate some SAMI tools that you'll be using often. This diagram shows how the SAMI entities interact in this Hello World exploration (click to expand).

![System diagram](/images/docs/sami/sami-documentation/diagramHelloWorld2.png){:.lightbox}

## Step 1: Log in and connect a device

Log into the [SAMI User Portal](https://portal.samsungsami.io). You may need to create a Samsung account first.

Now connect a "SAMI Gear Fit" device to SAMI. 

You do not need a real device to perform the connection.
{:.info}

- If this is your first time in the Portal, you will be asked to connect your first device. Type "sami gear fit" into the search box. This calls up the [device type](https://developer.samsungsami.io/sami/sami-documentation/sami-basics.html#device-id-and-device-type) "SAMI Gear Fit".
![Connect a device](/images/docs/sami/sami-documentation/add-first-device-gearfit.png){:.lightbox}
- Name the Gear Fit device you are connecting to SAMI (e.g., "My GearFit Device").
![Name a device](/images/docs/sami/sami-documentation/name_gearfit.png)
- Click "CONNECT DEVICE..."

## Step 2: Get an access token

Navigate to the [API Console](https://api-console.samsungsami.io) and log in with your user account used in Step 1.

- Toggle the method `GET /users/self` in the Users API.
![Toggle method](/images/docs/sami/sami-documentation/toggle_getuser.png)
- Click the "TRY IT!" button.
- Copy the access token from the "Request Headers" block. The token is the string next to the word "Bearer". 
![Request header](/images/docs/sami/sami-documentation/getuser_requestheader.png)

**Stay logged into the API Console.** Otherwise the token becomes invalid and you cannot perform the following operations in the Device Simulator. 
{:.warning}

## Step 3: Configure the Device Simulator

Download the [Device Simulator](/sami/downloads/device-simulator.zip?raw=true). In a terminal, type `cd` to navigate to the directory containing the Simulator, and run the following command to start it. (You need the token obtained above.)

~~~
java -jar device-simulator.jar -token=1c49e70b628240cc22dde4c6b3f70e82
~~~

Enter `list devices` (or its shortcut `ld`) to display the device list. The list, which includes your Gear Fit device, will look like this (click to expand):
![List devices](/images/docs/sami/sami-documentation/ds_list_device_gearfit.png){:.lightbox}

Create a [scenario template](/sami/demos-tools/device-simulator.html#guess-scenario) to configure the simulation of My GearFit Device data. In the following command, the first input argument is `did` (device ID of the device), which we obtained from the output of `ld` above.

~~~bash
gs 6fd48f79c02b41cf99f2bf8bbf29596d myGearFitSim
~~~

The output will display the location of the created scenario file:
![Guess Gear Fit Scenario](/images/docs/sami/sami-documentation/ds_gs_gearfit.png){:.lightbox}

You can open the JSON file to see how the data for each field is generated. Normally you want to edit this JSON file to [tweak the fields based on your needs](/sami/demos-tools/device-simulator.html#the-config-object). For this exploration, we can skip this step.

If you want to be thorough, [this](/sami/sami-documentation/editing-the-gearfit-scenario.html) is how you can edit the JSON file to generate data that makes the most sense for the Gear Fit device type.

We're ready to start the simulation!

## Step 4: Send data to SAMI

To [simulate sending data](/sami/demos-tools/device-simulator.html#running-a-scenario) to SAMI, enter the `rs` command. The first input argument is `did` and the second is the scenario filename.

~~~
rs 6fd48f79c02b41cf99f2bf8bbf29596d myGearFitSim
~~~

The Simulator will make an HTTP [POST](https://developer.samsungsami.io/sami/api-spec.html#post-a-message-or-action) to send each message from My GearFit Device. The output looks like this:

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

## Step 5: Visualize the data

Go back to the [User Portal](https://portal.samsungsami.io) to visualize the data sent to SAMI by the Device Simulator. Since this data is sent on behalf of My GearFit Device, click the magnifying glass next to it on the dashboard. 

![device simulator quick start magnifying glass](/images/docs/sami/sami-documentation/ds_magnifying_glass.png)

Click the "+/- CHARTS" button and check the data fields for your Gear Fit sensors: `heartRate`, `stepCount`, `state`, `activity`.

![device simulator select charts](/images/docs/sami/sami-documentation/ds_select_charts.png){:.lightbox}

Now you can view your simulation data in real-time!

 ![device simulator realtime data](/images/docs/sami/sami-documentation/ds_data_charts.png){:.lightbox}

You can also click "VIEW TABLE" to view and sort the individual messages sent. 

 ![device simulator data table](/images/docs/sami/sami-documentation/ds_data_table.png){:.lightbox}

Stop your simulation by entering `s` or `stop` followed by the "Enter" key in the Simulator. You can also enter `?` for more help. 

## That's it!

Now you have a feel for the SAMI basics: connecting a device, sending data to SAMI, and viewing and visualizing that data.

Protip: You can also send commands called **[Actions](https://developer.samsungsami.io/sami/sami-documentation/sending-and-receiving-data.html#posting-a-message-with-actions)** to devices via SAMI. Feeling adventurous enough to **[try it out](https://developer.samsungsami.io/sami/demos-tools/device-simulator.html#simulate-sending-actions)**?
{:.info}

Read on to learn about SAMI in depth. You can also jump ahead to peek at other [tutorials](/sami/demos-tools/) or play with some advanced SAMI features [using the Device Simulator](/sami/demos-tools/device-simulator.html).