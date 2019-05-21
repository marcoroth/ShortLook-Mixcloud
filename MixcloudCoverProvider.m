#import "MixcloudCoverProvider.h"

@implementation MixcloudCoverProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NSString *baseURL = @"https://mixcloud.com/";
    NSString *showId = [notification userInfo][@"key"];

    NSString *fullPath = [NSString stringWithFormat:@"%@%@", baseURL, showId];
    NSURL *url = [NSURL URLWithString:fullPath];

    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    if (error == nil){
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<meta name=\"twitter:image\" data-meta-side-effect=\"true\" content=\"(.+)\">" options:0 error:&error];
      NSTextCheckingResult *result = [regex firstMatchInString:html options:0 range:NSMakeRange(0, html.length)];

      if (result) {
        NSString *imageURLStr = [html substringWithRange:[result rangeAtIndex:1]];
        NSURL *imageURL = [NSURL URLWithString:imageURLStr];

        return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerDownloadingPromiseWithPhotoIdentifier:imageURLStr fromURL:imageURL];
      }
    }

    return nil;
  }
@end
