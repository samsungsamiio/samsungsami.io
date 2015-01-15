---
title: "Build a mobile app to work with SAMI"

---

# Build an iOS app to work with SAMI

## Introduction

In the previous exploration, I was able to connect my Withings scale to SAMI and visualize my weight data on SAMI User Portal. This time, I would like to go further by developing an iOS app to interact with SAMI in a more profound way.

I name the app SAMIHMonitor. The goal of this app is to allow a user to monitor his health related data from diverse data sources. I will show you how to develop SAMIHMonitor to achieve that goal.

I start with a simple version that allows a user to see his historical weight data from the Withings scale on the phone. Later on, I will evolve the simple one. The later version allows a user to enter his own calories data and see the historical calories data from SAMI. 

My development of this iOS app is primarily to test the feasibility that SAMI allows the 3rd party developers to combine the data from diverse sources. In this post, I talk about the first version. In the followup post, I will discuss how to implement the second version.

## Demo: show weight data on phone

Before digging in, here's a preview of how the first version of the app will work.

- Start SAMIHMonitor.
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-demo-0-starting.png)
- Click "CONNECT" and then you will be presented the login screen like this:
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-demo-1-login.png)
- Enter your user name and password to login.
- Click "Allow" when the app asks you to give it the permission to read your Withings data on SAMI.
- After you finish the whole authentication flow, you will see the user information screen like this:
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-demo-2-userinfo.png){:.lightbox}
- If you have connected your Withings scale to SAMI, "See Weight" button is enabled. Click the button and see the data on the screen like this:
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-demo-3-weight-data.png)
- You can make a pull gesture on the data screen to refresh and show the latest data.
- You can navigate back to the user info screen and logout from SAMI.

## Installation and setup

### Register the app

I logged in the Developer Portal to register this iOS application on SAMI. Remember that I have registered in the User Portal in my previous post. This time, I use a different email address to register in the Developer Portal as a developer.

I followed [these instructions](/sami/sami-documentation/developer-user-portals.html#creating-an-application) to create an application. For this iOS app, select the following:

- Set "Redirect URL" to 'ios-app://redirect'.
- Choose "Client Credentials Flow & Implicit Flow".
- Under "PERMISSIONS", click "Add Device Type" button. Choose "Withings Device" as the device type. Check "Read" permissions for this device type.

[Make a note of the client ID.](/sami/sami-documentation/developer-user-portals.html#how-to-find-your-application-id) This is my application ID, which I will use in my source file later.

### Prepare source files and libraries

I uses the SAMI [iOS SDK](http://developer.samsungsami.io/sami/native-SDKs/objectivec-SDK.html) to simplify coding. With the SDK, I do not need to implement REST call details.

1. Download [SAMIHMonitor V1](/sami/downloads/blogs/SAMIHMonitor-v1.zip).
2. Download the SAMI [Objective-C/iOS SDK](https://github.com/samsungsamiio/sami-ios) from github.
3. Install CocoaPods. See [this page](http://guides.cocoapods.org/using/getting-started.html) for instructions. In a terminal window, cd to the root directory of SAMIHMonitor app, and run `pod install`. This installs all the SAMI SDK prerequisites like AFNetworking. Here is what my terminal window looks like:![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-install-1-pod.png){:.lightbox}
4. Open `SAMIHMonitor.xcworkspace`. Now import the SAMI SDK into the Xcode project of the app. Drag the `client` folder of the downloaded SAMI iOS SDK from the Finder window into `SAMIHMonitor` group in Xcode.
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-install-2-add-SDK.png){:.lightbox}
5. Use the Application Client ID obtained when registering the app to replace `YOUR CLIENT APP ID` in `SamiConstants.m`.
![SAMIHMonitor V1](/images/docs/sami/blogs/iosapp/v1-install-3-client-id.png){:.lightbox}

Now build in Xcode and run SAMIHMonitor in iOS simulator. You should be able to play with the app in the way that has been demoed.

## Implementation

Hope by now you have succeeded in playing with the first version of the app. Now let me discuss the implementation.

At the high level, I need to implement five functionalities:

- Authenticate a user using OAuth 2.0 workflow.
- Collect user information such as user ID, name, and email et al.
- Enquire SAMI to learn if the user has a connected Withings device and if so collect the information about that device.
- Get the weight data of the identified Withings device from SAMI.
- Request from SAMI the Manifest of the Withings device and then obtain the unit of the weight data.
 
### Authenticate user

SAMI supports multiple OAuth 2.0 workflows. After consulting the [workflow examples](http://developer.samsungsami.io/sami/demos-tools/oauth2-flow-examples.html) on SAMI developer documentation site, I chose to implement the [Implicit method](http://developer.samsungsami.io/sami/sami-documentation/authentication.html#implicit-method). It is straightforward to implement this method. In addition, the method is sufficient for my mobile app.

The authentication functionality is implemented in `LoginViewController`.
The controller contains a `UIWebView`, which submits a `GET` request to the Authorization endpoint: `https://accounts.samsungsami.io/authorize` during `viewDidLoad`. Note that the request contains the client id and redirect url, which are configured or obtained in the previous [app registration](#register-the-app) phase.

~~~
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    //6. Create the authenticate string that we will use in our request.
    // we have to provide our client id and the same redirect uri that we used in setting up our app
    // The redirect uri can be any scheme we want it to be... it's not actually going anywhere as we plan to
    // intercept it and get the access token off of it
    NSString *authenticateURLString = [NSString stringWithFormat:@"%@%@?client=mobile&client_id=%@&response_type=token&redirect_uri=%@", kSAMIAuthBaseUrl, kSAMIAuthPath, kSAMIClientID, kSAMIRedirectUrl];
    //7. Make the request and load it into the webview
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:authenticateURLString]];
    
    self.addressField.text = authenticateURLString;
    [self.webView loadRequest:request];    
}
~~~

In order to get an access token, `LoginViewController` needs to capture the callback after the authentication succeeds. To do so, it overrides `UIWebViewDelegate`'s method. In that method, the controller exams if the redirct url is the right one and extracts the access token if so.

~~~~
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if([request.URL.scheme isEqualToString:@"ios-app"]){
        // 8. get the url and check for the access token in the callback url
        NSString *URLString = [[request URL] absoluteString];
        if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
            // 9. Store the access token in the user defaults
            NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
            [UserSession sharedInstance].accessToken = accessToken;
            // 10. dismiss the view controller
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return YES;
}
~~~~

`UserSession` stores the access token in a persistent storage. Later on, this object is consulted to get the token for each REST API calls to SAMI.

### Get user information

`UserInfoViewController` is in charge of presenting user information after the user logins in. The controller uses `SamiUserApi` class in the SDK library to send the request to SAMI and presents the received user information as the following code:

~~~
- (void) validateAccessToken {
    [self setWithingsDevice:nil];

    NSString* authorizationHeader = [UserSession sharedInstance].bearerToken;

    SamiUsersApi * usersApi = [[SamiUsersApi alloc] init];
    [usersApi addHeader:authorizationHeader forKey:kOAUTHAuthorizationHeader];
    
    [usersApi selfWithCompletionBlock:^(SamiUserEnvelope *output, NSError *error) {
        if (error) {
            self.fullnameLabel.text = error.localizedFailureReason;
        } else {
            UserSession *session = [UserSession sharedInstance];
            session.user = output.data;
            
            self.idLabel.text = output.data._id;
            self.nameLabel.text = output.data.name;
            self.fullnameLabel.text = output.data.fullName;
            self.emailLabel.text = output.data.email;
            
            NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, yyyy HH:mm"];
            
            NSDate *created = [NSDate dateWithTimeIntervalSince1970:([output.data.createdOn doubleValue])];
            self.createdLabel.text = [dateFormat stringFromDate:created];
            
            NSDate *modified = [NSDate dateWithTimeIntervalSince1970:([output.data.modifiedOn doubleValue])];
            self.modifiedLabel.text = [dateFormat stringFromDate:modified];
            
            [self processWithingsDevice];
        }        
    }];
}

~~~

### Get Withings device info

In `UserInfoViewController`, I need to enquire SAMI twice to get Withings device info. The first enquiry is to get the device type ID of Withings devices. The second enquiry is to get a list of the devices that the user owns and then checks if the user has any Withings device using the device type ID. Based on that piece of information, "See Weight" button is enabled or disabled on the screen.

When enquiring for the device type ID, I need to pass in the device type name of Withings device. The name is the one shown in the User Portal. I define it in `SamiConstants.m` as the following code: 

~~~
NSString *const kDeviceTypeNameWithings = @"Withings Device";
~~~

Then I call a method of `SamiDeviceTypesApi` class in the SDK get the device type ID.

~~~
- (void)getWithingsDeviceTypeId
{
    SamiDeviceTypesApi *api = [[SamiDeviceTypesApi alloc] init];
    NSString* authorizationHeader = [UserSession sharedInstance].bearerToken;
    [api addHeader:authorizationHeader forKey:kOAUTHAuthorizationHeader];
    [api getDeviceTypesWithCompletionBlock:kDeviceTypeNameWithings offset:@(0) count:@(1) completionHandler:^(SamiDeviceTypesEnvelope *output, NSError *error) {
        [UserSession sharedInstance].withingsDeviceTypeId = ((SamiDeviceType *)[output.data.deviceTypes objectAtIndex:0])._id;
        NSLog(@"Store Withings Device Type %@", [UserSession sharedInstance].withingsDeviceTypeId);
        [self searchWithingsInDeviceList];
    }];
}
~~~

After obtaining the device type ID, I call a method of `SamiUsersApi` class in the SDK to get the list of the users' devices and then check for Withings devices using the type ID.

~~~
- (void)processWithingsDevice {
    [self setWithingsDevice:nil];

    NSString* authorizationHeader = [UserSession sharedInstance].bearerToken;
    
    SamiUsersApi * api = [[SamiUsersApi alloc] init];
    [api addHeader:authorizationHeader forKey:kOAUTHAuthorizationHeader];
    
    [api getUserDevicesWithCompletionBlock:@(0) count:@(100) includeProperties:@(YES) userId:[UserSession sharedInstance].user._id completionHandler:^(SamiDevicesEnvelope *output, NSError *error) {
        NSArray *devices = output.data.devices;

        NSPredicate *predicateMatch = [NSPredicate predicateWithFormat:@"dtid == %@", kDeviceTypeID_Withings];
        NSArray *withingsDevice = [devices filteredArrayUsingPredicate:predicateMatch];
        if ([withingsDevice count] >0) {
            NSLog(@"Found %lu Withings devices", (unsigned long)[withingsDevice count]);
            [self setWithingsDevice:((SamiDevice *)withingsDevice[0])];
         } else {
            NSLog(@"Found 0 Withings devices");
        }
    }];
}
~~~

The first Withings device in the device list is used. Later on the app will get weight data of this device.  

### Get weight data

`DataTableViewController` is in charge of enquiring SAMI to obtain messages from the identified Withings device, parsing the response, and finally presenting weight data.

To get the historical messages, I call the method of `SamiMessagesApi` class in the SDK per following code:

~~~
- (void)refreshMessages {
    NSString *authorizationHeader = [UserSession sharedInstance].bearerToken;
    int messageCount = 20;

    SamiMessagesApi * api2 = [SamiMessagesApi apiWithHeader:authorizationHeader key:kOAUTHAuthorizationHeader];
    [api2 getLastNormalizedMessagesWithCompletionBlock:@(messageCount) sdids:device_._id fieldPresence:nil completionHandler:^(SamiNormalizedMessagesEnvelope *output, NSError *error) {
        self.messages = output.data;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}
~~~

I call `refreshMessages` method in `viewDidLoad` and also set it as the action of `UIRefreshControl`. To properly present weight data and corresponding dates on the screen, I also need to parse the messages in the HTTP response as below:

~~~
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCell"];
    }
    SamiNormalizedMessage *message = (SamiNormalizedMessage *)[self.messages objectAtIndex:indexPath.row];
    
    NSDictionary *dict = message.data;
    id value = [dict objectForKey:@"weight"];
    cell.textLabel.text = [value description];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([message.ts doubleValue]/1000)];
    cell.detailTextLabel.text = [self.dateFormat stringFromDate:date];
    
    return cell;
}
~~~

### Get weight unit

By now, I can see weight numbers showing in the table. However, what is the unit of the weight data? Based on the [SAMI developer documentation](http://developer.samsungsami.io/sami/sami-documentation/the-manifest.html), I can get the information from the Manifest of the Withings device type. The following code uses the method of `SamiDeviceTypesApi` class in the SDK to get the Manifest and then parse it to get the unit:

~~~
- (void)parseManifestSetUnit {
    NSString* authorizationHeader = [UserSession sharedInstance].bearerToken;
    
    SamiDeviceTypesApi * api = [[SamiDeviceTypesApi alloc] init];
    [api addHeader:authorizationHeader forKey:kOAUTHAuthorizationHeader];
    
    [api getLatestManifestPropertiesWithCompletionBlock:device_.dtid completionHandler:^(SamiManifestPropertiesEnvelope *output, NSError *error) {
        NSLog(@"%@ %@", output, error);
        
        NSDictionary *dict = [output.data.properties objectForKey:@"fields"];
        NSDictionary *fieldInfo = [dict objectForKey:@"weight"];
        unit_ = [fieldInfo objectForKey:@"unit"];
        NSString *fieldName = @"Weight in ";
        NSString *titleWithUnit = [fieldName stringByAppendingString:unit_];
        self.navigationItem.title = titleWithUnit;
    }];
    
}
~~~

Ok, you are done with a simple iOS app that presents historical weight data from the Withings device of a logged in users. Please consult the followup post for version two of the app.