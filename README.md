#Buri

![Buri](http://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Treated_NKS_audhumla.jpg/300px-Treated_NKS_audhumla.jpg)


##Status

The current implementation should be treated as **alpha software** but should be stable and usable enough to try out in applications. Future updates could break the data structure, so by careful when updating...

##Overview

**Buri** is a easy to use object storage solution for Objective-C which is targeted a simpler and faster alternative to **CoreData**.

Object storage is implemented using the Google's C++ [leveldb](http://code.google.com/p/leveldb/) key-value store.

Buri supports the standard fetch, store and delete methods and implements some naïve secondary indexing functionality which can be used to retrieve objects by exact or ranged index matches.

##Installation

The easiest way to add **Buri** to your application, is to add it as a submodule to your application:

`git submodule add https://github.com/gideondk/Buri.git`

And retrieving and building the required leveldb dependency by initializing the submodule in the Buri subdirectory:

```
git submodule init
git submodule update
cd leveldb-library
make PLATFORM=IOS
```

Then drag and drop the `m, mm & h` files from the `Classes` directory into your project. And adding the `Buri/leveldb/include` path to your header path.

##Usage

###Protocol

Objects stored into Buri should be implementing the `<BuriSupport>` protocol. This protocol requires three methods to be implemented:

```
+ (NSDictionary *)buriProperties

- (id)initWithCoder:(NSCoder *)decoder
- (void)encodeWithCoder:(NSCoder *)encoder
```

The last two methods are used to serialize and deserialize objects into `NSData` objects and should follow the normal `NSEncoder` specifications.

The first method: `+ (NSDictionary *)buriProperties` should return the properties needed for Buri to store the objects in the database.

```
return @ {
        BURI_KEY: @"objectId",
        BURI_BINARY_INDEXES: @[@"locale"],
        BURI_NUMERIC_INDEXES: @[@"age"],
};
```

The first field `BURI_KEY` should point to the (`NSString *`) property or action which returns the unique identifier for the object.

The `BURI_BINARY_INDEXES` and `BURI_NUMERIC_INDEXES` are both `NSArray *` objects pointing to the properties or actions returning value which should be indexed (both binary `NSString *` as numerical `NSNumber *`).

###Client

Using the client requires two more preperation steps; creating a database and creating a bucket to store the objects.

```
Buri *db = [Buri databaseInLibraryWithName:@"Database.buri"];
BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];

```
LevelDB locks the file, so it is best to implement it in a singleton if you want to use the database multiple times in a application.

Fetching, storing and deleting objects is done by using the instance methods on the bucket:

```
- (id)fetchObjectForKey:(NSString *)key;

- (NSArray *)fetchKeysForBinaryIndex:(NSString *)indexField value:(NSString *)value;

- (NSArray *)fetchKeysForNumericIndex:(NSString *)indexField value:(NSNumber *)value;
- (NSArray *)fetchKeysForNumericIndex:(NSString *)indexField from:(NSNumber *)fromValue to:(NSNumber *)toValue;

- (NSArray *)fetchObjectsForBinaryIndex:(NSString *)indexField value:(NSString *)value;
- (NSArray *)fetchObjectsForBinaryIndex:(NSString *)indexField data:(NSData *)value;

- (NSArray *)fetchObjectsForNumericIndex:(NSString *)indexField value:(NSNumber *)value;
- (NSArray *)fetchObjectsForNumericIndex:(NSString *)indexField from:(NSNumber *)fromValue to:(NSNumber *)toValue;

- (NSArray *)allKeys;
- (NSArray *)allObjects;

- (void)storeObject:(NSObject <BuriSupport> *)value;

- (void)deleteForKey:(NSString *)key;
- (void)deleteObject:(NSObject <BuriSupport> *)storeObject;
```

##Performance

The current implementation of Buri works, but could be a lot faster (especially in the (de)serialization of objects).    
Nevertheless, the current implementation should be fast enough for most implementations:    




 Action	    |  iPhone 4		| iPhone 5 	   
------------ | ------------- | ------------ 
 Simple fill (objects w/o indexes)  | 490 o / s  | 1865 o / s 
 Complex fill (objects w 2 indexes) | 145 o / s  | 567 o / s 
 Bucket sequential retrieval |	1030 o / s | 3846 o /s		      | 
 2i key retrieval	|	3367 o / s | 12684 o / s
 2i object retrieval	|	704 o / s | 2892 o / s
 2i object retrieval on numerical range |	270 o / s | 1144 o /s

## Credits

Lots of credits go to [LevelDB-ObjC](https://github.com/hoisie/LevelDB-ObjC)  by [Michael Hoisie](https://github.com/hoisie)

## License

Distributed under the MIT license
