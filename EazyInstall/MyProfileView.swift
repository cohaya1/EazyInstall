//
//  MyProfileView.swift
//  EazyInstall
//
//  Created by Chika Ohaya on 11/12/23.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var sharedDataModel: SharedDataModel

    var body: some View {
        
        ZStack {
            PhoneBackground()
            
          
                
                ProfileBackground()
                    .padding(.bottom, 360)
                RedBar()
                    .padding(.bottom, 80)
                Profile()
                    .padding(.bottom, 700)
                    .padding(.trailing,225)
            
                PostsBackground()
                    .padding(.top,600)
            
                HStack(spacing: 190) {
                    MyManuals()
                    Image("Table")
                        .resizable()
                        .frame(width: 24, height: 24)
                } .padding(.top,300)
               
            VStack {
                // Iterate over the posts and create a Posts view for each
                ForEach(sharedDataModel.posts, id: \.self) { post in
                    Posts(postText: post )
                }
            }.padding(.top,500)
                
            }
        }
    }

struct PhoneBackground: View {
  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: 375, height: 812)
      .background(
        LinearGradient(gradient: Gradient(colors: [.white, Color(red: 0.96, green: 0.97, blue: 1)]), startPoint: .bottomLeading, endPoint: .topTrailing)
      );
  }
}
struct ProfileBackground: View {
  var body: some View {
      
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: 295, height: 284)
      .background(.white)
      .cornerRadius(16)
      .shadow(
        color: Color(red: 0.32, green: 0.51, blue: 1, opacity: 0.06), radius: 15, y: 10
      );
      VStack {
                 ProfileImage()
                 
                
             }
  }
}
struct ProfileImage: View {
    var body: some View {
        VStack {
            Image(" ") // Replace with your actual image name
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Text("@joviedan").offset(y: 75))
            Text("Jovi Daniel")
                .font(.title)
                .fontWeight(.bold)
           
        }
        .padding(.bottom, 150)
    }
}



struct RedBar: View {
    var body: some View {
        ZStack {
           
            Rectangle()
                .frame(width: 231, height: 68)
                .foregroundColor(.clear)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.8, green: 0.2, blue: 0.2).opacity(0.9),
                                                               Color(red: 0.6, green: 0.1, blue: 0.1)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                )
                .cornerRadius(12)
                .shadow(color: Color.red.opacity(0.5), radius: 10, x: 5, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.8),
                                                                           Color.white.opacity(0)]),
                                               startPoint: .top,
                                               endPoint: .bottom), lineWidth: 2)
                )
                .scaleEffect(1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: UUID()
                )
            VStack {
                Text("52")
                    .font(Font.custom("Muli ExtraBold", size: 20).weight(.heavy))
                    .lineSpacing(22)
                    .foregroundColor(.white)
                Text("Manuals")
                  .font(Font.custom("Mulish", size: 12))
                  .lineSpacing(18)
                  .foregroundColor(Color(red: 1, green: 1, blue: 1).opacity(0.87))
            }
        }
    }
}
struct MyManuals: View {
  var body: some View {
    Text("My Manuals")
      .font(Font.custom("Avenir", size: 20).weight(.heavy))
      .foregroundColor(Color(red: 0.05, green: 0.15, blue: 0.24));
  }
}
struct PostsBackground: View {
  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .frame(width: 385, height: 395)
      .background(.white)
      .cornerRadius(28)
      .shadow(
        color: Color(red: 0.32, green: 0.51, blue: 1, opacity: 0.07), radius: 32
      );
  }
}
struct Profile: View {
  var body: some View {
    Text("Profile")
      .font(Font.custom("Avenir", size: 24).weight(.heavy))
      .foregroundColor(Color(red: 0.05, green: 0.15, blue: 0.24));
  }
}
#Preview {
    MyProfileView()
}
