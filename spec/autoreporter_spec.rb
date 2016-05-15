require_relative "../lib/autoreporter"
require "thread"

describe "autoreporter" do
  let(:commands) { ["echo foo", "echo $[2+2]"] }
  let(:delay) { 15 }
  let(:events) { SizedQueue.new(10) }
  let(:ar) do
    ar = Autoreporter.new
    ar.commands = commands
    ar.delay = delay
    ar.verbose = verbose
    allow(ar).to receive(:sleep) {|*x| events << [:sleep, *x] }
    allow(ar).to receive(:puts) {|*x| events << [:puts, *x] }
    ar
  end

  before :each do
    ar
  end

  context "no verbose" do
    let(:verbose) { false }
    it do
      thr = Thread.new{ ar.run! }
      expect(6.times.map{events.deq}).to eq([
        [:puts, "\e[H\e[J\e[3J"],
        [:puts, "foo\n", "4\n"],
        [:sleep, 15],
      ] * 2)
      thr.kill
    end
  end

  context "verbose" do
    let(:verbose) { true }
    it do
      thr = Thread.new{ ar.run! }
      expect(6.times.map{events.deq}).to eq([
        [:puts, "\e[H\e[J\e[3J"],
        [:puts, "Running: echo foo\nfoo\n", "Running: echo $[2+2]\n4\n"],
        [:sleep, 15],
      ] * 2)
      thr.kill
    end
  end
end
