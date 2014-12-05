class App.Views.ModalLink extends Backbone.View
  events:
    'click': 'handleClick'

  handleClick: (e)->
    e.preventDefault()
    href = @$el.attr('href')
    $.ajax
      url: href
      dataType: 'html'
      success: @openModal

  openModal: (data)->
    content = $(data).find('.content .main').prop('innerHTML')
    @modalView.remove() if @modalView
    @modalView = new App.Views.Modal
      content: content

  closeModal: ()->
    @modalView.remove() if @modalView
