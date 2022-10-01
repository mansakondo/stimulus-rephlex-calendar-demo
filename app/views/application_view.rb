# frozen_string_literal: true

module Views
  class ApplicationView < Phlex::View
    include Rails.application.routes.url_helpers
  end
end
