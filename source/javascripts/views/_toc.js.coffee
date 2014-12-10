class App.Views.TableOfContents extends Backbone.View
  className: 'table-of-contents'
  id: 'toc'

  events:
    'click li.level-1': "setLevel1"
    'click li.level-2': "setLevel2"

  setLevel1: (e)->
    @$el.find('.level-1.active').removeClass('active')
    $(e.currentTarget).addClass('active')

  setLevel2: (e)->
    @$el.find('.level-2.active').removeClass('active')
    $(e.currentTarget).addClass('active')

  initialize: (opt)->
    @parent = opt?.parent
    @items = _.map opt?.items, (item)->
      currentLevel = "level-#{parseFloat(item.tagName.replace(/^h/i, ''), 10) - 1}"
      return {
        href: item.id
        text: $(item).text()
        className: currentLevel
      }
    @position = -1
    @render()
    @

  wrapContents: ->
    $(".level-2").each ->
      return if $(@parentNode).hasClass("interior-menu")
      $(this).nextUntil(":not(.level-2)").andSelf().wrapAll "<ul class=\"interior-menu dropdown-menu\">"
    $(".interior-menu").each ()->
      $(this).prev().addClass 'dropdown'
      $(this).insertAfter($(this).prev().find('a'))
    $(".level-1").eq(0).addClass('active')

  render: ->
    @$el.html ich.toc items: @items
    @parent.prepend(@$el)
    @wrapContents()
    @
