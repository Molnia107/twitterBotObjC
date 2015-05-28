//
//  TwitApi.h
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitSearchResult.h"

@protocol TwitApiClient<NSObject>

@required
-(void)setUrlRequest:(NSURLRequest *)urlRequest;
-(void)setAuthenticateRezult:(BOOL)result;
-(void)setSearchResult:(TwitSearchResult*)twitSearchResult;

@end


@interface TwitApi : NSObject

+ (instancetype)sharedInstance;
- (void)authenticateWithClient:(NSObject<TwitApiClient> *)client;
- (BOOL) verifyRedirectWithRequest:(NSURLRequest*)request;
- (void)getTwitsByTag:(NSString *)tag afterTwit:(NSNumber *)twitId;

@end
