//
//  ActionEditPage.swift
//  GoalTogether
//
//  Created by Charlie Page on 4/3/21.
//

import SwiftUI


struct ActionEditPage: View {
    @State var actionEditVM: ActionEditViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(actionEditVM: ActionEditViewModel) {
        _actionEditVM = State(initialValue: actionEditVM)
    }
    

    
    var body: some View {
        NavigationView {
            Form {
                    Section(header: Text("Action")) {
                        TextField("Action Title", text: $actionEditVM.action.title)
                    }
                    
                    Section(header: Text("Description")) {
                        ZStack {
                            TextEditor(text: $actionEditVM.action.description ?? "")
                            Text(actionEditVM.action.description ?? "")
                                .opacity(0)
                                .padding(.all, 8)
                        }
                    }
                    Section(header: Text("Dates")) {
                        DatePicker("Start Date", selection: $actionEditVM.action.startDate, displayedComponents: .date)
                        HStack {
                            Button(action: {
                                self.actionEditVM.action.startDate = Date()
                            }) {
                                Text("Today")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.actionEditVM.action.startDate = Date().tomorrowDate()
                            }) {
                                Text("Tomorrow")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.actionEditVM.action.startDate = Date().endOfWeekDate(weekStart: Weekday(rawValue: "sun")!)
                            }) {
                                Text("Later this Week")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
            }.navigationBarTitle("Edit Action")
            .navigationBarItems(
                leading: Button(action: { cancelChanges() }) { Text("Cancel") },
                trailing: Button(action: { saveChanges() }) { Text("Save") }
            )
        }
    }
    
    func cancelChanges() {
        dismiss()
    }
    
    func saveChanges() {
        
        // sets the description back to nil if one was not created
        if actionEditVM.action.description == "" {
            self.actionEditVM.action.description = nil
        }
        
        // updates the existing action if there is an ID, and creates a new one if there is none
        if actionEditVM.action.id != nil {
            self.actionEditVM.updateAction(action: self.actionEditVM.action)
        } else if actionEditVM.action.id == nil {
            self.actionEditVM.addAction(action: self.actionEditVM.action)
        }

        dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ActionEdit_Previews: PreviewProvider {
    static var previews: some View {
        ActionEditPage(actionEditVM: ActionEditViewModel(actionRepository: ActionRepository(), action: Action(title: "Test Task")))
    }
}
