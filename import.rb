#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), 'microbug')
require 'actionmailer'

class BugReceiver < ActionMailer::Base
  def receive(mail)
    Bug.create(mail.from, mail.subject)
  end
end

if $0 == __FILE__
  BugReceiver.receive($stdin.read)
end
