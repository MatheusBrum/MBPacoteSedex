//
//  AdicionarPacoteViewController.h
//  MBPacoteSedex
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AdicionarPacoteViewControllerDelegate <NSObject>
-(void)escolheuNome:(NSString*)nome comCodigo:(NSString *)codigo;
@end
@interface AdicionarPacoteViewController : UIViewController{
    IBOutlet UITextField *campoNome;
    IBOutlet UITextField *campoCodigo;
    id <AdicionarPacoteViewControllerDelegate> delegate;
}
@property (nonatomic,retain)id <AdicionarPacoteViewControllerDelegate> delegate;
-(IBAction)done:(id)sender;
-(IBAction)cancel:(id)sender;
@end
