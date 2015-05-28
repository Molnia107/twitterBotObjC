//
//  ViewController.m
//  TwitBot
//
//  Created by Admin on 5/25/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitMainViewController.h"
#import "TwitTableViewCell.h"
#import "TwitSearchResult.h"

#import "TwitApi.h"

@interface TwitMainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITabBar *tabBar;

@property (strong, nonatomic) TwitApi *twitApi;
@property (strong, nonatomic) TwitSearchResult *twitSearchResult;
@end

@implementation TwitMainViewController

static NSString *twitCellIdentifier = @"TwitCell";
static NSString *twitCellNibName = @"TwitTableViewCell";
static NSString *buttonCellIdentifier = @"TwitButtonCell";
static NSString *buttonCellNibName = @"TwitButtonTableViewCell";

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
    if(self.twitSearchResult.twitsArray){
        return self.twitSearchResult.twitsArray.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.twitSearchResult.twitsArray.count){
        TwitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
        if(!cell) {
            [self.tableView registerNib:[UINib nibWithNibName:twitCellNibName bundle:nil] forCellReuseIdentifier:twitCellIdentifier];
            cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
        }
        [cell updateWithTwit:self.twitSearchResult.twitsArray[indexPath.row]];
        return cell;
    }
    else{
        TwitButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier];
        if(!cell) {
            [self.tableView registerNib:[UINib nibWithNibName:buttonCellNibName bundle:nil] forCellReuseIdentifier:buttonCellIdentifier];
            cell = [self.tableView dequeueReusableCellWithIdentifier:buttonCellIdentifier];
        }
        cell.showMoreDelegate = self;
        return cell;
    }
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

-(void)setSearchResult:(TwitSearchResult*)twitSearchResult{
    if([self checkTag:twitSearchResult.tag]){
        if(self.twitSearchResult && [self.twitSearchResult.tag isEqualToString: twitSearchResult.tag]){
            [self.twitSearchResult appendSearchResult:twitSearchResult];
        }
        else{
            self.twitSearchResult = twitSearchResult;
        }
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self getTwitsForTabBarItem:item];
}

#pragma ShowMoreDelegate

-(void)showMoreTwits{
    if(self.twitApi && self.twitSearchResult){
        [self.twitApi getTwitsByTag:self.twitSearchResult.tag afterTwit:self.twitSearchResult.minTwitId];
    }
}

#pragma local

- (void)getTwitsForTabBarItem:(UITabBarItem *)item{
    if(self.twitApi){
        NSString *tag = [self getTagFromTabBarItem:item];
        [self.twitApi getTwitsByTag:tag afterTwit:0];
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
