//
//  BuriIndex.h
//  LevelDB
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 Pave Labs. All rights reserved.
//

@interface BuriBinaryIndex : NSObject {
	NSString	*_indexKey;
	NSString	*_indexValue;
}

- (NSString *)key;
- (NSString *)value;

- (id)initWithKey:(NSString *)key data:(NSData *)data;
- (id)initWithKey:(NSString *)key value:(NSString *)value;

@end

@interface BuriIntegerIndex : NSObject {
	NSString	*_indexKey;
	NSNumber	*_indexValue;
}

- (NSString *)key;
- (NSNumber *)value;

- (id)initWithKey:(NSString *)key value:(NSNumber *)value;

@end