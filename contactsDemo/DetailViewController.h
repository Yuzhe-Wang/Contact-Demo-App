//
//  DetailViewController.h
//  contactsDemo
//
//  Created by 王宇哲 on 8/8/21.
//

#import <UIKit/UIKit.h>
#import "People.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (strong, nonatomic) People * person;
@end

NS_ASSUME_NONNULL_END
