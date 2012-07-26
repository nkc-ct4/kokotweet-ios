//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()
@end

// ローカル変数記述領域
@implementation MenuViewController{
    __strong  NSArray *menuItems; //メニューリスト用配列。
                                  //将来的には二次元配列にし遷移先のView名と実際の表示名で分ける。
}

@synthesize navBar;
@synthesize mapView;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // メニューリストを宣言
    menuItems = [NSArray arrayWithObjects:@"TimelineViewController", @"SettingDialog", nil];

    //スライドメニュー用の設定
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    //MapKitのデリゲート及び位置情報取得用処理
    mapView.delegate = self;
    [mapView.userLocation addObserver:self forKeyPath:@"location" options:0 context:NULL];
}

// 通知センターを利用したデータ取得処理
// 今回は緯度経度を取得している
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    mapView.centerCoordinate = mapView.userLocation.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapView.userLocation.location.coordinate, span);
    [mapView setRegion:region animated:YES];

    [mapView.userLocation removeObserver:self forKeyPath:@"location"];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:mapView.userLocation.location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         NSString *my_str = [[NSString alloc] init];
         
         if ([placemarks count] > 0){
             CLPlacemark *my_placemark = [placemarks objectAtIndex:0];
             NSArray *address = [my_placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             my_str = @"";
             for(int i=0;i<[address count];i++){
                 my_str = [my_str stringByAppendingString:[address objectAtIndex:i]];
             }
             //頭の郵便番号を除去
             NSRegularExpression *regexp =
             [NSRegularExpression regularExpressionWithPattern:@"^〒\\d{3}-\\d{4} (.+)"
                                                       options:0
                                                         error:nil];
             NSTextCheckingResult *match =
             [regexp firstMatchInString:my_str options:0 range:NSMakeRange(0, my_str.length)];
             
             if(match.numberOfRanges > 0) //〒123-4567の場合
                 my_str = [my_str substringWithRange:[match rangeAtIndex:1]];
             
             regexp = [NSRegularExpression regularExpressionWithPattern:@"^\\d{7} (.+)"
                                                                options:0
                                                                  error:nil];
             match =
             [regexp firstMatchInString:my_str options:0 range:NSMakeRange(0, my_str.length)];
             
             if(match.numberOfRanges > 0)
                 my_str = [my_str substringWithRange:[match rangeAtIndex:1]];
        }else{
             my_str = @"(不明)";
         }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
  return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = @"MenuItemCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
  }
  
  cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = [NSString stringWithFormat:@"%@View", [menuItems objectAtIndex:indexPath.row]];

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
    [self setNavBar:nil];
    [super viewDidUnload];
}

@end
