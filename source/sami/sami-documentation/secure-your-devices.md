---
title: Secure your devices

---

# Secure your devices

SAMI supports secure device registration for communicating securely to devices. More specifically, SAMI guarantees the following:

- The device is genuine.
- The device owner has the device in hand.
- Every message exchanged between the device and SAMI is verified.
- The certificate cannot typically be forged or copied because it is "buried" in the device in a secure way.

If you are a device manufacturer, you should follow the below steps to create a secure device type:

- Obtain a client certificate and key for your device type.
- Work with the SAMI team to update your device type to support secure device registration.
- Implement logic in your device for secure registration with SAMI.
- Implement logic in your device for secure message exchange with SAMI. 

## Secure endpoints

These secure endpoints are used during secure registration and subsequent API calls after registration. 

~~~
https://s-api.samsungsami.io/v1.1/
wss://s-api.samsungsami.io/v1.1/
~~~

## Secure registration

The secure registration flow is different than the typical registration flow, in which an authenticated user creates a device, and can then request an access token for the device, or send data for the device as its logged-in owner.

Instead, the secure flow functions as follows:

- The device initiates the registration by authenticating via certificates.
- The logged-in user verifies ownership of the device by entering a PIN and the last 4 digits of the device certificate serial number in a browser.
- The device then completes the registration and obtains a device access token.
- Only a device that is identified by the certificates and the device token can send data to SAMI.

A registered device will appear in the [User Portal](https://portal.samsungsami.io/) on the list of user-owned devices.

The following sequence diagram of secure device registration illustrates the interactions among a user, a secure device, the user's browser and SAMI. You will need to implement the functionalities performed by "Device" in this diagram. 

![Secure Device Registration](/images/docs/sami/sami-documentation/secure-device-reg-seq-diagram.png){:.lightbox}

Below, we discuss the API calls made by the secure device. 

In our examples below, ‘curl’ must be built with OpenSSL v1.0.2 or higher to work with the secure endpoints.
{:.info}

### Initiate the registration

To initiate the registration process (Step 3 in the sequence diagram above), the device must pass a device type ID (`dtid`) and vendor device ID (`vdid`). The `vdid` is normally determined by the vendor, and must be unique for the device being registered. The API will return a 409 error if another device tries to register with the same `vdid` and `dtid`.

The following example shows how to make the API call using a curl command and the corresponding response. The response includes `rid` (request ID), `pin` (user PIN) and `nonce` (secret string, to be used in Step 15), which will be used in the subsequent API calls.

    localhost:~$ curl -X POST -k -i -H "Accept: application/json" -H "Content-Type: application/json" \
    -d '{"deviceTypeId":"dt430e40b477dd42ccb09cc83241ef9b99","vendorDeviceId":"a1b2c3d4"}' \
    --cert /path/to/client.cert --key /path/to/client-pri.key https://s-api.samsungsami.io/v1.1/cert/devices/registrations
    
    HTTP/1.1 200 OK
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Referer, User-Agent, Authorization
    Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS
    Allow: *
    Content-Type: application/json; charset=utf-8
    Content-Length: 96
    
    {"data":{"rid":"01329450db1b4a2d8e17acb4449b0f70","pin":"QJ39NCBO","nonce":"35cc3b62c8a544788a696a652d63d8c5","expiresOn":1423197470000}}

### Check registration status

At Step 8 of secure device registration, the user is presented `pin` and a registration URL. The user should navigate to this URL in their browser to move registration to the next phase.

During this process, the device can make the following **optional** API call to query the registration status. (This step is not illustrated in the sequence diagram.)

~~~
  GET /cert/devices/registrations/:rid/status
~~~

`nonce` is passed as data to this GET request. The below excerpt illustrates sending the HTTP request using curl, and the corresponding HTTP response.

    localhost:~$ curl -k -i -H "Accept: application/json" \
    --cert /path/to/client.cert --key /path/to/client-pri.key https://s-api.samsungsami.io/v1.1/cert/devices/registrations/01329450db1b4a2d8e17acb4449b0f70/status
    
    HTTP/1.1 200 OK
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Referer, User-Agent, Authorization
    Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS
    Allow: *
    Content-Type: application/json; charset=utf-8
    Content-Length: 29
    
    {"data":{"status":"PENDING_DEVICE_COMPLETION"}}

In the HTTP response, `status` could be one of the following strings:

- "PENDING_USER_CONFIRMATION": After initial registration; before user confirmation
- "PENDING_DEVICE_COMPLETION": After user confirmation; before device registration completes
- "REGISTERED": Device is registered
- "EXPIRED": Request is expired
- "REVOKED": Request is revoked due to another request being created for the same device

If "status" is "REGISTERED", the response will also contain `did`, the device ID.

The following error codes may be returned in the HTTP response:

- 404: Not found
- 403: Client certificates do not match the info in the request

### Complete the registration

When the user clicks the "Pair" button (Step 14), the device makes the final API call to complete the registration (Step 15). The following example shows sending the HTTP request via a curl command, and the corresponding reply:

    localhost:~$ curl -X PUT -k -i -H "Accept: application/json" -H "Content-Type: application/json" \
    -d '{"nonce":"35cc3b62c8a544788a696a652d63d8c5"}' --cert /path/to/client.cert --key /path/to/client-pri.key \
    https://s-api.samsungsami.io/v1.1/cert/devices/registrations/01329450db1b4a2d8e17acb4449b0f70
    
    HTTP/1.1 200 OK
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept, Referer, User-Agent, Authorization
    Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS
    Allow: *
    Content-Type: application/json; charset=utf-8
    Content-Length: 141
    
    {"data":{"accessToken":"e542564a82a5441a8bf20cb8c74cc43f","uid":"9c2717258a4d4092aeb3800e44629180","did":"0c9adcb292124f08955f11ea65c77e5d"}}

From now on, the `accessToken`{:.param} from the above response will be used with the certificate in subsequent calls sending messages to SAMI.

## Securely exchange information 

After secure registration, the device must make all subsequent API calls in the secure manner. The secure manner means that calls are made to a secure endpoint and contain both the device access token and the certificate. 

If a secure device makes an API call to a non-secure endpoint, it will get a 403 error.
{:.info}

The following examples illustrate sending messages from a secure device to SAMI via REST and WebSocket APIs.

### Securely post messages

This excerpt shows how to make such an API call and the corresponding HTTP response: 

    localhost:~$ curl -X POST -k -i -H "Accept: application/json" -H "Content-Type: application/json" \
    -H "Authorization: bearer e542564a82a5441a8bf20cb8c74cc43f" \
    -d '{"sdid":"0c9adcb292124f08955f11ea65c77e5d","data":{"stepCount":100,"timeInBed":200,"asleepTime":10,"calories":150}}' \
    --cert /path/to/client.cert --key /path/to/client-pri.key https://s-api.samsungsami.io:443/v1.1/message
    
    HTTP/1.1 200 OK
    X-Rate-Limit-Limit: 100/1000
    X-Rate-Limit-Remaining: 99/997
    X-Rate-Limit-Reset: 1423179332/1423180800
    Content-Type: application/json
    Content-Length: 51
     
    {"data":{"mid":"7d005bba074e4afab21d56e49f5301bd"}}

### Securely send and receive via WebSocket

The below sequence diagram gives an overview of sending and receiving data securely to and from SAMI using WebSockets:

![Secure Device Registration](/images/docs/sami/sami-documentation/secure-device-send-data-via-socket.png){:.lightbox}

Below are the details.

#### Setting up a bi-directional message pipe

Make the following WebSocket call to the secure WebSocket endpoint:

~~~
WebSocket /websocket
~~~

In the above call, you must pass the client certificate and the corresponding private key. You do not use the certificate in this call when [establishing the pipe](/sami/sami-documentation/sending-and-receiving-data.html#setting-up-a-bi-directional-message-pipe) between an ordinary device and SAMI. 

In addition, this call is only one for which you must provide the certificate for a secure session. Follow-up WebSocket calls in this session won't use the certificate.

#### Connecting the device to the pipe

After the pipe is established, the device sends a message with type "register" to connect itself to the session. Below is the example of the message payload:

~~~
{
  "sdid": "887750439b0548aba42a22c0ad26bc95",
  "Authorization": "bearer d77054a9b0874ba884499eef7768b7b9",
  "type": "register"
}         
~~~

#### Sending and receiving messages

After the device is connected into the secure pipe, it can securely send and receive messages to and from SAMI.

Below is an example of sending a message to SAMI in the established session:

~~~
send {"type":"message", "sdid":"887750439b0548aba42a22c0ad26bc95", "data":"data payload"}
~~~


