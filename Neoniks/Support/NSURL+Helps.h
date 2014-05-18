//
//  NSURL+Helps.h
//  Neoniks
//
//  Created by Andrei Vidrasco on 5/18/14.
//  Copyright (c) 2014 Andrei Vidrasco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Helpers)

+(NSURL *)urlFromName:(NSString *)name extension:(NSString *)extension;
+(NSURL *)urlFromLocalizedName:(NSString *)name extension:(NSString *)extension;

@end
