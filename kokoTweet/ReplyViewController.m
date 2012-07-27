//
//  ReplyViewController.m
//  kokoTweet
//
//  Created by CT4 on 12/07/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReplyViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "SVPullToRefresh.h"

@interface ReplyViewController ()

@end

@implementation ReplyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.showsInfiniteScrolling = NO;
/*
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"refresh dataSource");
        //更新処理
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccount *account = [accountStore accountWithIdentifier:self.accountIdentifier];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:@"1" forKey:@"include_entities"];
        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"];
        TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodGET];
        [request setAccount:account];
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){

            dispatch_async(dispatch_get_main_queue(), ^{
                if(!responseData){
                    NSLog(@"%@", error);
                }else{
                    NSError* error;
                    statuses = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:&error];
                    
                    if(statuses){
                        NSLog(@"%@", statuses);
                    }else{
                        NSLog(@"%@", error);
                    }
                    [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
                    [self.tableView reloadData];
                }
            });
        }];
        
        
    }];
        
    [self.tableView.pullToRefreshView triggerRefresh];
    //更新忘れずに
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *account = [accountStore accountWithIdentifier:self.accountIdentifier];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"1" forKey:@"include_entities"];
    NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"];
    TWRequest *request = [[TWRequest alloc] initWithURL:url
                                             parameters:parameters
                                          requestMethod:TWRequestMethodGET];
    [request setAccount:account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!responseData){
                NSLog(@"%@", error);
            }else{
                NSError* error;
                statuses = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableLeaves
                                                             error:&error];
                
                if(statuses){
                    NSLog(@"%@", statuses);
                }else{
                    NSLog(@"%@", error);
                }
                
                [self.tableView reloadData];
            }
        });
    }];
 */
}
@end
