# Project 2 - Yelp!

Yelp! is a Yelp search app using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 9 hours spent in total

## User Stories

The following **required** functionality is completed:

- [Y] Search results page
   - [Y] Table rows should be dynamic height according to the content height.
   - [Y] Custom cells should have the proper Auto Layout constraints.
   - [Y] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
- [Y] Filter page. Unfortunately, not all the filters are supported in the Yelp API.
   - [Y] The filters you should actually have are: category, sort (best match, distance, highest rated), distance, deals (on/off).
   - [Y] The filters table should be organized into sections as in the mock.
   - [Y] You can use the default UISwitch for on/off states.
   - [Y] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   - [Y] Display some of the available Yelp categories (choose any 3-4 that you want).

The following **optional** features are implemented:

- [N] Search results page
   - [N] Infinite scroll for restaurant results.
   - [N] Implement map view of restaurant results.
- [N] Filter page
   - [N] Implement a custom switch instead of the default UISwitch.
   - [N] Distance filter should expand as in the real Yelp app
   - [N] Categories should show a subset of the full list with a "See All" row to expand. Category list is [here](http://www.yelp.com/developers/documentation/category_list).
- [N] Implement the restaurant detail page.

The following **additional** features are implemented:


## Video Walkthrough

Here's a walkthrough of implemented user stories:

@dropbox - gif @ https://www.dropbox.com/s/ut7divoko26cxih/HW2.gif?dl=0

@dropbox - quicktimes video @ https://www.dropbox.com/s/7x42gh93f1p6jbx/HW2.mov?dl=0

@imgur - gif @ http://imgur.com/MUgTWLc


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2015] [Jiheng Lu]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
