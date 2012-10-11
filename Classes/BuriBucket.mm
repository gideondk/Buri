//
//  BuriBucket.cpp
//  LevelDB
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 Pave Labs. All rights reserved.
//

#import "BuriBucket.h"
#import "BuriSerialization.h"
#import "BuriIndex.h"

@implementation BuriBucket

@synthesize buri		= _buri;
@synthesize usedClass	= _usedClass;

- (id)initWithDB:(Buri *)aDb andObjectClass:(Class)aClass
{
	self = [super init];

	if (self) {
		_buri		= aDb;
		_name		= NSStringFromClass(aClass);
		_usedClass	= aClass;
		[self fetchOrCreateBucketPointer];
	}

	return self;
}

- (NSString *)prefixKey:(NSString *)origKey
{
	return [NSString stringWithFormat:@"%@::%@", _name, origKey];
}

- (NSString *)prefixBinaryIndexKey:(NSString *)origKey
{
    return [NSString stringWithFormat:@"%@_bin_index::%@", _name, origKey];
}

- (NSString *)prefixIntegerIndexKey:(NSString *)origKey
{
    return [NSString stringWithFormat:@"%@_int_index::%@", _name, origKey];
}

- (NSString *)bucketPointerKey
{
	return [self prefixKey:@""];
}

- (NSString *)removePrefixFromKey:(NSString *)prefixedKey
{
	int slicePosition = [prefixedKey rangeOfString:[self bucketPointerKey]].length;
	return [prefixedKey substringFromIndex:slicePosition];
}

- (void)fetchOrCreateBucketPointer
{
	NSString *value = [_buri getObject:[self bucketPointerKey]];
	if (!value) {
		[_buri putObject:@"*" forKey:[self bucketPointerKey]];
	}
}

- (NSArray *)allKeys
{
	NSMutableArray *keys = [[NSMutableArray alloc] init];

	[_buri seekToKey:[self bucketPointerKey] andIterateKeys:^BOOL (NSString * key) {
			if ([key rangeOfString:[self bucketPointerKey]].location != 0)
				return NO;

			[keys addObject:[self removePrefixFromKey:key]];
			return YES;
		}];

	// Remove pointer
	[keys removeObjectAtIndex:0];
	return keys;
}

- (NSArray *)allObjects
{
	NSMutableArray *objects = [[NSMutableArray alloc] init];

	[_buri seekToKey:[self bucketPointerKey] andIterate:^BOOL (NSString * key, id value) {
			if ([key rangeOfString:[self bucketPointerKey]].location != 0)
				return NO;

			if ([value isMemberOfClass:[BuriWriteObject class]]) {
				[objects addObject:[(BuriWriteObject *) value storedObject]];
			}

			return YES;
		}];

	return objects;
}

- (id)fetchObjectForKey:(NSString *)key
{
	BuriWriteObject *wo = [_buri getObject:[self prefixKey:key]];
	return [wo storedObject];
}

- (void)storeObject:(NSObject <BuriSupport> *)value
{
	BuriWriteObject *wo = [[BuriWriteObject alloc] initWithBuriObject:value];

	[_buri putObject:wo forKey:[self prefixKey:[wo key]]];
}

- (void)storeBinaryIndexesForWriteObject:(BuriWriteObject *)wo
{
    NSArray *binaryIndexes = [wo binaryIndexes];
    for (BuriBinaryIndex *index in binaryIndexes) {
        
    }
}

// - (id)getObject:(NSString *)key
// {
//    return [_db getObject:[self prefixKey:key]];
// }

// - (void)putObject:(NSObject <BuriSupport> *)storeObject
// {
//    if ([storeObject class] != _usedClass)
//        [NSException raise:@"Storing different object type" format:@"the object type you are trying to store, should be of the %@ class", NSStringFromClass(_usedClass)];
//    NSString *aKey = [storeObject valueForKey:[_usedClass primaryKey]];
//    [self putObject:storeObject forKey:[self prefixKey:aKey]];
// }
//
// - (void)deleteObjectForKey:(NSString *)key
// {
//    NSObject <BuriSupport> *obj = [self getObjectForKey:key];
//    [self deleteObject:obj];
// }
//
// - (void)deleteObject:(NSObject <BuriSupport> *)storeObject
// {
//    if ([storeObject class] != _usedClass)
//        [NSException raise:@"Storing different object type" format:@"the object type you are trying to store, should be of the %@ class", NSStringFromClass(_usedClass)];
//
//    NSString *aKey = [storeObject valueForKey:[_usedClass primaryKey]];
//    [_db deleteObject:aKey];
// }

@end