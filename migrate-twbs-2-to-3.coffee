# This file is under MIT License
# It is part of the Migrate-to-Twitter-Bootstrap-3-script
# Get it on https://github.com/rbecher/migrate-to-twbs3

jQuery ->
  "use strict"; # jshint ;_;

  # ref: http://getbootstrap.com/getting-started/#migration :-)
  # ref: http://bassjobsen.weblogs.fm/migrate-your-templates-from-twitter-bootstrap-2-x-to-twitter-bootstrap-3/
  # ref: http://code.divshot.com/bootstrap3_upgrader/
  # ref: http://bootstrap3.kissr.com/

  $ = jQuery
  log = (message) ->
    console.log message
  info = (message) ->
    console.info message
  error = (message) ->
    console.error message
  warn = (message) ->
    console.warn message

  version = '0.0.1'

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

  check = (transform = false) ->
    info "Starting migration helper for twitter bootstrap (#{version})"

    # check grid changes
    changeElementClass 'container-fluid', 'container', 'container', transform
    changeElementClass 'row-fluid', 'row', 'row', transform
    $.each [1..13], (num) ->
      changeElementClass "span#{num}", "col-lg-#{num}", "span of length #{num}", transform
      # TODO consider a way of dealing with other media sizes
    $.each [1..12], (num) ->
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

  if typeof jQuery is "undefined" and
      typeof Zepto is "undefined" and
      typeof $ is "function"
      libFuncName = $
  else if typeof jQuery is "function"
    libFuncName = jQuery
  else if typeof Zepto is "function"
    libFuncName = Zepto
  else
    throw new TypeError()

  # TODO make a difference between different areas and make default options
  window.MigrateTwBs = check
