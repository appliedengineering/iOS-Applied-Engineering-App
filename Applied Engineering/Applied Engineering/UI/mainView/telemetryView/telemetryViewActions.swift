//
//  telemetryViewActions.swift
//  Applied Engineering
//
//  Created by Richard Wei on 11/28/21.
//

import Foundation
import UIKit
import Charts

extension telemetryViewController{
    @objc internal func handleRefresh(_ refreshControl: UIRefreshControl){
        self.refreshControl.endRefreshing();
        self.renderData();
    }
    
    @objc internal func updateData(_ notification: NSNotification){
        //print("update data")
        guard let notificationDict = notification.object as? [String : Any] else{
            log.add("Invalid dictionary in notification");
            return;
        }
        
        guard let keyArray = notificationDict[notificationDictionaryUpdateKeys] as? [String] else{
            log.add("Invalid keyArray in updateData");
            return;
        }
        
        //print(keyArray);
        
        var shouldRerender : Bool = false;
        
        for key in keyArray{
            if (self.isDisplayingData[key] == nil){
                shouldRerender = true;
                
                self.isDisplayingData[key] = true;
                
                DispatchQueue.main.sync {
                    if (dataMgr.isGraphableData(key)){
                        self.createGraph(key);
                    }
                    else{
                        //
                    }
                }
                
            }
        }
        
        for key in self.isDisplayingData.keys{
            if (!keyArray.contains(key)){
                shouldRerender = true;
                
                if (dataMgr.isGraphableData(key)){
                    DispatchQueue.main.sync {
                        self.graphForData[key]?.removeFromSuperview();
                        self.graphForData[key] = nil;
                    }
                }
            }
        }
        
        //
        
        for key in keyArray{
            if (dataMgr.isGraphableData(key)){
                self.updateGraphData(key);
            }
        }
        
        //
        
        DispatchQueue.main.sync {
            if (shouldRerender){
                self.handleRefresh(self.refreshControl);
            }
        }
        
    }
    
    private func createGraph(_ graphKey: String){
        let graphButton = GraphUIButton(frame: .zero, key: graphKey);
        graphForData[graphKey] = graphButton;
        graphButton.tag = 1;
    }
    
    private func updateGraphData(_ graphKey: String){
        
        guard let graphButton = graphForData[graphKey] else{
            log.add("Missing graph for \(graphKey)");
            return;
        }
        
        guard let graphData = graphButton.chartView.data as? LineChartData else{
            log.add("Missing Graph Data for graph \(graphKey)");
            return;
        }
        
        guard let dataSet = graphData.dataSets[0] as? LineChartDataSet else{
            log.add("Missing dataSet for graph \(graphKey)");
            return;
        }
        
        //
        /*if (graphKey == "throttlePercent"){
            print("Updating \(graphKey) = \(dataMgr.getGraphDataFor(graphKey))");
        }*/
        
        dataSet.replaceEntries(dataMgr.getGraphDataFor(graphKey)); // can be optimized
        
        //
        
        graphData.notifyDataChanged();
        
        DispatchQueue.main.sync {
            //print("graph button frame for \(graphKey) = \(graphButton.frame)")
            graphButton.chartView.notifyDataSetChanged();
        }
    }
    
    //
    
    @objc internal func openGraph(_ button: GraphUIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: layoutContentGraphPage), object: nil, userInfo: ["graphKey":button.graphKey]);
    }
    
    internal func updateDataButton(){
        dataButton.setImage((dataMgr.isReceivingData() ? dataButtonOnImage : dataButtonOffImage), for: .normal);
    }
    
    @objc internal func updateDataButtonStatus(_ notification: NSNotification){
        
        guard let dict = notification.userInfo as NSDictionary? else{
            return;
        }
        
        guard let isConnected = dict["isConnected"] as? Bool else{
            return;
        }
        
        dataButton.tintColor = isConnected ? dataButtonOnColor : dataButtonOffColor;
        
    }
    
    @objc internal func toggleDataButton(_ button: UIButton){
        dataMgr.setShouldReceiveData(!dataMgr.isReceivingData());
        updateDataButton();
    }
}
