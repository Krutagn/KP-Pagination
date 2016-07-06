//
//  ViewController.m
//  pagination
//
//  Created by krutagn on 01/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import "ViewController.h"
#import "Yellow_ViewController.h"
#import "Blue_ViewController.h"
#import "Red_ViewController.h"

@interface ViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
- (void)loadScrollViewWithPage:(int)page;
@end

@implementation ViewController
@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize rotating = _rotating;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.scrollview setPagingEnabled:YES];
    [self.scrollview setScrollEnabled:YES];
    [self.scrollview setShowsHorizontalScrollIndicator:NO];
    [self.scrollview setShowsVerticalScrollIndicator:NO];
    [self.scrollview setDelegate:self];
    
    
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Yellow_ViewController"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Blue_ViewController"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Red_ViewController"]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (NSUInteger i =0; i < [self.childViewControllers count]; i++) {
        [self loadScrollViewWithPage:i];
    }
    
    self.pageControll.currentPage = 0;
    _page = 0;
    [self.pageControll setNumberOfPages:[self.childViewControllers count]];
    
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
    if (viewController.view.superview != nil) {
        [viewController viewWillAppear:animated];
    }
    
    self.scrollview.contentSize = CGSizeMake(_scrollview.frame.size.width * [self.childViewControllers count], _scrollview.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.childViewControllers count]) {
        UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
        if (viewController.view.superview != nil) {
            [viewController viewDidAppear:animated];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.childViewControllers count]) {
        UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
        if (viewController.view.superview != nil) {
            [viewController viewWillDisappear:animated];
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
    if (viewController.view.superview != nil) {
        [viewController viewDidDisappear:animated];
    }
    [super viewDidDisappear:animated];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0)
        return;
    if (page >= [self.childViewControllers count])
        return;
    
    
    UIViewController *controller = [self.childViewControllers objectAtIndex:page];
    if (controller == nil) {
        return;
    }
    
    
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollview.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollview addSubview:controller.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)previousPage {
    if (_page - 1 > 0) {
        
        
        CGRect frame = self.scrollview.frame;
        frame.origin.x = frame.size.width * (_page - 1);
        frame.origin.y = 0;
        
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page - 1];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        
        [self.scrollview scrollRectToVisible:frame animated:YES];
        
        self.pageControll.currentPage = _page - 1;
        
        _pageControlUsed = YES;
    }
}

- (void)nextPage {
    if (_page + 1 > self.pageControll.numberOfPages) {
        
        
        CGRect frame = self.scrollview.frame;
        frame.origin.x = frame.size.width * (_page + 1);
        frame.origin.y = 0;
        
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page + 1];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        
        [self.scrollview scrollRectToVisible:frame animated:YES];
        
        self.pageControll.currentPage = _page + 1;
        
        _pageControlUsed = YES;
    }
}


- (IBAction)changePage:(id)sender {
    
    int page = ((UIPageControl *)sender).currentPage;
    
 
    CGRect frame = self.scrollview.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.scrollview scrollRectToVisible:frame animated:YES];
    
   
    _pageControlUsed = YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (_pageControlUsed || _rotating) {
     
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollview.frame.size.width;
    int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControll.currentPage != page) {
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControll.currentPage];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        self.pageControll.currentPage = page;
        [oldViewController viewDidDisappear:YES];
        [newViewController viewDidAppear:YES];
        _page = page;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}


@end
