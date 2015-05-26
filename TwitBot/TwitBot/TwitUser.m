//
//  TwitUser.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitUser.h"

@implementation TwitUser

-(id)initWithDictionary:(NSDictionary*) dictionary{
    self = [super init];
    if(self){
        self.name = [dictionary valueForKey:@"name"];
        self.imageUrl = [dictionary valueForKey:@"profile_image_url"];
    }
    return self;
}

@end
