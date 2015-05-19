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
![Developer Portal](/images/docs/sami/sami-documentation/developer-portal-header.png)
- On the next page, fill out a name and redirect URL for your application.
- Choose an OAuth2 grant type. (See [Authentication](/sami/sami-documentation/authentication.html) for more details.)
- Choose "Read" and/or "Write" permissions for your application.
- Click the "Add Device Type" button to associate a device type with your application.
  - Select one of the published device types from the pulldown list.
  - Choose "Read" and/or "Write" permissions for the device type.
- You may click the "Add Device Type" button again to add more device types:<br /><br />
![Create an application](/images/docs/sami/sami-documentation/create-application-form.png)
- When you are done, click "Save Application". You will be returned to your list of applications.

#### How to find your application ID

You will need your application ID (also called a client ID) to use in API calls. Here's how to locate it.

- Click either "Applications" in the top menu or "View All" under the list of Applications on your dashboard.
- This brings up your list of applications, sorted by name.
- Click the relevant application name. This brings up a submenu.
- Click "Edit App Info".
- Now click "Show Client ID & Secret" on the resulting page.
  - The application ID is the string found next to "Client ID".<br /><br />
![Reveal client ID](/images/docs/sami/sami-documentation/application-client-id-reveal-2.png)


### Creating a device type

Creating and publishing a device type makes it available to all developers that want to store data in SAMI using a client of this device type.

You will also need to [learn how to write a Manifest](/sami/sami-documentation/the-manifest.html) for your device type. 

- Click "Device Types" in the menu at the top of the Developer Portal.<br /><br />
![Developer Portal](/images/docs/sami/sami-documentation/developer-portal-header.png)
- Click the "+ New Device Type" button.
- Fill out the name, unique name and description for your device type. The form helps you format the unique name so that it is consistent with the other device types in SAMI. 
- Choose whether to create a Simple Manifest or Advanced Manifest. [The Manifest](/sami/sami-documentation/the-manifest.html) explains the differences between them and how they are created.<br /><br />
  ![Create a device type](/images/docs/sami/sami-documentation/create-device-type-form-2.png)
- Click the "Create Device Type" button. You will be returned to the dashboard with your new device type on the list.

### Publishing a device type

All device types are created as "Private" by default. If you want other SAMI developers to be able to use your device type, you need to Publish it. If you used a Simple Manifest in the steps above, the device is immediately ready to be published. 

If you used an Advanced Manifest, the device type initially has a "Pending" status. Once we have reviewed your Manifest, you will be sent an email notifying you of a change in status. If the device type is Approved, you can immediately Publish the device type:

  - From the dashboard, click the name of your device type.
  - On the next page, click "Status" on the left.
  - Click the "Publish" button.

![Publish a device type](/images/docs/sami/sami-documentation/publish-device-type.png)

If your Manifest for the device type was Rejected, you will first have to resubmit (see below).

### Updating a device type

<div  class="photo-grid" style="max-width: 512px;">
![SAMI architecture overview](/images/docs/sami/sami-documentation/device-type-update.png)
</div>

- From the dashboard, click the name of the device type you want to update.
- On the next page, click "Manifests" on the left.
- Click the "+ New Version" button.
- On the next page, submit a new Simple Manifest or Advanced Manifest.
- Click "Save Manifest".

## Inside the User Portal

The User Portal is located at [portal.samsungsami.io.](http://portal.samsungsami.io) This is where users can access their connected devices and view their data on SAMI. Here's how to add a new device.

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

### Manage a device token

Click the name of a connected device in the User Portal. The device information screen similar to the following is prompted. 
<div  class="photo-grid" style="max-width: 512px;">
![SAMI generate device token](/images/docs/sami/sami-documentation/generate-device-token.png)
</div>
Click "GENERATE DEVICE TOKEN..." to generate a device token for this device. After the token is generated, click "REVOKE TOKEN" to revoke the token.  