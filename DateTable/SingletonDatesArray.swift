import UIKit

final class SingletonDatesArray {
    static let shared = SingletonDatesArray()
    private init() {  }
    
    var allDates = [DateModel]()
    
    func addDate(date: Date) {
        let newDateContainer = DateModel(date: date)
        allDates.insert(newDateContainer, at: 0)
    }
    
    func delDate(index: Int) {
        guard allDates.count > index else { return }
        
        allDates.remove(at: index)
    }
}
