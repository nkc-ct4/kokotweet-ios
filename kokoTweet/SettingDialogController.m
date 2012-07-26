//
//  SettingDialogController.m
//  kokoTweetSetting
//
//  Created by zuzu on 12/07/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingDialogController.h"

@interface SettingDialogController (){
    __strong NSObject *str;
}
@end

@implementation SettingDialogController
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
}

- (void)close {
    [self dismissModalViewControllerAnimated:YES];
    [delegate modalViewWillClose];
}
/*
- (void) push{
    NSLog(@"push!");
    [delegate modalViewWillClose];
}
*/

- (void)setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView {
    [super setQuickDialogTableView:aQuickDialogTableView];
        
}

+ (QRootElement *)createDetailsForm:(NSMutableArray *)accountNameArray {
    QRootElement *details = [[QRootElement alloc] init];
    details.title = @"設定";
    details.controllerName = @"SettingDialogController";
    details.grouped = YES;
    QSection *section = [[QSection alloc] init];
    QRadioElement *accountRadio = [[QRadioElement alloc] initWithItems:accountNameArray selected:0 title:@"Twitterアカウント"];
    accountRadio.key = @"selectAccountNum";
    
    [section addElement:accountRadio];

    [details addSection:section];
    return details;
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
    
}



@end
