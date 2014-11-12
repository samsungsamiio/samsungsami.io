class App.Collections.Topics extends Backbone.Collection
  model: App.Models.Topic

  url: "https://api.stackexchange.com/2.2/questions?order=desc&sort=creation&tagged=samsung-galaxy-gear&site=stackoverflow&pagesize=10"

  parse: (response) ->
    response.items