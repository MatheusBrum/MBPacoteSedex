//
//  MBPacoteSedex.m
//  SEDEX
//
//  Created by Matheus Brum on 11/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MBPacoteSedex.h"
@implementation MBPacoteSedex
@synthesize link,name,currentStatus,code,historico,delegate,pacoteIndexPath,loading,ultimaAtualizacao,ultimoLocal,ultimoDetalhe;
-(id)initWithName:(NSString *)nam code:(NSString *)cod indexPath:(NSIndexPath*)ind{
    self = [super init];
    if (self) {
        self.code=cod;
        self.pacoteIndexPath=ind;
        self.historico=[NSArray array];
        self.name=nam;
       // [self reload];
        self.link=[NSURL URLWithString:[NSString stringWithFormat:@"http://websro.correios.com.br/sro_bin/txect01$.Inexistente?P_LINGUA=001&P_TIPO=002&P_COD_LIS=%@",code]];
    }
    return self;
}
-(void)reload{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *jsonUrl =[NSString stringWithFormat:@"http://rastreamentocorreios.com.br/classes/correio/?q=%@",self.code];
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:jsonUrl]];
        loading=YES;
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        NSDictionary *items = [jsonKitDecoder objectWithData:jsonData];
        self.historico=[items objectForKey:@"track"];
        self.currentStatus=[[historico lastObject] objectForKey:@"acao"];
        self.ultimaAtualizacao=[[historico lastObject] objectForKey:@"data"];
        self.ultimoLocal=[[historico lastObject] objectForKey:@"local"];
        self.ultimoDetalhe=[[historico lastObject] objectForKey:@"detalhes"];
     //   NSLog(@"total items: %@", historico);
		dispatch_async(dispatch_get_main_queue(), ^{
          //  NSLog(@"Acabou");
            loading=NO;
            if ([delegate respondsToSelector:@selector(Pacote:atualizouParaStatus:noIndexPath:)]) {
                [delegate Pacote:self atualizouParaStatus:currentStatus noIndexPath:pacoteIndexPath];
            }
		});
	});
}
- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject: self.link forKey:@"link"];
    [coder encodeObject: self.name forKey:@"nome"];
    [coder encodeObject: self.currentStatus forKey:@"currentStatus"];
    [coder encodeObject: self.code forKey:@"code"];
    [coder encodeObject: self.historico forKey:@"historico"];
    [coder encodeObject: self.pacoteIndexPath forKey:@"pacoteIndexPath"];
    [coder encodeObject: self.ultimoLocal forKey:@"ultimoLocal"];
    [coder encodeObject: self.ultimaAtualizacao forKey:@"ultimaAtualizacao"];
    [coder encodeObject: self.ultimoDetalhe forKey:@"ultimoDetalhe"];
}
- (id) initWithCoder: (NSCoder *)coder{
    if (self = [super init]){
        [self setLink:[coder decodeObjectForKey:@"link"]];
        [self setName:[coder decodeObjectForKey:@"nome"]];
        [self setCurrentStatus:[coder decodeObjectForKey:@"currentStatus"]];
        [self setCode:[coder decodeObjectForKey:@"code"]];
        [self setHistorico:[coder decodeObjectForKey:@"historico"]];
        [self setPacoteIndexPath:[coder decodeObjectForKey:@"pacoteIndexPath"]];
        [self setUltimoLocal:[coder decodeObjectForKey:@"ultimoLocal"]];
        [self setUltimaAtualizacao:[coder decodeObjectForKey:@"ultimaAtualizacao"]];
        [self setUltimoDetalhe:[coder decodeObjectForKey:@"ultimoDetalhe"]];
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [delegate release];
    [name release];
    [historico release];
    [code release];
    [link release];
    [currentStatus release];
}
@end
