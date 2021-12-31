//
//  SeasonView.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/14/21.
//

import SwiftUI

struct SeasonView: View {
    
    @EnvironmentObject var currentUser: CurrentUserProfile
    @ObservedObject var seasonAimsVM: SeasonAimsViewModel
    
    var body: some View {
        if seasonAimsVM.featuredSeason != nil {
            SeasonPage(seasonAimsVM: seasonAimsVM)
                .environmentObject(seasonAimsVM)
        } else if seasonAimsVM.seasonLength == nil {
            ChooseSeasonLength(seasonAimsVM: seasonAimsVM)
                .environmentObject(seasonAimsVM)
        } else {
            LoadingScreen(seasonAimsVM: seasonAimsVM)
                .environmentObject(seasonAimsVM)
        }
    }
}

struct SeasonView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonView(seasonAimsVM: SeasonAimsViewModel())
    }
}
