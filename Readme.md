# Service reporter

The service reporter is an abstract library that can be used to report data to
a `service-report-manager`.

Typically you will embed this library in a specific reporter
(eg.: `service-log-reporter`) and use it to submit the data.