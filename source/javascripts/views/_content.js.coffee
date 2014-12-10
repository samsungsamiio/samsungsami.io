class App.Views.Content extends Backbone.View
  initialize: (opt)->
    @render()

  groupImages: ()->
    @$el.children('.main-content-interior').children('p').each (i, el)->
      images = $(el).find('img')
      if images.length > 1
        $(el).addClass('img-gallery')

  createTableOfContents: ()->
    headers =  @$el.children('.main-content-interior').children('h2, h3')
    showNavItems = headers.not('h3').length > 2 and @$el.attr('data-no-toc') is undefined

    if @$el.siblings('.section-nav').length > 0
      $toc = new App.Views.TableOfContents
        items: if showNavItems then headers else []
        parent: @$el

    if showNavItems
      $('#toc').on 'activate.bs.scrollspy', (e)->
        headers.filter('.active').removeClass('active')
        target = $(e.target).find('a').attr('href')
        $(target).addClass('active')

  parseTables: ->
    tables = @$el.children('.main-content-interior').children('table')
    tables.wrap('<div class="table-wrapper"></div>')
    tables.find('td').each (i, el)->
      $(el).html $.parseHTML( el.innerHTML
        .replace(/&lt;/g, '<')
        .replace(/&gt;/g, '>'))

  render: ()->
    @groupImages()
    @createTableOfContents()
    @parseTables()
    return @

