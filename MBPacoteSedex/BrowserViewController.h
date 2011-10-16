//
//  BrowserViewController.h
//  MBPacoteSedex
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController{
    IBOutlet UIWebView *webV;
    NSURL *link;
}
@property (nonatomic,retain)    NSURL *link;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil comLink:(NSURL*)lin;
@end
