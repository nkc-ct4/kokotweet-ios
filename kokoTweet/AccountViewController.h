//
//  AccountViewController.h
//  TweetTest
//
//  Created by Satou Shingo on 12/05/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UITableViewController {
    NSArray *accountsArray;
}
- (IBAction)pressRefreshButton:(id)sender;
- (IBAction)pressComposeButton:(id)sender;

@end
