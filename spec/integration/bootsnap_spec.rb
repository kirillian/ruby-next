# frozen_string_literal: true

require_relative "../support/command_testing"

using CommandTesting

describe "bootsnap compatibility" do
  it "works" do
    skip if defined? JRUBY_VERSION

    cache_path = File.join(__dir__, "fixtures", "bootsnap", "tmp")
    if File.directory?(cache_path)
      FileUtils.rm_rf(cache_path)
    end

    run(
      "ruby -rbundler/setup -I#{File.join(__dir__, "../../lib")} "\
      "#{File.join(__dir__, "fixtures", "bootsnap", "test.rb")}"
    ) do |_status, output, _err|
      output.should include("PERFORM: ruby_next#test\n")
      output.should include("UNKNOWN: perform\n")
    end
  end
end
