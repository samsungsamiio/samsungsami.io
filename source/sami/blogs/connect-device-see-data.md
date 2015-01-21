---
layout: post
title: "Developing with SAMI 
        --- Part 1: Making the connection"
author: yujing_wu
categories: portals dataviz apps
---

# Peek into SAMI

*This is the first of a series of articles exploring the possibilities of SAMI from a developer's perspective.*

## Introduction

[SAMI](http://developer.samsungsami.io/) is a data exchange platform that enables any device or sensor or application to push its data to the cloud. Applications, services and devices can then use that data through simple APIs.

As an app developer, I can see the huge benefits of having a single app access a user's data from diverse data sources. In this way, the app can provide more relevant services to the user. It is also important that the app's integration with other data sources requires minimum effort.

In order to explore how SAMI can help me do this, I first want to connect my own device to SAMI, and then visualize its data on SAMI. For this baby step, I do not write a single line of code, and I can approach SAMI more like a user than a developer. This helps me gain an intuitive understanding of how SAMI connects devices and their data.

## Connecting the device

I have a [Withings smart scale](http://www.withings.com/us/smart-body-analyzer.html) and will use it as an example here. The Withings smart scale is one of many devices supported in SAMI.

SAMI users and developers can access a couple of web portals to manage and modify their applications and devices. This time, I only need to use the User Portal.

I go to the User Portal located at [portal.samsungsami.io](http://portal.samsungsami.io) to connect my Withings smart scale. Since this is my first time logging into the portal, I need to follow the following steps to create an account.

- Click "Sign up here" on the Samsung login page to register.
- Fill out the required fields on the next page.
- Click "Confirm" on the next page to be sent a verification email.
- Check my email inbox and open the verification email. Click "Verify Account".
- This opens the Account Verification page. Click "Start".
- I am returned to the login page. Now I can login!

After I successfully login, I connect my Withings smart scale to SAMI as follows:

- Click "+ Connect another device..." in the User Portal.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/connect-another-device.png)
- In the box, start typing the name of my device. 
  - The available options pop up. Select "Withings Device".
- Name my device (for example, "scale").
- Click the "Connect Device..." button.

Now the scale appears as one of my connected devices in the User Portal. Many devices are connected directly to SAMI and their data can be consumed directly. Some devices, like the Withings smart scale and Fitbit, have their own cloud and API and require a user to give SAMI permission when connecting the first time. Over time, there will be more cloud services connected to SAMI, which will be discussed in other posts on this blog.

For devices that require user authorization, there is an authorization button next to that device in the User Portal dashboard. I perform the following steps to authorize SAMI to get my scale's data from Withings' cloud:

- Click "Authorize" button of my Withings smart scale on the User Portal.
- After the page is redirected to Withings' login page, fill out my Withings user name and password.
- After login suceeds, click "Allow" on Withings' authorization page to authorize Samsung SAMI to use my Withings account.
- I am returned to the SAMI User Portal. 

Note that I only need to do authorization with Withings' cloud once for this device. 

## Visualizing the data

Now I am ready to see the data of my Withings smart scale on SAMI, using the [Data Visualization](https://blog.samsungsami.io/portals/dataviz/2015/01/09/opening-the-user-portal.html) features of the User Portal.

- Click the "View your data" icon in the SAMI User Portal (upper-left corner).
- This opens Data Visualization in a pop-up window.
- Click the "+/- CHARTS" button in the pop-up and check "Weight" underneath "Withings Device".
- Dismiss the chart selection screeen.
- Click "5w" (to the right of the "+/- CHARTS" button) to view the weight data (in kg) for the past 5 weeks.<br /><br />
![Weight Chart](/images/docs/sami/blogs/intro-weight-chart.png){:.lightbox}
- I can customize the annotation to see the chart in different formats like curves, dots and bars.
- I can choose different time windows like "10s" and "1d" to see the data in different durations.

I can see the Withings data update in near-real-time in the following way:

- Click the "Play" button in Data Visualization. Now the chart shows data within a 30s window and periodically refreshes to show new data.
- Make sure the Withings smart scale is connected to the Internet. Step on the scale, and a new measurement will be sent to Withings' cloud.
- Shortly after, I see the new weight data appear in a Data Visualization chart.

## What comes next?

My next steps are to develop an application to interact with SAMI. In future explorations, I will test how SAMI helps a third-party app to not just store the device data, but also easily get data from diverse sources.

In upcoming posts, I will develop an app to understand how to:

- Connect a user's Withings scale to SAMI within the app, without requiring the user to connect in the User Portal.
- Get the user's data from his Withings scale via SAMI.
- Get the user's data from multiple data sources via SAMI.