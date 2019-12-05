require 'thor'
require_relative 'auth'
require_relative 'info'
require_relative 'console'

class Cli < Thor
  map auth: :login, acct: :account

  def self.basename
    'sty'
  end

  desc "console", "Opens AWS console in browser for currently authenticated session"
  method_option :browser, type: :string, aliases: "-b", enum: Console::BROWSERS, desc: "Use specific browser"
  method_option :incognito, type: :boolean, aliases: "-i", desc: "Create new incognito window"
  method_option :logout, type: :boolean, aliases: "-l", dssc: "Logout from current session"
  def console
    Console.new.action(options[:browser], options[:incognito], options[:logout])
  end

  desc "login ACCOUNT_PATH", "Authenticate to the account"
  def login(path)
    source_run(__method__)
    Auth.new.login(path)
  end

  desc "logout", "Forget current credentials and clear cache"
  def logout
    source_run(__method__)
    Auth.new.logout
  end

  desc "info", "Get current session information"
  def info
    Info.new.session_info
  end

  desc "account ACCOUNT_ID", "Find account information"
  def account(path)
    Info.new.account_info(path)
  end

  no_tasks do
    def source_run(method)
      unless ENV['STY_SOURCE_RUN'] == 'true'
        puts "When using '#{method.to_s}' command, you must source it, i.e.: '. sty #{method.to_s}'"
        exit 128
      end
    end
  end

end

Cli.start(ARGV)