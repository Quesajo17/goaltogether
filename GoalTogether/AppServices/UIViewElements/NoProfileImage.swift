//
//  NoProfileImage.swift
//  GoalTogether
//
//  Created by Charlie Page on 5/5/21.
//

import SwiftUI

struct NoProfileImage: View {
    var body: some View {
        Image(systemName: "person.fill").foregroundColor(.white)
            .font(.system(size: 60))
            .frame(width: 100, height: 100)
            .background(Color.gray)
    }
}

struct NoProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        NoProfileImage()
    }
}
