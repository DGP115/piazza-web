class Organization < ApplicationRecord
  has_many :memberships, dependent: :destroy
  #
  # The relation to User is defined as has_many :members
  # because @organization.members reads better than @organization.users.
  # source: :user option tells ActiveRecord to use the user_id foreign key for this relation.
  has_many :members, through: :memberships, source: :user
end
