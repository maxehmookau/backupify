//
//  Login.m
//  SpotifyBackup
//
//  Created by Max Woolf on 10/04/2013.
//  Copyright (c) 2013 MaxWoolf. All rights reserved.
//

#import "Login.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "appkey.h"

@implementation Login

- (void)login {
    NSError *mainError = nil;
    if([SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"maxWoolf.SpotifyBackup" loadingPolicy:SPAsyncLoadingImmediate error:&mainError])
    {
        NSLog(@"Created fine");
    }else{
        NSLog(@"Everything is not ok");
    }
    
    [[SPSession sharedSession] setDelegate:self];
    [[SPSession sharedSession] attemptLoginWithUserName:@"maxehmookau" password:@"fupk5ek2"];
    
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    NSLog(@"Error");
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"All good");

    SPSession *session = [SPSession sharedSession];
    
    [SPAsyncLoading waitUntilLoaded:session timeout:10.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems){
        NSLog(@"loaded session");
        
        [SPAsyncLoading waitUntilLoaded:session.userPlaylists timeout:10.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"loaded playlist container");
            NSArray *playlists = [[loadedItems objectAtIndex:0] flattenedPlaylists];
            [SPAsyncLoading waitUntilLoaded:playlists timeout:10.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                playlistArray = playlists;
                [self processPlaylists];
            }];
        }];
    }];
}

- (void)processPlaylists
{
    NSLog(@"%@", [playlistArray description]);
    for (SPPlaylist *playlist in playlistArray) {
        [SPAsyncLoading waitUntilLoaded:[playlist items] timeout:10.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            
        }];
    }
}


@end
