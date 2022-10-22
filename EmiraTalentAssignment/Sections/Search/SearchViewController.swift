//
//  SearchViewController.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//  
//

import UIKit


class SearchViewController: UIViewController {
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtHistory: UITextView!
    @IBOutlet weak var btnLoadData: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let darkColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1)
    private let mediumColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1)
    private let lightColor = UIColor.white
    
    var presenter: ViewToPresenterSearchProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObjects()
        setupAppearance()
    }

    private func initObjects() {
        txtSearch.delegate = self
    }
    
    private func setupAppearance() {
        view.backgroundColor = darkColor
        
        txtSearch.backgroundColor = darkColor
        txtSearch.layer.borderWidth = 1
        txtSearch.layer.borderColor = lightColor.cgColor
        txtSearch.textColor = lightColor
        txtSearch.autocorrectionType = .no
        txtSearch.attributedPlaceholder = NSAttributedString(
            string: "Type a word to search in file",
            attributes: [NSAttributedString.Key.foregroundColor: mediumColor]
        )
        
        txtHistory.layer.borderColor = lightColor.cgColor
        txtHistory.layer.borderWidth = 1
        txtHistory.backgroundColor = darkColor
        txtHistory.textColor = lightColor
        
        segmentedControl.selectedSegmentTintColor = lightColor
        segmentedControl.layer.backgroundColor = mediumColor.cgColor
    }
    
    func updateInputField(shouldEnabled: Bool) {
        if shouldEnabled {
            txtSearch.isHidden = false
            txtHistory.isHidden = false
            btnLoadData.isEnabled = false
            segmentedControl.isEnabled = false
            
        } else {
            txtSearch.isHidden = true
            txtHistory.isHidden = true
            txtSearch.text = ""
            btnLoadData.isEnabled = true
            segmentedControl.isEnabled = true
        }
    }
    
    @IBAction func actionLoadData(_ sender: Any) {
        if let dataSource = FileSource(rawValue: segmentedControl.selectedSegmentIndex) {
            presenter?.loadDataWithAction(fileSource: dataSource)
        } else {
            showAlert(title: "Error", message: "File source is invalid.", handler: nil)
        }        
    }
    
    
    func logText(text: String) {
        var history = txtHistory.text ?? ""
        if !history.isEmpty {
            history = "\(history)\n"
        }
        
        txtHistory.text = "\(history)\(text)"
        scrollTextViewToBottom(textView: txtHistory)
    }
    
    func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    func showError(message: String) {
        showAlert(title: "Error", message: message, handler: nil)
    }
}

extension SearchViewController: PresenterToViewSearchProtocol{
    func showLoader() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)

    }
    
    func hideLoader() {
        dismiss(animated: false, completion: nil)
    }
    
    
    func showSearchResult(searchResult: String) {
        self.logText(text: searchResult)
        self.txtSearch.text = ""
        self.txtSearch.becomeFirstResponder()
    }
    
    func dataIsLoaded(dataLoaded: Bool) {
        updateInputField(shouldEnabled: dataLoaded)
    }
    
    func showErrorMessage(errorMessage: String) {
        showError(message: errorMessage)
    }
    
    func abortProgram() {
        logText(text: "program ended..")
        txtSearch.isEnabled = false
        txtSearch.text = ""
        txtSearch.isHidden = true
    }
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let query = textField.text ?? ""
        let queryText = ">> input search term: \(query)"
        logText(text: queryText)
        presenter?.searchWithQuery(query: query)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            showError(message: "Please type single work, space is not allowed.")
            return false
            
        } else {
            return true
        }
    }    
}
