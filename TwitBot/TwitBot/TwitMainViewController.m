//
//  ViewController.m
//  TwitBot
//
//  Created by Admin on 5/25/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitMainViewController.h"
#import "TwitTableViewCell.h"
#import "TwitApi.h"

@interface TwitMainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) TwitApi *twitApi;
@property (strong, nonatomic) NSArray *twitsArray;
@end

@implementation TwitMainViewController

static NSString *twitCellIdentifier = @"TwitCell";
static NSString *twitCellNibName = @"TwitTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.twitApi = [TwitApi sharedInstance];
    [self.twitApi authenticateWithClient:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.twitsArray){
        return self.twitsArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TwitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
    if(!cell) {
        [self.tableView registerNib:[UINib nibWithNibName:twitCellNibName bundle:nil] forCellReuseIdentifier:twitCellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
    }
    [cell updateWithTwit:self.twitsArray[indexPath.row]];
    return cell;
}

#pragma TwitApiClient

-(void)setUrlRequest:(NSURLRequest *)urlRequest{
    [self.webView loadRequest:urlRequest];
}

-(void)setAuthenticateRezult:(BOOL)result{
    if(result && self.tabBar.items.count > 0)
    {
        UITabBarItem *item =self.tabBar.items[0];
        self.tabBar.selectedItem = item;
        [self getTwitsForTabBarItem:item];
    }
}

-(void)setTwits:(NSArray *)twits ForTag:(NSString *)tag{
    if([self checkTag:tag]){
        self.twitsArray = twits;
        [self.tableView reloadData];
        [self hideSpinner];
    }
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(self.twitApi){
        BOOL result = [self.twitApi verifyRedirectWithRequest:request];
        if(result){
            [self.webView removeFromSuperview];
            [self.tabBar setHidden:false];
            [self showSpinner];
            return false;
        }
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}

#pragma UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.navigationItem.title = item.title;
    [self showSpinner];
    [self getTwitsForTabBarItem:item];
}

- (void)getTwitsForTabBarItem:(UITabBarItem *)item{
    if(self.twitApi){
        NSString *tag = [self getTagFromTabBarItem:item];
        [self.twitApi getTwitsByTag:tag];
    }
}

- (bool)checkTag:(NSString *) tag{
    NSString *tagFromTitle = [self getTagFromTabBarItem: self.tabBar.selectedItem];
    NSComparisonResult comparisonResult = [tag compare: tagFromTitle options:NSCaseInsensitiveSearch];
    return (comparisonResult == NSOrderedSame);
}

- (NSString*)getTagFromTabBarItem:(UITabBarItem *)item{
    return [item.title stringByReplacingOccurrencesOfString:@"#" withString:@""];
}

- (UIActivityIndicatorViewStyle) spinnerStyle
{
    return UIActivityIndicatorViewStyleGray;
}

- (void)showSpinner
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.spinnerStyle];
        spinner.center = self.view.center;
        spinner.tag = 12;
        [self.view addSubview:spinner];
        [spinner startAnimating];
    });
}

- (void)hideSpinner
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.view viewWithTag:12] removeFromSuperview];
    });
}

@end
