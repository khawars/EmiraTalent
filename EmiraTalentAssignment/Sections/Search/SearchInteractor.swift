//
//  SearchInteractor.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//  
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class SearchInteractor: NSObject, PresenterToInteractorSearchProtocol {
    var presenter: InteractorToPresenterSearchProtocol?
    
    func loadDataWithFileSource(fileSource: FileSource) {
        switch fileSource {
        case .files:
            loadFromFiles()
            break
            
            
        case .bundle:
            let filePath = Bundle.main.url(forResource: "file", withExtension: "txt")
            if let filePath = filePath {
                loadContentFromUrl(url: filePath)
            }
            break
            
        case .webservice:
            loadFromWebApi()
            break
        }
    }
    
    func loadFromFiles() {
        let supportedTypes: [UTType] = [UTType.text]
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPickerController.delegate = self
        documentPickerController.allowsMultipleSelection = false
        documentPickerController.shouldShowFileExtensions = true
        
        if let vc = UIApplication.shared.topMostViewController() {
            vc.present(documentPickerController, animated: true, completion: nil)
        }
    }
    
    func loadFromWebApi() {
        presenter?.dataLoadingStartedFromApi()
        let networkService = NetworkService()

        guard let url = URL(string: Endpoints.contentUrl.rawValue) else {
            return
        }
        
        let request = NetworkRequest(url: url)
        networkService.get(request: request) { result in
            switch result {
            case .success(let data):
                let searchResponseModel: SearchEntity = try! JSONDecoder().decode(SearchEntity.self, from: data)
                DispatchQueue.main.async {
                    self.presenter?.dataLoadingCompletedFromApi()
                    self.presenter?.fileLoadedWithContent(content: searchResponseModel.fileContent ?? "")
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.dataLoadingCompletedFromApi()
                    self.presenter?.fileNotLoadedWithErrorMessage(errorMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func loadContentFromUrl(url: URL) {
        do {
            let content = try String(contentsOf: url)
            presenter?.fileLoadedWithContent(content: content)
                        
        } catch let error {
            presenter?.fileNotLoadedWithErrorMessage(errorMessage: error.localizedDescription)            
        }
    }
}


extension SearchInteractor: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        presenter?.fileNotLoadedWithErrorMessage(errorMessage: "Document Picker was cancelled")
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            loadContentFromUrl(url: url)
        } else {
            presenter?.fileNotLoadedWithErrorMessage(errorMessage: "Could not load file")
        }
    }
}
