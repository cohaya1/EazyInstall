//
//  InstallationGuideItem.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 11/12/23.
//

import SwiftUI

struct InstallationGuideItem: View {
    var body: some View {
        MakeYourOwnFoodStayAtHome()
        
    }
}

struct MakeYourOwnFoodStayAtHome: View {
  var body: some View {
    Text("My Personal Guides,\nEnjoy!")
      .font(Font.custom("Roboto", size: 20).weight(.medium))
      .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.38));
  }
}

struct GuideItem: View {
  var body: some View {
    ZStack() {
      ZStack() {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 145, height: 187)
          .background(Color(red: 0, green: 0, blue: 0).opacity(0.22))
          .cornerRadius(30)
          .offset(x: 0.50, y: 0)
          .blur(radius: 32)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 162, height: 182)
          .background(.white)
          .cornerRadius(20)
          .offset(x: 0, y: -1.50)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 202.21, height: 181.97)
          .background(
            AsyncImage(url: URL(string: "https://via.placeholder.com/202x182"))
          )
          .offset(x: 4.02, y: -1.51)
      }
      .frame(width: 162, height: 187)
      .offset(x: 0, y: 0)
      Rectangle()
        .foregroundColor(.clear)
        .frame(width: 162, height: 35)
        .background(
          LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 0, blue: 0).opacity(0), Color(red: 0, green: 0, blue: 0).opacity(0.30)]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
        .offset(x: 0, y: 72)
      Text("Lemon Pancake")
        .font(Font.custom("Roboto", size: 13).weight(.medium))
        .foregroundColor(.white)
        .offset(x: -3.87, y: 76.17)
      Ellipse()
        .foregroundColor(.clear)
        .frame(width: 6, height: 6)
        .background(Color(red: 1, green: 0.25, blue: 0.25))
        .offset(x: -65, y: 75.50)
      ZStack() {
        Ellipse()
          .foregroundColor(.clear)
          .frame(width: 27.74, height: 27.74)
          .background(Color(red: 0.37, green: 0.37, blue: 0.38).opacity(0.44))
          .offset(x: 0, y: 0)
        VStack(spacing: 0) {
          ZStack() { }
          .frame(width: 16, height: 16)
        }
        .padding(
          EdgeInsets(top: 0.11, leading: 0, bottom: 0.07, trailing: 0.18)
        )
        .frame(width: 16.18, height: 16.18)
        .offset(x: -0, y: 1.12)
      }
      .frame(width: 27.74, height: 27.74)
      .offset(x: 57.14, y: -68.64)
    }
    .frame(width: 162, height: 187);
  }
}
#Preview {
    InstallationGuideItem()
}
