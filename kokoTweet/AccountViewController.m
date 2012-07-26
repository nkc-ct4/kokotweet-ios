//
//  AccountViewController.m
//  TweetTest
//
//  Created by Satou Shingo on 12/05/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccountViewController.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "TimelineViewController.h"

@interface AccountViewController ()
- (void)reloadAccounts;
@end

@implementation AccountViewController

- (void)reloadAccounts {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType
                            withCompletionHandler:^(BOOL granted, NSError *error)
     {
         if(granted){
             dispatch_async(dispatch_get_main_queue(), ^{
                 accountsArray = [accountStore accountsWithAccountType:accountType];
                 [self.tableView reloadData];
             });
         }
     }];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadAccounts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(accountsArray){
        return [accountsArray count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    ACAccount *account = [accountsArray objectAtIndex:indexPath.row]; 
    cell.textLabel.text = account.username;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTimelineViewControllerSegue" 
                              sender:self];
}

- (IBAction)pressRefreshButton:(id)sender {
    [self reloadAccounts];
}

- (IBAction)pressComposeButton:(id)sender {
    if([TWTweetComposeViewController canSendTweet]){
        TWTweetComposeViewController *composeViewController = 
        [[TWTweetComposeViewController alloc] init];
        [composeViewController setInitialText:@"これはテストです"];
        [self presentModalViewController:composeViewController animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showTimelineViewControllerSegue"]){
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ACAccount* account = [accountsArray objectAtIndex:path.row];
        TimelineViewController *viewController = (TimelineViewController*)[segue destinationViewController];
        viewController.accountIdentifier = account.identifier;
    }
}

@end
