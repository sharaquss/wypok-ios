//
//  WypokMirkoViewController.swift
//  wypok
//
//  Created by Przemyslaw Jablonski on 23/07/2018.
//  Copyright © 2018 Przemyslaw Jablonski. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

class WypokMirkoViewController: BaseView<WypokMirkoPresenter, WypokMirkoViewState>, UITableViewDataSource, UITableViewDelegate {
    
    private var entries = [MirkoItemModel]()
    @IBOutlet weak var listTypeControl: UISegmentedControl!
    @IBOutlet weak var entriesTableView: UITableView!
    @IBOutlet weak var upButton: UIButton!
    
    private var selectedEntryId: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entriesTableView.register(with: MirkoEntryTableViewCell.self.registerData)
        onListTypeChanged(listTypeControl)
    }
    
    
    @IBAction func onListTypeChanged(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0: presenter?.onHotSelected()
        case 1: presenter?.onRecentsSelected()
        default: break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //todo: this should be in presenter really
        //todo: magic string
        selectedEntryId = entries[indexPath.row].id
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "MirkoEntryDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController = segue.destination as? WypokMirkoDetailsViewController, let entryId = selectedEntryId {
            detailsViewController.receivedSelectedEntryId(entryId)
        }
        super.prepare(for: segue, sender: sender)
    }
    
    override func render(_ viewState: WypokMirkoViewState) {
        switch viewState {
        case .RECENTS_ERROR:
            break
        case .RECENTS_LOADING:
            break
        case .RECENTS_EMPTY_LIST:
            break
        case .RECENTS_LIST(let entries):
            reloadTableData(with: entries)
            break
        case .HOT_ERROR:
            break
        case .HOT_LOADING:
            break
        case .HOT_EMPTY_LIST:
            break
        case .HOT_LIST(let entries):
            reloadTableData(with: entries)
            break
        }
    }
    
    private func reloadTableData(with newEntries: [MirkoItemModel]) {
        let (inserts, updates, deletes, hasChanges) = calculateRowsToUpdate(between: self.entries, and: newEntries)
        self.entries = newEntries
        entriesTableView.performBatchUpdates({
            entriesTableView.insertRows(at: inserts, with: .automatic)
            entriesTableView.reloadRows(at: updates, with: .automatic)
            entriesTableView.deleteRows(at: deletes, with: .automatic)
        }, completion: { finished in
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.onMirkoItemShownOnScreen(row: indexPath.row) //todo: ShownOnScreen -> Rendered
        return update(rowId: indexPath.row,
                      with: tableView.dequeueReusableCell(withIdentifier: MirkoEntryTableViewCell.REUSE_IDENTIFIER, for: indexPath) as! MirkoEntryTableViewCell,
                      and: entries[indexPath.row])
    }
    
    private func calculateRowsToUpdate(between oldArray: [MirkoItemModel], and newArray: [MirkoItemModel]) -> (inserts: [IndexPath], updates: [IndexPath], deletes: [IndexPath], hasChanges: Bool) {
        let result = ListDiffPaths(
            fromSection: 0,
            toSection: 0,
            oldArray: oldArray,
            newArray: newArray,
            option: .equality).forBatchUpdates()
        return (result.inserts, result.updates, result.deletes, result.hasChanges)
    }
    
    //todo: here, each time NSAttributedString is calculated (item.content.convertToAttributedString())
    //todo: it should be in the model (as a field) in order to reduce performance impact
    //todo: quite similarly with the images, they are being pulled from the memory (or disk lol) and put in place
    //todo: convertToAttributedString is prolly used multiple times in single flow
    private func update(rowId: Int, with cell: MirkoEntryTableViewCell, and item: MirkoItemModel) -> MirkoEntryTableViewCell {
        cell.updateContents(
            DEBUGTEXTOLOL: String(item.id - 34857000) + " / " + String(rowId),
            authorImageUrl: item.authorAvatarUrl,
            authorName: item.authorName,
            authorDevice: item.application,
            entryContent: item.content.convertToAttributedString().setFontFace(font: UIFont.systemFont(ofSize: 13)),
            entryEmbedImageUrl: item.embed?.previewImageUrl,
            entryUpvotesCount: item.upvoteCount,
            entryCommentsCount: item.commentCount)
        return cell
    }
    
}

extension MirkoItemModel: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if (self === object) {
            return true
        }
        if (!(object is MirkoItemModel)) {
            return false
        }
        let compared = object as! MirkoItemModel
        if (self.id == compared.id) {
            return true
        }
        return self.upvoteCount == compared.upvoteCount &&
            self.commentCount == compared.commentCount &&
            self.date == self.date &&
            self.content == self.content
    }
}
