---
title: Changelog

---

#Changelog

Here we'll be posting regular updates about SAMI and updates to the documentation.

### August 27, 2015

Over [in the blog](https://blog.samsungsami.io/development/iot/mobile/2015/08/27/monitor-fire-and-temperature-using-an-arduino-raspberry-pi-and-sami.html), we expanded our IoT device below to add a temperature sensor. You can check out the source code on [the Samples page](/sami/samples/).

### August 25, 2015

Following our [SAMI Developer Meet-up on August 13](https://blog.samsungsami.io/data/development/iot/2015/08/25/sami-and-the-future-of-iot.html), we wrote a tutorial on [building an IoT device](/sami/demos-tools/your-first-iot-device.html) for flame detection using SAMI, Android and open-source hardware.

### August 13, 2015

We've added documentation on [a new API](/sami/api-spec.html#get-normalized-message-histogram) that returns message aggregate data in intervals that can be used to draw histograms. 

### June 17, 2015

Made some updates to the [WebSockets specification](/sami/sami-documentation/sending-and-receiving-data.html#live-streaming-data-with-websocket-api) and to [secure device registration](/sami/sami-documentation/secure-your-devices.html).

### June 13, 2015

Updated the application and device creation flows in the [Developer Portal documentation](/sami/sami-documentation/developer-user-portals.html) to reflect design changes and additions.

### June 10, 2015

New to SAMI and eager to start? Our new [Hello, World!](/sami/sami-documentation/hello-world.html) quick-start guide walks through the basics of connecting a device to SAMI, sending data and looking at the results (thanks to the Device Simulator).

### June 7, 2015

We documented the new functionalities of the Device Simulator: simulate sending data via WeSocket and simulate sending Actions. Download the latest file from [Device Simulator](/sami/demos-tools/device-simulator.html).

### May 27, 2015

We expanded our documentation on the [three types of access tokens](/sami/sami-documentation/authentication.html#three-types-of-access-tokens) used in authentication and clarified permissions and [rate limiting](/sami/sami-documentation/rate-limiting.html#rate-limits-for-three-actors) for the token types.

### May 20, 2015

An update to the API specification. The call to [get normalized message aggregates](/sami/api-spec.html#get-normalized-message-aggregates) now returns values for messages up to 1 minute old. We updated the API specification to reflect the new functionality.

### April 22, 2015

The [Developer Portal](https://devportal.samsungsami.io/) got a major overhaul for managing applications and device types. We've updated the [Developer and User Portals](/sami/sami-documentation/developer-user-portals.html) documentation to reflect some of these changes, with a longer blog post forthcoming.

### April 18, 2015

Some things for you to play with! A [JavaScript/Node.js demo](/sami/samples/) that shows user devices and device data, and our new [Python 3 SDK](/sami/native-SDKs/).

### April 17, 2015

Token refresh flow is now described in [Authentication](/sami/sami-documentation/authentication.html#refresh-a-token).

### April 1, 2015

We just documented [secure device registration](/sami/sami-documentation/secure-your-devices.html) for creating secure device types and registering devices with SAMI for secure communication. (No joke!)

### March 31, 2015

The article [Data collection with trials](/sami/sami-documentation/data-collection-with-trials.html) highlights some key APIs for conducting trials programmatically. 

The [WebSockets APIs](/sami/api-spec.html#websockets) have also been added to the API spec.

### March 23, 2015

We have added new documentation on writing a [Manifest with Actions](/sami/sami-documentation/the-manifest.html#manifests-that-support-actions) for devices. New "description" and "actions" parameters are returned when [getting Manifest properties](/sami/api-spec.html#get-manifest-properties) with the API.

### March 20, 2015

The API spec has been updated with [Trials APIs](/sami/api-spec.html#trials) and updates to the [Export API](/sami/api-spec.html#export), including "simple" CSV data exports. The [API Console](https://api-console.samsungsami.io) is also updated to reflect these changes and additions.

### January 31, 2015

[WebSocket rate limits](/sami/sami-documentation/rate-limiting.html#websocket-limits) have been documented.

### January 26, 2015

Expiration date and status "Expired" were added to the [`GET /messages/export/<exportID>/status`{:.param}](/sami/api-spec.html#check-export-status) response.

### January 22, 2015

Added a note about byte size limits for SAMI messages. See the [API spec.](/sami/api-spec.html#message-limits)

### January 21, 2015

We've posted [an article](/sami/sami-documentation/oauth2-flow-examples.html) that covers use cases of OAuth 2.0 for third-party applications.

### December 17, 2014

[Rate limiting](/sami/sami-documentation/rate-limiting.html) is now documented.

### December 16, 2014

We found an issue with the Device Simulator and we updated it. Download the latest file from [Device Simulator](/sami/demos-tools/device-simulator.html).

### December 09, 2014

Minor update to the Native SDKs today involving a change to a parameter name in the Messages API. Check out our GitHub page at [https://github.com/samsungsamiio/](https://github.com/samsungsamiio/).

### November 12, 2014

The beta starts today! Dig around the [documentation](/sami/sami-documentation/), play with the [APIs and tools](/sami/demos-tools/), and [post any questions](/community/) you might have. We're looking forward to your feedback.
