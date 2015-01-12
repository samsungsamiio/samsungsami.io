---
title: "OAuth2 flow examples"

---

# OAuth2 flow examples 

[OAuth 2.0](http://tools.ietf.org/html/draft-ietf-oauth-v2-23) is a protocol that allows external applications to request access to private data in a user’s SAMI account without getting their passwords. 

To learn about obtaining and refreshing access tokens, and the differences between the various authorization flows, first see [Authentication](/sami/sami-documentation/authentication.html). In this article, we give some examples of how third-party apps can build an OAuth 2.0 flow to interact with SAMI.

## Web applications

A real-world web application contains front-end components and back-end servers. 

To improve security, your web application should initially use the [Authorization Code method](/sami/sami-documentation/authentication.html#authorization-code-method) to have a user grant the app access to her data on SAMI. 

Later, your app could use the [Client Credentials method](/sami/sami-documentation/authentication.html#client-credentials-method) on the back end to get a token to access the data without requiring further involvement from the user.

### Obtain an access token by interacting with users

The Authorization Code method has two steps. First, the front end sends an HTTP request to get an authorization code. Then, the back end sends an HTTP request with client credentials and the obtained code to get an access token. 

#### Obtain an authorization code

Your web application should present a UI for a user to log into SAMI. Once the login button is clicked, the app then makes the HTTP call to request an authorization code from SAMI. Below is an example of an HTTP `GET` request call:

    https://accounts.samsungsami.io/authorize?client_id=9628eef2a00d43d89b757b8d34373588&response_type=code&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write

The user will be presented a Samsung Accounts screen, where she may sign in or create a new account. If login is successful, the user will be asked to grant specific permissions on her data.

When the user clicks "Grant", the server (at the `redirect_uri`) will receive an HTTP request with an authorization code as follows:

    https://myapp.com/callback?code=0ee7fcd0abed470182b02cd649ec1c98&state=abcdefgh

#### Obtain an access token

Now your back-end server exchanges the authorization code obtained above for an access token within 60 seconds before expiring. 

Since the client credentials will be used in this step, it is recommended that the back-end server sends the request. The credentials (`client_id` and `client_secret`) should be encoded in an HTTP Authorization header. Consult [Sending client ID and client secret](/sami/sami-documentation/authentication.html#sending-clientid-and-clientsecret) for details on how to include them in an HTTP request. 

Below are examples of the HTTP request sent by your back-end server, and the response:

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

Now your web application can use the token to make API calls to SAMI, to access the corresponding user's data, until the token expires or the permissions are revoked.

You can continue to use Authorization Code flow to get the user's access token. Future interactions with your web application's UI only require the user to login, and does not require that she grant permission again, unless she revokes or changes the permissions.

However, it is preferable to have the web app perform API calls on behalf of a user without prompting another login. We describe how in the next section.

### Obtain an access token without user interaction

Once a user has granted your web app permission to access her data, the back-end server of the app can request an access token without further interaction from the user. This can be done two ways: 

- Refreshing a token. 
- Using the Client Credentials method. 

In each method, HTTP calls must be performed by the back-end server because it requires passing the credentials (`client_id` and `client_secret`). The credentials are encoded in an HTTP Authorization header. Consult [Sending client ID and client secret](/sami/sami-documentation/authentication.html#sending-clientid-and-clientsecret) for details on how to include them in a HTTP request.

The token obtained by refreshing a token can access data of a specific user. The token obtained using the Client Credentials method can access data of all users that have granted permissions to the application.
{:.info}

#### Refresh a token

The back-end server can obtain a new access token by exchanging a previously issued `refresh_token` during the flow of the Authorization Code method. The new token allows access to the data of a specific user. Please see [Authentication](/sami/sami-documentation/authentication.html#refresh-a-token) for more details.

#### Use Client Credentials method

As an alternative to refreshing tokens, the back-end server can use the [Client Credentials method](/sami/sami-documentation/authentication.html#client-credentials-method) to get new tokens without prompting users again. 

Below are examples of the HTTP request sent by your back-end server, and the response:

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

## Standalone mobile applications

Let's call a mobile application that does not have back-end servers. An standalone mobile application without back-end servers is less secure, and cannot protect the client secret. Therefore, it is recommended that you use the [Implicit method](/sami/sami-documentation/authentication.html#implicit-method) in a standalone mobile app.

The Implicit method is straightforward to use. It takes one step for a mobile app to get the access token. Please consult the [Authentication](/sami/sami-documentation/authentication.html#implicit-method) for more details on this flow. The following is an example of the HTTP `GET` request sent by the mobile app:

**Example request**

    https://accounts.samsungsami.io/authorize?client_id=9628eef2a00d43d89b757b8d34373588&response_type=token&redirect_uri=https://myapp.com/callback&state=abcdefgh&scope=read,write

After an user successfully logins and grants specific permissions on her data, the mobile app will receive a redirection response as the following:

**Example response**

~~~~ 
HTTP/1.1 302 Found
Location: http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpAA&state=xyz&token_type=bearer&expires_in=7200
~~~~

Instead of redirecting, the mobile app extracts the access token from the above response. Then it uses the token to make API calls to SAMI until the token is revoked or expires.

Please consult [Your first Android app](/sami/demos-tools/your-first-android-app.html) and [iOS app demo](https://github.com/samsungsamiio/sami-ios-demo) for specific examples of using the Implicit method.

## Mobile applications with back-end servers

If your mobile application can work with your back-end servers, your app is likely more secure. The client secret can be stored in the back-end server. You use one of the following options to do the initial authentication and permission grant, depending on your preference:

- Use the [Authorization Code method](/sami/sami-documentation/authentication.html#authorization-code-method) like in the [web application](#web-applications) described above. In this case, the mobile app acts like the front end of a web application.
- Use the [Implicit method](/sami/sami-documentation/authentication.html#implicit-method) like in the above [standalone mobile app](#standalone-mobile-applications).

After a user grants permissions to your mobile app during one of the above authentication workflows, the back-end server of the app can perform API calls without prompting the user to login again. This is done by refreshing tokens or using the Client Credentials method, just like in the above [web application](#obtain-an-access-token-without-user-interaction).