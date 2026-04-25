module Address::PermittedAttributes
  extend ActiveSupport::Concern

  class_methods do
    def permitted_attributes
       [ :id,
         :line_1,
         :line_2,
         :city,
         :subnational_division,
         :postcode,
         :country
      ]
    end
  end
end
