module HumanEnum
  extend ActiveSupport::Concern

  class_methods do
    # Because ActiveRecord does not enable localized enum values by default, this helper method can be
    # used to humanise enum values. It will look for a translation in the format:
    #   activerecord.attributes.{model_name}.{enum_name}.{enum_value}
    # If no translation is found, it will fall back to a humanised version of the enum value
    # (e.g. "near_mint" => "Near mint")
    # Note:  We give it the enum_name and the enum_value to be translated, meaninng this
    # methods works for any model's enum(s)
    def human_enum_name(enum_name, enum_value)
      model_key = model_name.i18n_key
      enum_key = enum_name.to_s.pluralize

      I18n.t("activerecord.attributes.#{model_key}.#{enum_key}.#{enum_value}",
             default: enum_value.to_s.humanize)
    end

    # Similarly, this helper method can be used to get all humanised enum options, say for populating
    # a menu of options
    def human_enum_options(enum_name)
      # Step 1: get the enum hash (e.g. { "pending" => 0, ... })
      enum_hash = send(enum_name.to_s.pluralize)

      # Step 2: build a new hash where the keys are humanised enum values and the
      # values are the original enum keys
      result = {}
      enum_hash.each do |key, value|
        label = human_enum_name(enum_name, key)
        result[label] = key
      end
      result
    end
  end

  # Provide a way to get the localized name for the condition on any given Listing
  # e.g. listing.human_condition => "Near mint"
  # i.e. an instance method that calls the class method human_enum_name with the appropriate arguments
  def human_enum_value(enum_name)
    enum_value = send(enum_name)
    self.class.human_enum_name(enum_name, enum_value)
  end
end
