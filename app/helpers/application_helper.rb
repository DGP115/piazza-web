module ApplicationHelper
  #
  # In this app, each page will have a title [helps SEO].
  # If a title isn't specified, this method sets a default.
  # NOTE:  All titles and user-facing text is managed by internationalization (i18n) files.
  def title
    return t("piazza") unless content_for?(:title)

    "#{content_for(:title)} | #{t("piazza")}"
  end
end
