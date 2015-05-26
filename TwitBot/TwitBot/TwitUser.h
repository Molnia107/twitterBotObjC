//
//  TwitUser.h
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitUser : NSObject

- (id)initWithDictionary:(NSDictionary*) dictionary;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageUrl;



@end
