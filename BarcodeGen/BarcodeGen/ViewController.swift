//
//  ViewController.swift
//  BarcodeGen
//
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var formats = ["Code128", "QR Code", "PDF417", "Post Net(5, 9, 11 digits only)", "Data Matrix", "Maxi Code", "Aztec Code"]
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        formats.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        formats[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if formats[row] == formats[3] {
            formatButton.setTitle("Post Net", for: .normal)
        } else {
            formatButton.setTitle("\(formats[row])", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.frame = CGRect(x: 0, y: view.frame.size.height - 200, width: view.frame.size.width, height: 200)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.isHidden = true
        pickerView.backgroundColor = .secondarySystemFill
        
        textField.delegate = self
        formatButton.frame = CGRect(x: 5, y: 200, width: 200, height: 60)
        imageView.frame = CGRect(x: 60, y: 350, width: 300, height: 300)
        label.frame = CGRect(x: view.frame.size.width / 2  - 140, y: 50, width: view.frame.size.width, height: 60)
        view.addSubview(imageView)
        view.addSubview(pickerView)
        view.addSubview(textField)
        view.addSubview(formatButton)
        view.addSubview(label)
    }
    
    private var imageView: UIImageView = {
        var image = UIImageView()
        return image
    }()

    private var textField: UITextField = {
        var field = UITextField()
        field.frame = CGRect(x: 210, y: 202.5, width: 200, height: 52.5)
        field.layer.cornerRadius = 12
        field.backgroundColor = .secondarySystemBackground
        field.returnKeyType = .continue
        field.placeholder = "Your Text/URl Here"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.leftViewMode = .always
        field.setLeftPaddingPoints(10)
        field.setRightPaddingPoints(10)
        return field
    }()
    
    private var pickerView: UIPickerView = {
        var picker = UIPickerView()
        return picker
    }()
    
    private var formatButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundImage(UIImage(named: "ButtonBack2"), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont(name: "ArialMT", size: 30)
        button.addTarget(self, action: #selector(formatter), for: .touchUpInside)
        return button
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Code Generator!"
        label.font = UIFont(name: "ArialMT", size: 40)
        return label
    }()
    
    @objc func formatter() {
        pickerView.isHidden = false
        textField.resignFirstResponder()
        if formatButton.titleLabel?.text == nil ||  formatButton.titleLabel?.text == ""{
            if formatButton.backgroundImage(for: .normal) == UIImage(named: "ButtonBack2") {
                formatButton.setBackgroundImage(UIImage(named:"ButtonBack"), for: .normal)
            }
            else if formatButton.backgroundImage(for: .normal) == UIImage(named: "ButtonBack") {
                formatButton.setBackgroundImage(UIImage(named:"ButtonBack2"), for: .normal)
            }
        }
    }
    
    func API(format: String, text: String) {
        let url = URL(string: "https://bwipjs-api.metafloor.com/?bcid=\(format)&text=\(text)")
        let task = URLSession.shared.dataTask(with: ((url ?? URL(string: "https://bwipjs-api.metafloor.com/?bcid=postnet&text=12345"))!)) { [self] (data, response, error) in
            
            do {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
            catch let error {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty != true && formatButton.titleLabel?.text?.isEmpty != true {
            let formatEdit = formatButton.titleLabel?.text?.removingWhitespaces()
            let formatEdit2 = formatEdit?.lowercased()
            let textFormat = textField.text?.replacingOccurrences(of: " ", with: "%20")
            API(format: (formatEdit2)!, text: "\(textFormat ?? "")")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.isHidden = true
        
    }

}
extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == textField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
