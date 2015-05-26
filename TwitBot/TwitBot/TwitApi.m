//
//  TwitApi.m
//  TwitBot
//
//  Created by Admin on 5/26/15.
//  Copyright (c) 2015 Touchin. All rights reserved.
//

#import "TwitApi.h"
#import "OAuthConsumer.h"

@implementation TwitApi

static NSString* const oAuthConsumerKey = @"WkLxKrBPzrxbiWVLKhLoPhsOM";
static NSString* const consumerSecret = @"0dbCsRUF74Wu29RPFEg8ktP3EU7uyELZ2UyTiD6Pz9vNU64YEL";
static NSString* const username = @"maria.mihailova@touchin.ru";
static NSString* const password = @"iphoneandroidwp7";

NSObject<TwitApiClient> *authClient;
OAToken *requestToken;
OAToken *accessToken;
OAConsumer *consumer;

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)authenticateWithClient:(NSObject<TwitApiClient> *)client{
    authClient = client;
    consumer = [[OAConsumer alloc] initWithKey:oAuthConsumerKey
                                                    secret:consumerSecret];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:nil
                                                                      realm:nil
                                                          signatureProvider:nil];
    
    [request setHTTPMethod:@"POST"];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        requestToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
        
        NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
        OAMutableURLRequest* authorizeRequest = [[OAMutableURLRequest alloc] initWithURL:authorizeUrl
                                                                                consumer:nil
                                                                                   token:nil
                                                                                   realm:nil
                                                                       signatureProvider:nil];
        NSString* oauthToken = requestToken.key;
        OARequestParameter* oauthTokenParam = [[OARequestParameter alloc] initWithName:@"oauth_token" value:oauthToken];
        [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];

        if(authClient){
            [authClient setUrlRequest:authorizeRequest];
        }
    }
}

- (void) requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSData *)data
{
    NSLog(@"error!");
}

- (BOOL) verifyRedirectWithRequest:(NSURLRequest*)request
{
    NSString *temp = [NSString stringWithFormat:@"%@",request];
    NSRange textRange = [[temp lowercaseString] rangeOfString:[@"https://www.yandex.ru/" lowercaseString]];
    
    if(textRange.location != NSNotFound){
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequest* accessTokenRequest = [[OAMutableURLRequest alloc] initWithURL:accessTokenUrl consumer:consumer token:requestToken realm:nil signatureProvider:nil];
            OARequestParameter* verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        }
        else {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)didReceiveAccessToken:(OAServiceTicket*)ticket data:(NSData*)data {
    
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:httpBody];
    // WebServiceSocket *connection = [[WebServiceSocket alloc] init];
    //  connection.delegate = self;
    NSString *pdata = [NSString stringWithFormat:@"type=2&token=%@&secret=%@&login=%@", accessToken.key, accessToken.secret, @"true"];
    // [connection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
    NSLog(@"%@",accessToken.secret);
    
}

- (void)didFailOAuth:(OAServiceTicket*)ticket error:(NSError*)error {
    NSLog(@"didFailOAuth");
}

@end
