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
}
-(void)loginWithUsername:(NSString *)username password:(NSString *)password;
-(void)processPlaylists;
@end
