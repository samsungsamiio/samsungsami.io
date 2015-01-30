---
title: "FAQ"
---

# Frequently Asked Questions

What is the maximum number of events per second and bytes per second that SAMI can consume from a single device?
: We will provide this information soon.

I developed a cool app and I want to store data in SAMI, but it's not a device. Can I still use SAMI?
: YES! SAMI defines as "device" any source of data. It can be an actual device, such as a Samsung Gear Fit, or a service that wants to store your data to make it available to you and other services.

OK, I developed a super-awesome app, and I want to use SAMI to store values and allow my users to share their data with other apps. Do I need to get certified? What do I do to get started with SAMI?
: It's very simple. First, you need to learn about the [Manifest.](/sami/sami-documentation/the-manifest.html) Once you have prepared a Manifest, go to the [Developer Portal](https://devportal.samsungsami.io), create a new Device Type, upload its Manifest and wait for it to be approved by our team. Once your Manifest is approved, you can start integrating your app. Feel free to grab one of our [SDKs.](/sami/native-SDKs/) Once your Device Type is approved, you can immediately "publish" it and any user will be able to connect this device to SAMI.

My Device Type has not been approved. How can I test my application?
: Unfortunately, you will have to wait for us to approve your Manifest. But don't worry, we are actively reviewing Manifest submissions and it should not take too long.

Is there a standard for units such as the metric system or the Imperial system?
: Everyone and everything is welcome in SAMI. When you submit a new Manifest for a (new) Device Type, we will review it and recommend changes. You are welcome to send data in the format and unit that suits you best, but in order to make data consistent we will from time to time recommend changes to your Manifest. This will make your app, service or device an active member of the SAMI ecosystem.

Is there, or will there be, any facility allowing for data set reduction on SAMI (e.g., MapReduce), either on-demand against historical data or applied to a live stream that is generating another stream to be stored?
: Not at this time. We will notify our community if our plans change.

How does SAMI handle data outages due to loss of device-to-SAMI connectivity?
: Devices are responsible of keeping the connection to SAMI active. If there is an outage, it will be the device’s responsibility to re-establish the connection.

Is there, or will there be, a pull model where SAMI will pull data from a device?
: This is not planned at this time.

Is there any notion of a heartbeat between SAMI and a device for monitoring?
: When using WebSockets, SAMI will send a heartbeat. The device is supposed to close and reopen the connection if no heartbeat is received. No heartbeat is supported when using REST, as the device is supposed to initiate the communication and it is the device's responsibility to make it work.

Can I search for a message with a specific key/value pair?
: SAMI allows you to query messages based on a start and end time, or querying the last *N* messages. A search functionality to extract messages with specific values is currently not implemented.

Can I upload images to SAMI?
: SAMI is designed to store and manage data that can be shared and reused by multiple applications and services. Some of the data might also be converted from one unit to another. At this time binary data such as images and videos don't meet our goals and require a lot of physical space. We recommend that you use a storage system that is optimized for this type of data.

I successfully created a new device type and successfully posted a message of this type of devices. Later on I retrieve the message from SAMI using the message ID. However, in the message, I do not see the data fields that I added when posting that message to SAMI?
: After you post a message to SAMI, you will get a message ID back. However, this does not mean that your message has been successfully parsed or stored in SAMI. The raw message received by SAMI is normalized when passing through SAMI. The normalization uses the Manifest of the device type you created. The normalization may fail to identify the fields of data in your message. For example, there is a typo in the field name of your message. We suggest you to capture the data you send to SAMI and follow [Validate your Manifest](http://developer.samsungsami.io/sami/demos-tools/manifest-sdk.html#test-in-a-maven-project) to test your data. Your [unit test](http://developer.samsungsami.io/sami/demos-tools/manifest-sdk.html#the-sample-maven-project-in-detail) should test if any field of the normalized data is NULL and also verify data values.