## Summary
Karros's Coding Challenge
Interviewee: Hoang Lu
Email: tyler.lu1401@gmail.com

## Prerequisites
* XCode 11.3.
* Cocoapods 1.9.1. Run `sudo gem install cocoapods`.
* iOS Deployment target: 13.2

## Usage
1. Open Terminal, navigate to project foler, run command `pod install`
2. Open project in XCode. Make sure you open file karros-video.xcworkspace, not karros-video.xcodeproj
3. Run the project on simulator

## Dependencies
* All dependencies are installed via cocoapods for easy update
  * 'RxSwift'
  * 'RxCocoa'
  * 'RxDataSources' 
  * 'ObjectMapper'
  * 'Alamofire'
  * 'AlamofireImage'
  * 'SnapKit'
  * 'Action' 

Features
=======

## Design Pattern

```swift
// swift-tools-version:5.0

class BaseCollectionViewController<VM: GenericListViewModel>
class BaseViewController<VM: GenericViewModel>
class BaseTableViewController<VM: GenericListViewModel>
```


**Core features:**
 - 8 different chart types
 - Scaling on both axes (with touch-gesture, axes separately or pinch-zoom)
 - Dragging / Panning (with touch-gesture)
 - Combined-Charts (line-, bar-, scatter-, candle-stick-, bubble-)
 - Dual (separate) Axes
 - Customizable Axes (both x- and y-axis)
 - Highlighting values (with customizable popup-views)
 - Save chart to camera-roll / export to PNG/JPEG
 - Predefined color templates
 - Legends (generated automatically, customizable)
 - Animations (build up animations, on both x- and y-axis)
 - Limit lines (providing additional information, maximums, ...)
 - Fully customizable (paints, typefaces, legends, colors, background, gestures, dashed lines, ...)
 - Plotting data directly from [**Realm.io**](https://realm.io) mobile database ([here](https://github.com/danielgindi/ChartsRealm))

**Chart types:**

*Screenshots are currently taken from the original repository, as they render exactly the same :-)*


 - **LineChart (with legend, simple design)**
![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/simpledesign_linechart4.png)
 - **LineChart (with legend, simple design)**
![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/simpledesign_linechart3.png)

 - **LineChart (cubic lines)**
![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/cubiclinechart.png)

 - **LineChart (gradient fill)**
![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/line_chart_gradient.png)

 - **Combined-Chart (bar- and linechart in this case)**
![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/combined_chart.png)

 - **BarChart (with legend, simple design)**

![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/simpledesign_barchart3.png)

 - **BarChart (grouped DataSets)**

![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/groupedbarchart.png)

 - **Horizontal-BarChart**

![alt tag](https://raw.github.com/PhilJay/MPChart/master/screenshots/horizontal_barchart.png)


 - **PieChart (with selection, ...)**

![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/simpledesign_piechart1.png)

 - **ScatterChart** (with squares, triangles, circles, ... and more)

![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/scatterchart.png)

 - **CandleStickChart** (for financial data)

![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/candlestickchart.png)

 - **BubbleChart** (area covered by bubbles indicates the value)

![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/bubblechart.png)

 - **RadarChart** (spider web chart)

![alt tag](https://raw.github.com/PhilJay/MPAndroidChart/master/screenshots/radarchart.png)


Documentation
=======
Currently there's no need for documentation for the iOS/tvOS/macOS version, as the API is **95% the same** as on Android.  
You can read the official [MPAndroidChart](https://github.com/PhilJay/MPAndroidChart) documentation here: [**Wiki**](https://github.com/PhilJay/MPAndroidChart/wiki)

Or you can see the Charts Demo project in both Objective-C and Swift ([**ChartsDemo-iOS**](https://github.com/danielgindi/Charts/tree/master/ChartsDemo-iOS), as well as macOS [**ChartsDemo-macOS**](https://github.com/danielgindi/Charts/tree/master/ChartsDemo-macOS)) and learn the how-tos from it.


Special Thanks
=======

Goes to [@liuxuan30](https://github.com/liuxuan30), [@petester42](https://github.com/petester42) and  [@AlBirdie](https://github.com/AlBirdie) for new features, bugfixes, and lots and lots of involvement in our open-sourced community! You guys are a huge help to all of those coming here with questions and issues, and I couldn't respond to all of those without you.

### Our amazing sponsors

[Debricked](https://debricked.com/): Use open source securely

[![debricked](https://user-images.githubusercontent.com/4375169/73585544-25bfa800-44dd-11ea-9661-82519a125302.jpg)](https://debricked.com/)


License
=======
Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
