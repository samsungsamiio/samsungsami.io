class App.Views.Topic extends Backbone.View
  tagName: "li"

  className: "topic"

  render: ->
    @$el.html ich.topic @model.attributes
    @
