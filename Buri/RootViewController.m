//
//  RootViewController.m
//  LevelDB
//
//  Copyright 2011 Pave Labs. All rights reserved.
//  See LICENCE for details.
//

#import "RootViewController.h"
#import "BuriSerialization.h"
#import "BuriBucket.h"
#import "Buri.h"

@implementation RootViewController


- (void)viewDidLoad
{
    [self performanceTest];
}

- (void)performanceTest
{
    perfDb = [Buri databaseInLibraryWithName:@"PerfDatabase.buri"];
    
    NSLog(@"-- Fills");
    [self simpleFill];
    [self complexFill];
    
    NSLog(@"\n\n-- Bucket Queries");
    [self bucketSweepTest];
    
    NSLog(@"\n\n-- Index Queries");
    [self indexKeyPerfTest];
    [self indexObjectPerfTest];
    [self indexRangePerfTest];
    
    [perfDb deleteDatabase];
    perfDb = nil;
}

- (void)simpleFill
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[SimpleFillObject class]];
    
    NSMutableArray *objs = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        SimpleFillObject *obj = [[SimpleFillObject alloc] init];
        [obj setObjectId:[self uuidString]];
        
        [objs addObject:obj];
    }
    
    NSDate *start = [NSDate date];
    for (SimpleFillObject *obj in objs) {
        [bucket storeObject:obj];
    }
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"-- Empty Database --");
    NSLog(@"Simple fill (objects w/o indexes): %f inserts / s", (10000 / (timeInterval * -1)));
}

- (void)complexFill
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];
    
    NSMutableArray *persons = [NSMutableArray array];
    for (int i = 0; i < 10000; i++) {
        Person *dirk = [[Person alloc] init];
        [dirk setObjectId:[self uuidString]];
        [dirk setName:@"Dirk"];
        [dirk setLocale:@"EN"];
        [dirk setAge:[NSNumber numberWithInt:20 + (i % 20)]];
        
        [persons addObject:dirk];
    }
    
    NSDate *start = [NSDate date];
    for (Person *person in persons) {
        [bucket storeObject:person];
    }
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"-- 10k items in database --");
    NSLog(@"Complex fill (objects w 2 indexes): %f inserts / s", (10000 / (timeInterval * -1)));
}

- (void)indexKeyPerfTest
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];
    
    NSDate *start = [NSDate date];
    NSArray *items = [bucket fetchKeysForBinaryIndex:@"locale" value:@"EN"];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"Index key retrieval: %f items / s", ([items count] / (timeInterval * -1)));
}

- (void)indexRangePerfTest
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];
    
    NSDate *start = [NSDate date];
    NSArray *items = [bucket fetchObjectsForIntegerIndex:@"age" from:@21 to:@24];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"Index object retrieval on range: %f items / s", ([items count] / (timeInterval * -1)));
}

- (void)bucketSweepTest
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];
    
    NSDate *start = [NSDate date];
    NSArray *items = [bucket allObjects];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"Bucket object sequential retrieval: %f items / s", ([items count] / (timeInterval * -1)));
}

- (void)indexObjectPerfTest
{
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:perfDb andObjectClass:[Person class]];
    
    NSDate *start = [NSDate date];
    NSArray *items = [bucket fetchObjectsForBinaryIndex:@"locale" value:@"EN"];
    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
    
    NSLog(@"Index object retrieval: %f items / s", ([items count] / (timeInterval * -1)));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell.
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}


@end

@implementation SimpleFillObject

@synthesize objectId = _objectId;

+(NSDictionary *)buriProperties {
    return @{
        BURI_KEY: @"objectId",
    };
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_objectId = [decoder decodeObjectForKey:@"objectId"];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_objectId forKey:@"objectId"];
}

@end

@implementation Person

@synthesize name = _name;
@synthesize cars = _cars;
@synthesize age = _age;
@synthesize locale = _locale;
@synthesize objectId = _objectId;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", _objectId, _name];
}

+(NSDictionary *)buriProperties {
    return @{
        BURI_KEY: @"objectId",
        BURI_BINARY_INDEXES: @[@"locale"],
        BURI_INTEGER_INDEXES: @[@"age"],
    };
}


- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
        _objectId		= [decoder decodeObjectForKey:@"objectId"];
		_name			= [decoder decodeObjectForKey:@"name"];
		_cars			= [decoder decodeObjectForKey:@"cars"];
		_age            = [decoder decodeObjectForKey:@"age"];
		_locale         = [decoder decodeObjectForKey:@"locale"];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_objectId forKey:@"objectId"];
	[encoder encodeObject:_name forKey:@"name"];
	[encoder encodeObject:_cars forKey:@"cars"];
	[encoder encodeObject:_age forKey:@"age"];
	[encoder encodeObject:_locale forKey:@"locale"];
}

@end

@implementation Car

@synthesize name = _name;
@synthesize buildYear = _buildYear;

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_name			= [decoder decodeObjectForKey:@"name"];
		_buildYear		= [decoder decodeIntForKey:@"buildYear"];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name forKey:@"name"];
	[encoder encodeInt:_buildYear forKey:@"buildYear"];
}

@end
