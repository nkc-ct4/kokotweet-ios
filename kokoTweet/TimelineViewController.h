//
//  TimelineViewController.h
//  TweetTest
//
//  Created by Satou Shingo on 12/05/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMImageCache.h"
#import <CoreLocation/CoreLocation.h>
#import "ECSlidingViewController.h"
#import "TweetDetailViewController.h"
#import "MenuViewController.h"
#import <Twitter/Twitter.h>
#import "SVPullToRefresh.h"
#import <Accounts/Accounts.h>


@interface TimelineViewController : UITableViewController<CLLocationManagerDelegate> {
}
- (IBAction)pressTwitter:(id)sender;
@property NSString* accountIdentifier;
@property NSMutableArray* accountNameArray;
@property NSMutableArray* accountsArray;
@end
