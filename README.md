# CityWiseAQI
This app is using web-socket for realtime updation of aqi for dedicated inidan cities.  

![Screenshots](https://github.com/vipulRajput/CityWiseAQI/issues/1)


We're following MVVM architecture in this app.
This app has two modules:- 
1. Listing of All Cities
2. AQI Chart for selcted City


**1. Listing of All Cities**

*ViewModel:-* 
1. Here App is establishing connection with WebSocket server. For that, app is using one library(Starscream).
2. Once App is connected to the server, App start getting realtime data and keep parsing the data into a desired model called AirQualityInfo.
3. I have created two more models called City & AQI.  
4. I have created array of unique Cities(if any city already exists then keep updating the past history of aqi), 
5. While updating the past history of aqi in a city, we add first two values of aqi directly and then we only add aqi values after 30 seconds(because in chart we're showing aqi on 30 seconds interval). 
6. City updation task we're doing on an internalQueue with .barrier flag, to get better ui performance. 
7. ViewModel builds tableview models. Once done ViewModel updates to ViewController to update the UI.
8. We also check if ViewModel has any selected city delegate, if yes then ViewModel also pass the updated aqi to the ViewModel of CityAqiDetails.
9. If WebSocket occurs any error then ViewModel also updates to the ViewController for retry connection. 

*ViewController:-* 
1. ViewController is listening events from ViewModel and updating the ui.
2. For better outcome, app is disconnecting from web-socket when enters on background and reconnecting to the web-socket when enters on foreground.
3. If WebSocket occurs any error then showing a alert to user for retry connection. 

*Model:-*
1. AirQualityInfo:- it represents data coming from web-socket server.
2. City:- This is for tableview cell, it has all required info for table cell, to make table cell light weight.
3. AQI:- This is for chart, on the basis of last record time of AQI model, we're checking the differnece, if it is equal to or greater than 30 seconds then only we update the chart with next AQI.  

*******************************


**2. AQI Chart for selcted City**

*ViewModel:-* 
1. This ViewModel is confirming to the delegate of city-listing-ViewModel to get the real time udpated aqi.
2. We're adding first two aqi objects into records to shat chart doesn't look odd, after that we're checking the differnece of updated aqi & last recorded aqi, if it is equal to or greater than 30 seconds then only we recoed the updated one and update the chart.  
3. We're maintaining records of 25 aqi, if aqi records reaches to 25, we're removing the first added aqi from records. 
4. On the basis of aqiRecords, we're making LineChartDataSet for Charts. Once done we pass to the ViewController to update the chart.

*ViewController:-* 
1. For chart, We're using one library called Charts.
2. We're using line chart here.
3. once ViewController recives the updated LineChartDataSet, chart has been udpated. 



We also have one enum called AQILevel, which has all the required methods like:-  
1. getAqiLevel():- to get to know the level of AQI.
2. getDesc():- for displaying the AQILevel.
3. getColor():- to get the dedicated color of an AQILevel.
4. getFace():- in our UI we're shpwing few emoji, to explain the AQILevel in a better way, so this function is for this purpose.


*********************

Time Invested:-
1. Socket: 4 hours
2. Cities listing: 2 hours
3. Charts:- 3 hours 
4. Project setup & Handling of use cases:- 1 hour

Overall around 10 hours have been invested on it.

