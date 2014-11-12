---
title: "Tictrac demo"
---

Tictrac demo
=========

This [package][1] contains an example implementation of connecting to a live Samsung SAMI
WebSocket and interpreting messages coming from a Simband device. These messages
are translated and delivered to a client application via another WebSocket for processing
and/or visualisation.

Note that due to this system operating on the live WebSocket, another service must be
publishing data to the account that is used to authorise the application. In the past, the
SAMIHub wizard has been used for this purpose, using the Simba Canned Data 0514 and Simba
E2E demo recorded samples datasets.

Prerequisites
-------------

* [golang](https://golang.org/) >= 1.1
* Install golang dependencies
  * `go get code.google.com/p/go.net/websocket`
  * `go get code.google.com/p/goauth2/oauth`
  * `go get github.com/go-martini/martini`
* [Download][1] the package

Configuration
-------------

* Update demo.go to set the OAuth credentials
 * Set SAMIClientId
 * Set SAMIClientSecret

General Operation
-----------------

* Start the server (`go run demo.go`)
* Connect to the Web server in a browser on `http://localhost:8000`
* Go through the SAMI OAuth process to obtain a token
* At the end of the previous step, if the token was successful the server will connect to SAMI
* Point a client application at `ws://localhost:8000/stream` (or use `http://localhost:8000/client`)

Licence and Copyright
---------------------
Licensed under the MIT License. See LICENCE.

Copyright (c) 2014 Tictrac Ltd

[1]:	/sami/downloads/tictrac_sami_demo.tar.gz
