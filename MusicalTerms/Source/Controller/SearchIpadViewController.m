//
//  SearchIpadViewController.m
//  Music(Ipad)
//
//  Created by runes on 12-9-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchIpadViewController.h"
#import "MySubCell.h"
#import "MyLabel.h"
#import "MusicInfo.h"
#import "DataBase.h"
#import "MyDetailView.h"

@interface SearchIpadViewController ()

@end

@implementation SearchIpadViewController
@synthesize listContent, filteredListContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,player;
@synthesize popoverController, splitViewController, rootPopoverButtonItem, detailNavigationViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        splitViewController = [[UISplitViewController alloc] initWithNibName:@"SearchIpadViewController" bundle:nil];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"词汇检索" image:[UIImage imageNamed:@"icon_glass.png"] tag:1];
        splitViewController.tabBarItem = tabBarItem;
        [tabBarItem release];
        splitViewController.delegate = self;
        detailNavigationViewController = [[DetailNavigationViewController alloc] initWithNibName:@"DetailNavigationViewController" bundle:nil];
        
        //开始设置splitViewController
        splitViewController.viewControllers = [[NSArray alloc] initWithObjects:[[[UINavigationController alloc] initWithRootViewController:self] autorelease], detailNavigationViewController, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailNavigationViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
    //设置标题
	self.title = @"词汇检索";
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;         
    }
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.filteredListContent = nil;
	self.splitViewController = nil;
	self.rootPopoverButtonItem = nil;
}

//IOS5 支持
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//IOS6 支持
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"检索列表";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    //UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailNavigationViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    //UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailNavigationViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    tableView.rowHeight = 66;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MySubCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        //使用自定义的模板
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MySubCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
	}
	MusicInfo *musicInfo = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        musicInfo = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        musicInfo = [self.listContent objectAtIndex:indexPath.row];
    }
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[musicInfo.wi_name lowercaseString] ofType:@"mp3"];        //创建音乐文件路径
    if (musicFilePath != NULL) {                //判断该路径是否存在,如存在,则显示播放图标
        cell.imageView.image = [UIImage imageNamed:@"icon_annoucement.png"];
        cell.imageView.userInteractionEnabled = YES;
        cell.imageView.imageName = musicInfo.wi_name;     //将文件名称传入图片属性中,待点击时获取文件
        UITapGestureRecognizer *singleTouch=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(speakVoice:)];
        singleTouch.numberOfTouchesRequired = 1;    //触摸点个数
        singleTouch.numberOfTapsRequired = 1;
        [cell.imageView addGestureRecognizer:singleTouch];
        [singleTouch release];
        musicFilePath = nil;
    }
    if(musicInfo.wi_language != NULL){
        cell.nameLabel.text = [musicInfo.wi_name stringByAppendingString: musicInfo.wi_language];
    }
    else{
        cell.nameLabel.text = musicInfo.wi_name;
    }
    [cell.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    if(musicInfo.wi_translation_simple != NULL){
        cell.translationLabel.text = musicInfo.wi_translation_simple;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	MusicInfo *musicInfo = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        musicInfo = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        musicInfo = [self.listContent objectAtIndex:indexPath.row];
    }
    DataBase *db = [[DataBase alloc] init];
    [db saveHistory:musicInfo.wi_id type:1];
    [db release];
    UIViewController *scrollViewController = [[UIViewController alloc] init];
    MyDetailView *myDetailView = [[MyDetailView alloc] init];
    [myDetailView setDetailsView:musicInfo withType:1];
    scrollViewController.view = myDetailView;
    [myDetailView release];
    scrollViewController.title = musicInfo.wi_name;
    NSMutableArray *itemsArray = [detailNavigationViewController.navigationBar.topItem.rightBarButtonItems mutableCopy];
    [detailNavigationViewController pushViewController:scrollViewController animated:YES];
    [scrollViewController release];
    if (itemsArray != nil && itemsArray.count > 0) {
        [detailNavigationViewController.navigationBar.topItem setRightBarButtonItems:itemsArray animated:NO];
    }
    [itemsArray release];
}

/**
 * 隐藏视图
 */
- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}      

/**
 * 初始化search bar时讲取消按钮的标题更改为中文
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)cc;
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

/**
 * 释放内存
 */
- (void)dealloc
{
	[listContent release];
	[filteredListContent release];
	[player release];
    savedSearchTerm = nil;
    savedScopeButtonIndex = 0;
    [popoverController release];
    [rootPopoverButtonItem release];
    [detailNavigationViewController release];
    [splitViewController release];
	[super dealloc];
}

#pragma mark - slef method
/**
 * 点击图标播放声音
 */
- (void)speakVoice:(UITapGestureRecognizer *)sender
{ 
    
    if(sender.state == UIGestureRecognizerStateEnded)
    { 
        NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:[((SpeakImageView*)sender.view).imageName lowercaseString] ofType:@"mp3"];       //创建音乐文件路径
        if (musicFilePath != NULL) {
            NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];  
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
            
            [musicURL release];
            //[player prepareToPlay];
            if (player == nil){
                NSLog(@"audio player not initialized");   
            }          
            else if(TARGET_IPHONE_SIMULATOR){
                NSLog(@"player play"); 
                //[player play];   //播放
            } 
            else{
                [player play];  
            }
        }
        
    }
}

/**
 * 通过按钮点击响应超链接的页面跳转
 */
- (void)showWebView:(UITapGestureRecognizer *)sender
{
    MyLabel *wi_link_path = (MyLabel*)sender.view;
    UIViewController *webController = [[UIViewController alloc] init];
    UIWebView *webView = [[UIWebView alloc] init];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:wi_link_path.text]];
    [webView loadRequest:request];
    webController.view = webView;
    NSMutableArray *itemsArray = [detailNavigationViewController.navigationBar.topItem.rightBarButtonItems mutableCopy];
    [detailNavigationViewController pushViewController:webController animated:YES];
    if (itemsArray != nil && itemsArray.count > 0) {
        [detailNavigationViewController.navigationBar.topItem setRightBarButtonItems:itemsArray animated:NO];
    }
    [itemsArray release];
    [webView release];
    [webController release];
}

#pragma mark -
#pragma mark Content Filtering
/**
 * 根据过滤信息设置过滤list
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	//NSLog(@"类型:%@",searchText);
	[self.filteredListContent removeAllObjects]; // 首先清空过滤list.
	DataBase *db =[[DataBase alloc]init];
    if ([scope isEqualToString:@"描述"])
    {
        self.filteredListContent = [db quaryTable:[[@" and wt_msg_zh like '%%" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:1];
    }
    else if([scope isEqualToString:@"解释"])
    {
        self.filteredListContent = [db quaryTable:[[@" and wtd_msg_zh like '%%" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:2];
    }
    else
    {
        self.filteredListContent = [db quaryTable:[[@" and wi_name like '" stringByAppendingFormat:@"%@",searchText] stringByAppendingFormat:@"%%' "] type:0];
    }
    [db release];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods


/**
 * 发生更换检索字符串时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

/**
 * 发生更改检索scope时执行的方法
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //NSLog(@"QQQ:%@",[self.searchDisplayController.searchBar text]);
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

@end
