//
//  NewsView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct NewsView: View {
	
	@State var height: CGFloat
	@ObservedObject var news: NewsModel
	@Binding var showNewsArticle: Bool
	
	@State var newsArticleURLString: String = ""
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		return VStack {
			HStack {
				Text("News")
					.font(.headline)
				
				Spacer()
			}
			
			if self.news.dataIsLoaded {
				ScrollView(.vertical) {
					ForEach(self.news.newsResults ?? [], id: \.url) { newsItem in
						VStack {
							HStack {
								NewsRow(newsItem: newsItem, geometry: self.geometry)
							}
							
							Divider()
						}
						.frame(minHeight: self.height * 0.15)
						.onTapGesture {
							self.newsArticleURLString = newsItem.url ?? ""
							self.showNewsArticle.toggle()
						}
						
					}
				}
				.sheet(isPresented: self.$showNewsArticle) {
					SFSafariView(urlString: self.newsArticleURLString)
				}
			} else {
				VStack {
					Spacer()
					ActivityIndicator(isLoading: self.$news.dataIsLoaded)
					Spacer()
				}
			}
			
			Spacer()
		}
		
	}
}

struct NewsRow: View {
	
	@State var newsItem: NewsItem
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		ZStack {
			VStack {
				HStack {
					Text(self.newsItem.headline ?? "N/A")
						.font(.subheadline)
						.bold()
						.lineLimit(nil)
						.multilineTextAlignment(.leading)
					
					Spacer()
					
					Image(uiImage: (UIImage(data: self.displayImage()) ?? UIImage(systemName: "exclamationmark.triangle"))!)
						.resizable()
						.aspectRatio(contentMode: .fit)
					//							.frame(maxHeight: geometry.size.width * 0.4)
					//						.frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3, alignment: .center)
					
				}
				
				HStack {
					Text(self.newsItem.source ?? "N/A")
						.font(.subheadline)
					
					Spacer()
				}
			}
			.padding(.bottom)
		}
	}
	
	private func displayImage() -> Data {
		
		var data = Data()
		
		guard let imageURL: URL = URL(string: self.newsItem.image ?? "") else {
			return Data()
		}
		
		guard let imageData: Data = try? Data(contentsOf: imageURL) else {
			return Data()
		}
		
		data = imageData
		
		return data
		
	}
	
}
