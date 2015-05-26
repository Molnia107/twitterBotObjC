//
//  TwitTwit.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitTwit.h"
#import "TwitUser.h"

@implementation TwitTwit

-(id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.text = [dictionary valueForKey:@"text"];
        NSDictionary *userDictionary = [dictionary valueForKey:@"user"];
        TwitUser *user = [[TwitUser alloc] initWithDictionary:userDictionary];
        self.user = user;
    }
    return self;
}

@end
