ColdFusion Google API
created by: todd sharp (todd@cfsilence.com) and raymond camden (ray@camdenfamily.com)
version: 1.0
released on: 07/09/2009

Version History:
1.0:	First public release.

About:

This package is a set of ColdFusion Components built to interact with a number of Google APIs. The package contains a base CFC which provides basic authentication and session token retrieval. Other components in the package extend the base CFC to interact with individual Google services such as Docs and Analytics.
The package has some minor syntax issues that are exclusive to CF 8, but could probably easily be made backwards compatible with minor changes.
The base code and all inspiration for this project are taken (with permission from and many thanks to) from the original work done by Raymond Camden. For more information see the following post:
http://www.coldfusionjedi.com/index.cfm/2007/12/8/Google-Docs-CFC

The analytics component wraps some common dimensions into convenience methods for you.  However, there are tons of different possible combinations of dimensions and metrics that you can pass to the Analytics API to get at your data.  Have a look at the Analytics API if you feel need more data then I'm exposing with the convenience functions.  The Google documentation is pretty decent, this page in particular should help you out with possible dimensions and metrics: http://code.google.com/apis/analytics/docs/gdata/gdataReferenceDimensionsMetrics.html.  If you want to roll your own query you can call the getAnalyticsData() method and pass it dimensions, metrics, filters, sorts, date ranges, etc. Most methods will return a struct - one key for the query, another for some metadata from the Google data feed.  Play around with different combinations and see what you can get.


Installation:

Drop the CFC's in your project and have at em.

Upgrading:

N/A

Usage:

See the docs folder for CFC documentation.  Also see test files in the project for sample usage.

If you should find this component useful please consider visiting my wishlist (http://www.amazon.com/gp/registry/wishlist/2PTWNTIRNTIKS/)
Give Ray some wishlist love too - since he is the man behind the original code (http://www.amazon.com/o/registry/2TCL1D08EZEYE)

Credits:

Thanks to Ray - a great friend and mentor.

License:

ColdFusion Google API:
Copyright 2009 Todd Sharp
  
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.