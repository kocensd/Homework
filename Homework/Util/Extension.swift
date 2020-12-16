//
//  Extension.swift
//  Homework
//
//  Created by SangDo on 2020/09/06.
//  Copyright © 2020 SangDo. All rights reserved.
//

//import Foundation
import UIKit
import RxSwift

func checkValid(_ str: String) -> String {
    if let tagStr = str.html2Attributed {
        return tagStr.string
    } else {
        return str
    }
}

func changeDate(_ day: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko")
    formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.sssZ"
    let date1 = formatter.date(from: day)
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatterPrint.dateFormat = "yyyy년 MM월 dd일 a hh:mm"
    let resultTime = dateFormatterPrint.string(from: date1!)
    return resultTime
}

func dateBetween(_ releaseDate: String) -> String {
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    let requestedComponent: Set<Calendar.Component> = [.month,.day]
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'+'mm:ss"
    let startTime = Date()
    let endTime = dateFormatter.date(from: releaseDate)
    let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime, to: endTime!)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.sssZ"
    let date1  = formatter.date(from: releaseDate)
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatterPrint.dateFormat = "yyyy-MM-dd"
    let resultTime = dateFormatterPrint.string(from: date1!)
    
    if abs(timeDifference.month ?? 0) > 0 {
        return resultTime
    } else {
        let day = abs(timeDifference.day ?? 0)
        if day == 0 {
             return "오늘"
        } else if day == 1 {
            return "어제"
        } else {
            return resultTime
        }
    }
}

extension String {
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else { return nil }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
}

extension UIAlertController {
    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style
        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }
    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        type: String,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: style)
            if type == "ipad" {
                alertController.popoverPresentationController?.sourceView = viewController.view
                alertController.popoverPresentationController?.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
                alertController.popoverPresentationController?.permittedArrowDirections = []
            }
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
