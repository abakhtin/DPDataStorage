//
//  DPArrayController.H
//  DP Commons
//
//  Created by Dmitriy Petrusevich on 23/07/15.
//  Copyright (c) 2015 Dmitriy Petrusevich. All rights reserved.
//

#import "DPBaseDataSource.h"

@interface DPArrayController : NSObject <DataSourceContainerController>
@property (nonatomic, weak) id<DataSourceContainerControllerDelegate> delegate;
@property (nonatomic, assign) BOOL removeEmptySectionsAutomaticaly; // Default YES
@property (nonatomic, strong) NSPredicate * _Nullable filter;

- (instancetype _Nonnull)initWithDelegate:(id<DataSourceContainerControllerDelegate> _Nullable)delegate;

- (void)removeAllObjects;

- (void)insertObject:(id _Nonnull)object atIndextPath:(NSIndexPath * _Nonnull)indexPath;
- (void)deleteObjectAtIndextPath:(NSIndexPath * _Nonnull)indexPath;
- (void)reloadObjectAtIndextPath:(NSIndexPath * _Nonnull)indexPath;
- (void)moveObjectAtIndextPath:(NSIndexPath * _Nonnull)indexPath toIndexPath:(NSIndexPath * _Nonnull)newIndexPath;

- (void)insertSectionAtIndex:(NSUInteger)index;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeEmptySections;

- (void)addObjects:(NSArray * _Nullable)objects atSection:(NSInteger)section;
- (void)setObjects:(NSArray * _Nullable)objects atSection:(NSInteger)section;

- (void)startUpdating;
- (void)endUpdating;

- (id _Nonnull)objectAtIndexPath:(NSIndexPath * _Nonnull)indexPath;
- (NSIndexPath * _Nullable)indexPathForObject:(id _Nonnull)object;
@end
