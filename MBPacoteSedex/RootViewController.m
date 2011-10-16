//
//  RootViewController.m
//  MBPacoteSedex
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define PLISTFILE [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ArrayMasterSalvo.plist"]

#import "BrowserViewController.h"
#import "RootViewController.h"
#import "GradientView.h"
@interface RootViewController (private)
-(BOOL)carregandoAlgum;
-(void)adicionar:(NSString *)nome comCodigo:(NSString *)codigo;
@end
@implementation RootViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    self.tableView.backgroundColor=[UIColor lightGrayColor];
    [_refreshHeaderView refreshLastUpdatedDate];
    self.title=@"Rastreador Decente";
    superArray=[[NSMutableArray alloc]init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:PLISTFILE]) {
      //  superArray=[[NSMutableArray alloc]initWithContentsOfFile:PLISTFILE];
        NSLog(@"Existe");
        NSMutableArray *arrayDados=[[NSMutableArray alloc]initWithContentsOfFile:PLISTFILE];
        for (int i = 0; i<[arrayDados count]; i++) {
            NSDictionary *dic=[arrayDados objectAtIndex:i];
            MBPacoteSedex *pacote=[[MBPacoteSedex alloc]initWithName:[dic objectForKey:@"Titulo"] code:[dic objectForKey:@"Codigo"] indexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            pacote.delegate=self;
            [superArray addObject:pacote];
         //   [self adicionar:[dic objectForKey:@"Titulo"] comCodigo:[dic objectForKey:@"Codigo"]];
            NSLog(@"Adicionou %@",dic);
        }
    
    }
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(adicionarPacote)]autorelease];
    [self.tableView reloadData];
    [self reloadTableViewDataSource];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(salvar)name:UIApplicationWillResignActiveNotification object:nil];

}
-(void)adicionarPacote{
    AdicionarPacoteViewController *addController=[[AdicionarPacoteViewController alloc]initWithNibName:@"AdicionarPacoteViewController" bundle:nil];
    addController.delegate=self;
    [self presentModalViewController:addController animated:YES];
    [addController release];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
-(void)salvar{
    NSMutableArray *dadosArray=[[NSMutableArray alloc]init];
    for (int i = 0; i<[superArray count]; i++) {
        MBPacoteSedex *pacote=(MBPacoteSedex *)[superArray objectAtIndex:i];
        [dadosArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:pacote.name,@"Titulo",pacote.code,@"Codigo", nil]];
    }
    [dadosArray writeToFile:PLISTFILE atomically:YES];
    NSLog(@"SALVOU %@",dadosArray);  
    [dadosArray release];
}
- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [superArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundView = [[[GradientView alloc] init] autorelease];
    }
    cell.detailTextLabel.numberOfLines=3;
    MBPacoteSedex *pacote=(MBPacoteSedex*)[superArray objectAtIndex:indexPath.row];
    pacote.pacoteIndexPath=indexPath;
    cell.textLabel.text=pacote.name;
    if (pacote.currentStatus) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@: %@ em %@",pacote.ultimoLocal,pacote.ultimoDetalhe,pacote.ultimaAtualizacao];
    }else{
        cell.detailTextLabel.text=@"Objeto ainda não rastreável";
    }
    for ( UIView* view in cell.contentView.subviews ) {
        view.backgroundColor = [ UIColor clearColor ];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [superArray removeObjectAtIndex:indexPath.row];
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert){}   
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MBPacoteSedex *pacote=(MBPacoteSedex*)[superArray objectAtIndex:indexPath.row];
    BrowserViewController *detailViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil comLink:pacote.link];
    [self.navigationController pushViewController:detailViewController animated:YES];
    detailViewController.title=pacote.name;
    [detailViewController release];
}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
    for (int i = 0; i<[superArray count]; i++) {
        MBPacoteSedex *pacote=(MBPacoteSedex *)[superArray objectAtIndex:i];
        [pacote reload];
    }
    checarCarregando=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checarSeEstaCarregando) userInfo:nil repeats:YES];
}
-(void)checarSeEstaCarregando{
    if ([self carregandoAlgum]==NO) {
        [checarCarregando invalidate];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    }
}
-(void)Pacote:(MBPacoteSedex *)pac atualizouParaStatus:(NSString *)status noIndexPath:(NSIndexPath*)indexP{
    if (indexP) {
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexP] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    }
}
-(BOOL)carregandoAlgum{
    BOOL checar=NO;
    for (int i = 0; i<[superArray count]; i++) {
        MBPacoteSedex *pacote=(MBPacoteSedex *)[superArray objectAtIndex:i];
        if (pacote.loading) {
            checar=YES;
            return checar;
        }
    }
    return checar;
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];	
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];	
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return [self carregandoAlgum]; // should return if data source model is reloading	
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{	
	return [NSDate date]; // should return date data source was last changed
}
#pragma mark-
#pragma mark- Adicionar pacote
-(void)escolheuNome:(NSString *)nome comCodigo:(NSString *)codigo{
    [self adicionar:nome comCodigo:codigo];
}
-(void)adicionar:(NSString *)nome comCodigo:(NSString *)codigo{
    [self.tableView beginUpdates];
    MBPacoteSedex *pacote=[[MBPacoteSedex alloc]initWithName:nome code:codigo indexPath:nil];
    pacote.delegate=self;
    [pacote reload];
    [superArray insertObject:pacote atIndex:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}
#pragma mark-
#pragma mark- View Lifecycle
- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload{
    [super viewDidUnload];
}
- (void)dealloc{
    [super dealloc];
}

@end
