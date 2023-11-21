//
//  Posts.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 11/16/23.
//

import SwiftUI

struct Posts: View {
    @EnvironmentObject var sharedDataModel: SharedDataModel
    var postText: String  // New parameter to accept post text

    var body: some View {
        ZStack {
            PostsCardBackground()
            HStack(alignment: .top, spacing: 12) { // adjusted spacing between image and text
                ImagePlaceholder()
                VStack(alignment: .leading, spacing: 4) { // adjusted spacing between title and preview text
                    TitleText()
                    PostsPreviewText(text: postText)

                    HStack {
                        Time()
                            .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                        TimeOfText()
                       
                    }
                }
                .padding(.top, 16) // adjusted top padding
                .padding(.trailing, 16) // adjusted trailing padding
            }
            .padding(.leading, 12) // adjusted leading padding
        }
    }
}

struct PostsCardBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 345, height: 141)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0.32, green: 0.51, blue: 1, opacity: 0.06), radius: 15, x: 0, y: 10)
    }
}

struct ImagePlaceholder: View {
    var body: some View {
        Image("background2")
            .resizable()
            .frame(width: 92, height: 141)
            .cornerRadius(16)
    }
}

struct TitleText: View {
    var body: some View {
        Text("BIG DATA")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(Color(red: 0.22, green: 0.42, blue: 0.93))
            .lineLimit(1) // assuming title is only one line
    }
}

struct PostsPreviewText: View {
    var text: String  // Accepts the text to display

    var body: some View {
        Text(text)  // Use the passed-in text
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(Color(red: 0.05, green: 0.15, blue: 0.24))
            .lineLimit(2)
            .padding(.bottom, 2)
    }
}

struct Time: View {
  var body: some View {
    ZStack() {
     Image("Time")
            .resizable()
    }
    .frame(width: 16, height: 16)
    .shadow(
      color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
    );
  }
}
struct TimeOfText: View {
    var body: some View {
       
           
            Text("1hr ago")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(red: 0.18, green: 0.26, blue: 0.47))
        }
    }


