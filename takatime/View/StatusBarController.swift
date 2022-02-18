import AppKit
//
// Created by mix on 2022/02/04.
//
import SwiftUI

class StatusBarController: ObservableObject {
  @Published var statusItem: NSStatusItem

  private var statusBar: NSStatusBar!
  private var popover: NSPopover

  private var eventMonitor: EventMonitor?

  init(_ popover: NSPopover) {
    self.popover = popover
    statusBar = NSStatusBar.init()
    // Creating a status bar item having a fixed length
    statusItem = statusBar.statusItem(withLength: 55.0)

    if let statusBarButton = statusItem.button {
      // 追加したアイコン名を設定
      statusBarButton.title = "25分00秒"
      statusBarButton.action = #selector(togglePopover(sender:))
      statusBarButton.target = self
    }

    eventMonitor = EventMonitor(
      mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
  }

  @objc func togglePopover(sender: AnyObject) {
    if popover.isShown {
      hidePopover(sender)
    } else {
      showPopover(sender)
    }
  }

  func showPopover(_ sender: AnyObject) {
    if let statusBarButton = statusItem.button {
      popover.show(
        relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
      eventMonitor?.start()
    }
  }

  func hidePopover(_ sender: AnyObject) {
    popover.performClose(sender)
  }

  func mouseEventHandler(_ event: NSEvent?) {
    if popover.isShown {
      hidePopover(event!)
    }
  }
}
