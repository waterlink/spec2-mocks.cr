require "./spec2-mocks/*"
require "spec2"
require "mocks"

module ::Spec2::Mocks
  class Expectation(T) < ::Spec2::Expectation(T)
    def initialize(@actual : T, @delayed)
    end

    def to(m : ::Mocks::Message)
      ::Mocks::Allow.new(@actual).to m
      delayed_have_received(to, m)
    end

    def to(m : ::Mocks::Receive)
      delayed_have_received(to, m)
    end

    def not_to(m : ::Mocks::Receive)
      delayed_have_received(not_to, m)
    end

    macro delayed_have_received(marker, matcher)
      @delayed << -> do
        ::Spec2::Expectation.new(@actual)
          .{{marker.id}} HaveReceived.new({{matcher}})
      end
    end
  end

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

module ::Spec2::DSL
  macro expect(target)
    ::Spec2::Mocks::Expectation.new({{target}}, __spec2_delayed)
  end

  include ::Mocks::Macro::GlobalDSL

  macro have_received(method)
    ::Spec2::Mocks::HaveReceived.new(receive({{method}}))
  end
end

module ::Spec2
  macro describe(what, file = __FILE__, line = __LINE__, &blk)
    ::Spec2::DSL.context({{what}}, {{file}}, {{line}}) do
      before { Mocks.reset }
      {{blk.body}}
    end
  end
end
