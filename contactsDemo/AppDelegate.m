//
//  AppDelegate.m
//  contactsDemo
//
//  Created by 王宇哲 on 8/8/21.
//

#import "AppDelegate.h"
#import <Contacts/Contacts.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //construct a viewController and set as the rootViewController of an navigationController
    self.viewController = [[ViewController alloc] init];
    self.viewController.title = @"Contacts";
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    //construct a new window
    UIWindow * window = [[UIWindow alloc] init];
    self.window = window;
    
    //set the navigationController as the root viewController of this window
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    //request for system contact authorization
    [self requestAuthorizationFromAddressBook];
    
    return YES;
}

- (void) requestAuthorizationFromAddressBook {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus == CNAuthorizationStatusNotDetermined) {
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            } else {
                NSLog(@"Authorization failed");
            }
        }];
    }
}

@end
