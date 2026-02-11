class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Include Authenticate concern.  It helps with user authenication in all controllers
  include Authenticate

  # Turbo adds a Turbo-Frame HTTP header when a request originates from within a Turbo Frame.
  # The turbo-rails gem has a method called turbo_frame_request? that checks if this header exists.
  # It’s not exposed as a helper method though, so it needs to be declared as such
  helper_method :turbo_frame_request?
end
