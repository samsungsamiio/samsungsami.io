---
title: "Using Cloud Connectors"
---

# Using Cloud Connectors

SAMI can [accept data from any device](/sami/sami-documentation/sending-and-receiving-data.html), but some devices already send data to a third-party cloud. In this case, SAMI can connect to the third-party cloud and use it as the data source for a device type. We have built an infrastructure called *Cloud Connectors* that enables you to connect the third-party cloud to SAMI. SAMI can then retrieve the device's data sent to that cloud.

A Cloud Connector brings a third-party device into the SAMI ecosystem. Once there, it can communicate with other devices through features like <a href="https://blog.samsungsami.io/data/rules/iot/2015/09/23/sami-rules-make-your-devices-work-together.html" target="_blank">SAMI Rules</a>, which uses SAMI messages to trigger device commands. SAMI enables cloud-connected devices to benefit from data aggregation and analytics <a href="https://blog.samsungsami.io/iot/events/2015/11/20/your-questions-about-sami-continued.html" target="_blank">across silos</a>.

This article gives a high-level overview on how to build a Cloud Connector. After reading this article, you should read our tutorial [Your First Cloud Connector](/sami/demos-tools/your-first-cloud-connector.html) to see an example.

![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/CC_Figure1.png){:.lightbox}

## Eligibility

You can build a Cloud Connector for the third-party cloud if it:

* Uses <a href="https://tools.ietf.org/html/rfc5849" target="_blank">OAuth 1</a> or [OAuth 2](/sami/sami-documentation/oauth2-flow-examples.html) for authentication.
* Provides subscribe/notification APIs for SAMI to subscribe and receive notifications about new data.
* Has public APIs to read data from the cloud.

## Building Cloud Connectors as a developer

There are two parts to building a Cloud Connector:

1. Create and configure a SAMI device type [configured to receive data from a cloud service](#configuring-a-device-type-as-a-cloud-connector) on SAMI.
1. Create and configure a "SAMI Connector" application on the third-party cloud. This enables SAMI devices of the above type to interact with that cloud.

For the second part, refer to the developer documentation of the third-party cloud to learn how to create an application. [Our Cloud Connector tutorial](/sami/demos-tools/your-first-cloud-connector.html) also gives an example. The rest of this section will focus on the first part only.

![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/CC_Figure2.png){:.lightbox}

### Configure a device type as a Cloud Connector

To connect a third-party cloud to SAMI, we first need to define a device type. All data coming in from the third-party cloud will be associated with this device type. We do this by [creating a new device type](/sami/sami-documentation/developer-user-portals.html#creating-a-device-type) in the SAMI <a href="https://devportal.samsungsami.io/" target="_blank">Developer Portal</a>.

Once you have entered the basic information, you will [**define a Manifest**](/sami/sami-documentation/the-manifest.html) for your device type. In doing so, reference the documentation for the third-party cloud. See [**Create device type Manifest**](/sami/demos-tools/your-first-cloud-connector.html#create-device-type-manifest) in our Cloud Connector tutorial to learn how third-party documentation formed the basis of our Manifest.
{:.info}

See [**SAMI Basics**](/sami/sami-documentation/sami-basics.html) for a refresher on how device types and Manifests work in SAMI.
{:.info}

For a Cloud Connector, we take a different path than usual. We first tell SAMI that the source is not a physical device but a cloud service. At the bottom of the Device Info tab, change the Device Data Source from "sends directly to SAMI" to "sends data to a cloud that SAMI will subscribe to". This will unfold two additional tabs for configuring the Cloud Connector:

![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/devicedatasource.png)

### Set authentication parameters

In the **Cloud Authentication** tab, you tell SAMI how to authenticate itself to the third-party cloud. You must select either OAuth 1 or OAuth 2, depending on which protocol is supported by the cloud.

<div  class="photo-grid" style="max-width: 512px;">
![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/CC_OAuth1.png){:.lightbox}
![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/CC_OAuth2.png){:.lightbox}
</div>

The following tables describe the parameters displayed in the Developer Portal that correspond to each authentication protocol.

Some parameters are obtained from third-party documentation. Other parameters, such as *Client ID* and *Client Secret*, are provided only once you define an application on the third-party cloud. See our tutorial to [**create a SAMI Connector application**](/sami/demos-tools/your-first-cloud-connector.html#create-a-moves-app) on the third-party cloud.
{:.info}

#### OAuth 1 parameters<br><br>

| Parameter name | Description | Default value
|----------------|-------------|---------------
|Request Token URL | The request token URL provided by the third-party cloud. |
|AccessTokenURL	| The access token URL provided by the third-party cloud. |
|AuthorizationURL	|The authorization URL provided by the third-party cloud. |
|Consumer Key	|The consumer ID provided by the third-party cloud. |
Consumer Secret	|The consumer secret provided by the third-party cloud. |
Signature Method	|The signature method to use in the Oauth 1 flow (HMAC-SHA1, RSA-SHA1, Plaintext)	|HMAC-SHA1
|Transmission Method	|When making an OAuth-authenticated request, protocol parameters as  well as any other parameter using the "oauth_" prefix SHALL be included in the request using one and only one of the following locations, listed in order of decreasing preference: HTTP Authorization header, HTTP request entity-body, HTTP request URI query	|HTTP Authorization header
|Credentials Parameters	|A map to identify the fields "userid", "token", "secret", "external_id" in the request	|Identity


#### OAuth 2 parameters<br><br>

| Parameter name | Description | Default value
|----------------|-------------|---------------
|Authorization URL	|The authorization URL provided by the third-party cloud.	| 
|Access Token URL	|The access token URL provided by the third-party cloud.	 |
|Client ID	|The client ID provided by the third-party cloud.	 |
|Client Secret	|The client secret provided by the third-party cloud.	 |
|scope	|The OAuth 2 scope parameter provided by the the third-party cloud.	 |
|Credentials Params	|A map to identify the following fields in the request: `access_token`, `token_type`, `refresh_token`, `expires_in`, `external_id`	|Identity

Two additional parameters, *redirect URL* and *notification URL*, are already populated and can be used to [**create a SAMI Connector application**](/sami/demos-tools/your-first-cloud-connector.html#create-a-moves-app) on the third-party cloud. Depending on your scenario, you may not need a notification URL.
{:.info}

### Configure the cloud subscription

The **Connector Code** tab is the final step of building a SAMI Cloud Connector. Here you can paste or upload Groovy code that tells SAMI how to interact with the third-party APIs in order to get data from the cloud. 

![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/CC_groovy.png)

You implement a Cloud Connector Groovy code using the <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk" target="_blank">Cloud Connector SDK</a>. The SDK's GitHub repository contains libraries, API reference documentation, sample codes, and a template project. You can perform unit and integration testing using the SDK.

#### About the Cloud Connector Groovy code

The code implements a derived class of `CloudConnector` base class from the SDK. The following diagram illustrates the major steps and methods. All these steps are performed for individual devices of a Cloud Connector device type. 

![SAMI Cloud Connectors](/images/docs/sami/sami-documentation/Cloud_Connector_Fig_3_v2.png){:.lightbox}

As seen in the above image, a SAMI Cloud Connector uses subscribe/notification APIs to access data in three steps:

1. **subscribe:** Subscribe to notification.
1. **notification:** Receive notification.
1. **fetch:** Call endpoint(s) to get data if needed.

The following methods are optional. Override a method only when it is necessary.

| Method | Description 
|-----------|------------
|`signAndPrepare`{:.param} | Called at the beginning of the methods initiated by SAMI (`subscribe`{:.param}, `fetch`{:.param} and `unsubscribe`{:.param}). It is a good practice to implement a generic process (i.e., add headers and signature) in this function.
|`subscribe`{:.param} | Called by SAMI when a [user has completed the Authentication process](#using-cloud-connectors-as-a-user) for a device. This method creates URLs (zero or more) to call an endpoint of the third-party cloud to subscribe to notifications for this device. 
|`onSubscribeResponse`{:.param} | Called by SAMI for each response from the third-party cloud to the requests created in `subscribe`{:.param}. It processes the result of the subscription. You may add additional logics if needed.
|`onNotification`{:.param} |Callback method triggered when the third-party cloud sends a notification to SAMI. This function extracts parameters within the notification. If the notification contains data, send data to SAMI. Otherwise, call `fetch`{:.param}.
|`fetch`{:.param}| Called by SAMI for each HTTP request returned by `onNotification`{:.param}. This function allows you to customize the request  using the selected device's parameters. The request will be used to fetch data on the third-party cloud.
|`onFetchResponse`{:.param} |Called by SAMI for each response from the third-party cloud to the requests created in `fetch`{:.param}. This method gets the data from the response and pushes it to SAMI.
|`unsubscribe`{:.param} |Called by SAMI when the user disconnects the device.
|`onUnsubscribeResponse`{:.param} |Called by SAMI for each response from the third-party cloud to the requests created in `unsubscribe`{:.param}.

[Our tutorial](/sami/demos-tools/your-first-cloud-connector.html) and <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk" target="_blank">SDK sample code</a> give examples of how to implement the above methods for a few clouds. 

#### About custom parameters

At the bottom of the Connector Code tab, there is a **Custom Parameters** table. You can store key-value pairs in this table and then access them in [your Cloud Connector Groovy code](#about-the-cloud-connector-groovy-code). 

In the Groovy code, you do not hardcode the values of the custom parameters. Read the values from the table instead. 
{:.info}

Later on, if you decide to change the value of a parameter, you only need to change its value in the table instead of changing the Groovy code. That is the benefit of using custom parameters—your Groovy code becomes more flexible. 

To access key-value pairs in the parameter table, use the object of `com.samsung.sami.cloudconnector.api.Context`{:.param} trait in the Groovy code. `Context`{:.param} has the following interface, per the <a href="https://github.com/samsungsamiio/sami-cloudconnector-sdk/tree/master/apidoc" target="_blank">Cloud Connector API doc</a>:

~~~scala
trait Context extends scala.AnyRef {
    def cloudId: String
    def clientId: String
    def clientSecret: String
    def scope: JList[String]
    def parameters: JMap[String, String]
    def debug(obj: Object)
    /** epoch in millis */
    def now(): Long
    def requestDefTools: RequestDefTools
}
~~~

Let's use an example to explain how to access the parameters in the table. Add two key-value pairs in the Custom Parameters table as shown in the screenshot below:

![SAMI Cloud Connector Custom Parameter table](/images/docs/sami/sami-documentation/CC_custom-param-table.png){:.retain-width}

Under the hood, the SAMI Developer Portal generates the following `parameters`{:.param} JSON object based on the table.

~~~json
{
  ...
    "parameters": {
      "myUrl": "http://www.foo.com/bar",
      "myNum": "10",
    },
  ...
}
~~~

You access these parameters via `Context`{:.param} in your Cloud Connector Groovy code as follows:

~~~java
@Override
Or<List<RequestDef>, Failure> subscribe(Context ctx, DeviceInfo info) {
    ...
    ctx.parameters()["myUrl"]...
    ctx.parameters()["myNum"]...
    ...
}
~~~

Not only can your Groovy code access all the parameters in the Custom Parameters table, but also some of the parameters in the [Cloud Authentication](#set-authentication-parameters) tab. Based on the `com.samsung.sami.cloudconnector.api.Context`{:.param} interface above, you can read the values of the three parameters of Cloud Authentication as follows:

~~~java
@Override
Or<List<RequestDef>, Failure> subscribe(Context ctx, DeviceInfo info) {
    ...
    ctx.clientId...
    ctx.clientSecret
    ctx.scope...
    ...
}
~~~

### Approval

Your Cloud Connector needs to be approved by the SAMI team before you can use it. Because SAMI executes your Groovy code, we will check that there is nothing harmful before uploading your code on the platform. You will receive an email on the status of your Groovy code within 24 hours of submitting it.

Recall that we have an approval process for [**Advanced Manifests submitted in the Developer Portal**](https://developer.samsungsami.io/sami/sami-documentation/the-manifest.html#manifest-certification). These are two different approval processes.
{:.info}

## Using Cloud Connectors as a user

Once a developer has created a Cloud Connector, any user can connect a device of this device type in the <a href="https://portal.samsungsami.io/" target="_blank">SAMI User Portal</a>. The device connection process is identical to the [normal flow](/sami/sami-documentation/developer-user-portals.html#connecting-a-device) except that the user must authenticate once with the third-party cloud, by clicking the "AUTHORIZE" button seen below:

![Moves authorization](/images/docs/sami/sami-documentation/userportal_authorize.png){:.retain-width}

The authorization process then starts:

![Moves authorization](/images/docs/sami/sami-documentation/movesauthorization.jpg){:.retain-width}