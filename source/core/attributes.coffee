###
HTML Renderer

@namespace Atoms.Core
@class Attributes

@author Javier Jimenez Villar <javi@tapquo.com> || @soyjavi
###
"use strict"

Atoms.Core.Attributes =

  ###
  Set the parent instance to current instance.
  @method setParent
  ###
  scaffold: ->
    # Assign Parrent
    @parent = {}
    if @attributes?.parent?
      @parent = @attributes.parent
      delete @attributes.parent

    # Assign Container
    @container = @attributes.container or @parent.el or document.body
    delete @attributes.container

    # Assign Entity
    if @attributes?.entity?
      @entity = @attributes.entity
      delete @attributes.entity

  chemistry: (children) ->
    children = @attributes.children or @default.children
    for item, index in children
      for key of item when not @constructor.available or key in @constructor.available
        base = key.split(".")
        type = base[0]
        class_name = base[1]
        if Atoms[type][class_name]?
          attributes = item[key]
          if @default?.children?[index]?[key]?
            attributes = Atoms.Core.Helper.mix item[key], @default.children?[index]?[key]
          @children.push @instance type, class_name, attributes

  instance: (type, class_name, attributes={}) ->
    if @__available type, class_name
      attributes.parent = attributes.parent or @
      new Atoms[type][class_name] attributes
    else
      throw "Instance no available in current container."

  __available: (type, class_name) ->
    instance = Atoms[type][class_name]
    instance = instance.base or instance.name
    (not @constructor.available or "#{type}.#{instance}" in @constructor.available)
