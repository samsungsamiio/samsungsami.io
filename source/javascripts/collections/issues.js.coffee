class App.Collections.Issues extends Backbone.Collection
  model: App.Models.Issue

  url: "https://api.github.com/repos/samsung/cynara/issues?per_page=10"

  parse: (response) ->
    response.data