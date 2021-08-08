//
//  ViewController.h
//  contactsDemo
//
//  Created by 王宇哲 on 8/8/21.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "People.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSMutableArray * contactPeople;
@property (strong, nonatomic) NSMutableArray * parsedContacts;

@end
