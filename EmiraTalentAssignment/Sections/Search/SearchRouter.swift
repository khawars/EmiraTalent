//
//  SearchRouter.swift
//  EmiraTalentAssignment
//
//  Created by Khawar Shahzad on 22/10/2022.
//  
//

import Foundation
import UIKit

class SearchRouter: PresenterToRouterSearchProtocol {
    
    // MARK: Static methods
    static func createModule() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        let presenter: ViewToPresenterSearchProtocol & InteractorToPresenterSearchProtocol = SearchPresenter()
        
        viewController.presenter = presenter
        viewController.presenter?.router = SearchRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SearchInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        
        return viewController
    }
    
}
