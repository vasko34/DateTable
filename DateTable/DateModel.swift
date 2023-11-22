import UIKit

extension Date {
    func coolDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\ndd MMMM\nHH:mm"
        return dateFormatter.string(from: self)
    }
}

struct DateModel: Codable {
    var date: Date
    var name: String {
        return self.date.coolDescription()
    }
}
