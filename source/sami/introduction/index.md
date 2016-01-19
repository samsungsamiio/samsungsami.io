---
title: "Introduction"

nav:
   - 'sami-basics'
   - 'hello-world'
   - 'authentication'
   - 'administrative-apis'
   - 'the-manifest'
---

# Introduction

SAMI is a data exchange platform that enables any device or sensor to push its data to the cloud. Applications, services and devices can then use that data through [simple APIs.](/sami/api-spec.html)

SAMI is open and agnostic. To save data or send a message to the cloud, you can do it in the format most convenient to you. SAMI will do the work of interpreting it.

![SAMI architecture overview](/images/docs/sami/sami-documentation/sami-architecture-overview.png){:.lightbox}

SAMI defines a new paradigm for developers to create services and applications. It offers a new dimension to think beyond a single device and enables developers to connect and analyze all sorts of data. This is what we call Data Driven Development (D<sup>3</sup>).

- Clients can access and aggregate historical data from different sources, thus opening a new perspective on big data.
- Clients that subscribe to a WebSocket can receive data in real-time, enabling different devices and applications to talk to each other.
- SAMI is the only service that gives users complete control over their data. By granting access to devices and applications, users promote an ecosystem of services around data.
- Through the definition of a Manifest, developers can support diverse devices and data.

## What this documentation covers

- Important [SAMI concepts](/sami/sami-documentation/sami-basics.html), including messages, devices and device types, and data normalization; along with a [Hello, World!](/sami/sami-documentation/hello-world.html) quick-start guide.
- The full [SAMI API specification](/sami/api-spec.html). 
- [Authentication with OAuth2](/sami/sami-documentation/authentication.html) and [managing users and their devices](/sami/sami-documentation/administrative-apis.html) in the cloud.
- [Writing the Manifest](/sami/sami-documentation/the-manifest.html) to interpret and normalize your device data.
- How to begin [connecting data](/sami/connect-the-data/) between devices, clouds and SAMI.
- [Advanced SAMI features](/sami/advanced-features/) like Rules and trials.
- [Developer tools](/sami/tools/) to help you work with the platform. 
- [Tutorials](/sami/tutorials/) for developing basic SAMI applications, and [Samples](/sami/samples/) of more advanced SAMI applications available on GitHub.
