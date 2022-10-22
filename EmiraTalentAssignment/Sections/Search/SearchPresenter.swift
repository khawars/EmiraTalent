//
//  SearchPresenter.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//  
//

import Foundation

enum FileSource: Int {
    case files = 0
    case bundle = 1
    case webservice = 2
}

class SearchPresenter: ViewToPresenterSearchProtocol {

    // MARK: Properties
    var view: PresenterToViewSearchProtocol?
    var interactor: PresenterToInteractorSearchProtocol?
    var router: PresenterToRouterSearchProtocol?
    
    private let prePostSearchWordCount = 3
    private let abortCommand = "letsquit"
    var words = Array<String>()
    
//    var errorMessage = Observable<String>("")
//    var dataAvailable = Observable<Bool>(false)
//    var searchResult = Observable<String>("")
//    var abortProgram = Observable<Bool>(false)
    
    private func prepareDataSource(content: String) {
        var fileData = content.replacingOccurrences(of: "\n", with: " ")
        fileData = content.replacingOccurrences(of: ".", with: "")
        words = fileData.components(separatedBy: " ")
        view?.dataIsLoaded(dataLoaded: true)
    }
    
    
    func loadDataWithAction(fileSource: FileSource) {
        interactor?.loadDataWithFileSource(fileSource: fileSource)        
    }
    
    func searchWithQuery(query: String) {
        if query.lowercased() == abortCommand.lowercased() {
            view?.abortProgram()
            return
        }
        
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            view?.showSearchResult(searchResult: "Input is empty\n")
            return
        }
                
        let word = trimmed.components(separatedBy: " ").first ?? ""
        
        let indices = words.enumerated().compactMap {
            $0.element.lowercased() == word.lowercased() ? $0.offset : nil
        }
        
        if !indices.isEmpty {
            var searchText = ""
            for index in indices {
                let startIndex = index-prePostSearchWordCount < 0 ? 0 : index-prePostSearchWordCount
                let endIndex = index+prePostSearchWordCount > words.count-1 ? words.count-1 : index+prePostSearchWordCount
                var sentence = ""
                for i in startIndex...endIndex {
                    sentence += "\(words[i]) "
                }
                
                sentence.removeLast()
                searchText += "\"\(sentence)\"\n"
            }

            view?.showSearchResult(searchResult: searchText)
            
        } else {
            view?.showSearchResult(searchResult: "No results found\n")
        }
    }
}

extension SearchPresenter: InteractorToPresenterSearchProtocol {
    func fileLoadedWithContent(content: String) {
        prepareDataSource(content: content)
    }
    
    func fileNotLoadedWithErrorMessage(errorMessage: String) {
        view?.showErrorMessage(errorMessage: errorMessage)
        view?.dataIsLoaded(dataLoaded: false)
    }
    
    func dataLoadingStartedFromApi() {
        view?.showLoader()
    }
    
    func dataLoadingCompletedFromApi() {
        view?.hideLoader()
    }
}
