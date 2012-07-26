//
//  TweetDetailViewController.m
//  kokoTweet
//
//  Created by 多賀 淳哉 on 12/07/26.
//
//

#import "TweetDetailViewController.h"


@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController
@synthesize imageview;
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    imageview.image =  [[JMImageCache sharedCache] imageForURL:[array objectForKey:@"profile_image_url"] delegate:self];

    
}

- (void)viewDidUnload
{
    [self setImageview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void) cache:(JMImageCache *)c didDownloadImage:(UIImage *)i forURL:(NSString *)url {
    [self.view reloadInputViews];
}

@end
