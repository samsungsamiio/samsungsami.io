#= require 'lib/jquery-1.9.1'
#= require 'lib/jquery.ba-hashchange.min'
#= require 'lib/jquery.swiftype.autocomplete'
#= require 'lib/jquery.swiftype.search'
#= require 'lib/lodash-1.2.1'
#= require 'lib/backbone-1.0.0'
#= require 'lib/icanhaz-0.10'
#= require 'lib/raf'
#= require 'lib/ƒ'
#= require 'lib/featherlight.min.js'
#= require 'lib/bootstrap.js'
#= require_tree './config'
#= require_self
#= require 'router'
#= require 'app'
#= require_tree './models'
#= require_tree './collections'
#= require_tree './views'
#


window.App ||=
  Views: {}
  Models: {}
  Collections: {}
  Helpers: {}
  views: {}
  collections: {}
  models: {}
  environment: config.environment
  console:
    log: ->
    error: ->
    warn: ->

#prevent console logs from throwing an exception
window.console = App.console if App.environment is 'production'

_.extend App, Backbone.Events
