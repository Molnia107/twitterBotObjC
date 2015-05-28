//
//  TwitTwit.h
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitUser.h"

@interface TwitTwit : NSObject

- (id)initWithDictionary:(NSDictionary*) dictionary;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) TwitUser *user;
@property (strong, nonatomic) NSDate *twitDate;
@property (strong, nonatomic) NSNumber *twitId;

@end

