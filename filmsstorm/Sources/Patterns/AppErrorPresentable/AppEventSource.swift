//
//  AppErrorPresentable.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 22.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

/// Interfase to handle app events (AppEvent)
protocol AppEventSource {
    var eventHandler: (AppEvent) -> Void { get }
}
