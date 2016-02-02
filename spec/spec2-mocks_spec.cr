require "./spec_helper"

class Greeting
  def say(what)
    what
  end
end

create_mock Greeting do
  mock say(what)
end

Spec2.describe "Spec2::Mocks" do
  before { Mocks.reset }
  after { Mocks.reset }

  it "works" do
    p = Greeting.new
    p.say("hi John")
    expect(p).to have_received(say("hi John"))
    expect(p).not_to have_received(say("hello world"))
    expect {
      expect(p).to have_received(say("hello world"))
    }.to raise_error(Spec2::ExpectationNotMet, "expected: say[\"hello world\"]\n     got: say[\"hi John\"]")
  end
end
