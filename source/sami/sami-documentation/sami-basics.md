---
title: "Basics"
---

# Basics

SAMI is designed to be as easy as possible to integrate with existing devices and services. This article presents the basic concepts behind how SAMI recognizes users, devices, data and applications.

## Authorization

The API's authorization model is based on a very simple set of permissions (READ and WRITE) on users and other entities in the system. These grant a user the right to perform activities in SAMI via the API calls.

If a user has created her own account, only she will have access to her data. If you have admin privileges on the user, you will be able to perform some limited actions on behalf of the user, such as getting the user's profile information and changing the user's application properties.

Future changes to the API might include more fine-grained management of permissions by the user, more permission types and more activity checks. [Learn more about authorization.](/sami/sami-documentation/authentication.html)

## Messages

Data is stored in SAMI by applications and devices in a **message**. Each message in SAMI is associated with a set of identifying metadata: the device ID, user ID and application ID. To record a message, an application must provide the payload and the device ID. SAMI can automatically infer the user ID and application ID from the access token that was generated during authentication. When the message is received, SAMI also creates a timestamp. 

Applications must specify at least one of these parameters when querying SAMI. This means that depending on the scenario, data can be queried per user, per device or per application. [Learn more about sending and receiving data.](/sami/sami-documentation/sending-and-receiving-data.html)

## User ID

A user ID is defined by SAMI and assigned on user creation, which is done through Samsung Accounts. With a user ID, applications may obtain the user's profile and device list, and may request to create and manage an application profile for that user. 

Users can additionally choose to grant an application access to their data. Once an application has been granted access, it may also request data from the user's devices. Users may remove these permissions at any time. 

## Device ID and device type

Any source of data in SAMI is called a **device**. Devices in SAMI can be sensors, appliances, applications, services, etc. Usually one user will own one or more devices, and devices can send messages or be used to send messages into SAMI. Every device in SAMI is identified with a unique device ID. Device IDs are assigned by SAMI when devices are first created in the system. A device ID is a unique instance of a device type. 

A device type defines a category of device in SAMI. For example, "Samsung Galaxy Gear Fit" is a device type, and "Andrea's Samsung Galaxy Gear Fit" will have a unique device ID. Only the owner, vendor or OEM of a device will likely need to create a device type. Owners of a device type are responsible for keeping the name and description of a device type updated. [Learn more about creating devices.](/sami/sami-documentation/administrative-apis.html#creating-a-device)

## Application ID

Each application is assigned a unique ID by SAMI. An application ID is required to obtain an [OAuth2](/sami/sami-documentation/authentication.html) access token and to request data from an application, provided that the user has granted access. Developers can request as many application IDs as needed. If you have multiple application IDs, data can be shared among your applications if users have authorized this. [Learn how to find your application ID.](/sami/sami-documentation/developer-user-portals.html#how-to-find-your-application-id)

## Raw and normalized data

Data collected by SAMI is called **raw data**: it refers to the original format and structure, unmodified by the system. After collection, raw data is processed and becomes **normalized data**: JSON-formatted, with standardized field names and values.

## Manifest

SAMI is designed to be agnostic of the data sent by devices and applications. To make this data usable, SAMI requires what we call a **Manifest**. The Manifest, which is associated with a device type, describes the structure of the data. When an application or device sends a message to SAMI, the Manifest takes a string as input that corresponds to the data, and outputs a list of normalized fields/values that SAMI can store.

When querying data stored in SAMI, developers can request either the original "raw" format or the standard normalized format. This is the output generated when passing the original message through the Manifest. Accurately defining and updating the Manifest will ensure that the normalized data delivered by SAMI is also accurate. Manifests cannot be updated or deleted, but new ones can be uploaded to SAMI. [Learn more about the Manifest.](/sami/sami-documentation/the-manifest.html)

## SAMI tools

These tools were designed to make SAMI development and research faster and easier. The [Developer Portal](/sami/sami-documentation/developer-user-portals.html#inside-the-developer-portal) provides a web-based interface for creating and managing device types and applications, while the [User Portal](/sami/sami-documentation/developer-user-portals.html#inside-the-user-portal) lets you connect devices and visualize their data. The [API Console](https://api-console.samsungsami.io/sami) allows you to execute API calls and see the results in your browser. Finally, the [Device Simulator](/sami/demos-tools/device-simulator.html) is a command-line tool you can use to send simulated messages and Actions to SAMI.
