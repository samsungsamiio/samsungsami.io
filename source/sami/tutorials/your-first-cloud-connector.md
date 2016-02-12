---
title: "Your first Cloud Connector"
---

# Your first Cloud Connector

In this article we'll show you how to build a [Cloud Connector](/sami/sami-documentation/using-cloud-connectors.html) for the Moves cloud. <a href="https://www.moves-app.com/" target="_blank">Moves is an Android/iOS app</a> that tracks activity data. After reading this tutorial, you'll understand how to build a Cloud Connector for [any cloud](/sami/sami-documentation/using-cloud-connectors.html#eligibility) that interests you.

You should read [Using Cloud Connectors](/sami/sami-documentation/using-cloud-connectors.html) before diving into this tutorial. The <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk" target="_blank">Cloud Connector SDK repository</a> includes example Cloud Connector code for other clouds.

## Initial configuration

This tutorial assumes you are familiar with SAMI and the [web tools](/sami/sami-documentation/sami-basics.html#sami-tools). If this is your first time using SAMI, please see [Initial setup](/sami/demos-tools/your-first-application.html#initial-setup) in the Web app tutorial.

### Create a SAMI device type

First, let's configure a new SAMI device type as a Cloud Connector.

* Log into the SAMI <a href="https://devportal.samsungsami.io/" target="_blank">Developer Portal</a> and [create a new device type](/sami/sami-documentation/developer-user-portals.html#creating-a-device-type).
* Click the Device Info link.  
![SAMI Developer and User Portals](/images/docs/sami/sami-documentation/deviceinfolink.png){:.retain-width}
* Under the "Device Data Source" heading, check "Data is provided by a cloud service".

### Create a Moves app

In a new tab, create an application in the Moves developer portal to obtain the necessary authentication info.

Take a moment to familiarize yourself with the <a href="https://dev.moves-app.com/" target="_blank">**Moves documentation**</a>. Note that Moves uses OAuth 2, [**like SAMI**](/sami/sami-documentation/authentication.html).
{:.info}

* Log into the <a href="https://dev.moves-app.com/" target="_blank">Moves developer portal</a>. 
* Click on "Manage Your Apps" and then "Create a New App".
* Give your app a name like "SAMI Connector", enter a developer name, and click "Create".
* Navigate to the Development tab and copy the `Client ID` and `Client Secret`. You will need these in the next step. 
* Click "Save Changes".

### Configure SAMI authentication to Moves cloud

Now return to the SAMI Developer Portal in the first tab. You should be looking at the "Device Data Source" heading.

* Navigate to the Cloud Authentication tab under "Device Data Source".
* Choose "OAuth2" as AUTHENTICATION TYPE.
* Paste the `Client ID` and `Client Secret` you copied from Moves in the previous section.
* Fill in the following information from the <a href="https://dev.moves-app.com/docs/authentication" target="_blank">Moves Authentication doc</a>:
	* **Authorization URL:** `https://api.moves-app.com/oauth/v1/authorize`{:.param}
	* **Access token URL:** `POST https://api.moves-app.com/oauth/v1/access_token`{:.param}
	* **Credentials Parameters:** Expand this section and set `external_id` to `user_id`{:.param} to match the Moves doc.
	* **PERMISSION SCOPE:** default, activity, location
* Copy the `Redirect URL` and `Notification URL` displayed in Authentication. You will need these in the next step.
* Save your changes.

### Complete Moves setup

Finally, switch back to the Moves developer portal. You should be looking at the "Manage Your Apps" page.

* Navigate to the "Development" tab for your "SAMI Connector" app.
* Fill in the `Redirect URL` and `Notification URL` that you copied from SAMI in the previous section.

## Let's code

Use the <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk/" target="_blank">**Cloud Connector SDK**</a> for this section.
{:.info}

### Get source code and tools

* Download and install <a href="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html" target="_blank">JDK 8</a>.
* Clone the <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk" target="_blank">Cloud Connector SDK</a> repository from GitHub.
* Copy and rename `template` to e.g. `movestest`.
* Navigate to the `movestest` directory.

### Prepare Cloud Connector Groovy class

* Replace the contents of `src/main/groovy/com/sample/MyCloudConnector.groovy`{:.param} with [**MyCloudConnector.groovy**](#mycloudconnectorgroovy) at the end of this article.
* Compile and check: run `../gradlew classes`{:.param} from `movestest` directory. The command will download the required tools and libraries on demand. Build should be "SUCCESSFUL".

## Implementation details

The full Moves Cloud Connector Groovy code `MyCloudConnector.groovy`{:.param} is given [at the end of this article](#mycloudconnectorgroovy). 

You can use the following libraries to develop the Groovy code:

* <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk/tree/master/apidoc" target="_blank">SAMI Cloud Connector API</a>
* <a href="http://www.joda.org/joda-time/apidocs/index.html" target="_blank">joda-time 2.3</a> for date and time manipulation
* <a href="https://commons.apache.org/proper/commons-codec/archives/1.10/apidocs/index.html" target="_blank">commons-codec 1.10</a>
* <a href="http://www.scalactic.org/" target="_blank">scalactic 2.2.4</a>, which provides a few helper constructs including classes <a href="http://www.scalactic.org/user_guide/OrAndEvery" target="_blank">Or, Good, Bad</a>

Below we explain the major methods of `MyCloudConnector.groovy`{:.param}. Take note on the following:

`subscribe`{:.param}: This method is usually called to subscribe to notifications for this user. In this case, there is no need to implement a subscription because Moves subscribes your Cloud Connector to notifications once you provide a notification URL for your "SAMI Connector" app in the Moves developer portal ([see above](#authenticate-the-moves-app)).

`onNotification`{:.param}: This callback method is triggered when the Moves cloud sends a notification to SAMI. This function extracts parameters within the notification. Read the <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk/tree/master/apidoc" target="_blank">Cloud Connector API documentation</a> to understand the format of the notification parameters.

~~~
def Or<NotificationResponse, Failure> onNotification(Context ctx, RequestDef req) {
        def json = slurper.parseText(req.content)
        def extId = json.userId.toString()
        def storyLineFiltered = json.storylineUpdates.findAll{ reasonToFetchSummaryData.contains(it.reason) }
        def datesFromStoryLines = storyLineFiltered.collect { e ->
            //We try to recover a valid Date from the storyLine event, and use it to fetch summary data.
            String dtStr = (
                (e.endTime)?e.endTime:
                (e.startTime)?e.startTime:
                (e.lastSegmentStartTime)?e.lastSegmentStartTime:
                null
            )
            DateTime dt = (dtStr != null) ?DateTime.parse(dtStr, receivedDateFormat): DateTime.now()
            requestDateFormat.print(dt)
        }.unique()
        def requestsToDo = datesFromStoryLines.collect{ dateStr ->
            new RequestDef(summaryEndpoint(dateStr)).withQueryParams(queryParams)
        }
        new Good(new NotificationResponse([new ThirdPartyNotification(new ByExternalDeviceId(extId), requestsToDo)]))
    }
~~~

The above code parses the JSON content received in the request, extracts `userId`{:.param} (our external ID that links a Moves user to a [SAMI device ID](/sami/sami-documentation/sami-basics.html#device-id-and-device-type)), extracts Moves' <a href="https://dev.moves-app.com/docs/api_notifications" target="_blank">storyline updates</a>, and extracts date/time to later fetch data from Moves. For each date/time extracted, the code builds a request to fetch data using a base URL (`summaryEndpoint`{:.param}) and the date/time.

Next, to fetch data we simply add to the requests built in `onNotification`{:.param} the access token we received during authentication. (NOTE: We could also have done this in a `signAndPrepare`{:.param} function; refer to [Using Cloud Connectors](/sami/sami-documentation/using-cloud-connectors.html#configure-the-cloud-subscription).)

~~~
def Or<RequestDef, Failure> fetch(Context ctx, RequestDef req, DeviceInfo info) {
        new Good(req.addHeaders(["Authorization": "Bearer " + info.credentials.token]))
    }
~~~

### Receiving data

With `onFetchResponse`{:.param} we receive some data:

~~~
def Or<List<Event>, Failure> onFetchResponse(Context ctx, RequestDef req, DeviceInfo info, Response res) {
        switch(res.status) {
            case HTTP_OK:
                def content = res.content.trim()
                if (content == "") {
                    ctx.debug("ignore response valid respond: '${res.content}'")
                    return new Good(Empty.list())
                } else if (res.contentType.startsWith("application/json")) {
                    def json = slurper.parseText(content)
                    def events = json.collectMany { jsData ->
                        def ts = (jsData.date)? getTimestampFromDate(DateTime.parse(jsData.date, requestDateFormat)): ctx.now()
                        extractSummaryNotification(jsData, ts) + extractCaloriesIdle(jsData, ts)
                    }
                    return new Good(events)
                }
                return new Bad(new Failure("unsupported response ${res} ... ${res.contentType} .. ${res.contentType.startsWith("application/json")}"))
            default:
                return new Bad(new Failure("http status : ${res.status} is not OK (${HTTP_OK})"))
        }
    }
~~~

In the above code, if the response is a success (`HTTP_OK`{:.param}) we parse the JSON response. For each item received, we extract the timestamp and the data, and we create an event with the timestamp and the data (SAMI will normalize this data using the Manifest. See [About the Manifest](#about-the-manifest) for details.)

## Test the code locally

Now test the Groovy code, working in the `movestest` directory unless otherwise specified. (Check [Get source code and tools](#get-source-code-and-tools) to learn more.)

### Unit testing

Replace the contents of `src/test/groovy/com/sample/MyCloudConnectorSpec.groovy`{:.param} with [**MyCloudConnectorSpec.groovy**](#mycloudconnectorspecgroovy) at the end of this article.

Force-run the test by running command `../gradlew cleanTest test`{:.param}. The output of the test should be "BUILD SUCCESSFUL".

### Integration testing

You can manually perform integration testing using a local HTTP server. The SDK provides an easy way to run an HTTP (HTTPS) local server. The server runs your Cloud Connector so that you can test authentication and fetching data with the third-party cloud before uploading your code to the [SAMI Developer Portal](/sami/sami-documentation/developer-user-portals.html).

First configure Cloud Connector authentication locally. You should have already [configured the authentication to the Moves cloud](#configure-sami-authentication-to-moves-cloud) in the SAMI Developer Portal. This step is only necessary for testing your Cloud Connector on the local server.

Replace the contents of `src/main/groovy/com/sample/cfg.json`{:.param} with the following content. Note that `src/main/groovy/com/sample/cfg.json.sample`{:.param} details all availble parameters in the configuration.

~~~
{
    "authorizationUrl":"https://api.moves-app.com/oauth/v1/authorize",
    "accessTokenUrl":"https://api.moves-app.com/oauth/v1/access_token",
    "clientId":"YOUR_CLIENT_ID_IN_MOVE_DEV_PORTAL",
    "clientSecret":"YOUR_CLIENT_SECRET_IN_MOVE_DEV_PORTAL",
    "authType" : "OAuth2",
    "scope":[ "default", "activity", "location" ],
    "accessTokenUrlMapper":{
        "external_id":"user_id"
    },
    "statusAcceptNotification":200,
    "accessTokenMethod": "post"
}
~~~

Replace "YOUR_CLIENT_ID_IN_MOVE_DEV_PORTAL" and "YOUR_CLIENT_SECRET_IN_MOVE_DEV_PORTAL" with the Client ID and Client Secret values you [retrieved for your application in the Moves developer portal](/sami/demos-tools/your-first-cloud-connector.html#create-a-moves-app).
{:.warning}

Now configure and run Cloud Connector on the local server:

* Edit `src/test/groovy/utils/MyCloudConnectorRun.groovy`{:.param} if you want to change the port of the local server (9080 by default for HTTP and 9083 for HTTPS).
* NOTE: To receive notifications, **your server should be accessible via internet** (e.g., use a server accessible from the outside or use an SSH tunnel with port forwarding).
* The device type ID in the redirect URI is hardcoded to "0000".
* Temporarily update the configuration in the Moves developer portal to use your local server for authentication and notification.
	* Redirect URI: `http://localhost:9080/cloudconnectors/0000/auth`{:.param}
	* Notification URI: `http://ADDR:9080/cloudconnectors/0000/thirdpartynotifications`{:.param}, replacing `ADDR`{:.param} with your server's external address.
* In the terminal, run the test server `../gradlew runTestServer`{:.param}.
* Start subscribing to a device by loading `http://localhost:9080/cloudconnectors/0000/start_subscription`{:.param} in your Web browser.
* Follow instructions displayed on the Web page.
* Generate new data in the Moves app. Then the local server should receive a notification with the new data.
* In the console, the running test server should print a line "0000: queuing event Event(" for every event. Each event will create a SAMI message.

After finishing your integration testing, you should change the configuration on the third-party cloud to use SAMI instead of your local test server for authentication and notifications.
{:.warning}

If you successfully finish all steps in this section, congratulations! Your Cloud Connector Groovy code passes the test and is ready for submission.


## Upload Cloud Connector code to SAMI

Log back into the <a href="https://devportal.samsungsami.io/" target="_blank">SAMI Developer Portal</a> and click on your Device Type. Navigate to the Device Info page and find the Device Data Source heading near the bottom. 

Switch to the Connector Code tab and copy-and-paste the contents of your `src/main/groovy/com/sample/MyCloudConnector.groovy`{:.param} into the text box. You may also upload the file. Finally, save your changes. You are prompted to save the draft or submit it.

Once you submit it, your Cloud Connector code is in approval state. You should hear back from us within 24 hours.
{:.info}

## Create device type Manifest

As with all device types, you should create the Manifest for the Cloud Connector device type using either the <a href="https://blog.samsungsami.io/portals/development/data/2015/03/26/the-simple-manifest-device-types-in-1-minute.html" target="_blank">Simple Manifest</a> or [Advanced Manifest](/sami/sami-documentation/the-manifest.html) workflow. For this particular example, you can upload **manifest.json** (see below), which we have written and included with the SDK for your convenience.

In the SAMI Developer Portal, navigate to the Manifest page for your device type. Click on the dropdown icon next to the "+ New Manifest" button:

![Upload new Manifest](/images/docs/sami/demos-tools/newmanifestdropdown.png){:.retain-width}

Here you can upload <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk/blob/master/sample-moves/src/main/groovy/io/samsungsami/moves/manifest.json" target="_blank">manifest.json</a>, which has the following content: 

~~~
{
  "fields": [
    {
      "children": [
        {
          "name": "activity",
          "type": "CUSTOM",
          "valueClass": "STRING"
        },
        {
          "name": "group",
          "type": "CUSTOM",
          "valueClass": "STRING"
        },
        {
          "name": "duration",
          "type": "CUSTOM",
          "valueClass": "LONG"
        },
        {
          "name": "calories",
          "type": "CUSTOM",
          "valueClass": "LONG"
        },
        {
          "name": "steps",
          "type": "CUSTOM",
          "valueClass": "LONG"
        },
        {
          "name": "distance",
          "type": "CUSTOM",
          "valueClass": "LONG"
        }
      ],
      "name": "summary"
    },
    {
      "name": "caloriesIdle",
      "type": "CUSTOM",
      "valueClass": "Double",
      "unit": "StandardUnits.KILO_CALORIE",
      "isCollection": false,
      "description": "daily idle burn in kcal. Available if user has at least once enabled calories",
      "tags": []
    }
  ],
  "messageFormat": "json",
  "actions": []
}
~~~

Because this is a <a href="https://blog.samsungsami.io/portals/development/data/2015/03/26/the-simple-manifest-device-types-in-1-minute.html" target="_blank">Simple Manifest</a>, it is automatically approved.

### About the Manifest

Let's explain the Manifest you uploaded in the above step. 

The <a href="https://dev.moves-app.com/docs/api_summaries" target="_blank">Moves daily summary API</a> call returns a JSON array of dates and summaries. Each `summary`{:.param} JSON object is also a JSON array of activities. Below is an example of the response, which contains two dates and summaries:

~~~
[{"date":"20121213",
  "summary":[
     {"activity":"walking","calories":300},
     {"activity":"biking","calories":450}
  ],
  "caloriesIdle":1000,
  "lastUpdate":"20130317T121143Z"
 },
 {"date":"20121214",
  "summary":[
     {"activity": "zumba","duration": 1200, "calories": 500}
  ],
  "caloriesIdle":100,
  "lastUpdate":"20130317T121143Z"}
]
~~~

The [Cloud Connector Groovy code](#receiving-data) flattens the top layer of the JSON array into individual JSON objects but drops the `date`{:.param} and `lastUpdate`{:.param} objects. In addition, each `summary`{:.param} JSON array is further flattened into multiple `activity`{:.param} JSON objects. 

For example, the above response from Moves generates five JSON objects as follows. *Each object is the payload of one SAMI message.* This is our basis for defining `manifest.json`{:.param} above. SAMI relies on this Manifest to process messages with such payload.

~~~
{"summary":{"activity":"walking","calories":300}}

{"summary":{"activity":"biking", "calories":450}}

{"caloriesIdle":1000}

{"summary":{"activity": "zumba","duration": 1200, "calories": 500}}

{"caloriesIdle", 100}
~~~

## Test Cloud Connector as a SAMI user

Once your Cloud Connector is approved, go to the <a href="https://portal.samsungsami.io/" target="_blank">SAMI User Portal</a> and [connect a device](/sami/sami-documentation/developer-user-portals.html#connecting-a-device) using your newly created Cloud Connector device type. [Authorize the device](/sami/sami-documentation/using-cloud-connectors.html#using-cloud-connectors-as-a-user) to grant SAMI access to your Moves data.

Generate new data in your Moves app and synchronize your app to Moves cloud. In the SAMI User Portal, navigate to the "Data Logs" tab. You should see new data coming into the device you've just connected!

## Full Groovy code

### MyCloudConnector.groovy

~~~java
package com.sample
import org.scalactic.*
import org.joda.time.format.DateTimeFormat
import org.joda.time.*
import groovy.transform.CompileStatic
import groovy.transform.ToString
import groovy.json.JsonSlurper
import groovy.json.JsonOutput
import com.samsung.sami.cloudconnector.api_v1.*
import static java.net.HttpURLConnection.*
//@CompileStatic
class MyCloudConnector extends CloudConnector {
    static final mdateFormat = DateTimeFormat.forPattern("yyyy-MM-dd").withZoneUTC()
    static final queryParams = ["timeZone": "UTC"]
    static final receivedDateFormat = DateTimeFormat.forPattern("yyyyMMdd'T'HHmmssZ").withZoneUTC().withOffsetParsed()
    static final requestDateFormat = DateTimeFormat.forPattern("yyyyMMdd").withZoneUTC()
    static final reasonToFetchSummaryData = ["DataUpload"]
    JsonSlurper slurper = new JsonSlurper()
    def summaryEndpoint(String date) {
        "https://api.moves-app.com/api/1.1/user/summary/daily/" + date
    }
    @Override
    def Or<NotificationResponse, Failure> onNotification(Context ctx, RequestDef req) {
        def json = slurper.parseText(req.content)
        def extId = json.userId.toString()
        def storyLineFiltered = json.storylineUpdates.findAll{ reasonToFetchSummaryData.contains(it.reason) }
        def datesFromStoryLines = storyLineFiltered.collect { e ->
            //We try to recover a valid Date from the storyLine event, and use it to fetch summary data.
            String dtStr = (
                (e.endTime)?e.endTime:
                (e.startTime)?e.startTime:
                (e.lastSegmentStartTime)?e.lastSegmentStartTime:
                null
            )
            DateTime dt = (dtStr != null) ?DateTime.parse(dtStr, receivedDateFormat): DateTime.now()
            requestDateFormat.print(dt)
        }.unique()
        def requestsToDo = datesFromStoryLines.collect{ dateStr ->
            new RequestDef(summaryEndpoint(dateStr)).withQueryParams(queryParams)
        }
        new Good(new NotificationResponse([new ThirdPartyNotification(new ByExternalDeviceId(extId), requestsToDo)]))
    }
    @Override
    def Or<RequestDef, Failure> fetch(Context ctx, RequestDef req, DeviceInfo info) {
        new Good(req.addHeaders(["Authorization": "Bearer " + info.credentials.token]))
    }
    def isSameDay(DateTime d1, DateTime d2) {
        (d1.year== d2.year) && (d1.dayOfYear ==  d2.dayOfYear)
    }
    def isToday(DateTime d) {
        isSameDay(d, DateTime.now())
    }
    def getTimestampOfTheEndOfTheDay(DateTime date) {
        date.minusMillis((date.millisOfDay().get() + 1 )).plusDays(1)
    }
    /**
     * Since we recover the summary data of the day, we want to have a meaningful timestamp from source:
     * If the date is not today : the day is finished. We set the source timestamp to the last second of this past day.
     * If the date is today : the day is not finished, data can continue to evolve for the day, we set the timestamp to now()
     */
    def getTimestampFromDate(DateTime date, DateTimeZone dtz = DateTimeZone.UTC) {
        def now = new DateTime(dtz).toDateTime(dtz)
        def returnedDate = isSameDay(date, now)? now : getTimestampOfTheEndOfTheDay(date)
        returnedDate.getMillis()
    }
    def extractSummaryNotification(jsonNode, long ts) {
        if (jsonNode.summary) {
            jsonNode.summary.collect {js -> new Event(ts, "{\"summary\":" + JsonOutput.toJson(js) + "}")}
        } else {
            []
        }
    }
    def extractCaloriesIdle(jsonNode, long ts) {
        if (jsonNode.caloriesIdle) {
            [new Event(ts,"{\"caloriesIdle\":" + JsonOutput.toJson(jsonNode.caloriesIdle) + "}")]
        } else {
            []
        }
    }
    @Override
    def Or<List<Event>, Failure> onFetchResponse(Context ctx, RequestDef req, DeviceInfo info, Response res) {
        switch(res.status) {
            case HTTP_OK:
                def content = res.content.trim()
                if (content == "") {
                    ctx.debug("ignore response valid respond: '${res.content}'")
                    return new Good(Empty.list())
                } else if (res.contentType.startsWith("application/json")) {
                    def json = slurper.parseText(content)
                    def events = json.collectMany { jsData ->
                        def ts = (jsData.date)? getTimestampFromDate(DateTime.parse(jsData.date, requestDateFormat)): ctx.now()
                        extractSummaryNotification(jsData, ts) + extractCaloriesIdle(jsData, ts)
                    }
                    return new Good(events)
                }
                return new Bad(new Failure("unsupported response ${res} ... ${res.contentType} .. ${res.contentType.startsWith("application/json")}"))
            default:
                return new Bad(new Failure("http status : ${res.status} is not OK (${HTTP_OK})"))
        }
    }
}
~~~

### MyCloudConnectorSpec.groovy

~~~java
package com.sample
import static java.net.HttpURLConnection.*
import utils.FakeContext
import static utils.Tools.*
import spock.lang.*
import org.scalactic.*
import scala.Option
import org.joda.time.format.DateTimeFormat
import org.joda.time.*
import com.samsung.sami.cloudconnector.api_v1.*
import groovy.json.JsonSlurper
import utils.FakeContext
import static utils.Tools.*
class MyCloudConnectorSpec extends Specification {
    def sut = new MyCloudConnector()
    def parser = new JsonSlurper()
    def ctx = new FakeContext() {
        List<String> scope() {["default", "activity", "location"]}
        long now() { new DateTime(1970, 1, 17, 0, 0, DateTimeZone.UTC).getMillis() }
    }
 
    def apiNotification = '''{ "userId": 23138311640030064,
        "storylineUpdates": [
            {
                "reason": "DataUpload",
                "startTime": "20121312T072747Z",
                "endTime": "20121212T234417-0200",
                "lastSegmentType": "place",
                "lastSegmentStartTime": "20121213T082747Z"
            }
        ]
    }'''
    def apiStoryLineResponse = ''' [
        {
            "date": "20121213",
            "summary": [
                {
                    "activity": "walking",
                    "group": "walking",
                    "duration": 3333,
                    "distance": 3333,
                    "steps": 3333,
                    "calories": 300
                }
            ],
            "segments": [
                {
                    "type": "move",
                    "startTime": "20121212T100051+0200",
                    "endTime": "20121212T100715+0200",
                    "activities": [
                        {
                            "activity": "walking",
                            "group": "walking",
                            "manual": false,
                            "startTime": "20121212T100051+0200",
                            "endTime": "20121212T100715+0200",
                            "duration": 384,
                            "distance": 421,
                            "steps": 488,
                            "calories": 99,
                            "trackPoints": [
                                {
                                    "lat": 55.55555,
                                    "lon": 33.33333,
                                    "time": "20121212T100051+0200"
                                },
                                {
                                    "lat": 55.55555,
                                    "lon": 33.33333,
                                    "time": "20121212T100715+0200"
                                }
                            ]
                        }
                    ],
                    "lastUpdate": "20130317T121143Z"
                }
            ],
            "caloriesIdle": 1000,
            "lastUpdate": "20130317T121143Z"
        }
    ]'''
 
    def extId = "23138311640030064"
    def apiEndpoint = "https://api.moves-app.com/api/1.1"
    def device = new DeviceInfo("deviceId", Option.apply(extId), new Credentials(AuthType.OAuth2, "", "1j0v33o6c5b34cVPqIiB_M2LYb_iM5S9Vcy7Rx7jA2630pK7HIjEXvJoiE8V5rRF", Empty.option(), Option.apply("bearer"), ctx.scope(), Empty.option()), ctx.cloudId(), Empty.option())
    // def "add accessToken into requests about device, with Credentials"() {
    //     //nothing to do
    // }
    def "build requests on notification"(){
        when:
        def req = new RequestDef("").withMethod(HttpMethod.Post).withContent(apiNotification, "application/json")
        println("req.get "+req)
        def res = sut.onNotification(ctx, req)
        then:
        res.isGood()
        res.get() == new NotificationResponse([
            new ThirdPartyNotification(new ByExternalDeviceId(device.extId.get()), [
                new RequestDef(apiEndpoint + "/user/summary/daily/20121213").withQueryParams(["timeZone": "UTC"]),
            ]),
        ])
    }
    def "fetch summary 20121213"() {
        when:
        def req = new RequestDef(apiEndpoint + "/user/summary/daily/20121213").withQueryParams(["timeZone": "UTC"])
        def resp = new Response(HttpURLConnection.HTTP_OK, "application/json", apiStoryLineResponse)
        def res = sut.onFetchResponse(ctx, req, device, resp)
        then:
        res.isGood()
        //20121213 at 23h59:59 = 1355356799 seconds
        def timestamp_20121213=1355443199999L
        def events = [
            new Event(timestamp_20121213, """{"summary":{"activity":"walking","group":"walking","duration":3333,"distance":3333,"steps":3333,"calories":300}}"""),
            new Event(timestamp_20121213, """{"caloriesIdle":1000}""")
        ]
        cmpEvents(res.get(), events)
    }
}
~~~
