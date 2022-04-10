# lucis

## Overview
Lucis is a location based social app. Users can upload photos using their camera or gallery and others can see it both on a live feed and on a map. When uploading a feed, Lucis wraps it with the current location. Live feed is fetched prioritizing proximity. In other words, each user see feed ordered by proximity. Users can favorite or pin the feed entries. Moreover, they can transition into map view from any feed entry. 

https://user-images.githubusercontent.com/47488705/162630692-d8fe3259-305c-4a4c-974d-73cb4c5f1699.mp4


![lucis_android 001](https://user-images.githubusercontent.com/47488705/162635178-59907919-4060-4ed2-8cbd-d99f13647264.png)



## Design
An interpretation of the clean architecture combined with MVVM is used to implement the project. Dependency injection is done using [**get_it**](https://pub.dev/packages/get_it) and state management is done with [**provider**](https://pub.dev/packages/provider). Back-end is powered with Firebase. Specifically, **Firebase Authentication**, **Firestore** and **Firebase Storage** are employed for the back-end. User and feed data are stored as documents in the Firestore. Images are stored in the Storage and are used within the app through their long-lived URLs. Using Firebase for this project had its limitations. Specifically, given that FIrebase does not allow multi-field range queries, location based queries cannot be done directly with (latitide, longitude) windows. Instead, [**geoflutterfire**](https://pub.dev/packages/geoflutterfire) is used for location based queries, which employs geohashes. There is room for improvement for the location based queries. For instance, by using a back-end that allows latitude & longitude query pagination and filtering current user favorites, pins in-place can greatly improve overall query performance, since they are done in the client side now. 

## Installation
Development is done with Flutter 2.10.1 and Dart 2.16.1. Here are the steps for installation of the project into the local device:

* Get an API key from [Google Maps API](https://mapsplatform.google.com/) for Android SDK and/or iOS SDK.
* For **Android** Put your maps API key into app/src/main/AndroidManifest.xml. Check it in the project folder and replace "YOUR_MAPS_API"
* For **iOS** Put your maps API key into ios/Runner/AppDelegate.swift. Check it in the project folder and replace "YOUR_MAPS_API"
* Configure Firebase for iOS and/or Android. A firebase_options.dart should be created automatically after completing configuration.
    
