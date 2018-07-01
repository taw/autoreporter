require_relative "../lib/autoreporter"

describe "autoreporter" do
  let(:commands) { ["echo foo", "echo $hello"] }
  let(:delay) { 15 }

  let(:events) { [] }
  let(:max_events) { 6 }
  let(:got_event) { proc{|*ev|
    events << ev
    throw :done if events.size >= max_events
  } }

  let(:ar) do
    ar = Autoreporter.new
    ar.commands = commands
    ar.delay = delay
    ar.verbose = verbose
    allow(ar).to receive(:sleep) {|*x| got_event[:sleep, *x] }
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
        [:print, "\e[H\e[J\e[3J"],
        [:puts, "foo\n", "world\n"],
        [:sleep, 15],
     ] * 2)
    end
  end

  context "verbose" do
    let(:verbose) { true }
    it do
      expect(events_received).to eq([
        [:print, "\e[H\e[J\e[3J"],
        [:puts, "Running: echo foo\nfoo\n", "Running: echo $hello\nworld\n"],
        [:sleep, 15],
      ] * 2)
    end
  end
end
