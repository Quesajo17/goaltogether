//
//  ActionEditPage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI

struct ActionEditPage: View {
    @ObservedObject var actionCellVM: ActionCellViewModel
    
    @State var startDate: Date
    @State var description: String
    @State var dueDate: Date
    var onCommit: (Action) -> (Void) = { _ in }
    @Binding var sheetActive: Bool
    @Environment(\.presentationMode) var presentationMode
    
    init(actionCellVM: ActionCellViewModel, sheetActive: Binding<Bool>) {
        self.actionCellVM = actionCellVM
        _startDate = State(initialValue: actionCellVM.action.startDate)
        self._sheetActive = sheetActive
        if actionCellVM.action.description != nil {
            _description = State(initialValue: actionCellVM.action.description!)
        } else {
            _description = State(initialValue: "")
        }
        if actionCellVM.action.dueDate != nil {
            _dueDate = State(initialValue: actionCellVM.action.dueDate!)
        } else {
            _dueDate = State(initialValue: actionCellVM.action.startDate)
        }
    }
    

    
    var body: some View {
        NavigationView {
            Form {
                    Section(header: Text("Task")) {
                        TextField("Task Title", text: $actionCellVM.action.title)
                    }
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $description)
                    }.fixedSize(horizontal: false, vertical: false)
                    
                    // TextField("Description", text: $actionCellVM.action.description)
                    Section(header: Text("Dates")) {
                        // Add back "in: Date()...," after selection if I don't want people to be able to use past dates.
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        HStack {
                            Button(action: {
                                self.startDate = Date().currentDate()
                            }) {
                                Text("Today")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.startDate = Date().tomorrowDate()
                            }) {
                                Text("Tomorrow")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.startDate = Date().endOfWeekDate(weekStart: Weekday(rawValue: "sun")!)
                            }) {
                                Text("Later this Week")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        // Add back "in: startDate...," after selection if I don't want people to be able to pick a past date.
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    }.navigationBarTitle("Edit Task")
                    .navigationBarItems(
                        leading: Button(action: { cancelChanges() }) { Text("Cancel") },
                        trailing: Button(action: { saveChanges() }) { Text("Save") }
                    )
                
            }
        }
    }
    
    func cancelChanges() {
        dismiss()
    }
    
    func saveChanges() {
        if dueDate != actionCellVM.action.startDate {
            print("Action Start Date is equal to \(actionCellVM.action.startDate)")
            print("Current Due Date is equal to \(dueDate)")
            print("Setting Action Due Date equal to Due Date variable in this view")
            self.actionCellVM.action.dueDate = dueDate
        }
        actionCellVM.action.startDate = startDate
        if description != "" {
            self.actionCellVM.action.description = description
        }
        self.actionCellVM.updateAction(action: actionCellVM.action)
        dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ActionEdit_Previews: PreviewProvider {
    static var previews: some View {
        ActionEditPage(actionCellVM: ActionCellViewModel(action: Action(title: "Test Task")), sheetActive: .constant(true))
    }
}
