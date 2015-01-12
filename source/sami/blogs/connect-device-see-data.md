---
title: "Peek into SAMI first time"

---

# Peek into SAMI

## Introduction

SAMI is a data exchange platform that enables any device or sensor or application to push its data to the cloud. Applications, services and devices can then use that data through simple APIs. At the first step to explore SAMI, I will show you how to connect a device to SAMI, and then visualize its data on SAMI.

This is a baby step in the journey of SAMI exploration. For this step, I do not need to write a single line of code in order to gain a bit tangible understanding of SAMI.

## Connect the device

I use a Withings smart scale in this exploration. Withings devices are just one of hundreds of device types that have been supported in SAMI.

Users and developers can access a couple of web portals to manage and modify applications and devices. I only need to use the User Portal for this exploration.

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

Now this scale appears as one of the connected devices in the User Portal. Depending on the type, some devices require the user to authorize SAMI to get device data from the 3rd party cloud. For example, Withings and Fitbit devices require authorization while Vital Connect Module devices do not. You only need to do authorization once for such a device if authorization is needed.

I follow the steps below to authorize SAMI to get my scale's data from Withings's server:

- Click "Authorize" button of my Withings scale on the User Portal.
- After the page is redirected to Withings login page, fill out my user name and password.
- After login suceeds, click "Allow" on Withings authorization page to authorize Samsung SAMI to use my Withings account.
- I am returned to the SAMI User Portal. 

Now I am ready to see the data of my Withings scale on SAMI.  

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