
Reporter = require "../index"
request = require "request"
sinon = require "sinon"
url = require "url"

describe "Reporter", ->
  urlObject = url.parse "http://www.test.com"
  reporter = new Reporter urlObject
  delete urlObject.path

  beforeEach ->
    sinon.stub request, "post"
  afterEach ->
    request.post.restore()


  describe "_getUrlObject()", ->
    it "should return a clone", ->
      thisObj = reporter._getUrlObject()
      thisObj2 = reporter._getUrlObject()
      thisObj.should.eql urlObject
      thisObj.should.not.equal urlObject
      thisObj.should.not.equal thisObj2


  describe ".submit()", ->

    it 'should use the request object', ->
      reporter.submit "log", "SOMECONTENT"

      thisObj = reporter._getUrlObject()
      thisObj.pathname = "/report"
      thisObj.query = type: "log"

      requestObj = {
        url: thisObj
        body: "SOMECONTENT"
        headers: { }
      }

      request.post.callCount.should.equal 1
      request.post.args[0][0].should.eql requestObj

  describe ".error()", ->

    it 'should use the request object', ->
      reporter.error new Error("some message"), test: "info"

      thisObj = reporter._getUrlObject()
      thisObj.pathname = "/report-error"

      requestObj = {
        url: thisObj
        body: JSON.stringify { error: "some message", info: { test: "info" } }
        headers: { "Content-Type": "application/json; charset=utf-8" }
      }

      request.post.callCount.should.equal 1
      request.post.args[0][0].should.eql requestObj
