---
title: "Data collection with trials"

---

# Data collection with trials

This page covers the creation and management of SAMI trials using the [trials APIs](/sami/api-spec.html#trials).

A SAMI **trial** is a way for a user (called a trial administrator) to invite other users to share their data for a controlled amount of time and set of device types. You can become a trial administrator by [creating a trial](#creating-a-trial). Each trial may have one or more administrators, who must define one or more [device types](/sami/sami-documentation/sami-basics.html#device-id-and-device-type) accepted for the trial. 

Administrators can [invite users](#invite-participants-or-administrators) to become trial administrators or participants via email. Participants who accept their invitation must login to SAMI with their Samsung account credentials (or sign up for a new account) and select one or more of the device types that administrators have defined. When participants accept an invitation, they grant access to their data to trial administrators. Users may leave a trial at any time.

SAMI offers a Web portal [**for trial administrators**](https://trials-admin.samsungsami.io/) and a portal [**for trial participants**](https://trials.samsungsami.io/), covered in this [**blog post**](https://blog.samsungsami.io/data/trials/research/portals/2015/03/20/do-your-own-research-with-sami-trials.html). These applications, developed using the APIs described here, are also available [**on GitHub**](https://github.com/samsungsamiio/sami-trials-webapps).
{:.info}

The Trials Admin tool includes tools to set up a trial *session*, which allows the recording of metadata along with trial data. Read <a href="https://blog.samsungsami.io/data/trials/research/portals/2016/03/08/your-sami-trials-are-now-in-session.html" target="_blank">**this blog**</a> and see the [**API**](/sami/api-spec.html#sessions).
{:.info} 

For more information on the trials API, see the [API spec](/sami/api-spec.html#trials). Unless otherwise specified, the following API calls are intended *for trial administrators only.*

## Creating a trial

~~~
POST /trials
~~~

This call creates a new trial. This will also make you the trial owner and the owner of its participant and administrator groups. 

You may optionally include a list of `deviceTypes`{:.param} or `invitations`{:.param} in this call. The lists have the same format as in [Add device types](#add-device-types) and [Invite participants or administrators](#invite-participants-or-administrators). Including them here has the same result as creating the trial and then calling each method separately. 

**Example request**

~~~
{
  "name": "test trial",
  "description": "this is a test trial",
  "deviceTypes": [
    {
      "dtid": "181a0d34621f4a4d80a43444a4658150"
    },
    {
      "dtid": "vitalconnect_module"
    }
 ],
  "invitations": [
    {
      "email": "john@email.com",
      "invitationType": "participant"
    }
 ]
}
~~~

The response will be the trial in JSON format, where `id`{:.param} is a unique trial ID and `startDate`{:.param} and `endDate`{:.param} are timestamps (milliseconds) representing the start date (also the creation date) and end date of the trial. The end date will be "null" since the trial has just been created.

**Example response**

~~~
{
  "data":{
    "id": "b5f1fd9954b348a3a6999fbd698a4928",
    "ownerId": "7b202300eb904149b36e9739574962a5",
    "name": "test trial",
    "description": "this is a test trial",
    "aid": "62bb65ceaa304f7989922fefb6a45814",
    "clientSecret": "e02a63d400b44d798b1f9962d7a8b09b",
    "startDate": 1396224000000,
    "endDate": null
  }
} 
~~~

The response also includes `aid`{:.param} and `clientSecret`{:.param}. These are the application ID and client secret of the companion application that SAMI associates with each trial to allow you to access trial data programmatically (server side). This information may also be found through the [Trials Admin](https://trials-admin.samsungsami.io/) tool and in the response to [Find a specific trial](#find-a-specific-trial).

Trials created before April 2015 do not have a companion application. You must [update the trial application](#update-the-trial-application) to generate a new companion app.
{:.warning}

### Invite participants or administrators

Your next step will be to invite SAMI users to become participants or administrators of the trial. You will need to include the trial ID in the path.

~~~
POST /trials/<trialID>/invitations
~~~

This call sends an invitation that expires after 24 hours. In the request, `invitationType`{:.param} can be set to either `participant` or `administrator`.

**Example request**

~~~
{
  "email": "john@email.com",
  "invitationType": "participant"
}
~~~

The response will be the invitation in JSON format. `status`{:.param} indicates the invitation status, which will be `sent` in this response. 

To learn more about managing your invitations, please see the API spec: [Find trial invitations](/sami/api-spec.html#find-trial-invitations) and [Update a trial invitation](/sami/api-spec.html#update-a-trial-invitation).

**Example response**

~~~
{
  "data":{
    "id": "f252c2e77a68419eb6322a8fbae37bc9",
    "tid": "f5fc7af5fa6d4480b597e340bfff4450",
    "email": "john@email.com",
    "invitationType": "participant",
    "sentDate": "1395705600000",
    "acceptedDate": null,
    "expirationDate": "1395878400000",
    "revokedDate": null,
    "status": "sent"
  }
} 
~~~

### Add device types to the trial

~~~
POST /trials/<trialID>/devicetypes
~~~

To add a device type to your trial, you must include the trial ID in the path and specify the device type ID (`dtid`{:.param}) in the request. 

See [**Basics**](/sami/sami-documentation/sami-basics.html#device-id-and-device-type) for a reminder about the difference between device types and devices.
{:.info}

**Example request**

~~~
{
  "dtid": "dta38d91dfd9164e96a5dc74ef2305af43" 
}
~~~

**Example response**

~~~
{
  "data": {
    "tid": "unique_trial_id",
    "dtid": "dta38d91dfd9164e96a5dc74ef2305af43"
  }
}
~~~

### Connect user devices

~~~
POST /trials/<trialID>/participants/<userID>/devices
~~~

Only a *trial participant* may use this API call to connect their devices. This requires that they include the trial ID and [user ID](/sami/sami-documentation/sami-basics.html#user-id) in the path and specify the device ID (`did`{:.param}) in the request. 

Participants invited to your trial can also connect devices with the [Trial Participant](https://trials.samsungsami.io/) tool.
{:.info}

**Example request**

~~~
{
  "did": "4697f11336c540a69ffd6f445061215e"
}
~~~

**Example response**

~~~
{
  "data":{
    "tid": "unique_trial_id",
    "uid": "7b202300eb904149b36e9739574962a5"
    "did": "4697f11336c540a69ffd6f445061215e"
  }
}
~~~

## Managing your trials

### Find trials by user

~~~
GET /users/<userID>/trials
~~~

This call returns a list of all your current trials. You will need to specify your user ID in the path. To find the trials for which you are an admin, set the query parameter `role`{:.param} to `administrator`. You may call up the list of a participant's trials by passing their user ID and setting `role`{:.param} to `participant`.

This can be called by both administrators and participants.

**Example response**

~~~
{
  "data": {
    "trials": [
      {
        "id": "924228cf373b4e6ebc343cdf1366209e",
        "ownerId": "7b202300eb904149b36e9739574962a5",
        "name": "My First Trial",
        "description": "This is my first trial",
        "startDate": 1426868135000,
        "endDate": null
      }
    ]
  },
  "total": 1,
  "offset": 0,
  "count": 1
}
~~~

### Find a specific trial

~~~
GET /trials/<trialID>
~~~

You can search for a trial by its trial ID. This will return the trial in JSON format, including `aid`{:.param} and `clientSecret`{:.param} of the companion application for authentication purposes.

### Update a trial

~~~
PUT /trials/<trialID>
~~~

To modify a trial's name or description, you can pass `name`{:.param} and `description`{:.param} in a JSON payload. Descriptions are limited to 1500 characters.

**Example request**

~~~
{
  "name": "new trial name",
  "description": "this is a new trial description"
}
~~~

The response will be the updated trial in JSON format.

### Update the trial application

~~~
PUT /trials/<trialID>/application
~~~

If you need to generate a new client secret for your trial's companion application, you may use this call to change both the application ID and its client secret. All previously created application tokens will become invalid.

Include the trial ID in the path. The response will include a new `aid`{:.param} (application ID) and a new `clientSecret`{:.param}.

### Remove participants and administrators

Participants and administrators can be removed from a trial by using the following calls. For each, you will need the trial ID and the user ID of the participant or administrator.

~~~
DELETE /trials/<trialID>/participants/<userID>
~~~

Deleting a participant will also disconnect that participant's devices. The participant's data may no longer be accessed by the trial administrators.

~~~
DELETE /trials/<trialID>/administrators/<userID>
~~~

Administrators may not be removed from trials that have only one admin.

**Example response**

~~~
{
  "data":{
    "tid":"unique_trial_id",
    "uid":"03c99e714b78420ea836724cedcebd49"
  }
}
~~~

## Ending a trial

There are several different ways you can end a trial.

### Update the trial

~~~
PUT /trials/<trialID>
~~~

This is the call otherwise used to modify a trial name and description. In the JSON body, change `status`{:.param} to `stop`. 

In addition to setting the end date of the trial, this will delete any pending invitations to the trial and disallow further updates to the trial. Once ended, a trial cannot be restarted. However, you may still access historical data from the participants enrolled in the trial.

**Example request**

~~~
{
  "status": "stop"
}
~~~

### Delete the trial

~~~
DELETE /trials/<trialID>
~~~

This deletes the trial, the invitations, the list of administrators and participants, and any connected devices. Consequently, the trial data and other information about the trial will no longer be accessible. 

The response will be the deleted trial in JSON format.