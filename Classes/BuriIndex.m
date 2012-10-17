//
//  BuriIndex.cpp
//  Buri
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 SpotDog. All rights reserved.
//

#include "BuriIndex.h"

@implementation BuriBinaryIndex

- (id)initWithKey:(NSString *)key data:(NSData *)data
{
	return [self initWithKey:key value:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
}

- (id)initWithKey:(NSString *)key value:(NSString *)value
{
	if (self = [super init]) {
		_indexKey	= key;
		_indexValue = value;
	}

	return self;
}

- (NSString *)key
{
    return _indexKey;
}

- (NSString *)value
{
    return _indexValue;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_indexKey	= [decoder decodeObjectForKey:@"indexKey"];
		_indexValue = [decoder decodeObjectForKey:@"indexValue"];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_indexKey forKey:@"indexKey"];
	[encoder encodeObject:_indexValue forKey:@"indexValue"];
}

@end

@implementation BuriNumericIndex

- (id)initWithKey:(NSString *)key value:(NSNumber *)value
{
	if (self = [super init]) {
		_indexKey	= key;
		_indexValue = value;
	}

	return self;
}

- (NSString *)key
{
    return _indexKey;
}

- (NSNumber *)value
{
    return _indexValue;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_indexKey	= [decoder decodeObjectForKey:@"indexKey"];
		_indexValue = [decoder decodeObjectForKey:@"indexValue"];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_indexKey forKey:@"indexKey"];
	[encoder encodeObject:_indexValue forKey:@"indexValue"];
}

@end