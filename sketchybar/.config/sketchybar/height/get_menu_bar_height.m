#import <Cocoa/Cocoa.h>

int main() {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSRect screenRect = [[NSScreen mainScreen] frame];
  NSRect visibleRect = [[NSScreen mainScreen] visibleFrame];

  // Show the menu bar temporarily to get its height
  [NSMenu setMenuBarVisible:YES];

  CGFloat menuBarHeight = screenRect.size.height - visibleRect.size.height;

  // Fallback to default
  if (menuBarHeight == 0) {
    menuBarHeight = 25;
  }

  printf("%d\n", (int)menuBarHeight);

  // Hide the menu bar again
  [NSMenu setMenuBarVisible:NO];

  [pool drain];
  return 0;
}
