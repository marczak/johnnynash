#JohnyNash  - Screen Saver
JohnnyNash is a transparent screen saver for OS X. It's main design is for use when you'd like to display the contents of a machine's desktop, but do not want to allow people to interact with it. Specifically, it's for use when you have a password-protected screen saver. (If you don't have a password-protected screen saver, but want to display the desktop, just don't run a screen saver at all.)

The non-password-prtotected screen saver version of this is one line of code. When you have a password, however, Apple really tries to protect your content. One way they do this is by putting a large, opaque black window in-between the running screen saver (running at the top window level) and everything else. (If you walk the window list while a password-protected screen saver is running, there's a new window owned by loginwindow.) JohnnyNash overcomes this by dropping its own window level below loginwindow's big black barrier, taking a screen capture, jumping back above loginwindow and rendering the screencapture into the screen saver view. It does this every second. Without a GUI way to configure it, 1 second seemed a good compromise, as it's a quick refresh, but doesn't even tax the CPU in my Core2Duo 11" MBA.

This was developed in Xcode 4 and has only been tested on Lion. It should run on 10.6, too, as OS X screen savers are not ARC-ified.

#To Do
- Configure sheet to allow frequency of running.
- Configure sheet to allow capture of a portion of the screen.
- Allow effects to be applied to screen capture.

#Bugs
- None known