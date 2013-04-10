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
}
-(void)login;
-(void)processPlaylists;
@end
