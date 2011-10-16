//
//  AdicionarPacoteViewController.m
//  MBPacoteSedex
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AdicionarPacoteViewController.h"

@implementation AdicionarPacoteViewController
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
	NSString *texto = [appPasteBoard string];
    if (texto && texto.length==13 ) {
        [campoCodigo setText:texto];
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [campoNome becomeFirstResponder];
}
-(IBAction)done:(id)sender{
    if (campoCodigo.text.length == 13) {
        if ([delegate respondsToSelector:@selector(escolheuNome:comCodigo:)]) {
            [delegate escolheuNome:campoNome.text comCodigo:campoCodigo.text];
        }
        [self dismissModalViewControllerAnimated:YES];
    }else{
        UIAlertView *alerta=[[UIAlertView alloc]initWithTitle:@"Ops!" message:@"O seu código não contém 13 caracteres" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alerta show];
        [alerta release];
    }
}
-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
