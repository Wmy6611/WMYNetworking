//
//  HttpComm.h
//  MWYNetworking
//
//  Created by Wmy on 2017/2/4.
//  Copyright © 2017年 Wmy. All rights reserved.
//

#import <Foundation/Foundation.h>

/** HttpServer API success or fail error code. */
typedef enum _HTTP_API_RESULTS_
{
    /** HTTP API success */
    HTTP_SUCCESS = 0,
    /** HTTP API in progress, return progress rate or total bytes of transferred */
    HTTP_SUCCESS_INPROGRESS = 1,
    /** HTTP API abort */
    HTTP_SUCCESS_ABORT = 2,
    
    
    /** HTTP API default fail */
    HTTP_FAILURE = 50,
    /** Network no connection */
    HTTP_FAILURE_NETWORK_NO_CONNECTION = 100,
    /** Network connection failed */
    HTTP_FAILURE_NETWORK_CONNECTION_FAILED = 101,
    /** Network timeout */
    HTTP_FAILURE_NETWORK_TIMEOUT = 102,
    
    /** Parameter invalid */
    HTTP_FAILURE_PARAMETER_INVALID = 200,
    
    /** Server disconnect */
    HTTP_FAILURE_SERVER_DISCONNECT = 300,
    /** Server not exist */
    HTTP_FAILURE_SERVER_NOT_EXIST = 301,
    /** Not login */
    HTTP_FAILURE_NOT_AUTHORIZED = 400,
    /** Login fail */
    HTTP_FAILURE_AUTHORIZATION_FAILED = 401,
    /** No enough memory */
    HTTP_FAILURE_SYSTEM_OUTOFMEMORY = 500,
    /** Station unsupported */
    HTTP_FAILURE_STATION_UNSUPPORTED = 600,
    /** Station not enabled */
    HTTP_FAILURE_STATION_NOT_ENABLED = 601,
    
    /** File exist */
    HTTP_FAILURE_FILE_EXIST = 700,
    /** File not exist */
    HTTP_FAILURE_FILE_NOT_EXIST = 701,
    /** File permission denied */
    HTTP_FAILURE_FILE_PERMISSION_DENIED = 702,
    
    
}HTTP_API_RESULTS;


/*!
 * \brief
 * Content of API Response.
 *
 */
@interface HTTP_RESPONSE : NSObject

/** HTTP API result */
@property (assign) HTTP_API_RESULTS result;
/** HTTP API Response Content */
@property (strong) NSArray* response;

@end
