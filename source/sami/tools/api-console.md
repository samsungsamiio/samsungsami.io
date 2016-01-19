---
title: "API Console"
---
 
# API Console
 
The API Console is a web tool that you can use to test the SAMI APIs and quickly retrieve important information such as device IDs and normalized messages. It also works as a hands-on reference for required and optional parameters discussed in the [API specification.](/sami/api-spec.html)
 
The Console is found at [https://api-console.samsungsami.io/sami](https://api-console.samsungsami.io/sami). In order to use the Console, you must first authenticate with your Samsung account. Here's how to authenticate:
 
- Click the "Authenticate with SAMI" button in the top bar.
	- If you don't have a Samsung account, you can [create one now.](/sami/sami-documentation/developer-user-portals.html)
- If authentication was successful, you will see this reflected with a green checkmark at the top of the page:
![API Console](/images/docs/sami/demos-tools/apiConsoleOverview.png){:.lightbox}

After authentication, you can test the API calls using information returned by the Console itself, beginning with your user ID.
 
- There are four categories of API calls: Users, Devices, Device Types and Messages.
- The "List Methods" button unfolds the available calls in each category. You can click on a specific call to see and enter values for the parameters.
- The "Try It!" button under each API call produces a response body using the parameter values you entered.
- You can click "Toggle All Methods" at the top of the page to see the details for every call. Click the button again to collapse the page into summary view.
 
## Find your user ID
 
Many of the calls include `uid` (user ID) as a required parameter. Here's how to find your user ID to use in the Console:
 
- Make sure you have authenticated with SAMI.
- Find the call `GET /users/self`. This retrieves the profile for the current user.
- No request parameters are needed. Click "Try It!"
- Your user ID is the string next to `id` in the response body.
![API Console](/images/docs/sami/demos-tools/apiConsoleGetUserId.png)

## Find a device ID
 
Device IDs are needed for calls in the Devices category. You can view all of your devices connected to SAMI at the [User Portal](https://portal.samsungsami.io/), but the User Portal doesn't list their corresponding device IDs. To find these, you can use the Console.
 
- Find the call `GET /users/{userId}/devices`.
- Paste your user ID into the required field and click "Try It!"
- Your devices will be listed in the response body.
	- The device ID for each device is `id`.
	- The device type ID is `dtid`. For other ways to locate a device type ID, see the next section.
![API Console](/images/docs/sami/demos-tools/apiConsoleGetUserDevices.png)


## Find a device type ID
 
If you want to create a new device for a user, you’ll need the device type ID. These are the most direct ways to find a device type ID:
 
- If an instance of the device type is already connected to SAMI, you can enter its device ID in `GET /devices/{deviceId}`. 
	- The device type ID is `dtid` in the response body.
![API Console](/images/docs/sami/demos-tools/apiConsoleGetDevice.png)

- If you know the device type name, you can enter this string in `GET /devicetypes`. Device type names that you have created can be found in the [Developer Portal](https://devportal.samsungsami.io/).
	- The device type ID is `id` in the response body.
![API Console](images/docs/sami/demos-tools/apiConsoleGetDeviceTypes.png)
 
## Get some messages
 
Using the API Console, you can conveniently retrieve historical messages from a device or user. 
 
- Find the call `GET /messages`.
- Note that you can use various parameter combinations to retrieve messages.
- Since `startDate` and `endDate` are already filled, try entering the device ID under `sdid`. This will pull up a list of messages in that date range for the source device.
 
## Get the last messages sent by a device

This call returns a device's most recent messages irrespective of duration, and is useful for debugging. 

- Find the call `GET /messages/last`.
- Next to `count`, enter the number of messages to return (default is 10).
- Enter the source device ID. Note that you can enter multiple device IDs separated by commas.
- The last messages sent by each device are returned.