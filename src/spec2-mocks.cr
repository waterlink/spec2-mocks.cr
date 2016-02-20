require "./spec2-mocks/*"
require "spec2"
require "mocks"

module Spec2::Mocks
  class HaveReceived
    include ::Spec2::Matcher

    @unwrap : ::Mocks::HaveReceivedExpectation
    getter unwrap
    
    def initialize(receive)
      @unwrap = ::Mocks::HaveReceivedExpectation.new(receive)
    end

    def match(value)
      unwrap.match(value)
    end

    def failure_message
      unwrap.failure_message
    end

    def failure_message_when_negated
      unwrap.negative_failure_message
    end

    def description
      "(have received #{receive.method_name}#{receive.args.inspect})"
    end
  end
end

module Spec2::Matchers
  macro have_received(method)
    ::Spec2::Mocks::HaveReceived.new(receive({{method}}))
  end
end
