require "./spec_helper"

class Greeting
  def say(what)
    what
  end
end

Mocks.create_mock Greeting do
  mock say(what)
end

Spec2.describe "Spec2::Mocks" do
  it "works" do
    p = Greeting.new
    p.say("hi John")
    expect(p).to have_received(say("hi John"))
    expect(p).not_to have_received(say("hello world"))
    expect {
      expect(p).to have_received(say("hello world"))
    }.to raise_error(Spec2::ExpectationNotMet, "expected: say[\"hello world\"]\n     got: say[\"hi John\"]")
  end

  it "works with delayed expectation (and_return)" do
    p = Greeting.new
    expect(p).to receive(say("hi John")).and_return("hello John")
    expect(p.say("hi John")).to eq("hello John")
  end

  it "works with delayed expectation (just receive)" do
    p = Greeting.new
    expect(p).to receive(say("hi John"))
    expect(p.say("hi John")).to eq("hi John")
  end

  it "works with delayed expectation (not_to)" do
    p = Greeting.new
    expect(p).not_to receive(say("hi John"))
    expect(p.say("hi Bruce")).to eq("hi Bruce")
  end
end
