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
//    LevelDB *ldb = [LevelDB databaseInLibraryWithName:@"test.ldb"];
//
//    //test string
//    [ldb putObject:@"laval" forKey:@"string_test"];
//    NSLog(@"String Value: %@", [ldb getString:@"string_test"]);
//    
//    //test dictionary
//    [ldb putObject:[NSDictionary dictionaryWithObjectsAndKeys:@"val1", @"key1", @"val2", @"key2", nil] forKey:@"dict_test"];
//    NSLog(@"Dictionary Value: %@", [ldb getDictionary:@"dict_test"]);
//    [super viewDidLoad];
//    
//    //test invalid get
//    NSLog(@"Should be null: %@", [ldb getString:@"does_not_exist"]);
//    
//    [ldb iterate:^BOOL(NSString *key, id value) {
//        NSLog(@"value: %@", value);
//        return TRUE;
//    }];
//    
//    NSLog(@"String Value: %@", [ldb getString:@"string_test"]);
//     
//    [ldb clear];
    
    Car *porche = [[Car alloc] init];
    [porche setName:@"Porche 911"];
    [porche setBuildYear:2001];
    
    Car *lada = [[Car alloc] init];
    [lada setName:@"Lada 1600"];
    [lada setBuildYear:1977];
    
    //[Buri storeObject:lada];
    //[Buri fetchObjectForKey:@"qweqwewqe"];
    //[Buri
    
    Person *john = [[Person alloc] init];
    [john setName:@"John"];
    [john setLocale:@"John Doe"];
    [john setAge:@22];
    [john setCars:@[porche, lada]];
    
//    BuriWriteObject *writeObject = [[BuriWriteObject alloc] initWithBuriObject:john];
//    NSLog(@"writeObject: %@", writeObject);

    Buri *buri = [Buri databaseInLibraryWithName:@"TestDatabase.buri"];
    BuriBucket *bucket = [[BuriBucket alloc] initWithDB:buri andObjectClass:[Person class]];
    
    [bucket storeObject:john];
    
    Person *fetchedJohn = [bucket fetchObjectForKey:@"John"];
    NSLog(@"Pers: %@", fetchedJohn);
    NSLog(@"Cars: %@", [fetchedJohn cars]);
    
    [buri iterate:^BOOL(NSString *key, id value) {
        NSLog(@"key: %@", key);
        NSLog(@"value: %@", value);
        return TRUE;
    }];
    
    NSLog(@"%@", [bucket allKeys]);
    NSLog(@"%@", [bucket allObjects]);
    
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


@end

@implementation Person

@synthesize name = _name;
@synthesize cars = _cars;
@synthesize age = _age;
@synthesize locale = _locale;

+(NSDictionary *)buriProperties {
    return @{
        BURI_KEY: @"name",
        BURI_BINARY_INDEXES: @[@"locale"],
        BURI_INTEGER_INDEXES: @[@"age"],
    };
}


- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init])) {
		_name			= [decoder decodeObjectForKey:@"name"];
		_cars			= [decoder decodeObjectForKey:@"cars"];
		_age = [decoder decodeObjectForKey:@"age"];
		_locale	= [decoder decodeObjectForKey:@"locale"];
	}
    
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
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
