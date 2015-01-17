---
title: "A developer's journey of playing with SAMI 
        --- Peek into SAMI first time"

---

# Peek into SAMI

## Introduction

SAMI is a data exchange platform that enables any device or sensor or application to push its data to the cloud. Applications, services and devices can then use that data through simple APIs.

As an app developer, I can see the huge benefits for a single app to access the data of a user from diverse data sources. In that way, the app can provide more relevant service for the user. It is also important that integration with other data sources requires minimum efforts. I am very interested in exploring SAMI to understand how it helps me develop an app to easily get data from diverse data sources.

At the first step of the exploration journey, I would like to see how I can connect my own device to SAMI, and then visualize its data on SAMI. For this baby step, I do not write a single line of code. I act more like a SAMI user than a developer. However this exploration helps me believe that I can access the data from SAMI as a developer after seeing how a user can connect his devices to SAMI.

After I gain intuitive understanding about SAMI, the next steps are to  develop an app to interact with it. My future exploration will test how SAMI helps a 3rd party app to not just store the data but also get data from diverse sources easily.

## Connect the device

I have a Withings smart scale and will use it as an example in this exploration. The Withings smart scale is one of many devices supported in SAMI.

Users and developers can access a couple of web portals to manage and modify applications and devices. I only need to use the User Portal in this exploration.

I go to the User Portal located at [portal.samsungsami.io.](http://portal.samsungsami.io) to connect the device. Since this is my first time to login to the portal, I need to follow the following steps to create an account.

- Click "Sign up here" on the Samsung login page to register.
- Fill out the required fields on the next page.
- Click "Confirm" on the next page to be sent a verification email.
- Check my email inbox and open the verification email. Click "Verify Account".
- This opens the Account Verification page. Click "Start".
- I am returned to the login page. Now I can login!

After I successfully login, I connect my smart scale to SAMI as follows:

- Click "+ Connect another device..." in the User Portal.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/connect-another-device.png)
- In the box, start typing the name of a device. 
  - The available options pop up. Select "Withings Device".
- Name this device (for example scale).
- Click the "Connect Device..." button.

Now this scale appears as one of the connected devices in the User Portal. Many devices are connected directly to SAMI and data can be consumed directly. Some devices like Withings and Fitbits where they have their own cloud and API, require a user to give SAMI the permission when connecting the first time. Over time, there will be more cloud services connected to SAMI, which will be discussed in other posts on this blog.

For the device that requires a user's authorization, there is an authorization button on that device. I perform the following steps to authorize SAMI to get my scale's data from Withings' cloud:

- Click "Authorize" button of my Withings scale on the User Portal.
- After the page is redirected to Withings login page, fill out my Withing's user name and password.
- After login suceeds, click "Allow" on Withings authorization page to authorize Samsung SAMI to use my Withings account.
- I am returned to the SAMI User Portal. 

Note that I only need to do authorization with Withings' cloud once for this device. Now I am ready to see the data of my Withings scale on SAMI.  

## Visualize the data

- Click "View your data" icon on the SAMI User Portal.
- "SAMI.Data Visualization" tool opens.
- Click "+/- CHARTS" button on the tool screen and check "Weight" of the scale in order to see weight data chart.
- Dismiss the chart selection screeen.
- Click "5w" to see the chart of the weight data (in kg) for the past 5 weeks.<br /><br />
![Weight Chart](/images/docs/sami/blogs/intro-weight-chart.png){:.lightbox}
- I can customize the annotation to see the chart in different formats like curves, dots and bars.
- I can choose different time windows like "10s" and "1d" to see the data in different durations.

I can see the near real time update of the data in the following way:

- Click play button in SAMI.Data Visualization tool. Now the chart shows data within 30s window and refreshs to show new data.
- Make sure the scale connects to the Internet. Step on the scale and a new measurement will be sent to Withings cloud.
- Shortly I see the new weight data appears in the chart of SAMI.Data Visualization tool.

## What is the next?

In the future exploration, I will develop an app to understand how to:

- connect a user's Withings scale to SAMI within the app without requiring the user to connect in the User Portal
- get user's data from his Withings scale via SAMI
- get user's data from multiple data sources via SAMI
