require "rubygems"
require "sinatra"

get "/" do
  erb("Hello World")
end

get "/:name" do |thing|
  @name = thing
  erb(:index)
end
