//
//  TextViewViewController.swift
//  Notes2
//
//  Created by PVH_002 on 13/9/23.
//

import UIKit
import CoreData

class TextViewViewController: UIViewController, UITextViewDelegate {
    var titles = ""
    var desc = ""
    var delegate: Delegate?
    var textView = ""
    @IBOutlet weak var textEditor: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textEditor.delegate = self
        textEditor.text = textView
        textViewDidChange(textEditor) 
    }
    @IBAction func Save(_ sender: Any) {
        delegate?.getText(title: titles, desc: desc)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Back(_ sender: Any) {
        delegate?.getText(title: titles, desc: desc)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func edit(_ sender: Any) {
        
    }
    
   
//    override func viewWillDisappear(_ animated: Bool) {
//        if isMovingFromParent {
//            delegate?.changeName(title: textEditor.text)
//            navigationController?.popViewController(animated: true)
//        }
//    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        let lines = text.components(separatedBy: "\n")
        if lines.count == 1 {
                titles = text
                desc = ""
            } else if lines.count > 1 {
                titles = lines.first ?? ""
                desc = lines.dropFirst().joined(separator: "\n")
            }
        
            let attributedText = NSMutableAttributedString()
            for (index, line) in lines.enumerated() {
                let isBold = (index == 0)
                let font = isBold ? UIFont.boldSystemFont(ofSize: 30) : UIFont.systemFont(ofSize: 18)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .paragraphStyle: NSParagraphStyle.default
                ]
                let attributedLine = NSAttributedString(string: line, attributes: attributes)
                attributedText.append(attributedLine)
                if index < lines.count - 1 {
                    attributedText.append(NSAttributedString(string: "\n"))
                }
            }
            textView.attributedText = attributedText

        }

}
