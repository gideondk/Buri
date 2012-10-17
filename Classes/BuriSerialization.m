//
//  BuriSerialization.cpp
//  Buri
//
//  Created by Gideon de Kok on 10/10/12.
//  Copyright (c) 2012 SpotDog. All rights reserved.
//

#include "BuriSerialization.h"
#include "BuriIndex.h"

@implementation BuriWriteObject

- (id)initWithBuriObject:(NSObject <BuriSupport> *)buriObject
{
	if (self = [super init]) {
		NSDictionary *objectProperties = [[buriObject class] buriProperties];

		if (!objectProperties[BURI_KEY]) {
			[NSException raise:@"No complete Buri object implementation" format:@"No key found in the property declaration."];
		}
        
        NSString *keyField = objectProperties[BURI_KEY];

        if (![buriObject respondsToSelector:NSSelectorFromString(keyField)]) {
            [NSException raise:@"Incorrect Buri object implementation" format:@"No getter found for key: %@", keyField];
        }
        
		_key = [buriObject performSelector:NSSelectorFromString(keyField)];
        if (!_key) {
            [NSException raise:@"Incorrect Buri object implementation" format:@"Nil value for key: %@", keyField];
        }

            
		_numericIndexes = @[];
		_binaryIndexes	= @[];

		if (objectProperties[BURI_NUMERIC_INDEXES]) {
			if ([objectProperties[BURI_NUMERIC_INDEXES] isMemberOfClass:[NSArray class]]) {
				[NSException raise:@"Incorrect Buri object implementation" format:@"Numeric indexes should be declared in array."];
			}

			NSArray *indexFields = objectProperties[BURI_NUMERIC_INDEXES];
            NSMutableArray *tempIndexes = [NSMutableArray array];
            
            for (id indexField in indexFields) {
				if (![buriObject respondsToSelector:NSSelectorFromString(indexField)]) {
					[NSException raise:@"Incorrect Buri object implementation" format:@"No getter found for: %@", indexField];
				}
                
				id indexValue = [buriObject performSelector:NSSelectorFromString(indexField)];
                
				if ([indexValue isKindOfClass:[NSNumber class]]) {
					[tempIndexes addObject:[[BuriNumericIndex alloc] initWithKey:indexField value:indexValue]];
				} else {
					[NSException raise:@"Incorrect Buri object implementation" format:@"Binary index values should be a NSString or NSData."];
				}
			}
            
            _numericIndexes = tempIndexes;
		}

		if (objectProperties[BURI_BINARY_INDEXES]) {
			if ([objectProperties[BURI_BINARY_INDEXES] isMemberOfClass:[NSArray class]]) {
				[NSException raise:@"Incorrect Buri object implementation" format:@"Binary indexes should be declared in array."];
			}

			NSArray *indexFields = objectProperties[BURI_BINARY_INDEXES];

			NSMutableArray *tempIndexes = [NSMutableArray array];

			for (id indexField in indexFields) {
				if (![buriObject respondsToSelector:NSSelectorFromString(indexField)]) {
					[NSException raise:@"Incorrect Buri object implementation" format:@"No getter found for: %@", indexField];
				}

				id indexValue = [buriObject performSelector:NSSelectorFromString(indexField)];

				if ([indexValue isKindOfClass:[NSString class]]) {
					[tempIndexes addObject:[[BuriBinaryIndex alloc] initWithKey:indexField value:indexValue]];
				} else if ([indexValue isKindOfClass:[NSData class]]) {
					[tempIndexes addObject:[[BuriBinaryIndex alloc] initWithKey:indexField data:indexValue]];
				} else {
					[NSException raise:@"Incorrect Buri object implementation" format:@"Binary index values should be a NSString or NSData."];
				}
			}

			_binaryIndexes = tempIndexes;
		}

		if (objectProperties[BURI_META_DATA]) {
			if ([objectProperties[BURI_BINARY_INDEXES] isMemberOfClass:[NSDictionary class]]) {
				[NSException raise:@"Incorrect Buri object implementation" format:@"Binary indexes should be declared in array."];
			}

			_metadata = objectProperties[BURI_META_DATA];
		}
        
        _value = buriObject;
	}

	return self;
}

- (NSString *)key
{
    return _key;
}

- (id)storedObject
{
    return _value;
}

- (NSArray *)binaryIndexes
{
    return _binaryIndexes;
}

- (NSArray *)numericIndexes
{
    return _numericIndexes;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_key			= [decoder decodeObjectForKey:BURI_KEY];
		_value			= [decoder decodeObjectForKey:BURI_VALUE];
		_numericIndexes = [decoder decodeObjectForKey:BURI_NUMERIC_INDEXES];
		_binaryIndexes	= [decoder decodeObjectForKey:BURI_BINARY_INDEXES];
		_metadata		= [decoder decodeObjectForKey:BURI_META_DATA];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_key forKey:BURI_KEY];
	[encoder encodeObject:_value forKey:BURI_VALUE];
	[encoder encodeObject:_numericIndexes forKey:BURI_NUMERIC_INDEXES];
	[encoder encodeObject:_binaryIndexes forKey:BURI_BINARY_INDEXES];
	[encoder encodeObject:_metadata forKey:BURI_META_DATA];
}

@end