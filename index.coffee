# Copyright(c) 2012 Matias Meno <m@tias.me>


request = require "request"
url = require "url"


class Reporter

  # originalUrlObject should be an object like url.parse
  constructor: (@originalUrlObject) ->


  # Clones the url object
  _getUrlObject: ->

    urlObject = { }
    urlObject[param] = value for param, value of @originalUrlObject
    delete urlObject.path
    urlObject    


  submit: (type, body) ->
    urlObject = @_getUrlObject()

    urlObject.pathname += "report"
    urlObject.query = { type: type }

    @_submitRequest urlObject, body


  error: (err, info) ->
    urlObject = @_getUrlObject()

    urlObject.pathname += "report-error"

    body =
      error: err.message
      info: info

    @_submitRequest urlObject, JSON.stringify(body), { "Content-Type": "application/json; charset=utf-8" }


  _submitRequest: (urlObject, body, headers = { }) -> 
    request.post {
      url: urlObject
      body: body
      headers: headers
    }, (err) ->
      console.error err if err?



module.exports = Reporter