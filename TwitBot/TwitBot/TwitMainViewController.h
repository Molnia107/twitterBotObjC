//
//  ViewController.h
//  TwitBot
//
//  Created by Admin on 5/25/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitApi.h"

@interface TwitMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,TwitApiClient, UIWebViewDelegate>


@end

