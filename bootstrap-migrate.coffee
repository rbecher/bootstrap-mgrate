# This file is under MIT License
# It is part of the Migrate-to-Twitter-Bootstrap-3-script
# Get it on https://github.com/rbecher/migrate-to-twbs3

$ ->
  "use strict"; # jshint ;_;

  # ref: http://getbootstrap.com/getting-started/#migration :-)
  # ref: http://bassjobsen.weblogs.fm/migrate-your-templates-from-twitter-bootstrap-2-x-to-twitter-bootstrap-3/
  # ref: http://code.divshot.com/bootstrap3_upgrader/
  # ref: http://bootstrap3.kissr.com/

  ### --------------------------------------------
  | Options
  -------------------------------------------- ###
  defaults =
    autoRun: false
    transform: false
    showInfo: true
    showWarning: true
    colorize: false
    colorType: 'border'
    color: 'red'
    checks: [ 'grid', 'structure', 'buttons', 'responsive', 'icons', 'form' ]

  ### --------------------------------------------
  | Helper
  -------------------------------------------- ###
  log = (message) ->
    console.log message
  info = (message) ->
    console.info message
  error = (message) ->
    console.error message
  warn = (message) ->
    console.warn message

  version = '0.0.1'

  # convenience method for creating new jQuery objects
  # seen at jQuery colorbox http://www.jacklmoore.com/colorbox
  $tag = (tag, classes = [], id = null, css = null) ->
    element = document.createElement tag
    if id
      element.id = id
    unless classes.length is 0
      (element.addClass klass for klass in classes)
    if css
      element.style.cssText = css
    $ element

  changeElementClass = (oldClass, newClass, name, transform, tagName = '') ->
    el = $ "#{tagName}.#{oldClass}"
    if el.length > 0
      warn "'.#{oldClass}' has been renamed to '.#{newClass}', found #{el.length} times"
      if transform
        el.removeClass(oldClass).addClass(newClass)
        info "Transformed #{name}"

  removeElementClass = (oldClass, name, transform, tagName = '') ->
    el = $ "#{tagName}.#{oldClass}"
    if el.length > 0
      warn "'.#{oldClass}' has been removed, found #{el.length} times"
      if transform
        el.removeClass(oldClass)
        info "Transformed #{name}"

  addClassToElement = (element, newClass, name, transform) ->
    el = $ element
    if el.length > 0
      warn "'.#{newClass}' has been added for '#{element}', found #{el.length} times"
      if transform
        el.addClass(newClass)
        info "Transformed #{name}"

  wrapElementInElement = (inner, outer, name, transform) ->
    el = $ inner

    if el.length > 0
      transformable = (element for element in el unless el.parent().tagName is 'DIV' )
      if transformable.length > 0
        warn "#{inner} should be wrapped now in '#{outer}' tags, found #{transformable.length} times"
        if transform
          transformable.wrapAll(document.createElement(outer))
          info "Transformed #{name}"

  if $.BootstrapMigrate
    # already exists, don't do anything at all
    return

  publicMethod = $.fn[BootstrapMigrate] = $[BootstrapMigrate] = (options = {}) ->
    this.each ->
      $.data(this, BootstrapMigrate, $.extend({}, $.data(this, BootstrapMigrate) || defaults, options))

    if options.autoRun
      check options.transform

  publicMethod.settings = defaults

  ### --------------------------------------------
  | Checks
  -------------------------------------------- ###
  check = (transform = false) ->
    info "Starting migration helper for twitter bootstrap (#{version})"

    # check grid changes

    changeElementClass 'container-fluid', 'container', 'container', transform
    changeElementClass 'row-fluid', 'row', 'row', transform
    $.each [1..12], (i, num) ->
      changeElementClass "span#{num}", "col-lg-#{num}", "span of length #{num}", transform
      # TODO consider a way of dealing with other media sizes
    $.each [1..12], (i, num) ->
      changeElementClass "offset#{num}", "col-md-offset-#{num}", "offset of length #{num}", transform

    # Navbar Structural Changes
    changeElementClass 'brand', 'navbar-brand', 'brand in navbar', transform
    changeElementClass 'nav-collapse', 'navbar-collapse', 'collapsing navbar', transform
    changeElementClass 'nav-toggle', 'navbar-toggle', 'toggling navbar', transform
    changeElementClass 'btn-navbar', 'navbar-btn', 'toggling navbar', transform
    changeElementClass 'navbar-search', 'navbar-form', 'navbar search', transform
    changeElementClass 'navbar-inner', 'container', 'inner navbar', transform
    # TODO Replace .navbar .nav with .navbar-nav
    # TODO .navbar.pull-left is now .navbar-left
    # TODO .navbar.pull-right is now .navbar-right
    # TODO .navbar-brand, .navbar-toggle are wrapped by .navbar-header
    # wrapElementInElement '.navbar-brand', 'div.navbar-header', 'navbar brands', transform
    # wrapElementInElement '.navbar-toggle', 'div.navbar-header', 'navbar toggles', transform
    # TODO .navbar:not(.navbar-inverse) is now .navbar.navbar-default

    # Changes to Button Color Classes
    # TODO Add btn-default to btn elements with no other color.
    changeElementClass 'btn-inverse', 'btn-default', 'inverse buttons', transform

    # Dividers Removed from Breadcrumbs
    # Bootstrap 3 uses CSS to add the dividers between breadcrumbs.
    # Remove all span.divider elements inside breadcrumbs.
    removeElementClass 'divider', 'dividers in breadcrumbs', transform, 'span'

    # Helper Class Specificity
    changeElementClass 'muted', 'text-muted', 'muted text', transform
    changeElementClass 'unstyled', 'list-unstyled', 'unstyled ordered lists', 'ol'
    changeElementClass 'unstyled', 'list-unstyled', 'unstyled unordered lists', 'ul'

    # Progress Bar Structural Changes
    # The inner element class is now progress-bar, not bar.
    changeElementClass 'bar', 'progress-bar', 'progress bars', transform
    # TODO the bar colors also have a progress- prefix.

    # Upgrade Responsive Classes
    # Change responsive classes from [visible|hidden]-[phone|tablet|desktop] to [visible|hidden]-[sm|md|lg]
    changeElementClass 'visible-phone', 'visible-sm', 'visible for phones', transform
    changeElementClass 'hidden-phone', 'hidden-sm', 'hidden for phones', transform
    changeElementClass 'visible-tablet', 'visible-md', 'visible for tablets', transform
    changeElementClass 'hidden-tablet', 'hidden-md', 'hidden for tablets', transform
    changeElementClass 'visible-desktop', 'visible-lg', 'visible for desktop', transform
    changeElementClass 'hidden-desktop', 'hidden-lg', 'hidden for desktop', transform


    # check content changes
    changeElementClass 'hero-unit', 'jumbotron', 'toggling navbar', transform

    # TODO get list of icon classes
    oldIconClasses = 'icon-glass icon-music icon-search icon-envelope icon-heart icon-star icon-star-empty icon-user icon-film icon-th-large icon-th icon-th-list icon-ok icon-remove icon-zoom-in icon-zoom-out icon-off icon-signal icon-cog icon-trash icon-home icon-file icon-time icon-road icon-download-alt icon-download icon-upload icon-inbox icon-play-circle icon-repeat icon-refresh icon-list-alt icon-lock icon-flag icon-headphones icon-volume-off icon-volume-down icon-volume-up icon-qrcode icon-barcode icon-tag icon-tags icon-book icon-bookmark icon-print icon-camera icon-font icon-bold icon-italic icon-text-height icon-text-width icon-align-left icon-align-center icon-align-right icon-align-justify icon-list icon-indent-left icon-indent-right icon-facetime-video icon-picture icon-pencil icon-map-marker icon-adjust icon-tint icon-edit icon-share icon-check icon-move icon-step-backward icon-fast-backward icon-backward icon-play icon-pause icon-stop icon-forward icon-fast-forward icon-step-forward icon-eject icon-chevron-left icon-chevron-right icon-plus-sign icon-minus-sign icon-remove-sign icon-ok-sign icon-question-sign icon-info-sign icon-screenshot icon-remove-circle icon-ok-circle icon-ban-circle icon-arrow-left icon-arrow-right icon-arrow-up icon-arrow-down icon-share-alt icon-resize-full icon-resize-small icon-plus icon-minus icon-asterisk icon-exclamation-sign icon-gift icon-leaf icon-fire icon-eye-open icon-eye-close icon-warning-sign icon-plane icon-calendar icon-random icon-comment icon-magnet icon-chevron-up icon-chevron-down icon-retweet icon-shopping-cart icon-folder-close icon-folder-open icon-resize-vertical icon-resize-horizontal icon-hdd icon-bullhorn icon-bell icon-certificate icon-thumbs-up icon-thumbs-down icon-hand-right icon-hand-left icon-hand-up icon-hand-down icon-circle-arrow-right icon-circle-arrow-left icon-circle-arrow-up icon-circle-arrow-down icon-globe icon-wrench icon-tasks icon-filter icon-briefcase icon-fullscreen'.split(' ')
    (changeElementClass oldClass, oldClass.replace(/^icon/, 'glyphicon'), oldClass.replace(/^icon-/, '') + ' icon', transform for oldClass in oldIconClasses)
    # TODO warn about new resource to link for glyphicon font

    # TODO check for existence of btn-sizes
    # TODO add list of classes for icons

    # Upgrade Button, Pagination, and Well sizes.
    # Change sizes from [button|pagination|well]-[mini|small|large] to [button|pagination|well]-[xs|sm|lg]
    changeElementClass 'button-mini', 'button-xs', 'mini buttons', transform
    changeElementClass 'pagination-mini', 'pagination-xs', 'mini paginations', transform
    changeElementClass 'well-mini', 'well-xs', 'mini well', transform
    changeElementClass 'button-small', 'button-sm', 'small buttons', transform
    changeElementClass 'pagination-small', 'pagination-sm', 'small paginations', transform
    changeElementClass 'well-small', 'well-sm', 'small well', transform
    changeElementClass 'button-large', 'button-lg', 'large buttons', transform
    changeElementClass 'pagination-large', 'pagination-lg', 'large paginations', transform
    changeElementClass 'well-large', 'well-lg', 'large well', transform

    # Upgrade Alert Block Classes.
    # Changes .alert-block to simply .alert
    changeElementClass 'alert-block', 'alert', 'alert blocks', transform
    # TODO Alerts without a modifier are defaulted to .alert-warning.
    # TODO .alert-dismissable added to all alerts that may be dismissed.

    # Upgrade Label Classes.
    # TODO Changes .label to .label.label-default

    changeElementClass 'hero-unit', 'jumbotron', 'toggling navbar', transform

    # form changes
    changeElementClass 'form-search', 'form-inline', 'inline forms', transform
    changeElementClass 'input-block-level', '', 'block level inputs', transform
    removeElementClass 'input-block-level', 'block level inputs', transform
    changeElementClass 'help-inline', 'help-block', 'inline help in forms', transform
    changeElementClass 'control-group', 'form-group', 'groups in forms', transform
    removeElementClass 'controls', 'obsolete controls', transform
    addClassToElement 'input', 'form-control', 'form-control for inputs', transform
    addClassToElement 'select', 'form-control', 'form-control for select', transform
    wrapElementInElement 'input[type="radio"]', 'div', 'radios with div', transform
    wrapElementInElement 'input[type="checkbox"]', 'div', 'checkbox with div', transform
    # TODO Replace .radio.inline and .checkbox.inline with -inline instead
    # TODO Text-based form controls are now 100% wide. Wrap inputs inside <div class="col-*"></div> to control input widths.

    # TODO Typeahead has been dropped, in favor of using Twitter Typeahead.

    # Modal markup has changed significantly.
    # TODO The .modal-header, .modal-body, and .modal-footer sections now get wrapped in .modal-content and .modal-dialog for improved mobile styling and behavior.


  # TODO check for included CDN version of bootstrap 2 - css
    # TODO check for included CDN version of bootstrap 2 - js
    # if transform then detach the old CDN and add the new

  # TODO somehow check for version of bootstrap or whether new version is already there
  # desired behaviour:
  # Bootstrap 2.x: Warn
  # Bootstrap 3.x: Warn and change (classes) accordingly

  # <s>stolen</s>borrowed from foundation :-)
  # Accommodate running jQuery or Zepto in noConflict() mode by
  # using an anonymous function to redefine the $ shorthand name.
  # See http://docs.jquery.com/Using_jQuery_with_Other_Libraries
  # and http://zeptojs.com/
  libFuncName = null;

  if typeof jQuery is "undefined" and typeof Zepto is "undefined" and typeof $ is "function"
    libFuncName = $
  else if typeof jQuery is "function"
    libFuncName = jQuery
  else if typeof Zepto is "function"
    libFuncName = Zepto
  else
    throw new TypeError()

  # TODO make a difference between different areas and make default options
  window.BootstrapMigrate = check
