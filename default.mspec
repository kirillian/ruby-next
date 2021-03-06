# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

begin
  require "pry-byebug"
rescue LoadError
  nil
end

class MSpecScript
  # Language features specs
  set :language, %w[spec/language]

  # Core library specs
  set :core, %w[spec/core]

  # Integration specs
  set :integration, %w[spec/integration]

  # Command line specs
  set :cli, %w[spec/cli]

  # Optional specs (require custom parser)
  set :optional, %w[spec/optional]

  # Latest stable Ruby release specs
  set :stable, get(:cli) + get(:language) + get(:core) + get(:integration)
end

require "ruby-next/language"
# It's important to enable optional rewriters before loading Runtime module,
# 'cause it creates a copy of the original list
require "ruby-next/language/rewriters/method_reference"
RubyNext::Language.rewriters << RubyNext::Language::Rewriters::MethodReference

require "ruby-next/language/runtime"

if ENV["CORE_EXT"] == "gem"
  require "ruby-next/core_ext"
elsif ENV["CORE_EXT"] == "generated"
  require "ruby-next/cli"
  RubyNext::CLI.new.run(["core_ext", "--min-version", RUBY_VERSION, "-o", File.join(__dir__, "tmp", "core_ext.rb")])
  require_relative "tmp/core_ext"
  RubyNext::Core.strategy = :core_ext
else
  require "ruby-next/core/runtime"
end

$stdout.puts "RubyNext core strategy: #{RubyNext::Core.strategy}"
