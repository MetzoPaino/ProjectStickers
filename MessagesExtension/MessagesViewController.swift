//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by William Robinson on 26/09/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, DataManagerDelegate, MonsterBrowserViewControllerDelegate, MonsterMakerViewControllerDelegate {
    
    let dataManager = DataManager()
    var monsterBrowser: MonsterBrowserViewController?
    var presentMonsterMaker = true
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.delegate = self
    }
    
    // MARK: - Navigation
    
    private func presentChildViewController(for presentationStyle: MSMessagesAppPresentationStyle) {
        
        //let controller: UIViewController
        
        
        if presentationStyle == .compact {
            
            let controller = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MonsterBrowser") as! MonsterBrowserViewController
            controller.delegate = self
            controller.stickerManager = dataManager.stickerManager

            showViewController(controller: controller)
            monsterBrowser = controller
            
        } else {
            
            if presentMonsterMaker == true {
                
                let controller = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MonsterMaker") as! MonsterMakerViewController
                controller.delegate = self
                showViewController(controller: controller)
                
            } else {
                
                let controller = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "MonsterBrowser") as! MonsterBrowserViewController
                controller.delegate = self
                controller.stickerManager = dataManager.stickerManager

                showViewController(controller: controller)
                monsterBrowser = controller
            }
        }
    }
    
    func showViewController(controller: UIViewController) {
        
        // Remove any existing child controllers.
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            
//            if child is MonsterMakerViewController {
//                child.view.removeFromSuperview()
//                child.removeFromParentViewController()
//            }
            
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
       // view.addSubview(controller.view)
        view.insertSubview(controller.view, belowSubview: loadingImageView)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
        //presentMonsterMaker = false
        
        let topConstraint = NSLayoutConstraint(item: controller.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)      
        NSLayoutConstraint.activate([topConstraint])
        
        view.layoutIfNeeded()

    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        super.willBecomeActive(with: conversation)
        presentChildViewController(for: .compact)
        view.sendSubview(toBack: loadingImageView)

        
    }
    
    override func willResignActive(with conversation: MSConversation) {
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        view.bringSubview(toFront: loadingImageView)
        presentChildViewController(for: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
        view.sendSubview(toBack: loadingImageView)
    }
    
    // MARK: - DataManagerDelegate

    
    func dataManagerChanged() {
        
        if monsterBrowser != nil {
            monsterBrowser!.reloadData()
        }
        
    }
    
    // MARK: - MonsterBrowserViewControllerDelegate
    
    func addCellSelected() {
        
        presentMonsterMaker = true
        self.requestPresentationStyle(.expanded)
    }
    
    func deleteButtonPressedForCellAtIndex(index: Int) {
        
        dataManager.deleteURLAtIndex(index: index)
    }
    
    // MARK: - MonsterMakerViewControllerDelegate
    
    func createdImage(image: UIImage) {
        
        dataManager.saveImageToDisk(image: image)
        self.requestPresentationStyle(.compact)
        
        guard let conversation = activeConversation else {
            print("Couldn't find an active conversation")
            return
        }
        
        if let sticker = dataManager.stickerManager.customStickers.first {
            conversation.insert(sticker) {
                error in
                
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func cancelButtonPressed() {
        self.requestPresentationStyle(.compact)
    }
}
