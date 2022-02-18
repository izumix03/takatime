//
//  AppDelegate.swift
//  takatike
//
//  Created by mix on 2022/02/04.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  private var popover = NSPopover.init()
  private var statusBar: StatusBarController?
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    statusBar = StatusBarController.init(popover)
    let contentView = PopupView(statusBar: statusBar!)
    popover.contentViewController = NSHostingController(rootView: contentView)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    true
  }
}
