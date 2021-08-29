<h1>TRI Nearby:  API</h1>
This repo is for the frontend component of my final project for Geospatial Web and Mobile Programming.  This iOS app presents the user with map pins identifying TRI Sites in their direct vicinity.  It allows users to adjust the search radius beyond the inital 5 miles, as well as filter sites by industry sector, release type, and site carcinogen status.  Finally, users can submit activity reports for individual sites as a way to crowdsource potential data corrections.

<h2>Link to project demo</h2>

[View a 5 minute overview walkthrough here](https://youtu.be/jYbpUzD-KjI)

<h2>Tech Stack</h2>

* Swift 5
* UIKit
* MapKit
* Made with Storyboard layout

<h2>Project Features</h2>

* iOS app built on MapKit provides an elegant basemap and intuitive interface
* Top-level map view presents Filter button which presents selectable filter modal
* User can filter sites by radius (1-25 miles) as well as site industry sector, release type, and carcinogen status
* Filter selections are translated into HTTP query strings which are sent to the live backend API
* Changing search radius automatically adjusts view frame accordingly
* TRI sites and their address are identified by pins
* Map pins are color-coded and symbolized according to release type
* Tapping map pin expands site characteristics through callout presentation
* Callout for each site allows user to submit site report based on activity characteristics using preconfigured attribute selections
* User report selections are translated into HTTP query strings, which the API uses to generate report table entries
* Joined inheritance structure utilized in database allows for minimalistic implementation
