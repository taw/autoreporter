require "open3"
require "shellwords"
require "timeout"

class Autoreporter
  attr_accessor :delay, :commands, :verbose

  def initialize
    @output = nil
    @delay = 60
    @verbose = false
    @commands = []
  end

  def run_command(cmd)
    output, status = Open3.capture2e(cmd)
    output += "\n" if output != "" and output[-1] != "\n"
    output = "Running: #{cmd}\n" + output if verbose
    output
  end

  def run_commands!
    @output = @commands.map{|cmd| run_command(cmd)}
  end

  def clear_terminal!
    # system("clear") doesn't clear scrollback buffer on iTerm2, we need to do this:
    print "\e[H\e[J\e[3J"
  end

  def display_result!
    clear_terminal!
    puts *@output
  end

  # Wait for either @delay seconds
  # or for user forcing autorefresh by pressing enter
  def wait_for_condition!
    begin
      Timeout.timeout(@delay) do
        STDIN.readline
      end
    rescue Timeout::Error
    end
  end

  def call
    while true
      run_commands!
      display_result!
      wait_for_condition!
    end
  end
end
