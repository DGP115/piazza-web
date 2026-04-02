class ApplicationRecord < ActiveRecord::Base
  # Include our enum concern
  include HumanEnum
  primary_abstract_class
end
