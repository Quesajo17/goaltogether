//
//  ActionListViewModel.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import Foundation
import Combine

class ActionListViewModel: ObservableObject {
    @Published var actionRepository: ActionStoreType
    
    @Published var baseDateActionCellViewModels = [ActionCellViewModel]()
    @Published var baseDateWeekActionCellViewModels = [ActionCellViewModel]()
    @Published var previousActionCellViewModels = [ActionCellViewModel]()
    @Published var futureActionCellViewModels = [ActionCellViewModel]()
    
    @Published var baseDate: Date = Date().dateStart()
    @Published var hideCompleted: Bool = true
    @Published var baseDateIsEndOfWeek: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    // Default initializer for production code.
    init() {
        self.actionRepository = ActionRepository()
        self.baseDateIsEndOfWeek = isDateEndOfWeek(date: self.baseDate, weekEnd: self.baseDate.endOfWeekDate())
        
        loadPastActions()
        loadBaseActions()
        loadWeekActions()
        loadFutureActions()
    }
    
    // Secondary initializer to initialize a different type of action repository.
    init(actionRepository: ActionStoreType) {
        self.actionRepository = actionRepository
        self.baseDateIsEndOfWeek = isDateEndOfWeek(date: self.baseDate, weekEnd: self.baseDate.endOfWeekDate(timeOfDay: .start))
        
        loadPastActions()
        loadBaseActions()
        loadWeekActions()
        loadFutureActions()

    }
    
    // MARK: Functions for initializing the main groups of actions for the Homepage.
    
    
    func isDateEndOfWeek(date currentDate: Date, weekEnd endOfWeekDate: Date) -> Bool {

        if currentDate == endOfWeekDate {
            print("Current Date: \(currentDate) and endOfWeekDate: \(endOfWeekDate) are the same!")
            return true
        } else {
            return false
        }
    }
    
    ///The loadPastActions function takes the published actions list from the repository, and pulls a list of actions from before the base date. (It hides completed actions by default, but this is impacted by the viewModel's "hideCompleted" parameter.
    ///
    ///- returns: Assigns a list of actions from prior to the base date to the pastActionCellViewModels published property in the viewModel.
    func loadPastActions() {
        self.actionRepository.actionsPublisher.map { actions in
            actions.filter { action in
                action.beforeDate(self.baseDate) && action.showIfIncomplete(onlyIncomplete: self.hideCompleted)
            }
            .map { action in
                ActionCellViewModel(actionRepository: self.actionRepository, action: action)
            }
        }
        .assign(to: \.previousActionCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    ///The loadBaseActions function takes the published actions list from the repository, and pulls a list of actions from the base date. (It hides completed actions by default, but this is impacted by the viewModel's "hideCompleted" parameter.
    ///
    ///- returns: Assigns a list of actions from the base date to the viewModel's baseDateActionCellViewModels property.
    func loadBaseActions() {
        self.actionRepository.actionsPublisher.map { actions in
            actions.filter { action in
                action.inDateRange(from: self.baseDate, to: self.baseDate) && action.showIfIncomplete(onlyIncomplete: self.hideCompleted)
            }
            .map { action in
                ActionCellViewModel(actionRepository: self.actionRepository, action: action)
            }
        }
        .assign(to: \.baseDateActionCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    /// The loadWeekActions takes the published actions list for the current user from the repository, and pulls a list of actions either from remainder of the current week (if not the end of the week), or from next week, if it's the last day of the week.
    ///
    ///- returns: Assigns a list of actions from the rest of this week or the next week to the viewModel's baseDateWeekActionCellViewModels property.
    func loadWeekActions() {
        let startDate: Date = self.baseDate.tomorrowDate()
        
        self.actionRepository.actionsPublisher.map { actions in
            actions.filter { action in
                action.inDateRange(from: startDate, to: startDate.endOfWeekDate()) && action.showIfIncomplete(onlyIncomplete: self.hideCompleted)
            }
            .map { action in
                ActionCellViewModel(actionRepository: self.actionRepository, action: action)
            }
        }
        .assign(to: \.baseDateWeekActionCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    /// The loadFutureActions function takes the published actions list for the current user from the repository, and pulls a list of actions from after the week tasks.
    ///
    ///- returns: Assigns a list of actions from the future (beyond this week or next, depending on whether the baseDate is the end of the week) to the futureActionCellViewModels property in the viewModel.
    func loadFutureActions() {
        let startAfter: Date = baseDate.tomorrowDate().endOfWeekDate()
        
        self.actionRepository.actionsPublisher.map { actions in
            actions.filter { action in
                action.afterDate(startAfter) && action.showIfIncomplete(onlyIncomplete: self.hideCompleted)
            }
            .map { action in
                ActionCellViewModel(actionRepository: self.actionRepository, action: action)
            }
        }
        .assign(to: \.futureActionCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    // MARK: Functions for CRUD operations on existing actions
    func addAction(_ action: Action) {
        actionRepository.addAction(action)
    }
    
    func updateAction(_ action: Action) {
        actionRepository.updateAction(action)
    }
    
    func deleteAction(_ action: Action) {
        actionRepository.deleteAction(action)
    }
}
