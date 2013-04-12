//
//  main.m
//  SpotifyBackup
//
//  Created by Max Woolf on 10/04/2013.
//  Copyright (c) 2013 MaxWoolf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Login.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        
        Login *login = [[Login alloc] init];
        [login loginWithUsername:[NSString stringWithUTF8String:argv[1]] password:[NSString stringWithUTF8String:argv[2]]];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

