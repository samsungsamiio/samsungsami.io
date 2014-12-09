---
title: "Your first Web app"

---

# Your first Web app

Our first tutorial uses PHP with a little JavaScript. These should interest anyone building a Web app or any service using SAMI.

We assume you know or understand the basics of PHP, HTML and JavaScript.
{:.info}

For this tutorial, we will use SAMI's [REST APIs](/sami/api-spec.html) and authenticate via OAuth2. If you are not familiar with OAuth2, you can read more about it in [Authorization](/sami/sami-documentation/authentication.html). But don't worry, we'll guide you through all the steps.

## Prerequisites

 * PHP 5.4 or higher
 * cURL support in PHP
 * Apache Web server (or equivalent HTTP server with PHP support)

## Initial setup

If this is your first time using SAMI, you will need to [create a Samsung account.](/sami/sami-documentation/developer-user-portals.html) You will also use the web tools we created to handle specific tasks:

- For developers creating apps, services and devices using SAMI, we created the [Developer Portal.](https://devportal.samsungsami.io) 

- Regular users of SAMI (and your apps) can manage permissions, connect devices and review their data at the [User Portal.](https://portal.samsungsami.io)

- The [API Console](https://api-console.samsungsami.io/sami) lets you execute API calls and see the results straight from your browser.

For the sake of simplicity in this tutorial, you take the role of both the application developer and the SAMI user. You will use the sample app to access your own device.
{:.info}

### Create an application

Follow [these instructions](/sami/sami-documentation/developer-user-portals.html#creating-an-application) to create an application using the Developer Portal. For this tutorial, select the following:

- Set "Redirect URL" for your application to `http://localhost:8000/samidemo/index.php`.
- Choose "Client Credentials Flow & Implicit Flow".
- Under "PERMISSIONS", click "Add Device Type" button. Choose "Sami Gear Fit" as the device type. Check both "Read" and "Write" permissions for this device type.

[Make a note of your client ID.](/sami/sami-documentation/developer-user-portals.html#how-to-find-your-application-id) This is your application ID, which you will need later.

### Connect a device

Follow [these instructions](/sami/sami-documentation/developer-user-portals.html#inside-the-user-portal) to create and connect a device with the User Portal. For this tutorial, select the following:

- Choose "Sami Gear Fit".

Now as a SAMI user, you have a device. The sample app will access your data on this device.

### Use the API Console

The purpose of using the API Console is to get the ID of your device created above. In the real world, your application should call a SAMI API to get the device ID of a user. For the sake of simplicity when using the sample app, you will use the API Console to do the same.

- Go to the [API Console.](https://api-console.samsungsami.io/)
- Click "Authenticate with SAMI".
  - Log into your Samsung account if you haven't already. Then you are authenticated.
- Now use the "Get Current User Profile" API call to get your user ID. 
  - Click on the name of the call, then click "Try it!". 
  - In the response body, find "id". This is your user ID:
![Alt text sample](/images/docs/sami/demos-tools/getUserIdOnAPIconsole.png){:.lightbox}
- Now use the "Get User Devices" API call to get your device ID. 
  - Fill in the "userId" input field using the user ID obtained in the above step. Then click "Try it!". 
  - In the response body, find the "Sami Gear Fit" device you created before. The device's "id" field is the device ID that we will use in the sample app:
![Alt text sample](/images/docs/sami/demos-tools/getDeviceIdOnAPIconsole.png){:.lightbox}

Great! You now have the client (application) ID and the device ID, which will be used in the sample app.

### Setup your local machine 

- Install a Web server and configure it to open port 8000 on localhost.
- Install PHP and enable cURL in PHP.
- Create a directory `samidemo` that is accessible via `http://localhost:8000/samidemo`. For example, set up `http://localhost:8000/` to access C:\MyWebsites on your Windows machine. Then create `samidemo` under C:\MyWebsites.

### Prepare the sample application files

- Copy all files of the [sample application](/sami/downloads/sami-demo-firstwebapp.zip) into the `samidemo` directory created above.
- In the following line in `index.php`, change `client_id`{:.param} to your application ID (accessible in the Developer Portal).

~~~html
<p>Please <a href="https://accounts.samsungsami.io/authorize?response_type=token&client_id=xxxxx">login</a></p>
~~~

- Change `CLIENT_ID`{:.param} and `DEVICE_ID`{:.param} to your real client and device IDs in the following lines in `SamiConnector.php`.

~~~php
<?php
const CLIENT_ID = "xxxxx";
const DEVICE_ID = "xxxxx";  
?>
~~~

## Demo

Before we dig in, here's a preview of how our simple Web app will work.

- Load  [http://localhost:8000/samidemo/index.php](http://localhost:8000/samidemo/index.php) in your browser. You will see the following page:
![SAMI first Web app](/images/docs/sami/demos-tools/sampleWebAppLoginScreen.png)
- Click "Login" and authenticate with the account you used so far.
- Once you complete authentication, you will be redirected to `hello-sami.php`. Now you can play with SAMI.
- Click "Send a message" to send a message to SAMI on behalf of your device.
- Click "Get a message" to get the latest message from your device on SAMI. Note that it may take up to a few seconds for your message to appear since the called API is not intended for real-time data streaming.
- After sending and receiving messages, your window should look like this:
![SAMI first Web app](/images/docs/sami/demos-tools/sampleWebAppSamiMessageScreen.png){:.lightbox}

## Implementation Details

This sample application consists of four PHP files. `SamiConnector.php` contains a helper class, and the other PHP files communicate to SAMI via the helper.

### Warm-up

We'll start with a basic HTML page. Our `index.php` initially looks like the following:

~~~html
<html lang="en">
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.1/css/bootstrap.min.css" rel="stylesheet">
    <title>SAMI First Web App</title>
</head>
<body>
    <h1>Hello!</h1>
    <p>Please <a href="https://accounts.samsungsami.io/authorize?response_type=token&client_id=YOUR_CLIENT_ID">login</a></p>
</body>
</html>
~~~

### Catch authentication callback and obtain access token

Now let's enhance `index.php` and add `hello-sami.php` to get the SAMI authorization token. This sample application uses the OAuth2 [implicit grant flow.](/sami/sami-documentation/authentication.html#implicit-method) After a successful login, SAMI calls back the redirect URL we set in the Developer Portal. The URL contains the access token, as seen in the following example:

~~~
http://localhost:8000/samidemo/index.php#expires_in=1209600&amp;token_type=bearer&amp;access_token=e77d0e4fc3e144429e062021f70894d3
~~~

Insert the following lines of JavaScript within the document body of `index.php`. After SAMI calls back, the script replaces the # with a ? and then reloads a new page `hello-sami.php`.

~~~javascript
<script>
query = window.location.hash.split("#");
if (query[1]) { 
    // SAMI accounts sends an URL fragment in the login callback,
    // Now make Web browser to load a new url
    window.location = "hello-sami.php?"+query[1];
}
</script>
~~~

After loading `hello-sami.php`, the following PHP code in that file obtains the access token from the query string and stores it into a session variable.

~~~php
<?php
session_start();
if (isset($_REQUEST['access_token'])) {
    $_SESSION['access_token'] = $_REQUEST['access_token'];
}
?>
~~~

### Call the SAMI APIs

In `hello-sami.php`, create a helper instance and set the access token to it.

~~~php
<?php
require('SamiConnector.php');
$sami = new SamiConnector();
$sami->setAccessToken($_SESSION['access_token']);
?>
~~~

Please see details of [**SamiConnector.php**](#sami-helper-class) at the end of the document or [**download**](/sami/downloads/sami-demo-firstwebapp.zip) the attached source code.
{:.info}

#### Send a message to SAMI

First, we'll send a message to SAMI on behalf of the device. The application sends a `POST` HTTP request to SAMI. The URL looks like this:

~~~
https://api.samsungsami.io/v1.1/messages/
~~~

The HTTP request needs to include the authorization header and the payload. The payload contains the device ID and data. The helper class assembles the request.

Please keep in mind that you need to include the authorization header on every request you send to SAMI. In this tutorial app, the helper class does this for you.      

Now let's enhance the code to achieve this functionality. By putting the following lines of HTML in `hello-sami.php`, we will add a button on the page:

~~~html
<a class="btn sendMessage">Send a message</a>
<p id="sendMessageResponse">Response will be put here....</p>
~~~

Now add the following JavaScript for the button, which sends a message and updates the page with the response from SAMI. Particularly, the script calls `post-message.php`{:.param} to send on background.

~~~javascript
<script>
// Sends a message using PHP
$('.sendMessage').click(function(ev){
    document.getElementById("sendMessageResponse").innerHTML ="waiting for response";
    $.ajax({url:'post-message.php', success:function(result){
        document.getElementById("sendMessageResponse").innerHTML = JSON.stringify(result);
        }});
});
</script>
~~~

Here is what `post-message.php` looks like. It uses the helper class to construct the HTTP `POST` request and then sends it to SAMI.

~~~php
<?php
session_start();
require('SamiConnector.php');
$sami = new SamiConnector();
$sami->setAccessToken($_SESSION["access_token"]);
$data ='{"stepCount":7994,"heartRate":100,"description":"Run","activity":2}'; // sami_gear_fit device
$payload = '{"sdid":"'.SamiConnector::DEVICE_ID.'", "data":'.$data.'}';
$response = $sami->sendMessage($payload);
header('Content-Type: application/json');
echo json_encode($response);
?>
~~~

The payload depends entirely on the device type you're using to send data to SAMI. The provided payload is for the device with type "SAMI Gear Fit".
{:.info}

Every time you send a message to SAMI and it is stored successfully, you will receive a message ID. The message ID will be useful if you need to query that message later. 

If something went wrong, you will receive an [error message.](/sami/api-spec.html#validation-and-errors)

#### Get a message from SAMI

Now get the latest message on SAMI that was sent by the demo device. The sample app sends a `GET` request to SAMI and the URL looks like this:     

~~~
https://api.samsungsami.io/v1.1/messages/last?sdids=c1717a85481b4f2aa0a1b231a1905941&count=1
~~~

In the URL, `sdids`{:.param} is the source device ID (the demo device you created) and `count`{:.param} is a limit for the number of messages in the result. This example queries only one device. You can add more source device IDs. For more details, please consult the [API specification.](/sami/api-spec.html#get-last-messages-normalized)  

Now let's enhance the code to achieve this functionality. Put the following HTML in `hello-sami.php`, which adds a button on the page:

~~~html
<a class="btn getMessage">Get a message</a>
<p id="getMessageResponse">a message will be put here....</p>
~~~

Add the following JavaScript for the button, which queries SAMI and updates the page with the response. Particularly, the script calls `get-message.php`{:.param} to send a `GET` request on background.

~~~html
<script>
// Get a message using PHP
$('.getMessage').click(function(ev){
  document.getElementById("getMessageResponse").innerHTML = "waiting for response";
  $.ajax({url:'get-message.php', dataType: "json", success:function(result){
     console.log(result);
     // Get the result and show it
     var message = result.data[0];
     document.getElementById("getMessageResponse").innerHTML = JSON.stringify(message);
     }});
});
</script>
~~~

Here is what `get-message.php` looks like. It uses the helper class to construct the HTTP `GET` request and then sends it to SAMI.

~~~php
<?php
session_start();
require('SamiConnector.php');
$sami = new SamiConnector();
$sami->setAccessToken($_SESSION["access_token"]);
$messageCount = 1;
$response = $sami->getMessagesLast(SamiConnector::DEVICE_ID, $messageCount);
header('Content-Type: application/json');
echo json_encode($response);
?>
~~~

If everything works, the latest message shows up on the screen.

### SAMI helper class

This is the helper class used in the tutorial. You can also [download](/sami/downloads/sami-demo-firstwebapp.zip) all the files used in this sample application. This helper uses [cURL](http://php.net/manual/en/intro.curl.php) functions to construct HTTP requests and then communicate with SAMI.

The next section will show you a simpler way to implement this helper class. That approach is based on [SAMI PHP SDK][1]. You do not need to handle `cURL` directly in approach.

Below is the source code of the helper class that does not use PHP SDK.

~~~php
<?php
/**
 * SAMI helper class that communicates to SAMI
 * */
class SamiConnector {
    # General Configuration
    const CLIENT_ID = "xxxxx";
    const DEVICE_ID = "xxxxx";
    const API_URL = "https://api.samsungsami.io/v1.1";
 
    # SAMI API paths
    const API_USERS_SELF = "/users/self";
    const API_MESSAGES_LAST = "/messages/last?sdids=<DEVICES>&count=<COUNT>"; 
    const API_MESSAGES_POST = "/messages";
     
    # Members
    public $token = null;
    public $user = null;
     
    public function __construct(){ }
     
    /**
     * Sets the access token and looks for the user profile information
     */
    public function setAccessToken($someToken){
        $this->token = $someToken;
        $this->user = $this->getUsersSelf();
    }
     
    /**
     * API call GET
     */
    public function getCall($url){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST,false);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HTTPGET, true);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Authorization:bearer '.$this->token));
        $json = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if($status == 200){
            $response = json_decode($json);
        }
        else{
            var_dump($json);
          $response = $json;
        }

       return $response;
    }
     
    /**
     * API call POST
     */
    public function postCall($url, $payload){
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, (String) $payload);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HEADER, false);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json', 'Authorization: bearer '.$this->token));
        $json = curl_exec($ch);
        $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        if($status == 200){
            $response = json_decode($json);
        }
        else{
            var_dump($json);
            $response = $json;
        }
        return $response;
    }
     
    /**
     * GET /users/self API
     */
    public function getUsersSelf(){
        return $this->getCall(SamiConnector::API_URL . SamiConnector::API_USERS_SELF);
    }
     
    /**
     * POST /message API
     */
    public function sendMessage($payload){
        return $this->postCall(SamiConnector::API_URL . SamiConnector::API_MESSAGES_POST, $payload);
    }
     
    /**
     * GET /historical/normalized/messages/last API
     */
    public function getMessagesLast($deviceCommaSeparatedList, $countByDevice){
        $apiPath = SamiConnector::API_MESSAGES_LAST;
        $apiPath = str_replace("<DEVICES>", $deviceCommaSeparatedList, $apiPath);
        $apiPath = str_replace("<COUNT>", $countByDevice, $apiPath);
        return $this->getCall(SamiConnector::API_URL.$apiPath);
    }
}
?>
~~~

### Simplify SAMI helper class with PHP SDK

This section shows you a simpler way to implement the helper class `SamiConnector`, using the [PHP SDK][1].

First you'll need to do a bit of setup:

- Create a directory `sdk` under your directory `samidemo`.
- Follow the instructions at [PHP SDK][1] to get the SDK source code. Copy all the source code to `samidemo/sdk`.
- Replace `SamiConnector.php` with [the new one.](/sami/downloads/SamiConnector.php)
- Change `CLIENT_ID`{:.param} and `DEVICE_ID`{:.param} to your real client and device IDs in `SamiConnector.php`.

Now you are ready to play with the newer version of the app. This version has been tested on Mac systems.

Below is the shorter and simpler source code of `SamiConnector.php` using the PHP SDK. There is no need to deal with the details of `cURL` in this version compared to [the older version](#sami-helper-class), since the PHP SDK handles that for you. 

~~~php
<?php
/**
 * SAMI helper class that communicates to SAMI via SAMI PHP SDK
 * */
require_once(dirname(__FILE__) .'/sdk/Swagger.php');
swagger_autoloader('MessagesApi');

class SamiConnector {
    # General Configuration
    const CLIENT_ID = "xxxxx";
    const DEVICE_ID = "xxxxx";
    const API_URL = "https://api.samsungsami.io/v1.1";
 
    # Members
    public $token = null;
    public $apiClient = null; 

    public function __construct(){ }
     
    /**
     * Sets the access token and looks for the user profile information
     */
    public function setAccessToken($someToken){
      $this->token = $someToken;
      $authHeader = 'bearer ' .$this->token;
      $this->apiClient = new APIClient(SamiConnector::CLIENT_ID, SamiConnector::API_URL, $authHeader);
    }
     
    /**
     * GET /historical/normalized/messages/last API
     */
    public function getMessagesLast($srcDeviceId, $countByDevice){
      try {
        $callAPI = new MessagesApi($this->apiClient);
        $method = 'getNormalizedMessagesLast';
        $params = array(
            "sdids"         => $srcDeviceId,
            "fieldPresence" => NULL,
            "count"         => $countByDevice
        );
        $result = call_user_func_array(array($callAPI, $method), array_values($params));
      } catch (Exception $e) {
        $result = '{"getMessageLast_exception":"'.$e->getMessage().'"}';
      }
      return $result;
    }
    
    /**
     * POST /message API
     */
    public function sendMessage($payload){
      try {
        $callAPI = new MessagesApi($this->apiClient);
        $method = 'postMessage';
        $params = array(
          "postParams" => $payload,
          );
        
        $result = call_user_func_array(array($callAPI, $method), array_values($params));
      } catch (Exception $e) {
          $result = "{sendMessage_exception:".$e->getMessage()."}";
      }
        return $result;
    }
}
?>
~~~

`SamiConnector.php` shows how to call the `MessagesApi` methods to get and post messages to SAMI. Browse the files under the directory `sdk`. You'll find many more API methods that are handy to use.

[1]: /sami/native-SDKs/php-SDK.html "SAMI PHP SDK"