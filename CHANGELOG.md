# CHANGELOG

## v0.11 (2017-03-14)

- Updated dependencies:
  - `json ~> 2.0` (was `>= 1.7.7`)
  - `rest-client` updated to `= 2.0.1` to (was `= 1.6.9`)

- Fixed a warning about the Content-Type being overridden to
  `application/x-www-form-urlencoded` when creating a creative.

## v0.9 (2016-12-08)

Up until now, the `create_report` function was using a deprecated Adzerk API
endpoint, /v1/report.

This release has a better implementation of `create_report` that uses the
/v1/report/queue asynchronous reporting API instead, polling with exponential
backoff and returning the report once it is retrieved.

The usage of `create_report` is effectively the same -- you should not need to
update any of your code, unless you want/need to add a timeout.

One key difference with this new implementation is that by default, there is no
timeout, and it will block indefinitely until the report comes back.

You may wish to add a timeout (in ms) as the second argument to `create_report`.
An error will be raised if the report does not come back within the timeout.

## v0.8 (2016-08-25)

`rest-client` dependency upgraded/pinned to 1.6.9.

## v0.7 (2016-03-22)

The Adzerk API Ruby gem now uses https by default.

## v0.6 (2015-06-22)

Updated tests to reflect the current state of the API.

## v0.5 (2015-03-06)

Updated tests to reflect the current state of the API.

Added SelectionAlgorithm to Priorities (defaults to 0).

## v0.4 (2014-11-19)

Reporting API methods updated to reflect how the reporting API works.

`create_report` creates a report which is only available at the time of the API
call, and could potentially timeout when asking for a huge amount of data.
Removed the `retrieve_reports` method, which was unsuccessfully attempting to
retrieve these (non-queued) reports.

`create_queued_report` creates a queued report, which will take at least a
couple seconds for the results to be available. This API call immediately
returns a JSON object with a single property `Id`, which represents the GUID of
the queued report. This `Id` will be available for 30 days.

`retrieve_queued_report` will poll for the result of a queued report, given the
`Id` of the queued report. If the report is not ready yet, the resulting JSON
object's `Status` property will be 1 ("in progress"). If the report is ready,
`Status` will be 2 ("complete") and `Result` will contain the requested report.

