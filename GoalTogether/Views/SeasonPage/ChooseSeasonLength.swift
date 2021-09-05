//
//  ChooseSeasonLength.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/14/21.
//

import SwiftUI

struct ChooseSeasonLength: View {
    
    @ObservedObject var seasonAimsVM: SeasonAimsViewModel
    
    var body: some View {
        VStack {
            Text("Long Term Goals")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("How long do you want to measure your long term goals for?")
            Button(action: {
                seasonAimsVM.seasonLength = .quarter
                print("Set seasonGoals seasonLength to \(String(describing: seasonAimsVM.seasonLength))")
            }, label: {
                Text("Quarterly")
            })
            .padding()
            Button(action: {
                seasonAimsVM.seasonLength = .month
                print("Set seasonGoals seasonLength to \(String(describing: seasonAimsVM.seasonLength))")
            }, label: {
                Text("Monthly")
            })
            .padding()
        }

    }
}

struct ChooseSeasonLength_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSeasonLength(seasonAimsVM: SeasonAimsViewModel())
    }
}
