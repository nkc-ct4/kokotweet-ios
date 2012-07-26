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

@interface TimelineViewController : UITableViewController<CLLocationManagerDelegate> {
    NSMutableArray *statuses;
    NSMutableArray *statuses_ex;
    CLLocationManager *locationManager;
    NSString *geocodeStr;
    NSUserDefaults *ud;
    NSString *distance;
    int locationUpdateCount;
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
