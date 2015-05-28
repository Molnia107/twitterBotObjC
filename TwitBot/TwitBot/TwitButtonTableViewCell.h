//
//  TwitButtonTableViewCell.h
//  TwitBot
//
//  Created by Admin on 5/28/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TwitShowMoreDelegate <NSObject>

-(void)showMoreTwits;

@end

@interface TwitButtonTableViewCell : UITableViewCell

@property (strong, nonatomic) NSObject<TwitShowMoreDelegate> *showMoreDelegate;

@end
