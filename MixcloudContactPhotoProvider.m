#import "MixcloudContactPhotoProvider.h"

@implementation MixcloudContactPhotoProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NSString *baseURL = @"https://mixcloud.com/";
    NSString *showId = [notification userInfo][@"key"];

    NSString *fullPath = [NSString stringWithFormat:@"%@%@", baseURL, showId];
    NSURL *url = [NSURL URLWithString:fullPath];

    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];

    if (error == nil){
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"m-background-image=\"(.+)\" m-background" options:0 error:&error];
      NSTextCheckingResult *result = [regex firstMatchInString:html options:0 range:NSMakeRange(0, html.length)];

      if (result) {
        NSString *imageURL = [html substringWithRange:[result rangeAtIndex:1]];
        UIImage *image = [UIImage imageWithContentsOfFile:imageURL];

        return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imageURL image:image];
      }
    }

    return nil;
  }
@end
