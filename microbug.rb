require 'rubygems'
require 'json'

Bugdir = File.join(File.dirname(__FILE__), 'bugs')

unless File.directory?(Bugdir)
  FileUtils.mkdir(Bugdir)
end

BaseUrl = 'https://github.com/pc/pay/commit/'

class Bug
  attr_accessor :author
  attr_accessor :status
  attr_accessor :created
  attr_accessor :message
  attr_accessor :id
  attr_accessor :fixed_in

  def self.all
    Dir.entries(Bugdir).select {|x| x =~ /\d+/}\
      .map{|x| Bug.from_id(x)}
  end

  def self.next_id
    m = Dir.entries(Bugdir)\
          .reject {|x| x =~ /^\.+$/}\
          .map {|x| x.to_i}\
          .max 
    1 + (m or 0)
  end

  def self.from_id(id)
    Bug.from_file(File.join(Bugdir, id.to_s))
  end

  def self.from_file(f)
    c = JSON.load(File.read(f))
    cs = {}
    c.each {|k,v| cs[k.to_sym] = v}
    self.new(cs)
  end

  def self.create(author, message)
    b = self.new(:message => message,
                 :author => author,
                 :id => Bug.next_id,
                 :status => 'open',
                 :created => Time.now.to_i)
    b.save
    b
  end

  def initialize(params={})
    @id = params[:id]
    @message = params[:message]
    @author = params[:author]
    @status = params[:status]
    @created = params[:created]
    @fixed_in = params[:fixed_in]
  end

  def fixed?
    @status == 'fixed'
  end

  def filename
    File.join(Bugdir, @id.to_s)
  end

  def save
    d = {:id => @id, :message => @message,
         :author => @author, :status => @status,
         :created => @created, :fixed_in => @fixed_in}
    File.open(filename, 'w') {|f| f.write d.to_json }
  end
end
