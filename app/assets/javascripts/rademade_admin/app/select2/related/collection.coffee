class @Select2Input.RelatedCollection extends Backbone.Collection

  comparator : 'position'

  initialize : () ->
    @on 'add', @addPosition
    @on 'relation-remove', @removeFromCollection

  addPosition : (model) ->
    model.set 'position', @length

  removeFromCollection : (model) =>
    @remove model
    @_triggerChange()

  update : (data) ->
    @add new Select2Input.RelatedModel(data), merge : true
    @_triggerChange()

  resort : () ->
    @sort()
    @_triggerChange()

  getData : () ->
    @pluck 'id'

  _triggerChange : () ->
    @trigger 'data-change'