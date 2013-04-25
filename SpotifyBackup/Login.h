//
//  Login.h
//  SpotifyBackup
//
//  Created by Max Woolf on 10/04/2013.
//  Copyright (c) 2013 MaxWoolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface Login : NSObject <SPSessionDelegate>
{
    NSArray *playlistArray;
    NSMutableArray *processedPlaylists;
    NSString *credentials;
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password credentials:(NSString *)credentials;
-(void)processPlaylists;
@end
