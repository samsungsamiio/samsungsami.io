---
title: "Rate limiting"
---

# Rate limiting

This article provides information on how rate limiting is applied to REST and WebSocket API calls. To check the current rate limits, see the table [REST limits](#rest-limits).

Rate limits are considered separately for three actors that can call the SAMI API:

- [Users](#user-token)
- [Devices](#device-token)
- [Applications](#application-token)
 
One of two [limit windows](#limit-windows) may be considered per token:

- Daily (UTC) window.
- Sliding one-minute window.

See [**Authentication**](/sami/sami-documentation/authentication.html) for instructions on obtaining and using OAuth2 tokens.
{:.info}

## User token

Rate limiting is applied to an authenticated user in a single application. This means that rate limits on a user are considered separately for each application that calls the API. Remember that this will be the token your application will have once a user is logged in to your app. The limits will be applied to the user.

## Device token

Rate limiting is applied to an authenticated device. Since device tokens are not linked to developer applications, each device sending data can be considered to have its own rate limit.

## Application token

Rate limiting is applied to an authenticated application that can call the API without a user token.

## HTTP headers

The following HTTP headers will be returned for REST calls for the application, user-application or device-application context. This information allows you to assess where your application stands with rate limits.

- `X-Rate-Limit-Limit`: The maximum number of allowed requests in the current period (minute/daily).

- `X-Rate-Limit-Remaining`: The number of remaining requests in the current period (minute/daily).

- `X-Rate-Limit-Reset`: Unix epoch timestamp (in seconds) marking when the counter will reset and allow one or more requests to be made (minute/daily). For the sliding one-minute window, this denotes the time when the next (oldest) call will expire.

## WebSocket calls

By default, responses are not included with [WebSocket calls.](/sami/sami-documentation/sending-and-receiving-data.html#setting-up-a-bi-directional-message-pipe) However, if `ack` is set to `true` upon opening the connection, then a response is returned when the limit is reached.

Rate limits are not applied to a [/live WebSocket.](/sami/sami-documentation/sending-and-receiving-data.html#live-streaming-data-with-websocket-api) 

## Limit windows

### Daily window

This determines the maximum number of calls for 1 UTC-based day (not sliding).

### Minute window

This determines the maximum number of calls in a sliding window of one minute. Counts against the rate limit will be successively reset at one minute since each request.

## Error code

If the rate limit is exceeded on a given call, a 429 status code ("Too Many Requests") will be returned. 

## REST limits

| Method | Window | Requests (User token) | Requests (Device token) | Requests (Application token)
|----- |---------- |---------------------------|-----------------------------|---------------------------------|
| GET | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| POST | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| PUT | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| DELETE | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
