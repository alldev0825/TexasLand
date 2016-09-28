//
//  Server.h
//  ZoesKitchen
//
//  Created by Ajay Kumar on 25/08/12.
//  Copyright (c) 2012 Mycompany. All rights reserved.
//

//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Server;

@protocol ServerProtocol

- (void) requestFinished:( NSString* )responseData;
- (void) requestError:( NSString* )responseData;
- (void) requestNetworkError;
@end


@interface Server : NSObject
{
    NSMutableArray				   *daataArray;
	ServerRequestType		currentRequestType;
    NSMutableData           *receivedData;
    id <ServerProtocol> delegate;
}

@property (retain,nonatomic) id <ServerProtocol> delegate;

- (void) sendRequestToServer:(NSDictionary*)userInfo;
- (NSMutableArray*)getResults;


@end
