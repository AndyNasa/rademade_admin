class @GalleryPopup extends Backbone.View

  events :
    'click [data-gallery-prev]' : 'previousPhoto'
    'click [data-gallery-next]' : 'nextPhoto'
    'click [data-gallery-remove]' : 'removePhoto'
    'click [data-gallery-crop]' : 'cropPhoto'
    'click [data-popup-close]' : 'close'

  showForGallery : (model) ->
    @_setCurrentPhoto model
    @currentGallery = model.collection
    @hasPhotos = @currentGallery.length > 1
    @hasCrop = model.get('crop') isnt undefined
    @render()

  showForPreview : (model) ->
    @_setCurrentPhoto model
    @hasPhotos = false
    @hasCrop = model.get('crop') and model.get('uploadParams')
    @render()

  render : () ->
    @$popup = $ '<div class="popup-wrapper"></div>'
    @$popup.html @_getHTML()
    @_initCrop()
    $('html').addClass('opened-popup')
    @$el.append @$popup
    @_initImageCentering()

  previousPhoto : () ->
    photoIndex = @currentGallery.indexOf @currentPhoto
    if photoIndex <= 0
      photoIndex = @currentGallery.length - 1
    else
      photoIndex--
    @_changePhoto photoIndex

  nextPhoto : () ->
    photoIndex = @currentGallery.indexOf @currentPhoto
    if photoIndex >= @currentGallery.length - 1
      photoIndex = 0
    else
      photoIndex++
    @_changePhoto photoIndex

  removePhoto : () ->
    if confirm I18n.t('rademade_admin.remove_confirm.image')
      @currentPhoto.on 'image-removed', @_onImageRemove
      @currentPhoto.remove()

  cropPhoto : () ->
    cropAttributes = @cropper.getCropAttributes()
    @currentPhoto.crop(cropAttributes) if cropAttributes isnt undefined

  _initImageCentering : () ->
    @$galleryPopup = @$popup.find('.popup-gallery')
    @$galleryPopup.find('.popup-gallery-img').on 'load', @_centerImage
    @$window ||= $(window)
    @$window.on 'resize', @_centerImage

  _centerImage : () =>
    heightWithouImage = @$window.height() - @$galleryPopup.find('.popup-gallery-img').outerHeight()
    @$galleryPopup.find('.popup-gallery-item').css 'margin-top', heightWithouImage / 2 - @$galleryPopup.position().top

  close : (e) ->
    e.preventDefault()
    @closePopup()

  closePopup : () ->
    @$popup.remove()
    $('html').removeClass('opened-popup')
    @_unbindEvents()
    @undelegateEvents()

  _onImageRemove : () =>
    if @hasPhotos
      @hasPhotos = @currentGallery.length > 1
      @nextPhoto()
    else
      @closePopup()

  _initCrop : () ->
    @cropper = Cropper.init(@$popup.find('img'), @currentPhoto) if @hasCrop

  _changePhoto : (photoIndex) ->
    @_setCurrentPhoto @currentGallery.at(photoIndex)
    @_updateHTML()

  _setCurrentPhoto : (photo) ->
    @_unbindEvents()
    @currentPhoto = photo
    @currentPhoto.on 'crop', @_updateHTML

  _unbindEvents : () ->
    @currentPhoto.off('crop', @_updateHTML) if @currentPhoto
    @$window.off('resize', @_centerImage) if @$window

  _updateHTML : () =>
    @$popup.html @_getHTML()
    @_initCrop()
    @_initImageCentering()

  _getHTML : () ->
    JST['app/templates/gallery-popup']
      photo : @currentPhoto.toJSON()
      hasPhotos : @hasPhotos
      hasCrop : @hasCrop

  @getInstance : () ->
    instance = null
    do () ->
      instance ||= new @GalleryPopup
        el : document.querySelector 'body'