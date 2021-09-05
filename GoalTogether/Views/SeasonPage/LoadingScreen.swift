//
//  LoadingScreen.swift
//  GoalTogether
//
//  Created by Charlie Page on 6/15/21.
//

import SwiftUI

struct LoadingScreen: View {
    
    @ObservedObject var seasonAimsVM: SeasonAimsViewModel
    
    var body: some View {
        VStack {
            ProgressView()
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen(seasonAimsVM: SeasonAimsViewModel())
    }
}
