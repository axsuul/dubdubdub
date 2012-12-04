DubDubDub
=========

World wide web dubstep... and this is our [theme song](http://www.youtube.com/watch?v=OR6AV9yJPoM).

Description
===========

So what the hell this? This is a layer for two very useful http libraries: [rest-client](https://github.com/archiloque/rest-client) and [mechanize](https://github.com/sparklemotion/mechanize). If you do any sort of web crawling, browsing, URL following and want to consolidate all your tools in one library, then this one's for you. And if you're serious about that stuff, you're probably using proxies. `DubDubDub` makes it easy to configure proxies for everything you do.

Install
=======

```
gem install dubdubdub
```
    
Basics
======

```ruby
www = DubDubDub.new

# Uses rest-client and returns a Nokogiri::Document
www.crawl "http://google.com"

# Uses mechanize and returns a Mechanize::Page
www.browse "http://google.com"

# Follows and returns the end URL
www.follow "http://bit.ly/abcdefg"

# Be RESTful
www.get "http://google.com"
www.post "http://google.com", {}
www.delete "http://google.com", {}
```

Proxies
=======

```ruby
www = DubDubDub.new(proxy: "1.2.3.4:80")

# Now all requests will use the proxy
www.crawl "http://google.com"
```
    
Configuration
=============

Set a global proxy to use.

```ruby
DubDubDub.configure do |config|
  config.proxy = "1.2.3.4:8080"
end

www = DubDubDub.new(proxy: true)
```

Be fancy and customize the proxies you want to use by passing in a block which will be called when using a proxy. 

```ruby
DubDubDub.configure do |config|
  config.proxy do
    ["1.2.3.4:8080", "1.2.3.4:80"].sample
  end
end

www = DubDubDub.new(proxy: true)
www.proxy   # => 1.2.3.4:8080 OR 1.2.3.4:80
```
    
Ignore all proxies (useful for testing).

```ruby
DubDubDub.configure do |config|
  config.ignore_proxy = true
end
```