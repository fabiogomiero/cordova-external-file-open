//
//  FGExternalFileUtil.h
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

#import <Cordova/CDVPlugin.h>

#define KEY_WIDTH_VIEW      @"viewWidth"
#define KEY_HEIGHT_VIEW     @"viewHeight"
#define KEY_POSX_VIEW       @"viewPosX"
#define KEY_POSY_VIEW       @"viewPosY"

@interface FGExternalFileUtil : CDVPlugin <UIDocumentInteractionControllerDelegate> {
    NSString *localFile;
}

@property (nonatomic, strong) UIDocumentInteractionController *docController;

- (void) openWith:(CDVInvokedUrlCommand*)command;
- (void) cleanupTempFile: (UIDocumentInteractionController *) controller;

@end
