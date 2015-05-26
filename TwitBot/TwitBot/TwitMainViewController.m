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

@end

@implementation TwitMainViewController

static NSString *twitCellIdentifier = @"TwitCell";
static NSString *twitCellNibName = @"TwitTableViewCell";
TwitApi *twitApi;

- (void)viewDidLoad {
    [super viewDidLoad];
    twitApi = [TwitApi sharedInstance];
    [twitApi authenticateWithClient:self];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TwitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
    if(!cell) {
        [self.tableView registerNib:[UINib nibWithNibName:twitCellNibName bundle:nil] forCellReuseIdentifier:twitCellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:twitCellIdentifier];
    }

    return cell;
}


-(void)setUrlRequest:(NSURLRequest *)urlRequest{
    [self.webView loadRequest:urlRequest];
}

-(void)setAuthenticateRezult:(BOOL)result{
    if(result && self.tabBar.selectedItem)
    {
        [twitApi getTwitsByTag:self.tabBar.selectedItem.title];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if(twitApi){
        BOOL result = [twitApi verifyRedirectWithRequest:request];
        if(result){
            [self.webView removeFromSuperview];
            [self.tabBar setHidden:false];
            if(self.tabBar.items.count > 0){
                UITabBarItem *item =self.tabBar.items[0];
                [self.tabBar setSelectedItem:item];
            }
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

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    self.navigationItem.title = item.title;
    if(twitApi){
        [twitApi getTwitsByTag:item.title];
    }
}

@end
