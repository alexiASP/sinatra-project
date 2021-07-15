require 'sinatra'
require 'sinatra/cookies'
require 'rest-client'
require 'sqlite3'
require 'colorize'
require 'sqlite3'

set :protection, :except => :frame_options
set :bind, '0.0.0.0'
set :port, 8080

DB ||= SQLite3::Database.new('data/my-database.db')

class Tweet
  attr_accessor :text
  attr_reader :index, :time

  @@tweets = []

  def initialize(text: 'Empty tweet', time: "#{Time.now.strftime("%B")} #{Time.now.day}, #{Time.now.year} (#{Time.now.hour}:#{Time.now.min})")
    @index = @@tweets.size + 1
    @time = time
    @text = text
    @@tweets.unshift(self)
  end

  def delete
    @@tweets.delete(self)
  end

  def exists?
    DB.execute( "SELECT id from twits" ).map { |id| id[0] }.include?(self.to_h[:index])
  end

  def to_a
    result = [self.index, self.time, self.text]
  end

  def to_h
    result = {index: self.index, time: self.time, text: self.text}
  end

  def self.load_from(source)
    create_table
    @@tweets = source.execute( "SELECT * from twits" ).map(&:to_tweet)
  end

  def self.load_into(source)
    DB.execute("DELETE FROM twits")
    @@tweets.each { |tweet| source.execute("INSERT INTO twits values ( ?, ?, ? )", tweet.to_a)}
  end

  def self.tweets
    @@tweets
  end

  def self.hash_of_twits
    @@tweets.map(&:to_h)
  end
end

class Array
  def to_tweet
    Tweet.new(time: self[1], text: self[2])
  end
end

def create_table
  DB.execute <<-SQL
  create table if not exists twits (
    id int,
    twit varchar(200),
    time varchar(20)
  );
  SQL
end

Tweet.load_from(DB)

  if $stdin == "Hey"
    puts "AHDHSAHDAHDASD"
  end

hash = {g: 12, f: 10}.to_a
p hash
get '/' do
  if params[:tweet].to_s.length != 0
    Tweet.new(text: params[:tweet])
    Tweet.load_into(DB)
    redirect "/"
  end
  if params[:delete].to_s.length != 0
    puts "Deleting #{params[:delete]} el..."
    Tweet.tweets.each { |tweet| tweet.index == params[:delete].to_i ? tweet.delete : nil }
    Tweet.load_into(DB)
    redirect "/"
  end

  @tweets = Tweet.hash_of_twits
  erb :index
end