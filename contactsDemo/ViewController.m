//
//  ViewController.m
//  contactsDemo
//
//  Created by 王宇哲 on 8/8/21.
//

#import "ViewController.h"
#import <Contacts/Contacts.h>

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray <NSString*> * sectionIndexTitles;
- (void) getContacts; //read from system contacts and store it
- (void) parseFetchedContacts; //parse fetched contacts according to their initials
- (void) outputAllContacts;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getContacts];
    [self parseFetchedContacts];
    [self outputAllContacts];
    
    //construct a tableView and display all contact names
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.editing = NO;
    tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableView.backgroundColor = UIColor.systemBackgroundColor;
    
    [self.view addSubview:tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parsedContacts[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.parsedContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    People * oneContact = self.parsedContacts [indexPath.section] [indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", oneContact.firstName, oneContact.lastName];
    cell.textLabel.textColor = UIColor.labelColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = UIColor.systemBackgroundColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"delete";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //empty for now
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    People * firstPerson = self.parsedContacts [section] [0];
    NSString * title;
    if(firstPerson.firstName.length != 0) {
        title = [firstPerson.firstName substringToIndex:1];
    } else {
        title = [firstPerson.lastName substringToIndex:1];
    }
    return title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray <NSString*> * indices = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.parsedContacts.count; ++i) {
        People * firstPerson = self.parsedContacts[i][0];
        NSString * title;
        if (firstPerson.firstName.length != 0) {
            title = [firstPerson.firstName substringToIndex:1];
        } else {
            title = [firstPerson.lastName substringToIndex:1];
        }
        [indices addObject:title];
    }
    return indices;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController * detail = [[DetailViewController alloc] init];
    detail.person = self.parsedContacts[indexPath.section][indexPath.row];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString * str = cell.textLabel.text;
    detail.title = [NSString stringWithFormat:@"%@", str];
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark contactFetchAndModification

- (void) getContacts {
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (authorizationStatus != CNAuthorizationStatusAuthorized) {
        NSLog(@"No authorization...");
        return;
    }
    
    self.contactPeople = [[NSMutableArray alloc] init];
    
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        //NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        People * onePerson = [[People alloc] init];
        onePerson.firstName = givenName;
        onePerson.lastName = familyName;
     
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //NSString *label = labelValue.label;
            CNPhoneNumber *phoneNumber = labelValue.value;
     
            //NSLog(@"label=%@, phone=%@", label, phoneNumber.stringValue);
            NSString * onePhone = phoneNumber.stringValue;
            onePerson.phone = onePhone;
        }
        
        [self.contactPeople addObject:onePerson];
    }];
}

- (void) parseFetchedContacts {
    NSMutableArray * columns = [[NSMutableArray alloc] initWithCapacity:26];
    for(int i = 0; i < 26; i ++){
        NSMutableArray * group = [[NSMutableArray alloc] init];
        for(int j = 0; j < self.contactPeople.count ; j++){
            People * oneDude = self.contactPeople [j];
            NSString * letter;
            if(oneDude.firstName.length != 0) {
                letter = [oneDude.firstName substringToIndex:1];
            }
            else if(oneDude.lastName.length != 0) {
                letter = [oneDude.lastName substringToIndex:1];
            }
            if( letter == [NSString stringWithFormat: @"%c", i+'A'] ){
                [group addObject:oneDude];
            }
        }
        if (group.count) {
            [columns addObject:group];
        }
    }
    self.parsedContacts = columns;
    
    NSMutableArray* letters = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.parsedContacts.count; i ++){
        NSString * item = [NSString stringWithFormat:@"%c", i+'A'];
        [letters addObject:item];
    }
    
    self.sectionIndexTitles = [letters copy];
}

-  (void) outputAllContacts {
    for( int i = 0; i < [self.parsedContacts count]; i++) {
        for ( int j = 0; j < [self.parsedContacts[i] count]; j++) {
            People * man = self.parsedContacts[i][j];
            NSLog(@"%@, %@, %@", man.lastName, man.firstName, man.phone);
        }
    }
}

@end
