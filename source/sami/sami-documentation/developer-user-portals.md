---
title: "Developer and User Portals"

---
# Developer and User Portals

We designed the Developer Portal and User Portal to provide an easy, intuitive way for you to assess and modify the applications and devices you are working with. This article takes you through their primary features.

Both web tools require a Samsung account. Follow these steps to create an account after logging into the Developer or User Portal for the first time.
{:.info}

- Click "Sign up here" on the Samsung login page to register.
- Fill out the required fields on the next page.
- Click "Confirm" on the next page to be sent a verification email.
- Check your inbox and open the verification email. Click "Verify Account".
- This will open the Account Verification page. Click "Start".
- You will be returned to the login page. Now you can login!

## Inside the Developer Portal

The Developer Portal is located at [devportal.samsungsami.io.](http://devportal.samsungsami.io) Make sure you bookmark this page, because the dashboard provides a convenient view of all your applications and device types.

### Creating an application

- If this is your first application, click the "Create Application" button on the Developer dashboard.
  - If you've already made an application, the button is accessed by clicking "Applications" in the top menu:<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/developer-portal-header.png)
- On the next page, fill out a name and redirect URL for your application.
- Choose an OAuth2 grant type. (See [Authentication](/sami/sami-documentation/authentication.html) for more details.)
- Choose "Read" and/or "Write" permissions for your application.
- Click the "Add Device Type" button to associate a device type with your application.
  - Select one of the published device types from the pulldown list.
  - Choose "Read" and/or "Write" permissions for the device type.
- You may click the "Add Device Type" button again to add more device types:<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/create-application-form.png)
- When you are done, click "Save Application". You will be returned to your list of applications.

#### How to find your application ID

You will need your application ID (called a client ID in the Developer Portal) to use in API calls. Here's how to locate it.

- Click either "Applications" in the top menu or "View All" under the list of Applications on your dashboard.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/dashboard-application.png)
- This brings up your list of applications.
- Under the application, click "Show Client ID & Secret".
  - The application ID is the string found next to "Client ID".<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/application-client-id-reveal.png)


### Creating a device type

Creating and publishing a device type makes it available to all developers that want to store data in SAMI using a client of this device type.

You will also need to [learn how to write a Manifest](/sami/sami-documentation/the-manifest.html) for your device type. 

- Click "Device Types" in the menu at the top of the Developer Portal.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/developer-portal-header.png)
- Click the "Add Device Type" button.
- Fill out the name and unique name for your device type. 
- Paste your Manifest in the box.
  - If your Manifest is not correctly formatted, you won't be able to create the device type. [Here's how to write a Manifest.](/sami/sami-documentation/the-manifest.html)<br /><br />
  ![SAMI architecture overview](/images/docs/sami/sami-documentation/create-device-type-form.png)
- Click the "Create Device Type" button. You will be returned to the dashboard with your new device type on the list.
  - The device type initially has a "Pending" status. Once we have reviewed your Manifest, you will be sent an email notifying you of a change in status.
    - If the device type is Approved, you can immediately Publish the device type.
      - From the dashboard, click the name of your device type.
      - On the next page, click the "Publish" button.<br /><br />
      ![SAMI architecture overview](/images/docs/sami/sami-documentation/device-type-publish.png)
    - If the device type is Rejected, you will have to resubmit (see below).

### Updating a device type

- From the dashboard, click the name of the device type you want to update.
- On the next page, click the "Add New Version" button.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/device-type-update.png)
- Paste your new Manifest into the box on the next page.
- Click "Create Device Type Version".
  - On the dashboard, you will see a new version number and status for your device type.

## Inside the User Portal

The User Portal is located at [portal.samsungsami.io.](http://portal.samsungsami.io) This is where users can access their connected devices and view their data on SAMI. Here's how to add a new device.

### Connecting a device

- Click "+ Connect another device..." in the User Portal.<br /><br />
![SAMI architecture overview](/images/docs/sami/sami-documentation/connect-another-device.png)
- In the box, start typing the name of your device. 
  - The available options will pop up. Select one.
- Click the "Connect Device..." button.