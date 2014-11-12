class App.Views.Issue extends Backbone.View
  tagName: "li"

  className: "issue"

  render: ->
    @$el.html ich.issue @model.attributes
    @
