
/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller that sets up the table view and serves as the table view's data source and delegate.
 */

#import "APLViewController.h"
#import "UIScrollView+CPLiteRefresh.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface APLViewController ()

@property (nonatomic) NSArray *timeZoneNames;

@end

@implementation APLViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  Build Model
    NSArray *timeZones = [NSTimeZone knownTimeZoneNames];
    self.timeZoneNames = [timeZones sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    //header
    self.tableView.cp_header.backgroundColor = self.tableView.backgroundColor;
    self.tableView.cp_header.bgType = CPLiteRefreshTipBgType_Light;
    @weakify(self)
    self.tableView.cp_header.refreshBlock = ^{
        @strongify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.cp_header endRefreshing];
        });
    };
    
    //footer
    self.tableView.cp_footer.bgType = CPLiteRefreshTipBgType_Light;
    self.tableView.cp_footer.refreshBlock = ^{
        @strongify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.cp_footer endRefreshing];
            self.tableView.cp_footer.isNoMoreData = YES;
        });
    };
}

#pragma mark - UITableViewDataSource

/*
 There's no need to implement numberOfSectionsInTableView: because there's only one section and the method defaults to returning 1.
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of time zone names.
	return self.timeZoneNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *MyIdentifier = @"MyIdentifier";

	/*
     Retrieve a cell with the given identifier from the table view.
     The cell is defined in the main storyboard: its identifier is MyIdentifier, and  its selection style is set to None.
     */
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

	// Set up the cell.
	NSString *timeZoneName = self.timeZoneNames[indexPath.row];
	cell.textLabel.text = timeZoneName;

	return cell;
}

@end
