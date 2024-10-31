//
//  MainWidgetTimelineEntry.swift
//  WellyBus
//
//  Created by Eoin Kelly on 01/11/2024.
//
import WidgetKit

struct MainWidgetTimelineEntry: TimelineEntry {
  let date: Date
  let stopPredictions: [StopPrediction]
}
