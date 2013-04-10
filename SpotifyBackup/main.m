//
//  main.m
//  SpotifyBackup
//
//  Created by Max Woolf on 10/04/2013.
//  Copyright (c) 2013 MaxWoolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "appkey.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"MaxWoolf.SpotifyRadio" loadingPolicy:SPAsyncLoadingManual error:nil];
        
    }
    return 0;
}

