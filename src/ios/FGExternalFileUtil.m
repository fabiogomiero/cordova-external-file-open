//
//  FGExternalFileUtil.m
//  FGExternalFileUtil
//
//	Created by Fabio Gomiero on 4/20/13.
//  Based on Andrew Trice (8/15/12).
//	vers.: 0.0.2
//
//  THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
//  EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "FGExternalFileUtil.h"
#import <Cordova/CDV.h>

@implementation FGExternalFileUtil

@synthesize docController;

- (void) openWith:(CDVInvokedUrlCommand*)command;
{   
    CDVPluginResult* pluginResult = nil;
    
    NSString *path = [command.arguments objectAtIndex:0]; 
    NSString *uti = [command.arguments objectAtIndex:1]; 
    
    NSLog(@"path %@, uti:%@", path, uti);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(!fileExists){
        NSArray *parts = [path componentsSeparatedByString:@"/"];
        NSString *previewDocumentFileName = [parts lastObject];
        //NSLog(@"The file name is %@", previewDocumentFileName);
        
        NSData *fileRemote = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
        
        // Write file to the Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        if (!documentsDirectory) {NSLog(@"Documents directory not found!");}
        localFile = [documentsDirectory stringByAppendingPathComponent:previewDocumentFileName];
        [fileRemote writeToFile:localFile atomically:YES];
    } else {
        localFile = path;
    }
    //NSLog(@"Resource file '%@' has been written to the Documents directory from online", previewDocumentFileName);
    
    
    // Get file again from Documents directory
    NSURL *fileURL = [NSURL fileURLWithPath:localFile];
    
	self.docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
	self.docController.delegate = self;
	self.docController.UTI = uti;
    
    CDVViewController* cont = (CDVViewController*)[ super viewController ];
    CGRect rect = CGRectZero;
	if([command.arguments count] > 2) {
		NSMutableDictionary* options = [command.arguments objectAtIndex:2];
	    if(options == nil || [options count] == 0) {
	        rect = cont.view.frame;
	    } else {
	        float width = [[options objectForKey:KEY_WIDTH_VIEW] floatValue];
	        float height = [[options objectForKey:KEY_HEIGHT_VIEW] floatValue];
	        float posX = [[options objectForKey:KEY_POSX_VIEW] floatValue];
	        float posY = [[options objectForKey:KEY_POSY_VIEW] floatValue];
	        rect = CGRectMake(posX, posY, width, height);
	    }
	} else {
		rect = cont.view.frame;
	}
	
    if([self.docController presentOpenInMenuFromRect:rect inView:cont.view animated:YES]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];	
    } else {
        NSLog(@"Nessuna app trovata per aprire il documento %@", localFile);
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No app found"];
    }
	
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    NSLog(@"documentInteractionControllerDidDismissOpenInMenu");
    
    //[self cleanupTempFile:controller];
}

- (void) documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
     NSLog(@"documentInteractionController willBeginSendingToApplication");
}

- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application {
    NSLog(@"didEndSendingToApplication: %@", application);
    
    //[self cleanupTempFile:controller];
}

- (void) cleanupTempFile: (UIDocumentInteractionController *) controller
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL fileExists = [fileManager fileExistsAtPath:localFile];   
    
    //NSLog(@"Path to file: %@", localFile);   
    //NSLog(@"File exists: %d", fileExists);
    //NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:localFile]);
    
    if (fileExists) 
    {
        BOOL success = [fileManager removeItemAtPath:localFile error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
}

@end
