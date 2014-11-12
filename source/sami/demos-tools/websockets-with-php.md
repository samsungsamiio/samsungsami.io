---
title: "WebSockets with PHP"

---
> This is stuff that is removed from original your-firs-application.md
> This is not ready for others to consume

#### Get a message from SAMI

This sample application sends a GET request to get the latest message on SAMI that were sent by the device. The URL looks like:

[https://api.samihub.com/v1.1/messages/last?count=1&sdids=aa31a240c0cc493ab74d86b00f268812](https://api.samihub.com/v1.1/messages/last?count=1&sdids=aa31a240c0cc493ab74d86b00f268812)

In the URL, "sdids" is the source device ID (our demo device) and "count" is a limit for the number of messages in the result. This example queries only one device, but you can query multiple source devices by adding more device ids in the URL.

> Please keep in mind you need to include the authorization header on every request you send to SAMI. The helper class of this sample class does this for you.

Now enhance the code to achieve the above functionality. Put the following html code in hello-sami.php, which adds a button on the page:

~~~html
<a class="btn getMessage">Get a message</a>
<p id="getMessageResponse">a message will be put here....</p>
~~~

Add the following javascript for the button, which sends a GET request and updates the page with the repsonse from SAMI. Particularly, the script calls get-message.php to send the request on background.

~~~javascript
<script>
$('.getMessage').click(function(ev){
    document.getElementById("getMessageResponse").innerHTML = "waiting for response";
    $.ajax({url:'get-message.php', dataType: "json", success:function(result){
            console.log(result);
            // Get the result and show it
            var message = result.data[0];
            document.getElementById("getMessageResponse").innerHTML = JSON.stringify(message);
          }
    });
});
</script>
~~~

Here is how get-message.php looks like. It uses the helper class to construct http GET request and send to SAMI.

~~~php
session_start();
require('sami.php');
$sami = new SAMI();
$sami->setAccessToken($_SESSION["access_token"]);
$messageCount = 1;
$response = $sami->getMessagesLast(SAMI::DEVICE_ID, $messageCount);
header('Content-Type: application/json');
echo json_encode($response);
~~~

### Get a device's historical information (messages)

Now we're ready to get some messages that were sent by the demo device. This is a GET request and URL will look like:

[https://api.samihub.com/v1.1/historical/normalized/messages?sdid=c1717a85481b4f2aa0a1b231a1905941&amp;count=10&amp;startDate=1&amp;endDate=1410468213824&amp;order=desc](https://api.samihub.com/v1.1/historical/normalized/messages?sdid=c1717a85481b4f2aa0a1b231a1905941&amp;count=10&amp;startDate=1&amp;endDate=1410468213824&amp;order=desc)

Where "sdid" is the source device ID (our demo device), "count" is a limit for the number of messages in the result, finally "startDate" and "endDate" are milliseconds based timestamps, which is the time window we're interested in.For this example, we query everything until the time of this writing, the order defines if you get the first N or the last N messages.

> Please keep in mind you need to include the authorization header on every request you send to SAMI. The helper class on the demo does this for you.

Using the helper class, the code looks like:

~~~php
<?php
# Parameters for the /historical/normalized/messages API
$messageCount = 10;
$startDate = 1;
$endDate = $sami->currentTimeMillis();
$order = "desc";
 
$messagesAsJSON = $sami->getMessages(SAMI::DEVICE_ID, $messageCount, $startDate, $endDate, $order);
?>
~~~


As a result, the helper class returns a JSON object, that you can loop to build some table rows for a HTML table:

~~~php
# Create the table rows to render the JSON result as a HTML table
$tableRows = '';
foreach($messagesAsJSON->data as $message){
    $tableRows .= ' <tr>
                        <td><code>'.$message->mid.'</code></td>
                        <td>'.json_encode($message->data).'</td>
                    </tr>';
}
~~~


Finally, we build the HTML table and write it to the page:

~~~html
echo '<h3>Get Messages</h3>
    <p>Latest '.$messageCount.' messages sent by simband device ID: '.SAMI::DEVICE_ID.'</p>
    <div>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>Message ID</th>
                    <th>Data</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                '.$tableRows.'
            </tbody>
        </table>
    </div>';
~~~

> There are few constants inside the helper class that specifies the values mentioned at the beginning of this document.

## Introducing websockets

SAMI has a websocket endpoint (/live) where the developer can listen for any new messages related to a user ID and access token.

For this tutorial we're about to add a led indicator that blinks in green when the websocket has activity, and we'll update in real time the table we rendered from PHP.

We start by adding the markup:

~~~html
<h3>Websocket activity</h3>
<div id="websocketActivity" class="red-off"></div>
~~~


To make it round and have color let's use this CSS style:

~~~css
 #websocketActivity {display:block;width:40px;height:40px;border-radius:50%;border:2px solid #aaa;margin:10px 10px 10px 50px;}
.red-on{background:#f00;}
.green-on{background:#0f0;}
.red-off{background:#822;}
.green-off{background:#282;}
~~~


Now let's add a very basic websocket client to the page:

~~~javascript
<script type="text/javascript">
    // The following code allows to connect to /live websocket API
    // Url looks like wss://api.samihub.com/v1.1/live?userId=712dc68dea5044d9b9461c16e369fa62&Authorization=bearer+d470c810863d454c91a7c258e70def27
    var wsUri = "<?php echo $sami->getLiveWebsocketUrl(); ?>";
    var connected = false;
     
    // Set websocket events
    function init() {
        websocket = new WebSocket(wsUri);
        websocket.onopen = function(evt) { onOpen(evt) };
        websocket.onclose = function(evt) { onClose(evt) };
        websocket.onmessage = function(evt) { onMessage(evt) };
        websocket.onerror = function(evt) { onError(evt) };
    } 
     
    // CONNECT: Set switch status and indicator color
    function onOpen(evt) {
        connected = true;
        $('#websocketActivity').removeClass().addClass('green-off');
    } 
     
    // DISCONNECT: Set switch status and indicator color
    function onClose(evt) {
        connected = false;
        $('#websocketActivity').removeClass().addClass('red-off');
    } 
     
    // MESSAGE: Update the UI
    function onMessage(evt) {
        // Blink the indicator on green
        $('#websocketActivity').removeClass().addClass('green-on');
        window.setTimeout(function(){ $('#websocketActivity').removeClass().addClass('green-off'); }, 100);
         
        // Insert the new message in the messages table
        var message = JSON.parse(evt.data);
        if($('#tableBody').children.length == 10){
            $('#tableBody:last-child').remove();
        }
        if(typeof message.mid == 'undefined'){
            // Pings and other control messages, are not persisted and do not have message id
            $('#tableBody').prepend('<tr><td><code>N/A</code></td><td>'+JSON.stringify(message)+'</td></tr>');
        } else {
            $('#tableBody').prepend('<tr><td><code>'+message.mid+'</code></td><td>'+JSON.stringify(message.data)+'</td></tr>');
        }
         
    } 
     
    function onError(evt) {
        console.log('SOMETHING IS WRONG: ' + evt.data);
    }
     
     
    // Javascript initialization
    $(document).ready(function(){
         
        init();
         
    });
</script>
~~~


### Some words about the tutorial implementation


*   When the page loads, the websocket client is initialized and connected to the SAMI /live websocket end point. For simplicity we provide the access token to the script straight from PHP.
*   When the websocket connects, it turns the indicator green by replacing its CSS classes.
*   When the websocket gets a message, turns on the indicator for 100ms and inserts the message into the table, removes a row to keep the same row count and avoid flooding the browser with HTML data.

    The websocket sends device messages but also other special messages like pings, these messages do not have any message ID and are not persisted, so if you refresh the page, those message will simply dissapear.



## Finally let's send a message to SAMI

As we have a websocket already connected to the /live websocket endpoint, we're going to get the message immediatly and it will be inserted in the table.

If everything was OK, you should be able to see something like this:

![](/images/docs/sami/code-samples/sami-first-app.png)

## Complete source code