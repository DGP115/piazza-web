module ApplicationHelper
  #
  # In this app, each page will have a title [helps SEO].
  # If a title isn't specified, this method sets a default.
  # NOTE:  All titles and user-facing text is managed by internationalization (i18n) files.
  def title
    return t("piazza") unless content_for?(:title)
    # If running native app, don't inlcude "piazza" suffix as user knows they started app piazza
    return content_for(:title) if turbo_native_app?

    "#{content_for(:title)} | #{t("piazza")}"
  end
end
