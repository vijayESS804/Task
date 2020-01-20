//
//  SampleViewController.swift
//  Venkat Reddy
//
//  Created by ojas on 18/12/19.
//  Copyright © 2019 ojas. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController {

    @IBOutlet weak var tableView : UITableView!
    var tableListingArray = NSMutableArray()
    var dataInfoArray = NSMutableArray()
    var sampleServiceConnector = ServiceConnector()
    
    var refreshControl = UIRefreshControl()

    var isDataLoading:Bool=false
    var pageNo:Int=1
    var didEndReached:Bool=false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sample App"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController

        
        
        sampleServiceConnector.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getDataFromServer()
    }
}

extension SampleViewController : UITableViewDelegate , UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableListingArray.count > 0 ? tableListingArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SampleTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SampleTableCell
        cell?.selectionStyle = . none
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if let dict = tableListingArray[indexPath.row] as? NSDictionary
        {
            cell?.setDataToSampleTableCell(data: dict, delegate: self, indexpath: indexPath)
        }

        return cell!
    }
}

extension SampleViewController
{
    
    func getDataFromServer()
    {
        sampleServiceConnector.initiateServiceCall(delegate: self, httpMethod: GET_METHOD, pageNo: String(pageNo))
    }
    
    func showActivityIndicatorAtFooter()
    {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func hideActivityIndicator()
    {
        DispatchQueue.main.async {
            self.tableView.tableFooterView?.isHidden = true
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshData(_ sender:Any) {
        
        if dataInfoArray.count > 0
        {
            dataInfoArray.removeAllObjects()
        }
        
        if tableListingArray.count > 0
        {
            tableListingArray.removeAllObjects()
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        pageNo = 1
        self.getDataFromServer()
    }
}

extension SampleViewController : UIScrollViewDelegate
{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

            if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    self.pageNo=self.pageNo+1
                    
                    self.showActivityIndicatorAtFooter()
                    self.getDataFromServer()
                }
            }
    }
}

extension SampleViewController : ServiceConnectorDelegate
{
    func didReceiveResponse(data: AnyObject) {
        
        self.hideActivityIndicator()

        if data is NSDictionary , let responseDict = data as? NSDictionary
        {
            if responseDict.object(forKey: "hits") is NSArray , let array = responseDict.object(forKey: "hits") as? NSArray , array.count > 0
            {
                dataInfoArray.addObjects(from: array as! [Any])
                if(dataInfoArray.count > 0)
                {
                    self.tableListingArray = NSMutableArray(array: dataInfoArray as! [Any], copyItems: true)
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func didFailResponse() {
        
        
    }
    
    
}
