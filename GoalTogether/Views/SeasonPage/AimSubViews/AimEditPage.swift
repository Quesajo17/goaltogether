//
//  AimEditPage.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/28/21.
//

import SwiftUI

struct AimEditPage: View {
    @State var aimEditVM: AimEditViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    init(aimEditVM: AimEditViewModel) {
        _aimEditVM = State(initialValue: aimEditVM)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Aim")) {
                    TextField("Aim Title", text: $aimEditVM.aim.title)
                }
                
                Section(header: Text("Description")) {
                    ZStack {
                        TextEditor(text: $aimEditVM.aim.description ?? "")
                        Text(aimEditVM.aim.description ?? "")
                            .opacity(0)
                            .padding(.all, 8)
                    }
                    
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("StartDate", selection: $aimEditVM.aim.startDate, displayedComponents: .date)
                    DatePicker("PlannedEndDate", selection: $aimEditVM.aim.plannedEndDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle("Edit Aim")
            .navigationBarItems(
                leading: Button(action: { cancelChanges() }) { Text("Cancel") },
                trailing: Button(action: { saveChanges() }) { Text("Save") }
            )
        }
    }
    
    private func cancelChanges() {
        dismiss()
    }
    
    private func saveChanges() {
        
        // sets the description back to nil if one was not created.
        if aimEditVM.aim.description == "" {
            self.aimEditVM.aim.description = nil
        }
        
        // updates the existign action if there is an ID, and creates a new one if there is none.
        if aimEditVM.aim.id != nil {
            self.aimEditVM.updateAim(aim: self.aimEditVM.aim)
        } else if aimEditVM.aim.id == nil {
            self.aimEditVM.addAim(aim: self.aimEditVM.aim)
        }
        dismiss()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AimEditPage_Previews: PreviewProvider {
    static var previews: some View {
        AimEditPage(aimEditVM: AimEditViewModel(aimRepository: MyAimsRepository(), aim: Aim(id: nil, title: "Original Goal", userId: nil, seasonId: "newSeasonId", startDate: Date(), plannedEndDate: Date(), completed: false, completionDate: nil, description: "This is my first long term goal. We'll see if I'm able to accomplish it effectively.", actions: nil)))
    }
}
