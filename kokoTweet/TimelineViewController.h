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




@interface TimelineViewController : UITableViewController<CLLocationManagerDelegate> {
   //geo持ちのツイート
    NSMutableArray *statuses;
    //location起動のManager
    CLLocationManager *locationManager;
    //自分のいる場所
    NSString *geocodeStr;
    //半径
    NSString *distance;
}
- (IBAction)pressTwitter:(id)sender;

@property (copy, nonatomic) NSString *accountIdentifier;
@property (copy, nonatomic) NSString *geocodeStr;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (copy, nonatomic) NSString *distance;
@property (strong, nonatomic) NSArray *accountsArray;
@property (nonatomic, strong) NSMutableArray *accountNameArray;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end
