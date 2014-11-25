
$ ->
  App.router = new App.Router
  App.listenTo App.router, 'route', ->
    # _gaq.push(['_trackPageview',location.pathname + location.search  + location.hash])

  Backbone.history.start
    pushState: App.environment is 'production'

  $header = $('.main-header')
  $document = $(document)
  $window = $(window)
  $body = $('body')
  headerHeight = $header.outerHeight()
  minHeight = $window.height() - headerHeight
  navHeight = $('.section-nav').outerHeight()

  fixNav = ()->
    headerScrolledOut = $document.scrollTop() > headerHeight
    $body.toggleClass('fixed', headerScrolledOut)

  setMinHeight = ()->
    windowHeight = $window.height()
    headerHeight = $header.outerHeight()
    minHeight = windowHeight+1

    $('.main.content, #swiftype-results').css minHeight: minHeight  - headerHeight
    $('.section-nav').css minHeight: windowHeight - headerHeight, maxHeight: windowHeight - headerHeight

  lastPosition = -1

  scrollLoop = ()->
    if (lastPosition == window.pageYOffset)
      raf scrollLoop
      return false
    else lastPosition = window.pageYOffset

    headerScrolledOut = lastPosition > headerHeight
    $body.toggleClass('fixed', headerScrolledOut)

    raf scrollLoop

  setMinHeight()
  scrollLoop()

  # instantiate any element with a 'view'
  $('[data-view]').each (i, el)->
    new App.Views[$(el).attr('data-view')]
      el: el

  $(window).on 'resize', _.debounce setMinHeight, 200

  $('.toggle-menu').on 'click', (e)-> e.preventDefault(); $(this).parent('.content').toggleClass('sidebar-open')
  $('.main-header .toggle-nav').on 'click', (e)->
    e.preventDefault()
    setMinHeight()
    $activeItem = $('.main-header .nav-item.active')
    $nav = $('.main-nav')
    $body.toggleClass('menu-expanded')
    return unless $body.hasClass('menu-expanded')
    scrollOffset = Math.floor($activeItem.offset().left + $activeItem.outerWidth()/2 - $body.width()/2 + $nav.scrollLeft())
    $nav.scrollLeft scrollOffset


  UserVoice.push [ "set", {
      accent_color: "#448dd6"
      trigger_color: "white"
      trigger_background_color: "rgba(46, 49, 51, 0.6)"
    }]

  # set up autocomplete
  $(".search").swiftype
    engineKey: "RS9uPoVtgWEu9wCYvQoC"

  # set up search
  $(".search").swiftypeSearch
    engineKey: "RS9uPoVtgWEu9wCYvQoC",
    resultContainingElement: "#swiftype-results"
    renderFunction: (documentType, item)->
      body = if item['highlight'].body then "<blockquote>#{item['highlight'].body}</blockquote>" else ""
      "<div class='swiftype-result'><h3 class='title'>
        <a href='#{item['url']}'>#{item['highlight'].title || item['title']}</a>
        </h3>
        #{body}</div>"
  queryParams = {}
  _.map window.location.hash.replace(/#/,'').split('&'), (arg)-> 
    param = arg.split('=')
    queryParams[param[0]] = unescape(param[1])

  $('#swiftype-search').val(queryParams['stq'])

  # Set up highlighting
  $('.table_highlight').each ()->
    classes = $(this).attr('class')
    $(this).parent().addClass classes

  # Lightbox behavior
  $.featherlight.defaults.closeOnClick = 'anywhere'
  $('table img, img.lightbox').each ()->
    $(this).on 'click', ()->
      $.featherlight($(this), {type: 'image'});

  $('#mailing-list').each ()->
    $(this).on 'click', (e)->
      e.preventDefault()
      $.featherlight($("#mailing-list-container"), {type: 'image', variant: 'mailing-list', closeOnClick: 'background'});

  UserVoice.push(['addTrigger', '#feedback', { mode: 'contact' }])