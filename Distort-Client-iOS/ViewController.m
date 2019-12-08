//
//  ViewController.m
//  Distort-Client-iOS
//
//  Created by Jason Chiu on 12/7/19.
//  Copyright © 2019 Jason Chiu. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@interface ViewController ()

@end

@implementation ViewController

    NSMutableData *_responseData;               // Response data from the delegate
    NSString * baseApiURL = kbaseAPIEndpoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self view_setViewToDefault];
}


#pragma mark UI Methdos


// When the distort button is pressed
- (IBAction)onDistortButtonPress:(id)sender {
    
    // TODO: Do some client type checking to ensure this is 'valid' input
    [self doRequestToServerForProvidedID:[self.inputDistortSID text]];
    
    
}

// Adds the data to clipboard, and opens settings / clears the view
// TODO: clean this up so this function doesn't do 3 different things
- (IBAction)onCopyOpenSettingPress:(id)sender {
    
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];    // Get the pasteboard
    pasteboard.string = [self.textDistortInfo text];                // Get this from the clipboard
    
    // Open the settings app. We're not allowed to open the wifi page directly
    // TODO: Update this since we're using a deprecated method
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
    // Clear the view.
    [self view_setViewToDefault];
;
    
}


- (void) doRequestToServerForProvidedID:(NSString *)distortID {
    
    NSString * finalRequestURL = [NSString stringWithFormat:@"%@/%@/", baseApiURL, distortID];
    
    // Create the request, appending the distortID
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:finalRequestURL]];

    NSLog(@"The request URL is: %@", finalRequestURL);
    
    // Create url connection and fire request.
    // TODO: Update this since we're using a deprecated method
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

// Method to update the view with the string from the server
- (void) view_updateViewWithString:(NSString *)info {
    [self.textDistortInfo setText: info];
}

- (void) view_setViewToDefault {
    [self.textDistortInfo setText: @"///"];
}


#pragma mark Utility methods

- (NSString*) util_parseRespForBroadcastValue:(NSMutableData*)data {
    
    NSError *errorJson=nil;     // Create an error json
    NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
    
    NSLog(@"responseDict=%@",responseDict);
    if ([responseDict.allKeys count] > 0) {
        return [responseDict valueForKey:@"broadcastText"];
    } else {
        return @"session invalid";
    }
    
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    _responseData = [[NSMutableData alloc] init];
    
    
    NSLog(@"NSURLConnection didReceiveResponse from: %@", response.URL.absoluteString);



    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    // Note: connection:didReceiveData: will be hit several times
    
    [_responseData appendData:data];
    
    NSLog(@"NSURLConnection didReceiveData with length: %lu", (unsigned long)data.length);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSLog(@"NSURLConnection connectionDidFinishLoading");
    
    // Update the data view with the broadcast test from the JSOn response.
    [self view_updateViewWithString:[self util_parseRespForBroadcastValue:_responseData]];
}


// TODO: show something if it errors
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    [self view_updateViewWithString:@"connection error"];
}




@end
