---
title: "Rate limiting"
---

# Rate limiting

This article provides information on how rate limiting is applied to REST and WebSocket API calls. To check the current rate limits, see the tables [REST limits](#rest-limits) and [WebSocket limits](#websocket-limits).

Rate limits are considered separately for [three actors](#rate-limits-for-three-actors) that can call the SAMI API:

- [Users](#per-user)
- [Devices](#per-device)
- [Applications](#per-application)
 
One of two [limit windows](#limit-windows) may be considered per token:

- Daily (UTC) window.
- Sliding one-minute window.

See [**Authentication**](/sami/sami-documentation/authentication.html) for instructions on obtaining and using OAuth2 tokens.
{:.info}

## Rate limits for three actors

### Per user

Rate limiting is applied to an authenticated user in a single application. This means that rate limits on users are considered separately for each application that calls the API. Your application has this token once a user is logged in. [Read about user tokens.](/sami/sami-documentation/authentication.html#user-token)

### Per device

Rate limiting is applied to an authenticated device. Since device tokens are not linked to developer applications, each device sending data can be considered to have its own rate limit. [Read about device tokens.](/sami/sami-documentation/authentication.html#device-token)

### Per application

Rate limiting is applied to an authenticated application that can call the API without a user token. [Read about application tokens.](/sami/sami-documentation/authentication.html#application-token).

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

| Method | Window | Requests per user | Requests per device | Requests per application
|----- |---------- |---------------------------|-----------------------------|---------------------------------|
| GET | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| POST | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| PUT | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000
| DELETE | Minute | 100 | 100 | 500
|	| Daily | 1000 | 1000 | 5000

## WebSocket limits

| Window | Requests per user | Requests per device | Requests per application
|----- |---------- |---------------------------|-----------------------------|---------------------------------|
| Minute | 1000 | 1000 | 5000
| Daily | 10,000 | 10,000 | 500,000