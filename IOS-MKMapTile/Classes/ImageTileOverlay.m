#import "ImageTileOverlay.h"

@interface ImageTileOverlay ()

@property NSString *tilePath;

@end

@implementation ImageTileOverlay

@synthesize cache;

-(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
    
    
    
    
    if(self.cache&&[self cachedTileExistsForPath:path]){
        result([self getCachedTileForPath:path], nil);
        return;
    }
    
    
    [super loadTileAtPath:path result:^(NSData *data, NSError *err) {
        
        if((!err)&&self.cache){
            //[self cacheTile:data ForPath:path];
        }
        
        NSLog(@"%i, %i %i", path.x, path.y, path.z);
        result(data, err);
    }];
    
    
    
}



-(bool)cachedTileExistsForPath:(MKTileOverlayPath)path{
    
    NSString *file=[self fileNameForPath:path];
    return [[NSFileManager defaultManager] fileExistsAtPath:file];
    
}

-(NSData *)getCachedTileForPath:(MKTileOverlayPath)path{
    NSString *file=[self fileNameForPath:path];
    return [[NSData alloc] initWithContentsOfFile:file];
}

-(NSData *)cacheTile:(NSData *)tile ForPath:(MKTileOverlayPath)path{
    NSString *file=[self fileNameForPath:path];
    [[NSFileManager defaultManager] createFileAtPath:file contents:tile attributes:nil];
    
}


-(NSString *)fileNameForPath:(MKTileOverlayPath)path{
    NSString *folder = [[[[NSHomeDirectory() stringByAppendingPathComponent:@"tiles"] stringByAppendingPathComponent:[self uniqueId]] stringByAppendingString:[NSString stringWithFormat:@"%i", path.z]] stringByAppendingString:[NSString stringWithFormat:@"%i", path.x]];
    
    
    
    bool dir;
    if(![[NSFileManager defaultManager] fileExistsAtPath:folder]){
        NSError *err;
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:true attributes:nil error:&err];
        if(err){
            @throw err;
        }
        
    }
    
    NSString *file= [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.png", path.y]];
    NSLog(file);
    
  
    
}

-(NSString *)uniqueId{
    
    
    NSString *url=self.URLTemplate;
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return [[url componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@""];
    
}


@end
