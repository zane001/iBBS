//
//  ViewController.swift
//  TreeTableVIewWithSwift
//
//  Created by Robert Zhang on 15/10/24.
//  Copyright © 2015年 robertzhang. All rights reserved.
//

import UIKit

class NewSectionController: UIViewController, UISearchBarDelegate {

    //获取资源
    let plistpath = NSBundle.mainBundle().pathForResource("Board", ofType: "plist")!
    var filtered: [String] = []
    var searchActive = false
    var tableView: TreeTableView!
//    var newTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = NSMutableArray(contentsOfFile: plistpath)
        // 初始化TreeNode数组
        let nodes = TreeNodeHelper.sharedInstance.getSortedNodes(data!, defaultExpandLevel: 0)
        
        // 初始化搜索框
        let searchBar = UISearchBar(frame: CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 40))
        searchBar.delegate = self
        searchBar.placeholder = "请输入版块的中文描述"
        searchBar.barStyle = UIBarStyle.Default
        searchBar.searchBarStyle = UISearchBarStyle.Default
        searchBar.tintColor = UIColor.redColor()
        searchBar.translucent = true
        searchBar.showsSearchResultsButton = false
        searchBar.showsScopeBar = false
        searchBar.delegate = self
        
        // 初始化自定义的tableView
        tableView = TreeTableView(frame: CGRectMake(0, 100, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-160), withData: nodes)
        tableView.treeTableViewCellDelegate = self
        
//        newTableView = UITableView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height-100))
//        newTableView.delegate = self
//        newTableView.dataSource = self
        
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        tableView.hidden = true
        
        let data = NSMutableArray(contentsOfFile: plistpath)!
        var chineseData: [String] = [String]()

        for item in data {

            chineseData.append(item["description"] as! String)
        }
        
        filtered = chineseData.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if (filtered.count == 0) {
            searchActive = false
//            self.notice("没找到该版面哦", type: NoticeType.info, autoClear: true)
        } else {
            searchActive = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let board = storyboard.instantiateViewControllerWithIdentifier("board") as! BoardController
            for (var i=0; i<data.count; ++i) {
                let result = data[i]["description"] as! String
                if (result.containsString(filtered.first!)) {
                    let board_name = data[i]["name"] as! String

                    if (board_name != "子分区" && board_name != "0" && board_name != "1" && board_name != "2" && board_name != "3" && board_name != "4" && board_name != "5" && board_name != "6" && board_name != "7" && board_name != "8" && board_name != "9") {
                        
                        board.board_name = board_name
                    } else {
                        board.board_name = "BBShelp"
                    }
                }
            }

            self.navigationController!.pushViewController(board, animated: true)
        }
        
        
//        self.view.addSubview(newTableView)

    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filtered.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("nodecell")! as UITableViewCell
//        if(searchActive) {
//            cell.textLabel?.text = filtered[indexPath.row]
//        } else {
//
//        }
//        return cell
//    }
}

extension NewSectionController: TreeTableViewCellDelegate {
    func cellClick(treeNode: TreeNode) {
        
//        let vc = NewSectionController()
//        let navi = UINavigationController(rootViewController: vc)
//        treeTableView.delegate = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let board = storyboard.instantiateViewControllerWithIdentifier("board") as! BoardController
        board.board_name = treeNode.name!

        self.navigationController!.pushViewController(board, animated: true)

    }
}