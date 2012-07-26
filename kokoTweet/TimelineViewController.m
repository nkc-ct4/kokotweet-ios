//
//  TimelineViewController.m
//  TweetTest
//
//  Created by Satou Shingo on 12/05/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#ifdef DEBUG
#define PrintLog(format, ...)	NSLog((@"[%@:%d]%s " format), [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent], __LINE__, __FUNCTION__, ##__VA_ARGS__)
#define PrintLogS	NSLog
#define PrintLogF	printf
#else
#define PrintLog(format, ...)
#define PrintLogS
#define PrintLogF
#endif

#import "TimelineViewController.h"
#import "SettingDialogController.h"


@interface TimelineViewController ()

@end

@implementation TimelineViewController

@synthesize accountsArray;
@synthesize accountNameArray;
@synthesize loadingView;
@synthesize indicator;
@synthesize accountIdentifier;
@synthesize geocodeStr;
@synthesize distance;

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
    //初期設定確認
    self.accountsArray = [[NSMutableArray array]init];
    self.accountNameArray = [[NSMutableArray array]init];
    
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //int accountNumber = [defaults integerForKey:@"AccountNumber"];
    self.accountIdentifier = [defaults stringForKey:@"AccountIdentifier"];
    if (self.accountIdentifier == nil) {
        [self configWidnowShow];
        return;
    }
    
    
    //更新日時
    NSDate* date = [NSDate date];
    self.tableView.showsInfiniteScrolling = NO;
    //location初期化
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    //初期値
    distance = @"10km";
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    //PullToRefresh処理
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        // 位置情報サービスが利用できるかどうかをチェック
        self.tableView.pullToRefreshView.lastUpdatedDate = nil;
        self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];

        if ([CLLocationManager locationServicesEnabled]) {
            // 測位開始
            [locationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services not available.");
        }

    }];
    
   // [self.tableView.pullToRefreshView triggerRefresh];
    //更新忘れずに


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
    //ツイート個数カウント ＋ セル個数確定
    return [statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    //resultsにjson形式で入れる
    NSDictionary *results = [statuses objectAtIndex:indexPath.row];

    
    UIImageView *imageview =(UIImageView *)[cell viewWithTag:1];
    UILabel *namelabel = (UILabel*)[cell viewWithTag:2];
    UILabel *postText = (UILabel*)[cell viewWithTag:3];
    UILabel *datalabel = (UILabel *)[cell viewWithTag:4];

    
    //text表示
    NSString *text = [results objectForKey:@"text"];
    [postText setLineBreakMode:UILineBreakModeWordWrap];
    [postText setNumberOfLines:0];
    postText.text = text;
 
    //user名表示
    NSString *name = [results objectForKey:@"from_user"];
    namelabel.text = name;
    
    //画像をcacheしながら表示
    imageview.image = [[JMImageCache sharedCache] imageForURL:[results objectForKey:@"profile_image_url"] delegate:self];
    
    
    //string → data変換
    NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    //ロケールの設定
    [inputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    [inputDateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    NSString *intputDateStr = (NSString *)[results objectForKey:@"created_at"];
    NSDate *inputDate = [inputDateFormatter dateFromString:intputDateStr];
   
    //NSDate->NSString
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"JST"]];
    df.dateFormat  = @"yyyy-MM-dd HH:mm";

    NSString *date_str = [df stringFromDate:inputDate];
    //日時表示
    datalabel.text = date_str;

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    //セルの高さを計算
    NSDictionary *status = [statuses objectAtIndex:indexPath.row];
    //NSString *name = [status objectForKey:@"text"];
    NSString *text = [status objectForKey:@"text"];

	
	CGFloat cellHeight = 44; // カスタムセルのデフォルトのheight
	CGFloat textHeight = 23; // カスタムセル内の複数行表示したいラベルのデフォルトのheight
    
	
	UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17]; // IBで設定したのと同じに。
	CGSize size = CGSizeMake(271, 4000); // カスタムセル内のラベルのwidth。heightは適当に。
	CGSize textSize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap]; // IBで設定したのと同じlineBreakModeにする。
	
	cellHeight += (textSize.height - textHeight);

    if(cellHeight <= 44){
        cellHeight = 60;
    }
  //  cellHeight　+ sizeMente;
	return cellHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //ツイート詳細画面へ画面遷移＋データ渡し
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailViewController *tweetDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    tweetDetail.array = [statuses objectAtIndex:indexPath.row];
    [[self navigationController] pushViewController:tweetDetail animated:YES];
    
}

//tweet処理
- (IBAction)pressTwitter:(id)sender {
    if([TWTweetComposeViewController canSendTweet]){
        TWTweetComposeViewController *composeViewController = 
        [[TWTweetComposeViewController alloc] init];
        [self presentModalViewController:composeViewController animated:YES];
    }
}
//キャッシュ処理
- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSString *)url {
    [self.tableView reloadData];
}

//location取得
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
            
            //緯度・経度を取得
            CLLocationCoordinate2D coordinate = newLocation.coordinate;
                    
            //nsstring型に緯度経度を整形
            geocodeStr = [NSString stringWithFormat:@"%f,%f", coordinate.latitude,
                            coordinate
                            .longitude];
                    
            //location停止
            [locationManager stopUpdatingLocation];
            
            //アカウント取得
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccount *account = [accountStore accountWithIdentifier:self.accountIdentifier];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
         
            geocodeStr = [NSString stringWithFormat:@"http://search.twitter.com/search.json?geocode=%@,%@",geocodeStr,distance];
                    NSLog(@"geocodeStr %@",geocodeStr);
                    //http://search.twitter.com/search.json?geocode=35.44444,126.888888,10km
                
            NSURL *url = [NSURL URLWithString:geocodeStr];
                    
            
            TWRequest *request = [[TWRequest alloc] initWithURL:url
                                                     parameters:parameters
                                                  requestMethod:TWRequestMethodGET];
            
            [request setAccount:account];
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(!responseData){
                            NSLog(@"%@", error);
                        }else{
                            NSError *error;
                            NSDictionary *request;
                            request = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableLeaves
                                                                error:&error];
            statuses = [request objectForKey:@"results"];
                        
                    
            if(statuses){
                    NSLog(@"%@", statuses);
                    }else{
                        NSLog(@"%@", error);
                    }
                            [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil];
                        [self.tableView reloadData];
                    }
                });
            }];
}

//locationerror
- (void)locationManager:(CLLocationManager*)manager 
       didFailWithError:(NSError*)error {
}

-(void)configWidnowShow{
	// Twitterアカウントの一覧を取得.
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	//ローディング画面表示
    loadingView = [[UIView alloc] initWithFrame:[[self view] bounds]];
    [loadingView setBackgroundColor:[UIColor blackColor]];
    [loadingView setAlpha:0.5];
    //textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    //textlabel.text = @"Twitterアカウントを取得中...";
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [[self view] addSubview:loadingView];
    //[loadingView addSubview:textlabel];
    [loadingView addSubview:indicator];
    [indicator setFrame:CGRectMake ((320/2)-20, (480/2)-60, 40, 40)];
    [indicator startAnimating]; 
    
	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
		if(granted) {
            //ローディング画面終了
            [indicator stopAnimating];
            [loadingView removeFromSuperview];
            
			// Get the list of Twitter accounts.
			self.accountsArray = [accountStore accountsWithAccountType:accountType];
            
            self.accountNameArray = [ [NSMutableArray array]init];
            
            for(ACAccount *ac in self.accountsArray){
                [self.accountNameArray addObject:[NSString stringWithString:ac.username] ];
            }
            //SettingDialogController *settingDialogController = [[SettingDialogController alloc] init];
            QRootElement *details = [SettingDialogController createDetailsForm:self.accountNameArray];
            //            QuickDialogController *qcont = [[QuickDialogController alloc] initWithRoot:];
            SettingDialogController *qcont = [SettingDialogController controllerForRoot:details];
            qcont.willDisappearCallback = ^() {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [details fetchValueIntoObject:dict];
                int number = [ [dict valueForKey:@"selectAccountNum"] intValue ];
                number++;
                //NSLog( [self.accountsArray objectAtIndex:number] );
                // Do any additional setup after loading the view, typically from a nib.
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                int accountNumber = [defaults integerForKey:@"AccountNumber"];
                if (accountNumber != number) {
                    [defaults setInteger:number forKey:@"AccountNumber"];
                    //        ACAccount* account = [accountsArray objectAtIndex:path.row];
                }
            };
            
            [self dismissModalViewControllerAnimated:YES];
            [self.parentViewController dismissModalViewControllerAnimated:YES];
            qcont.delegate = self;

            
            [self presentModalViewController:[[UINavigationController alloc] initWithRootViewController:qcont] animated:YES];
		}
	}];
    
}

/*
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
}
*/

-(void) modalViewWillClose{
    NSLog(@"close");
    [self dismissModalViewControllerAnimated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int accountNumber = [defaults integerForKey:@"AccountNumber"];
    ACAccount* account = [self.accountsArray objectAtIndex:accountNumber - 1];
    self.accountIdentifier = account.identifier;
    [defaults setObject:self.accountIdentifier forKey:@"AccountIdentifier"];

    //設定反映のため起動時と同じ処理を行う
    
    NSDate* date = [NSDate date];
    self.tableView.showsInfiniteScrolling = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    
    distance = @"10km";
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        // 測位開始
        [locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
    
    //更新
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        // 位置情報サービスが利用できるかどうかをチェック
        self.tableView.pullToRefreshView.lastUpdatedDate = nil;
        self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
        
        if ([CLLocationManager locationServicesEnabled]) {
            // 測位開始
            [locationManager startUpdatingLocation];
        } else {
            NSLog(@"Location services not available.");
        }
        
    }];
}

@end
