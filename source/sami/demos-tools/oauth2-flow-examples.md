---
title: "OAuth2 flow examples"

---

# OAuth2 flow examples 

[OAuth 2.0](http://tools.ietf.org/html/draft-ietf-oauth-v2-23) is a protocol that allows external apps to request authorization to private details in a user’s SAMI account without getting their passwords. You should have read the basics of [Authentication](/sami/sami-documentation/authentication.html). In this article, we use a few examples to illustrate how 3rd party apps can build OAuth 2.0 flow to interact with SAMI.

## Web application

A real world web application contains frontend components and backend servers. To improve security, it is recommended that the app uses the [Authorization Code method](/sami/sami-documentation/authentication.html#authorization-code-method) initially for an user to grant the app to access to her data on SAMI. Later on, the app could use the [Client Credentials method](/sami/sami-documentation/authentication.html#client-credentials-method) in the backend to get tokens to access the data without requiring users' further involvement.

### Obtain an access token by interacting with users

The Authorization Code method has two steps. First, the front end sends a HTTP request to get an authorization code. Then, the back end sends a HTTP request with client credentials and the obtained code to get an access token. 

#### Obtain an authorization code

The web app presents a UI for an user to login to SAMI. After the login button is clicked, the app makes the HTTP call to request an authorization code from SAMI. Below is the example of a HTTP GET request call:

    https://accounts.samsungsami.io/authorize?client_id=9628eef2a00d43d89b757b8d34373588&response_type=code&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write

Then the user is presented a Samsung Accounts screen, where she may sign in or create a new account. If the login is successful, the user will be asked to grant specific permissions on her data.

When the user clicks "Grant", the server (at the `redirect_uri`) will receive a HTTP request with an authorization code as follows:

    https://myapp.com/callback?code=0ee7fcd0abed470182b02cd649ec1c98&state=abcdefgh

#### Obtain an access token

Now your backend server exchanges the authorization code obtained above for an access token within 60 seconds before expiring. Since the client credentials will be used in this step, it is recommended that the backend server sends the request. The credentials (`client_id` and `client_secret`) are encoded in HTTP Authorization header. Consult [Sending client ID and client secret](/sami/sami-documentation/authentication.html#sending-clientid-and-clientsecret) for details on how to include them in a HTTP request. Below is the examples of the HTTP request sent by your backend server and the response:

**Example request** 

~~~
POST /token HTTP/1.1
Host: accounts.samsungsami.io
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write
~~~

**Example response** 

~~~~json
{
    "access_token":"2YotnFZFEjr1zCsicMWpAA",
    "token_type":"bearer",
    "expires_in":3600,
    "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA"
}
~~~~

Now your web application uses the token to make API calls to SAMI to access the correpsonding user's data until the token expires or the permissions are revoked.

In the future, you could continue to use this flow to get an access token of a user by involving her to interact with UI of your web app. The future interaction via UI only requires the user to login, and does not require the user to grant the permission again unless she revokes or changes the permissions.

It is better that the web app performs API calls to SAMI on behalf of a user without prompting this user to login again. This method is elaborated in the next section.

### Obtain an access token without user's further interaction

Once a user has granted the web app the permission to her data on SAMI as above, the backend server of the app can request an access token without user's further interaction. This can be done by refreshing a token or using the Client Credenitals method. 

In either way, the HTTP calls must be done at the backend server because it requires passing the credentials (`client_id` and `client_secret`). The credentials are encoded in HTTP Authorization header. Consult [Sending client ID and client secret](/sami/sami-documentation/authentication.html#sending-clientid-and-clientsecret) for details on how to include them in a HTTP request.

The token obtained using the Client Credentials method can get data of all the users that granted permissions to that app while the token obtained by refreshing a token can get data of a specific user.
{:.info}

#### Refresh a token

The backend server can obtain a new access token by exchanging a previously issued refresh_token during the flow of the Authorization Code method. The new token allows access to the data of the specific user. Please consult [token refreshing](/sami/sami-documentation/authentication.html#refresh-a-token) for more details.

#### Use Client Credentials method

As an alternative to refreshing tokens, the backend server can use the [Client Credentials method](/sami/sami-documentation/authentication.html#client-credentials-method) to get new tokens without prompting users again. 

Below is the examples of the HTTP request sent by your backend server and the response:

**Example request**

~~~ 
POST /token HTTP/1.1
Host: accounts.samsungsami.io
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&scope=read,write
~~~

**Example response**

~~~~
{
    "access_token":"2YotnFZFEjr1zCsicMWpAA",
    "token_type":"bearer",
    "expires_in":3600
}
~~~~

## Mobile application

Depending on if you have backend servers to work with your mobile application, you have different options to design your authentication flows.

### Without backend servers

Lets call a mobile application that does not have backend servers to work with the standalone mobile app. This type of application is less secure and cannot protect the client secret enough. Therefore, it is recommended to use the [Implicit method](/sami/sami-documentation/authentication.html#implicit-method) in a standalone mobile app.

The Implicit method is straightforward to use. It takes one step for a mobile app to get the access token. Please consult the [Implicit method](/sami/sami-documentation/authentication.html#implicit-method) for more details. The following are the examples of HTTP GET request sent by the mobile app:

**Example request**

    https://accounts.samsungsami.io/authorize?client_id=9628eef2a00d43d89b757b8d34373588&response_type=token&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write

After an user successfully logins and grants specific permissions on her data, the mobile app will receive a redirection response as the following:

**Example response**

~~~~ 
HTTP/1.1 302 Found
Location: http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=bearer&expires_in=7200
~~~~

Instead of redirecting, the mobile app extracts the access token from the above response. Then it uses the token to make API calls to SAMI until the token is revoked or expires.

Please consult [Your first Android app](/sami/demos-tools/your-first-android-app.html) and [iOS app demo](https://github.com/samsungsamiio/sami-ios-demo) for the examples of using the Implicit method.

### With backend servers

If your mobile application can work with your backend servers, your app is likely more secure. The client secret can be stored in the backend server. You use one of the following options to do the initial authentication and permission grant depending on your preference:

- Use the [Authorization Code method](/sami/sami-documentation/authentication.html#authorization-code-method) like the [web application](#web-application) above. In this way, the mobile app acts like the frontend of a web application.
- Use the [Implicit method](/sami/sami-documentation/authentication.html#implicit-method) like the above [standalone mobile app](#without-backend-servers).

After an user grants the permission to your mobile app on UI during one of the above authentication workflows, the backend server of the app can perform API call without prompting a user to login again. This is done by refreshing tokens or using the Client Credentials method just like the above [web app](#obtain-an-access-token-without-users-further-interaction) does.
