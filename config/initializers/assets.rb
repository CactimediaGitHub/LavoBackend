Rails.application.config.assets.enabled = true
Rails.application.config.assets.precompile += %w(
  administrate/components/search_filters.js
  ckeditor/*
  ckeditor/lang/*
  administrate-field-nested_has_many.js
  administrate/bootstrap.min.js
  administrate/bootstrap.min.css
  administrate/jquery-ui.min.js
  administrate/jquery-ui.min.css
  fallback/item/default_icon.svg
  top.jpg
  administrate/transactions.coffee
)