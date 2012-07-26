//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize mapView;
@synthesize tableView;
@synthesize menuItems;
@synthesize locationManager;

- (void)awakeFromNib
{
  self.menuItems = [NSArray arrayWithObjects:@"TimelineViewController", @"SettingDialog", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
        [self.mapView setShowsUserLocation:YES];

        NSLog(@"Start updating location.");
        
    } else {
        NSLog(@"The location services is disabled.");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"MenuItemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
  }
  
  cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"%@View", [self.menuItems objectAtIndex:indexPath.row]];

  UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
  
  [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
    CGRect frame = self.slidingViewController.topViewController.view.frame;
    self.slidingViewController.topViewController = newTopViewController;
    self.slidingViewController.topViewController.view.frame = frame;
    [self.slidingViewController resetTopView];
  }];
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)mapReload:(CLLocation*)location
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"----------------------------------------------------");
    NSLog(@"latitude,logitude : %f, %f", coordinate.latitude, coordinate.longitude);
    NSLog(@"altitude          : %f", location.altitude);
    NSLog(@"cource            : %f", location.course);
    NSLog(@"horizontalAccuracy: %f", location.horizontalAccuracy);
    NSLog(@"verticalAccuracy  : %f", location.verticalAccuracy);
    NSLog(@"speed             : %f", location.speed);
    NSLog(@"timestamp         : %@", location.timestamp);
    MKCoordinateRegion region = MKCoordinateRegionMake([location coordinate], MKCoordinateSpanMake(1.75, 1.75));
    [self.mapView setCenterCoordinate:[location coordinate]];
    [self.mapView setRegion:region];

    //[self.locationManager stopUpdatingLocation]; //測位停止
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self mapReload:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
}
@end
