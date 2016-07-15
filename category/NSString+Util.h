//
//  NSString+Util.h
//  iosapp
//
//  Created by AeternChan on 10/16/15.
//  Copyright © 2015 oschina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Util)

- (NSString *)escapeHTML;
- (NSString *)deleteHTMLTag;



-(BOOL)isNullOrEmpty;

-(NSString*)StringWithoutEmpty;


/** creates an MD5 checksum
 
 @return returns an MD5 hash for the receiver.
 */
- (NSString *)md5Checksum;

@end
