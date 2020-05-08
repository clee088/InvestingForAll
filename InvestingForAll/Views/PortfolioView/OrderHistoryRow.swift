//
//  OrderHistoryRow.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 5/5/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct OrderHistoryRow: View {
	
	@Environment(\.managedObjectContext) var moc
	
	@State var geometry: GeometryProxy
	
	@State var order: FetchedResults<OrderHistory>.Element
	
	@State var isExpanded: Bool = false
	
	@State var isShowingAlert: Bool = false
	
	fileprivate static func statusImage(_ order: FetchedResults<OrderHistory>.Element) -> some View {
		
		switch order.status {
		case "Pending":
			return Image(systemName: "ellipsis.circle")
				.foregroundColor(Color(.systemYellow))
		case "Completed":
			return Image(systemName: "checkmark.circle")
				.foregroundColor(Color(.systemGreen))
		case "Cancelled":
			return Image(systemName: "xmark.circle")
				.foregroundColor(Color(.systemRed))
			
		default:
			return Image(systemName: "questionmark.circle")
				.foregroundColor(Color(.black))
		}
		
	}
	
	var body: some View {
		
		ZStack(alignment: .top) {
			
			RoundedRectangle(cornerRadius: 15)
				.fill(Color("Card Background"))
				.shadow(color: Color("Card Background"), radius: 5)
				.onTapGesture {
					withAnimation {
						self.isExpanded.toggle()
					}
				}
			
			VStack {
				HStack {
					
					Text(self.order.symbol ?? "N/A")
						.font(.headline)
						.fontWeight(.bold)
					
					Text(self.order.action ?? "N/A")
						.font(.subheadline)
						.fontWeight(.semibold)
						.foregroundColor(self.order.action == "Buy" ? Color(.systemGreen) : Color(.systemRed))
					
					Text("\(String(format: "%.2f", self.order.shares)) shares")
						.font(.subheadline)
						.fontWeight(.medium)
					
					Spacer()
					
					Text(self.order.status ?? "N/A")
						.font(.subheadline)
						.fontWeight(.medium)
					
					OrderHistoryRow.statusImage(self.order)
					
				}
				
				if self.isExpanded {
					Divider()
					
					OrderExpandedRow(order: self.order, geometry: self.geometry, isShowingAlert: self.$isShowingAlert)
					.environmentObject(DateModel())
					
				}
				
			}
			.padding()
			
		}
		.frame(height: self.isExpanded ? self.geometry.size.height * 0.4 : self.geometry.size.height * 0.05)
		.padding()
		
	}
	
}

fileprivate struct OrderExpandedRow: View {
	@Environment(\.managedObjectContext) var moc
	@EnvironmentObject var dateModel: DateModel
	@State var order: FetchedResults<OrderHistory>.Element
	@State var geometry: GeometryProxy
	@Binding var isShowingAlert: Bool
	private var cancelAlert: Alert {
		Alert(title: Text("Cancel Order?"), message: Text("Are you sure you want to cancel your order?"), primaryButton: .cancel(Text("No")), secondaryButton: .destructive(Text("Cancel Order"), action: {
			self.cancelOrder(self.order)
		}))
	}
	private var formatter: DateFormatter {
		get {
			
			let formatter = DateFormatter()
			formatter.timeZone = .autoupdatingCurrent
			formatter.dateFormat = "MM/dd/yyyy - HH:mm:ss"
			return formatter
		}
	}
	
	private func createItemRow(title: String, content: String, condition: Bool) -> some View {
		
		HStack {
			Text(title)
				.font(.subheadline)
				.fontWeight(.medium)
			
			Text(content)
				.font(.caption)
				.fontWeight(.regular)
			Spacer()
			Image(systemName: condition ? "xmark.circle" : "checkmark.circle")
				.foregroundColor(condition ? Color(.systemRed) : Color(.systemGreen))
		}
		
	}
	
	private func cancelOrder(_ order: FetchedResults<OrderHistory>.Element) {
		order.status = "Cancelled"
		try? self.moc.save()
	}
	
	var body: some View {
		
		ScrollView(.vertical, showsIndicators: false) {
			
			self.createItemRow(title: "Order ID:", content: "\(self.order.id ?? UUID())", condition: self.order.id == nil)
				.fixedSize(horizontal: false, vertical: true)

			self.createItemRow(title: "Name:", content: "\(self.order.name ?? "N/A")", condition: self.order.name?.isEmpty ?? true)
			
			self.createItemRow(title: "Shares:", content: "\(self.order.shares)", condition: self.order.shares.isNaN)
			
			self.createItemRow(title: "Date Ordered:", content: "\(formatter.string(from: self.order.date ?? Date()))", condition: self.order.date == nil)
			
			self.createItemRow(title: "Position:", content: "\(self.order.action ?? "N/A")", condition: self.order.action?.isEmpty ?? true)
			
			self.createItemRow(title: "Order Type:", content: "\(self.order.type ?? "N/A")", condition: self.order.type?.isEmpty ?? true)
			
			self.createItemRow(title: "Market Status:", content: "\(self.dateModel.marketStatus)", condition: !self.dateModel.marketIsOpen)
			
			HStack {
				Text("Order Status:")
					.font(.subheadline)
					.fontWeight(.medium)
				
				Text("\(self.order.status ?? "N/A")")
					.font(.caption)
					.fontWeight(.regular)
				Spacer()
				OrderHistoryRow.statusImage(self.order)
			}
			
			if self.order.status != "Cancelled" {
				HStack {
					Spacer()
					Button(action: {
						self.isShowingAlert.toggle()
					}) {
						ZStack {
							RoundedRectangle(cornerRadius: 15)
							Text("Cancel Order")
								.foregroundColor(Color.white)
								.scaledToFit()
						}
					}
					.alert(isPresented: self.$isShowingAlert, content: {
						self.cancelAlert
					})
						.frame(width: self.geometry.size.width * 0.3)
					Spacer()
				}
			}
		}
		
	}
	
}
