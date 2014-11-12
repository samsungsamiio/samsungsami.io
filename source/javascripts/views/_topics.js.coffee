class App.Views.Topics extends Backbone.View
  tagName: "ul"

  initialize: (opts) ->
    @listenTo @collection, "reset", @addAll

  render: ->
    @

  addAll: ->
    @$el.empty()
    @collection.each (topic,index) =>
      if index > 2 then return false
      topicItem = new App.Views.Topic model: topic
      @$el.append topicItem.render().el
