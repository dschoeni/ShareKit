//
//  IHSHKFacebook.m
//  ShareKit
//
//  Created by DS on 7/16/14.
//
//

#import <FacebookSDK/FacebookSDK.h>
#import "IHSHKFacebook.h"
#import "SharersCommonHeaders.h"

@interface IHSHKFacebook ()

@end

@implementation IHSHKFacebook

#pragma mark -
#pragma mark Configuration : Service Defination

- (id)init {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

// Enter the name of the service
+ (NSString *)sharerTitle
{
	return SHKLocalizedString(@"Facebook");
}

+ (BOOL)canShareURL
{
    return YES;
}

+ (BOOL)requiresAuthentication
{
	return NO;
}

#pragma mark -
#pragma mark Implementation

// Send the share item to the server
- (BOOL) send
{
	// Make sure that the item has minimum requirements
	if (![self validateItem])
		return NO;
    
    [self sendDidStart];
    

    return YES;
}

- (void) doSend {
    
    NSURL* url = self.item.URL;
    
    FBLinkShareParams* shareParams = [FBLinkShareParams new];
    shareParams.link = [url absoluteURL];
    
    if ([FBDialogs canPresentShareDialogWithParams:shareParams]) {
        
        [FBDialogs presentShareDialogWithParams:shareParams clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            NSLog(@"Native FB-Share done");
            
            if (error == nil) {
                [self sendDidFinish];
            } else {
                [self sendDidFailWithError:error];
            }
        }];
        
    } else {
        
        NSMutableDictionary *params =
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
         [url absoluteURL], @"link",
         nil];
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler: ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            NSLog(@"Web FB-Share done");
            
            if (error == nil) {
                [self sendDidFinish];
            } else {
                [self sendDidFailWithError:error];
            }
        }];
        
    }
    
}


@end
