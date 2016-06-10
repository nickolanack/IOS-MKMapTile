#import "ImageTileOverlay.h"

@interface ImageTileOverlay ()

@property NSString *tilePath;

@end

@implementation ImageTileOverlay

@synthesize cache;

-(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
    
    //self.cache=true;
    
    
    if(self.cache&&[self cachedTileExistsForPath:path]){
        NSData *data=[self getCachedTileForPath:path];
        if(data.length==0){
            NSLog(@"0");
        }
        result(data, nil);
        return;
    }
    
    
    [super loadTileAtPath:path result:^(NSData *data, NSError *err) {
        
        if((!err)&&self.cache){
            [self cacheTile:data ForPath:path];
        }
        
        if(err){
            NSLog(@"err");
        }
        
        NSLog(@"%i, %i %i", path.x, path.y, path.z);
        result(data, err);
    }];
    
    
    
}



-(bool)cachedTileExistsForPath:(MKTileOverlayPath)path{
    
    NSString *file=[self fileNameForPath:path];
    bool exists= [[NSFileManager defaultManager] fileExistsAtPath:file];
    return exists;
}

-(NSData *)getCachedTileForPath:(MKTileOverlayPath)path{
    NSString *file=[self fileNameForPath:path];
    return [[NSData alloc] initWithContentsOfFile:file];
}

-(bool)cacheTile:(NSData *)tile ForPath:(MKTileOverlayPath)path{
    NSString *file=[self fileNameForPath:path];
    [[NSFileManager defaultManager] createFileAtPath:file contents:tile attributes:nil];
    return true;
}


-(NSString *)fileNameForPath:(MKTileOverlayPath)path{
    
    if(!_tilePath){
        _tilePath= [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[self uniqueId]];
    }
    
     NSString *folder=[[_tilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i", path.z]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%i", path.x]];
    
    
    
    bool dir;
    
    NSString *file= [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.png", path.y]];
    //NSLog(file);
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:folder]){
        NSError *err;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:true attributes:nil error:&err];
        if(err){
            @throw err;
        }
        
    }
    
  
    return file;
  
    
}

-(NSString *)uniqueId{
    
    
    NSString *url=self.URLTemplate;
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return [[url componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
}


@end
