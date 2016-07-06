//
//  ViewController.h
//  pagination
//
//  Created by krutagn on 01/07/16.
//  Copyright © 2016 com.zaptechsolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControll;

- (IBAction)changePage:(id)sender;

-(void)nextPage;
-(void)previousPage;

@end

