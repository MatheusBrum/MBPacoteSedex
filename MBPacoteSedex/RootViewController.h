//
//  RootViewController.h
//  MBPacoteSedex
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBPacoteSedex.h"
#import "AdicionarPacoteViewController.h"
@interface RootViewController : UITableViewController <MBPacoteSedexDelegate,EGORefreshTableHeaderDelegate,AdicionarPacoteViewControllerDelegate>{
    NSMutableArray *superArray;
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSTimer *checarCarregando;
}
- (void)reloadTableViewDataSource;
@end
