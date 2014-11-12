class App.Views.Community extends Backbone.View
  initialize: ->
    @issues = new App.Collections.Issues()
    @issuesList = new App.Views.Issues collection: @issues

    @issues.fetch reset: true, dataType: "jsonp"

    @topics = new App.Collections.Topics()
    @topicsList = new App.Views.Topics collection: @topics

    @topics.fetch reset: true, dataType: "jsonp"

    @render()

  render: ->
    @$el.find(".issues").html @issuesList.render().el
    @$el.find(".topics").html @topicsList.render().el
    @