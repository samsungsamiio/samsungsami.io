class App.Views.Issues extends Backbone.View
  tagName: "ul"

  initialize: (opts) ->
    @listenTo @collection, "reset", @addAll

  render: ->
    @

  addAll: ->
    @$el.empty()
    @collection.each (issue,index) =>
      if index > 2 then return false
      issueItem = new App.Views.Issue model: issue
      @$el.append issueItem.render().el
