//
//  SearchContract.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//  
//

import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSearchProtocol {
    func showErrorMessage(errorMessage: String)
    func showSearchResult(searchResult: String)
    func dataIsLoaded(dataLoaded: Bool)
    func abortProgram()
    func showLoader()
    func hideLoader()
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSearchProtocol {    
    var view: PresenterToViewSearchProtocol? { get set }
    var interactor: PresenterToInteractorSearchProtocol? { get set }
    var router: PresenterToRouterSearchProtocol? { get set }
    
    func loadDataWithAction(fileSource: FileSource)
    func searchWithQuery(query: String)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSearchProtocol {
    var presenter: InteractorToPresenterSearchProtocol? { get set }
    func loadDataWithFileSource(fileSource: FileSource)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSearchProtocol {
    func fileLoadedWithContent(content: String)
    func fileNotLoadedWithErrorMessage(errorMessage: String)
    func dataLoadingStartedFromApi()
    func dataLoadingCompletedFromApi()
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSearchProtocol {
    
}
