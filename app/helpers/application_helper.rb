module ApplicationHelper
  #
  # In this app, each page will have a title [helps SEO].
  # If a title isn't specified, this method sets a default.
  # NOTE:  All titles and user-facing text is managed by internationalization (i18n) files.
  def title
    return t("piazza") unless content_for?(:title)
    # If running native app, don't include "piazza" suffix as user knows they started app piazza
    return content_for(:title) if turbo_native_app?

    "#{content_for(:title)} | #{t("piazza")}"
  end

  def pagy_needed?
    # A helper used to omit pagy navigation when there is only one page of results.
    # This is used in the feed page.
    # Also, omit pagy navigation if running on Android (where infinite scrolling is used instead).
    !turbo_native_app? && (@pagy && @pagy.pages > 1)
  end
end
