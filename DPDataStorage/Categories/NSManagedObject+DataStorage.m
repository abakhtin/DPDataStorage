//
//  NSManagedObject+DataStorage.m
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 11/11/11.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "NSManagedObject+DataStorage.h"
#import "DPDataStorage.h"

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif

@implementation NSManagedObject (DataStorage)

+ (instancetype)insertInContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context != nil);

    NSString *entityName = [context entityNameForManagedObjectClass:self];
    return entityName ? [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context] : nil;
}

+ (void)deleteAllEntriesInContext:(NSManagedObjectContext *)context {
    NSArray *allentries = [self allEntriesInContext:context];
    for (NSManagedObject *obj in allentries) {
        [context deleteObject:obj];
    }
}

+ (NSUInteger)allEntriesCountInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
    
    NSError *error = nil;
    NSUInteger result = [context countForFetchRequest:fetchRequest error:&error];
    FAIL_ON_ERROR(error);

    return result;
}

#pragma mark -

+ (instancetype)entryWithValue:(id<NSObject>)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    NSParameterAssert(key != nil);
    NSParameterAssert(context != nil);

    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
	[fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];

	NSError *error = nil;
	id result = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    FAIL_ON_ERROR(error);

    return result;
}

+ (NSArray *)entriesWithValue:(id<NSObject>)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context {
    NSParameterAssert(key != nil);
    NSParameterAssert(context != nil);

    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    id result = [context executeFetchRequest:fetchRequest error:&error];
    FAIL_ON_ERROR(error);

    return result ? result : @[];
}

+ (instancetype)anyEntryInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
    [fetchRequest setFetchLimit:1];

	NSError *error = nil;
	id result = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    FAIL_ON_ERROR(error);

    return result;
}

+ (NSArray *)allEntriesInContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
    
	NSError *error = nil;
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    FAIL_ON_ERROR(error);
    
    return result ? result : @[];
}

#pragma mark -

+ (NSFetchRequest *)newFetchRequestInContext:(NSManagedObjectContext *)context {
    NSParameterAssert(context != nil);
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSString *entityName = [context entityNameForManagedObjectClass:self];
    fetchRequest.entity = entityName ? [NSEntityDescription entityForName:entityName inManagedObjectContext:context] : nil;
    return fetchRequest.entity ? fetchRequest : nil;
}

+ (NSFetchedResultsController *)fetchedResultsController:(id<NSFetchedResultsControllerDelegate>)delegate
                                               predicate:(NSPredicate *)predicate
                                         sortDescriptors:(NSArray *)sortDescriptors
                                               inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [self newFetchRequestInContext:context];
    if (fetchRequest == nil) return nil;

	[fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
																							   managedObjectContext:context
																								 sectionNameKeyPath:nil
																										  cacheName:nil];
	fetchedResultsController.delegate = delegate;
    
	NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    FAIL_ON_ERROR(error);
    
	return fetchedResultsController;
}

#pragma mark -

- (BOOL)validate:(NSError **)error {
    if (self.isInserted) return [self validateForInsert:error];
    if (self.isUpdated) return [self validateForUpdate:error];
    if (self.isDeleted) return [self validateForDelete:error];
    return YES;
}

@end
