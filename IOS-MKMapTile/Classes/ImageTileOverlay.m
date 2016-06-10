#import "ImageTileOverlay.h"

@interface ImageTileOverlay ()

@end

@implementation ImageTileOverlay

-(void)loadTileAtPath:(MKTileOverlayPath)path result:(void (^)(NSData *, NSError *))result {
    
    [super loadTileAtPath:path result:^(NSData *data, NSError *err) {
        NSLog(@"%i, %i %i", path.x, path.y, path.z);
        result(data, err);
    }];
    
    
    
}

@end
