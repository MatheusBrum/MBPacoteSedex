//
//  MBPacoteSedex.h
//  SEDEX
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
@class MBPacoteSedex;
@protocol MBPacoteSedexDelegate <NSObject>
-(void)Pacote:(MBPacoteSedex *)pac atualizouParaStatus:(NSString *)status noIndexPath:(NSIndexPath*)indexP;
@end
@interface MBPacoteSedex : NSObject{
    NSString *name;
    NSString *code;
    NSString *currentStatus;
    NSString *ultimaAtualizacao;
    NSString *ultimoLocal;
    NSString *ultimoDetalhe;
    NSURL *link;
    NSArray *historico;
    NSIndexPath *pacoteIndexPath;
    BOOL loading;
    id <MBPacoteSedexDelegate> delegate;

}
@property (nonatomic,retain)     NSString *ultimoLocal;
@property (nonatomic,retain)     NSString *ultimoDetalhe;
@property (nonatomic,retain)     NSString *name;
@property (nonatomic,retain)     NSString *code;
@property (nonatomic,retain)     NSString *currentStatus;
@property (nonatomic,retain)     NSString *ultimaAtualizacao;
@property (nonatomic,retain)     NSURL *link;
@property (nonatomic,retain)     NSArray *historico;
@property (nonatomic,retain)     NSIndexPath *pacoteIndexPath;
@property (nonatomic)     BOOL loading;
@property (nonatomic,retain)     id <MBPacoteSedexDelegate> delegate;
-(id)initWithName:(NSString *)nam code:(NSString *)cod indexPath:(NSIndexPath*)ind;
-(void)reload;
@end
