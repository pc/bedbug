#!/usr/bin/ruby
require File.join(File.dirname(__FILE__), 'bedbug')
require 'actionmailer'

class BugReceiver < ActionMailer::Base
  def receive(mail)
    m = mail.subject.empty? ? mail.body : mail.subject
    Bug.create(mail.from.first, m)
  end
end

if $0 == __FILE__
  BugReceiver.receive($stdin.read)
end
