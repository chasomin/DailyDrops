//
//  SupplementViewModel.swift
//  DailyDrops
//
//  Created by 차소민 on 3/10/24.
//

import Foundation

final class SearchViewModel {
    
    let inputViewDidLoad: Observable<Void?> = Observable(nil)
    let inputSearchButtonTapped: Observable<String?> = Observable(nil)
    let inputPagenation: Observable<IndexPath?> = Observable(nil)
    let inputWeekButtonTapped: Observable<Int?> = Observable(nil)
    
    let outputData: Observable<[Supplement]> = Observable([])
    let outputSetTableView: Observable<Void?> = Observable(nil)
    let outputSetNavigation: Observable<Void?> = Observable(nil)
    let outputSetSearchBar: Observable<Void?> = Observable(nil)
    let outputWeekButtonTapped:  Observable<[Int]?> = Observable(nil)
    
    init () { transform() }
    
    private func transform() {
        inputViewDidLoad.bind { [weak self] value in
            guard let value, let self else { return }
            allFetch()
            outputSetTableView.value = ()
            outputSetNavigation.value = ()
            outputSetSearchBar.value = ()
        }
        inputSearchButtonTapped.bind { [weak self] value in
            guard let value, let self else { return }
            print("검색!")
            outputData.value.removeAll()
            searchFetch(value)
        }
        inputPagenation.bind { [weak self] indexPath in
            guard let self, let indexPath else { return }
            setPagenation(indexPath)
        }
        inputWeekButtonTapped.bind { [weak self] value in
            guard let self, let value else { return }
            if ((outputWeekButtonTapped.value?.contains(value)) != nil) {
                guard let index = outputWeekButtonTapped.value?.firstIndex(of: value) else { return }
                outputWeekButtonTapped.value?.remove(at: index)
            } else {
                outputWeekButtonTapped.value?.append(value)
            }
        }
    }
    
    private func allFetch() {
        APIManager.shared.callRequest(api: .all) { [weak self] result, error in
            guard let error else {
                guard let result, let self else { return }
                outputData.value.append(contentsOf: result)
                return
            }
            print(error)//TODO: Error
        }
    }
    
    private func searchFetch(_ text: String) {
        APIManager.shared.callRequest(api: .search(searchText: text)) { [weak self] result, error in
            guard let error else {
                guard let result, let self else { return }
                outputData.value.append(contentsOf: result)
                print("===", result)
                return
            }
            print(error)//TODO: Error
        }
    }
    
    private func setPagenation(_ indexPath: IndexPath) {
        if outputData.value.count - 4 == indexPath.row {
            SupplementAPI.start += 15
            SupplementAPI.end += 15
            guard let text = inputSearchButtonTapped.value else {
                allFetch()
                return
            }
            searchFetch(text)
        }
    }
}
