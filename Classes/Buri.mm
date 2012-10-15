//
//  Buri.cpp
//  LevelDB
//
//  Created by Gideon de Kok on 10/9/12.
//  Copyright (c) 2012 Pave Labs. All rights reserved.
//

#import <leveldb/db.h>
#import <leveldb/options.h>

using namespace leveldb;

#define SliceFromString(_string_) (Slice((char *)[_string_ UTF8String], [_string_ lengthOfBytesUsingEncoding:NSUTF8StringEncoding]))
#define StringFromSlice(_slice_) ([[NSString alloc] initWithBytes:_slice_.data() length:_slice_.size() encoding:NSUTF8StringEncoding])

struct LevelDB {
    DB              *db;
    ReadOptions		readOptions;
    WriteOptions	writeOptions;
};

using namespace leveldb;

static Slice SliceFromObject(id object) {
    NSMutableData *d = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:d];
    [archiver encodeObject:object forKey:@"object"];
    [archiver finishEncoding];
    
    return Slice((const char *)[d bytes], (size_t)[d length]);
}

static id ObjectFromSlice(Slice v) {
    NSData *data = [NSData dataWithBytes:v.data() length:v.size()];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    id object = [unarchiver decodeObjectForKey:@"object"];
    [unarchiver finishDecoding];
    return object;
}

#import "Buri.h"

@implementation Buri

@synthesize path = _path;

- (id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
        levelDB = new LevelDB();
        Options options;
        options.create_if_missing = true;
        Status status = leveldb::DB::Open(options, [_path UTF8String], &levelDB->db);
        
        levelDB->readOptions.fill_cache = false;
        levelDB->writeOptions.sync = false;
        
        if(!status.ok()) {
            NSLog(@"Problem creating Buri database: %s", status.ToString().c_str());
        }
        
    }
    
    return self;
}

+ (NSString *)libraryPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return paths[0];
}

+ (Buri *)databaseInLibraryWithName:(NSString *)name {
    NSString *path = [[Buri libraryPath] stringByAppendingPathComponent:name];
    Buri *ldb = [[Buri alloc] initWithPath:path];
    return ldb;
}

- (void) putObject:(id)value forKey:(NSString *)key {
    Slice k = SliceFromString(key);
    Slice v = SliceFromObject(value);
    Status status = levelDB->db->Put(levelDB->writeOptions, k, v);
    
    if(!status.ok()) {
        NSLog(@"Problem storing key/value pair in database: %s", status.ToString().c_str());
    }
}

- (id) getObject:(NSString *)key {
    std::string v_string;
    
    
    Slice k = SliceFromString(key);
    Status status = levelDB->db->Get(levelDB->readOptions, k, &v_string);
    
    if(!status.ok()) {
        if(!status.IsNotFound())
            NSLog(@"Problem retrieving value for key '%@' from database: %s", key, status.ToString().c_str());
        return nil;
    }
    
    return ObjectFromSlice(v_string);
}


- (void)deleteObject:(NSString *)key {
    
    Slice k = SliceFromString(key);
    Status status = levelDB->db->Delete(levelDB->writeOptions, k);
    
    if(!status.ok()) {
        NSLog(@"Problem deleting key/value pair in database: %s", status.ToString().c_str());
    }
}

- (void) clear {
    NSArray *keys = [self allKeys];
    for (NSString *k in keys) {
        [self deleteObject:k];
    }
}

- (NSArray *)allKeys {
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    //test iteration
    [self iterateKeys:^BOOL(NSString *key) {
        [keys addObject:key];
        return TRUE;
    }];
    return keys;
}

- (void)iterate:(KeyValueBlock)block {
    Iterator* iter = levelDB->db->NewIterator(ReadOptions());
    for (iter->SeekToFirst(); iter->Valid(); iter->Next()) {
        Slice key = iter->key(), value = iter->value();
        NSString *k = StringFromSlice(key);
        id v = ObjectFromSlice(value);
        if (!block(k, v)) {
            break;
        }
    }
    
    delete iter;
}

- (void)iterateKeys:(KeyBlock)block {
    Iterator* iter = levelDB->db->NewIterator(ReadOptions());
    for (iter->SeekToFirst(); iter->Valid(); iter->Next()) {
        Slice key = iter->key();
        NSString *k = StringFromSlice(key);
        if (!block(k)) {
            break;
        }
    }
    
    delete iter;
}

- (void)seekToKey:(NSString *)key andIterate:(KeyValueBlock)block
{
    Slice k = SliceFromString(key);
    Iterator* iter = levelDB->db->NewIterator(ReadOptions());
    
    for (iter->Seek(k); iter->Valid(); iter->Next()) {
        Slice key = iter->key(), value = iter->value();
        NSString *k = StringFromSlice(key);
        id v = ObjectFromSlice(value);
        if (!block(k, v)) {
            break;
        }
    }
    
    delete iter;
}

- (void)seekToKey:(NSString *)key andIterateKeys:(KeyBlock)block
{
    Slice k = SliceFromString(key);
    Iterator* iter = levelDB->db->NewIterator(ReadOptions());
    
    for (iter->Seek(k); iter->Valid(); iter->Next()) {
        Slice key = iter->key();
        NSString *k = StringFromSlice(key);
        if (!block(k)) {
            break;
        }
    }
    
    delete iter;
}

- (void)deleteDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:_path error:&error];
}

@end
