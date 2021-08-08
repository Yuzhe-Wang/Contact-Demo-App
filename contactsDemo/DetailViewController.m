//
//  DetailViewController.m
//  contactsDemo
//
//  Created by 王宇哲 on 8/8/21.
//

#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Contacts/Contacts.h>

@interface DetailViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView * detail = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    detail.delegate = self;
    detail.dataSource = self;
    
    detail.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString * firstLetter;
    NSString * secondLetter;
    
    if (self.person.firstName.length >= 1) {
        firstLetter = [self.person.firstName substringToIndex:1];
    }
    if (self.person.lastName.length >= 1) {
        secondLetter = [self.person.lastName substringToIndex:1];
    }
    NSString * initials;
    if (firstLetter == nil) {
        initials = [NSString stringWithFormat:@"%@", secondLetter];
    } else if (secondLetter == nil) {
        initials = [NSString stringWithFormat:@"%@", firstLetter];
    } else {
        initials = [NSString stringWithFormat:@"%@%@", firstLetter, secondLetter];
    }
    
    //generate an avater with the initials
    UILabel * avatar = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/8, 50, [UIScreen mainScreen].bounds.size.width/4, [UIScreen mainScreen].bounds.size.width/4)];
    avatar.text = initials;
    avatar.textAlignment = NSTextAlignmentCenter;
    avatar.font = [UIFont boldSystemFontOfSize:64];
    avatar.backgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.5];
    avatar.textColor = [UIColor whiteColor];
    
    //make the avatar circle shape
    avatar.layer.cornerRadius = avatar.bounds.size.width/2;
    avatar.layer.masksToBounds = YES;
    
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    [header addSubview:avatar];
    detail.tableHeaderView = header;
    
    [self.view addSubview:detail];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Phone : %@", self.person.phone];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * phoneNumberString = self.person.phone;
    phoneNumberString = [phoneNumberString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumberString = [NSString stringWithFormat:@"tel:%@", phoneNumberString];
    NSURL * phoneNumberURL = [NSURL URLWithString:phoneNumberString];
    [[UIApplication sharedApplication] openURL:phoneNumberURL options:@{} completionHandler:nil];
}

@end
