module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    # NOTE:
    #   The below includes a lambda for the if statement because this code is run not now, but when
    #   this concern is included (in the application controller).
    #   So, the below registers the callback now and then Rails runs the callback on every request
    #   but only if the lambda returns true
    before_action :set_current_organization, if: -> { Current.user.present? }
  end

  private
    def set_current_organization
      Current.organization = Current.user.organizations.first
    end
end
