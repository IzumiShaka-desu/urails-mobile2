//
//  TimelineItem.swift
//  iosApp
//
//  Created by Akashaka on 02/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import SwiftUI

protocol TimelineItem: Identifiable, Equatable {
    var id: UUID { get }
    var title: String { get }
    var subtitle: String? { get }
    var time: String? { get }
    var image: String? { get }
    var status: TimelineStatus { get }
}

struct TimelineItemData: Identifiable, Equatable, TimelineItem {
    let id = UUID()
    let title: String
    let subtitle: String?
    let time: String?
    var image: String? = nil
    let status: TimelineStatus
}

struct TimelineRouteItemData: Identifiable, Equatable, TimelineItem {
    let id = UUID()
    let title: String
    let subtitle: String?
    let time: String?
    var image: String? = nil
    let options: [ItemOptions]
    let child: [TimelineRouteChild]
    let status: TimelineStatus
}

struct TimelineRouteChild: Identifiable, Equatable {
    let id = UUID()
    let leading: String
    let trailing: String
    let status: TimelineStatus
}

struct ItemOptions: Identifiable, Equatable {
    static func == (lhs: ItemOptions, rhs: ItemOptions) -> Bool {
        lhs.id != rhs.id
    }

    let id = UUID()
    let leading: String
    let trailing: String
    let isActive: Bool
    let action: () -> Void
}

enum TimelineStatus {
    case active, past, future
}
