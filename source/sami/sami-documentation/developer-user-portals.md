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

- Click "+ New Application" in the menu at the top of the Developer Portal.
![Developer Portal](/images/docs/sami/sami-documentation/devportal-dashboard-createnew.png)
- Fill out a name, short description, details (in rich text) and redirect URL for your application. Click "Save Application". 
- This takes you to the Application Detail view, where you can enter and edit more information.
  - **Permissions**: Choose an OAuth2 grant type (see [Authentication](/sami/sami-documentation/authentication.html) for more details) and "Read" and/or "Write" permissions.
    - You can also "Set Permissions for a Specific Device" by clicking this option and selecting a published device type from the menu. Doing so will reveal the device type ID.
    ![Developer Portal](/images/docs/sami/sami-documentation/devportal-application-adddevicetype.png)
    - Click "+ Add Device Type" to add more device types.
  - **App Store**: Your publisher name, publisher URL and support URL are required fields:
    ![Developer Portal](/images/docs/sami/sami-documentation/devportal-application-pubinfo.png)
    - You can also paste your privacy policy and Terms of Use (in rich text) and add install URLs. 
    - Select relevant categories from the list and write tags (separated by spaces) to make your application more discoverable by other developers and users.
  - **Images**: Upload relevant images for your application's entry (the specs are on the page).
- When you are done on each page, be sure to click "Save".

#### How to find your application ID

You will need your application ID (also called a client ID) to use in API calls. Here's how to locate it.

- Click the relevant application name on your dashboard.
- This brings up the Application Detail view.
- Click **App Info** in the left navigation bar.
- Now click "Show Client ID & Secret".
![Reveal client ID](/images/docs/sami/sami-documentation/devportal-application-clientid.png)
  - The application ID is the string found next to "Client ID".
![Reveal client ID](/images/docs/sami/sami-documentation/application-client-id-reveal-3.png)

### Creating a device type

Creating and publishing a device type makes it available to all developers that want to store data in SAMI using a client with this device type.

You will also need to [learn how to write a Manifest](/sami/sami-documentation/the-manifest.html) for your device type. 

- Click "+ New Device Type" in the menu at the top of the Developer Portal.
![Developer Portal](/images/docs/sami/sami-documentation/devportal-dashboard-createnew.png)
- Fill out the display name, unique name (a format example is given) and short description for your device type.
  ![Create a device type](/images/docs/sami/sami-documentation/devportal_newdevicetype.png)
- Click the "Create Device Type" button.
- This takes you to the Device Type Detail view, where you can enter and edit more information.
  - **Manifests**: Click "+ New Version" to create a Manifest for your device type.
    - Choose whether to create a Simple Manifest or Advanced Manifest. [The Manifest](/sami/sami-documentation/the-manifest.html) explains the differences between them and what goes into creating one.
  - **App Store**: Your manufacturer name, manufacturer URL and support URL are required fields.
    ![Developer Portal](/images/docs/sami/sami-documentation/devportal-application-manuinfo.png)
    - You can also paste your privacy policy and Terms of Use (in rich text) and add a purchase URL. 
    - Select relevant categories from the list and write tags (separated by spaces) to make your device type more discoverable by other developers and users.
  - **Images**: you can upload relevant images for your device type's entry (the specs are on the page).

### Publishing a device type

All device types are created as "Private" by default. If you want other SAMI developers to be able to use your device type, you need to Publish it. If you used a Simple Manifest in the steps above, the device is automatically ready to be published. 

If you used an Advanced Manifest, the device type initially has a "Pending" status. Once we have reviewed your Manifest, you will be sent an email notifying you of a change in status. If the device type is Approved, you can immediately Publish the device type:

  - From the dashboard, click the name of your device type.
  - On the next page, click "Status" on the left.
  - Click the "Publish" button.

![Publish a device type](/images/docs/sami/sami-documentation/publish-device-type.png)

If your Manifest for the device type was Rejected, you will first have to resubmit (see below).

### Updating a device type

![SAMI architecture overview](/images/docs/sami/sami-documentation/device-type-update.png)

- From the dashboard, click the name of the device type you want to update.
- On the next page, click "Manifests" on the left.
- Click the "+ New Version" button.
- On the next page, submit a new Simple Manifest or Advanced Manifest.
- Click "Save Manifest".

## Inside the User Portal

The User Portal is located at [portal.samsungsami.io.](http://portal.samsungsami.io) This is where users can access their connected devices and view their data on SAMI. Here's how to add a new device.

Our [**Hello, World!**](/sami/sami-documentation/hello-world.html) guide puts the User Portal functionality into context.
{:.info}


### Connecting a device

<div  class="photo-grid" style="max-width: 512px;">
![SAMI architecture overview](/images/docs/sami/sami-documentation/connect-another-device.png)
</div>

- Click "+ Connect another device..." in the User Portal.
- In the box, start typing the name of your device. 
  - The available options will pop up. Select one.
- Click the "Connect Device..." button.

[**Read our blog**](https://blog.samsungsami.io/portals/datavisualization/2015/01/09/opening-the-user-portal.html) to learn about the User Portal's powerful Data Visualization feature.
{:.info}

### Managing a device token

Click the name of a connected device in the User Portal. A window like the following will appear. 

![SAMI generate device token](/images/docs/sami/sami-documentation/generate-device-token.png)

Click "GENERATE DEVICE TOKEN..." to get a device token for this device. When you are ready to revoke the token, click "REVOKE TOKEN".