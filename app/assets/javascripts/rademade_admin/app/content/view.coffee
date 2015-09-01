class @Content extends Backbone.View

  renderItemFromUrl : (url, cb) ->
    $.get url, layout : false, (html) =>
      $contentItem = $(html)
      $('[data-content]').append $contentItem
      $(window).scrollTop(0)
      $(document).trigger 'init-plugins'
      @bindClick $contentItem
      cb($contentItem) if cb

  renderModel : (model) ->
    @renderItemFromUrl model.get('editurl'), ($contentItem) =>
      $contentItem.find('form').on 'ajax-submit-done', (e, response) =>
        model.update response.data
        $contentItem.remove()

  moveToPreviousContentItem : () ->
    @moveToContentItem $('[data-content-item]:nth-last-child(2)')

  moveToContentItem : ($contentItem) ->
    return if $contentItem.is(':last-child')
    $contentItem.nextAll('[data-content-item]').remove()
    if $contentItem.is(':first-child')
      @renderItemFromUrl $contentItem.data('contentItem'), () ->
        $contentItem.remove()

  bindClick : ($el) ->
    $el.find('[data-content-header]').one 'click', (e) =>
      @moveToContentItem $(e.currentTarget).closest('[data-content-item]')
    $el.find('[data-content-url]').one 'click', (e) =>
      @renderItemFromUrl $(e.currentTarget).data('contentUrl')
      false
    $el.find('[data-content-close]').one 'click', () ->
      $(this).closest('[data-content-item]').remove()

  @getInstance : () ->
    instance = null
    do () ->
      instance ||= new Content()

$ ->
  $(document).on 'page:load ready', () ->
    Content.getInstance().bindClick $(document)