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

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    NSError *mainError = nil;
    if([SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"com.sharepfdslavcylists.cli85345435476" loadingPolicy:SPAsyncLoadingManual error:&mainError])
    {
        NSLog(@"Created fine");
    }else{
        NSLog(@"Everything is not ok %@", [mainError localizedDescription]);
        exit(EXIT_FAILURE);
    }
    
    processedPlaylists = [[NSMutableArray alloc] init];
    [[SPSession sharedSession] setDelegate:self];
    [[SPSession sharedSession] attemptLoginWithUserName:username password:password];
    
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    NSLog(@"Error");
    exit(EXIT_FAILURE);
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"All good");

    SPSession *session = [SPSession sharedSession];
    
    [SPAsyncLoading waitUntilLoaded:session timeout:10000.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems){
        NSLog(@"loaded session");
        
        [SPAsyncLoading waitUntilLoaded:session.userPlaylists timeout:10000.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"loaded playlist container");
            NSArray *playlists = [[loadedItems objectAtIndex:0] flattenedPlaylists];
            [SPAsyncLoading waitUntilLoaded:playlists timeout:10000.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                playlistArray = playlists;
                NSLog(@"%@", [playlistArray description]);
                [self processPlaylists];
            }];
        }];
    }];
}

- (void)processPlaylists
{
    processedPlaylists = [[NSMutableArray alloc] init];
    for (SPPlaylist *playlist in playlistArray) {
        NSMutableDictionary *currentPlaylist = [[NSMutableDictionary alloc] init];
        [currentPlaylist setValue:[playlist name] forKey:@"name"];
        [currentPlaylist setValue:[[playlist spotifyURL] absoluteString] forKey:@"url"];
        [currentPlaylist setValue:[playlist subscribers] forKey:@"subscribers"];
        
        NSMutableArray *playlistItems = [[NSMutableArray alloc] init];
        for (SPPlaylistItem *item in [playlist items]) {
            [playlistItems addObject:(SPTrack *)[item item]];
        }
        [SPAsyncLoading waitUntilLoaded:playlistItems timeout:100000.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            NSLog(@"Loaded: %@", [loadedItems description]);
            NSLog(@"Not Loaded: %@", [notLoadedItems description]);
            NSMutableArray *currentTracks = [[NSMutableArray alloc] init];
            for (SPTrack *track in loadedItems) {
                NSMutableDictionary *currentTrack = [[NSMutableDictionary alloc] init];
                [currentTrack setValue:[track name] forKey:@"title"];
                [currentTrack setValue:[track consolidatedArtists] forKey:@"artist"];
                [currentTrack setValue:[[track spotifyURL] absoluteString] forKey:@"url"];
                if ([track isLoaded]) {
                    [currentTrack setValue:@"YES" forKey:@"loaded"];
                }else{
                    [currentTrack setValue:@"NO" forKey:@"loaded"];
                }
                
                [currentTracks addObject:currentTrack];
                
            }
            [currentPlaylist setValue:currentTracks forKey:@"tracks"];
            [processedPlaylists addObject:currentPlaylist];
            if ([processedPlaylists count] == [playlistArray count]) {
                [[[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:processedPlaylists options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding] writeToFile:@"/dev/stdout" atomically:NO encoding:NSUTF8StringEncoding error:nil];
                exit(EXIT_SUCCESS);
            }
        }];
        
    }
    
    
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage
{
    NSLog(@"%@", aMessage);
}

-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage
{
    NSLog(@"Message: %@", aMessage);
}


@end
