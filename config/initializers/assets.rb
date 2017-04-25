Rails.application.config.assets.enabled = true
Rails.application.config.assets.precompile += %w(
  administrate/components/search_filters.js
  ckeditor/*
  ckeditor/lang/*
  administrate-field-nested_has_many.js
  fallback/item/default_icon.svg
  top.jpg
)