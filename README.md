# iOS-15-bug-demo
This example demonstrates iOS 15 bug with modal message box

On iOS versions less than 15, this example works well, when you click on the red rectangle, you see a modal message box that says "Don't touch this!".
But on iOS 15, instead of displaying a modal message box, the app hangs in NSRunLoop.
