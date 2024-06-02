require_relative "../lib/autoreporter"
require "tempfile"

describe "autoreporter" do
  let(:commands) { ["echo foo", "echo $hello"] }
  let(:delay) { 15 }
  let(:file) { nil }

  let(:events) { [] }
  let(:max_events) { 6 }
  let(:got_event) { proc{|*ev|
    events << ev
    throw :done if events.size >= max_events
  } }
  let(:clear_terminal) { "\e[H\e[J\e[3J" }

  let(:ar) do
    ar = Autoreporter.new
    ar.commands = commands
    ar.delay = delay
    ar.verbose = verbose
    ar.file = file
    allow(Timeout).to receive(:timeout) {|*x| got_event[:sleep, *x] }
    allow(ar).to receive(:puts) {|*x| got_event[:puts, *x] }
    allow(ar).to receive(:print) {|*x| got_event[:print, *x] }
    ar
  end

  let(:events_received) do
    ar
    catch(:done) { ar.call }
    events
  end

  before do
    ENV["hello"] = "world"
  end

  context "no verbose" do
    let(:verbose) { false }
    it do
      expect(events_received).to eq([
        [:print, clear_terminal],
        [:puts, "foo\n", "world\n"],
        [:sleep, 15],
     ] * 2)
    end
  end

  context "verbose" do
    let(:verbose) { true }
    it do
      expect(events_received).to eq([
        [:print, clear_terminal],
        [:puts, "Running: echo foo\nfoo\n", "Running: echo $hello\nworld\n"],
        [:sleep, 15],
      ] * 2)
    end
  end

  context "file" do
    let(:verbose) { false }
    let(:file) { Tempfile.new("output") }
    it do
      expect(events_received).to eq([
        [:print, clear_terminal],
        [:puts, "foo\n", "world\n"],
        [:sleep, 15],
      ] * 2)
      expect(File.read(file.path)).to eq("foo\nworld\n")
    end
  end
end
