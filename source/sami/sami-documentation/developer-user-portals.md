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

The Developer Portal is located at [devportal.samsungsami.io](http://devportal.samsungsami.io). 

### Creating an application

- If this is your first application, click the "+ New Application" button.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/firstapplication.png){:.retain-width}
  - Otherwise, the "+ New Application" button is accessible by clicking through to view your list of applications.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/applicationnav.png){:.retain-width}
- Fill in an application name and description.
- Choose an OAuth2 grant type and a redirect URL. (See [Authentication](/sami/sami-documentation/authentication.html) for more details.)
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/appcreation.png){:.retain-width}
- Click "Save Application". This takes you to a detailed view of your applications.
- Set permissions for your application.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/apppermissions.png){:.retain-width}
  - Choose "Read" and/or "Write" permissions.
    - You may also "Set Permissions for a Specific Device". 
    - Select a published device type from the pulldown that appears after clicking this option.
    - Choose "Read" and/or "Write" permissions for the device type.
- Click "Save".

### How to find your application ID

You will need your application ID (called a client ID in the Developer Portal) to use in API calls. Here's how to locate it.

- Click "Applications" in the top menu to view your list of applications.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/applicationnav.png){:.retain-width}<br><br>
- To the right, click "Show Client ID & Secret".
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/appsecret.png)
  - The application ID is the string found next to "Client ID".
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/appinfo.png){:.retain-width}

### Creating a device type

Creating and publishing a device type makes it available to all developers that want to store data in SAMI using a client of this device type.

- If this is your first device type, click the "+ New Device Type" button.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/firstdevicetype.png){:.retain-width}
  - Otherwise, the "+ New Device Type" button is accessible by clicking through to view your list of device types.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/devicetypenav.png){:.retain-width}
- Enter a display name and unique name (a formatted example is given) for your device type.
- Click "Create Device Type." This takes you to a detailed view of your device types.
- Click "Create Manifest" to enter Simple Manifest creation.
  - You may also "Switch to Advanced" to paste an [Advanced Manifest in Groovy](/sami/sami-documentation/the-manifest.html). After doing so, click "Submit Manifest" and skip down to [Publishing a device type](#publishing-a-device-type). You will receive feedback or an update on the status of your Manifest within 1 business day.<br>   
  ![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/manifestcreation.png)
- Enter at least one field name, data type and unit. The form auto-suggests [standard fields and units](https://blog.samsungsami.io/development/portals/2015/08/06/see-all-the-standard-fields-and-actions-in-sami.html) as you type. You may also click the "Browse" links to see all the available options. Click "Save".
- Click the "Device Actions" tab to optionally add Actions the device type is capable of receiving. As with the device fields, the form auto-suggests [standard Actions](https://blog.samsungsami.io/development/portals/2015/08/06/see-all-the-standard-fields-and-actions-in-sami.html) as you type, or you may click "Browse" to see the Actions that are already available. Click "Save".
- After you have entered all fields and Actions for your Simple Manifest, click the "Activate Manifest" button on the corresponding tab to enable your Simple Manifest.

### Publishing a device type

- Once your device type has a Manifest, you may want to publish the device to make it available to all SAMI developers. By default, it has a status of Private.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/privatestatus.png){:.retain-width}
- To publish the device type, you must populate the Device Info page. Click the "Device Info" link to the left.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/deviceinfolink.png){:.retain-width}
- Add a description and choose at least one category and tag. Click "Save Changes".
- You may now change the Private status by clicking the pulldown and then the "Publish..." button.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/publishbutton.png){:.retain-width}

### Updating a device type

![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/newmanifest.png){:.retain-width}

- You can update your Manifest by clicking the "Manifest" link to the left.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/manifestlink.png){:.retain-width}
- Click "+ New Version" to create a new Manifest.
  - Alternatively, click the arrow icon to upload a JSON snippet that defines the fields and Actions.
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/manifestjson.png){:.retain-width}
- After updating, you will see a new Manifest version number and status for your device type.


## Inside the User Portal

The User Portal is located at [portal.samsungsami.io.](http://portal.samsungsami.io) This is where users can access their connected devices, view their data on SAMI and create Rules for devices. 

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

![SAMI generate device token](/images/docs/sami/sami-documentation/generate-device-token.png){:.retain-width}

Click "GENERATE DEVICE TOKEN..." to get a device token for this device. When you are ready to revoke the token, click "REVOKE TOKEN".

### Creating a Rule

With this feature, you can create Rules for triggering device [Actions](/sami/sami-documentation/the-manifest.html#manifests-that-support-actions) based on the contents of SAMI messages. 

![SAMI Rules](/images/docs/sami/sami-documentation/SAMI_Rules.png){:.lightbox}

You define a Rule by selecting device fields and values, conditionals, and commands to send. The process looks like this:

![SAMI Rules](/images/docs/sami/sami-documentation/rulesnav.png)

- Click "Rules" in the User Portal navigation menu.
- This will take you to the Rule creation page.
- In the IF pane, select a device from your device list. This will bring up the fields defined in its Manifest.
![SAMI Rules](/images/docs/sami/sami-documentation/ifdevice.png)
  - Now select a field to use.
- In the next dialog, choose a statement such as "is equal to" or "is more than", and then specify a value.
- In the THEN pane, select a device and a corresponding command. This may be a standard Action or a custom command you write in JSON.
![SAMI Rules](/images/docs/sami/sami-documentation/thendevice.png)
- Click "Save Rule". Note the description auto-populates from your choices.
- You will be taken to your Rules dashboard. Here you can edit, clone, test, enable/disable and delete your Rules.
![SAMI Rules](/images/docs/sami/sami-documentation/tworules2.png){:.lightbox}

Read [**our blog post**](https://blog.samsungsami.io/data/rules/iot/2015/09/23/sami-rules-make-your-devices-work-together.html) to learn more about Rules.
{:.info}