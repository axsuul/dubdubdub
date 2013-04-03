# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rest-client'
require 'nokogiri'
require 'mechanize'

describe DubDubDub do
  let(:www) { DubDubDub.new }

  it "gives the version" do
    DubDubDub::VERSION.should be_a String
  end

  describe '::new' do
    it "instantiates a new instance with a new client" do
      www = DubDubDub.new
      www.should be_a DubDubDub
    end

    it "can specify a proxy" do
      www = DubDubDub.new(proxy: "203.131.212.166:3128")
      www.proxy_host.should == "203.131.212.166"
      www.proxy_port.should == 3128
      www.should be_proxy
    end

    it "uses port 80 by default for proxy" do
      www = DubDubDub.new(proxy: "203.131.212.166")
      www.proxy_host.should == "203.131.212.166"
      www.proxy_port.should == 80
    end

    it "can configure to use a proxy globally" do
      DubDubDub.configure do |config|
        config.proxy = "localhost:8000"
      end

      www = DubDubDub.new(proxy: true)
      www.should be_proxy
      www.proxy.should == "localhost:8000"
    end

    it "ignores proxy if configured to and it's set to nil" do
      DubDubDub.configure do |config|
        config.ignore_proxy = true
        config.proxy = nil
      end

      www = DubDubDub.new(proxy: true)
      www.should_not be_proxy
    end

    it "raises an error if we have specified to use a proxy but none has been set globally" do
      DubDubDub.configure do |config|
        config.ignore_proxy = false
        config.proxy = nil
      end

      lambda { DubDubDub.new(proxy: true) }.should raise_error(ArgumentError)
    end

    it "doesn't raise an error if configured to ignore proxies and we have specified to use a global proxy that hasn't been set" do
      DubDubDub.configure do |config|
        config.ignore_proxy = true
        config.proxy = nil
      end

      lambda { DubDubDub.new(proxy: true) }.should_not raise_error(ArgumentError)
    end

    it "does not pass the method to client if that method doesn't exist within the client" do
      www = DubDubDub.new
      lambda { www.some_method_that_doesnt_exist }.should raise_error(NameError)
    end
  end

  describe '::configuration' do
    it "accesses config object" do
      DubDubDub.configuration.should be_a DubDubDub::Configuration
    end

    it "has default config values" do
      DubDubDub.configuration.ignore_proxy.should be_false
      DubDubDub.configuration.proxy.should be_nil
    end
  end

  describe '::reset_configuration!' do
    it "resets configuration by to defaults" do
      DubDubDub.configure do |config|
        config.ignore_proxy = true
      end

      DubDubDub.configuration.ignore_proxy.should be_true

      DubDubDub.reset_configuration!

      DubDubDub.configuration.ignore_proxy.should be_false
    end
  end

  describe '::configure' do
    it "sets config attributes" do
      DubDubDub.configure do |config|
        config.ignore_proxy = true
      end

      DubDubDub.configuration.ignore_proxy.should be_true
    end

    it "can pass a string to proxy config" do
      DubDubDub.configure do |config|
        config.proxy = "localhost:8000"
      end

      DubDubDub.configuration.proxy.should == "localhost:8000"
    end

    it "can pass a block to proxy config with the block being called when accessing it" do
      DubDubDub.configure do |config|
        config.proxy do
          "localhost:8000"
        end
      end

      DubDubDub.configuration.proxy.should == "localhost:8000"
    end
  end

  describe '#client' do
    it "returns the client" do
      www.client.should be_a DubDubDub::Client
    end
  end

  describe '#mechanize' do
    it "returns a Mechanize agent" do
      www.mechanize.should be_a Mechanize
    end

    it "returns a proxied Mechanize agent if proxied" do
      www.proxy = "localhost:8000"
      agent = www.mechanize
      agent.proxy_addr.should == "localhost"
      agent.proxy_port.should == 8000
    end

    it "ignores proxy if configured" do
      DubDubDub.configuration.ignore_proxy = true

      www.proxy = "localhost:8000"
      agent = www.mechanize
      agent.proxy_addr.should be_nil
      agent.proxy_port.should be_nil
    end
  end

  describe '#get' do
    it "makes a GET request using RestClient and returns a response", vcr: { cassette_name: "get/basic", record: :once } do
      response = www.get "http://www.google.com"
      response.should be_a RestClient::Response
    end

    it "works with params", vcr: { cassette_name: "get/params", record: :once } do
      response = www.get "http://www.google.com", params: { foo: "bar" }
      response.should be_a RestClient::Response
    end

    it "works with a proxy", vcr: { cassette_name: "get/proxy", record: :once } do
      www.proxy = "173.234.181.64:8800"
      response = www.get "http://www.whatismyipaddress.com"
      html = Nokogiri::HTML(response)

      html.css('.ip').text.strip.should == "173.234.181.64"
    end

    it "raises an exception if it doesn't exist", vcr: { cassette_name: "get/doesnt_exist", record: :once } do
      lambda { www.get("https://github.com/asdasd/asdasd") }.should raise_error(DubDubDub::ResponseError)

      begin
        www.get("https://github.com/asdasd/asdasd")
      rescue DubDubDub::ResponseError => e
        e.code.should == 404
        e.error.should_not be_nil
        e.message.should_not be_nil
      end
    end

    it "raise the proper exception when exceeding maximum redirects", vcr: { cassette_name: "get/infinite_redirects", record: :once } do
      lambda { www.get("http://wayback.archive.org/web/20050204085854im_/http://www.drpep.com/images/home_19.gif") }.should raise_error(DubDubDub::RedirectLimitReachedError)
    end

    it "raises proper timeout exception if it times out", vcr: { cassette_name: "get/timeout", record: :once } do
      pending "Long running test, comment out to run it"
      ip_address = "4.4.4.4"
      lambda { www.get(ip_address) }.should raise_error(DubDubDub::ResponseError)

      begin
        www.get(ip_address)
      rescue DubDubDub::ResponseError => e
        e.code.should == 408
      end
    end

    it "raises proper exception if domain doesn't resolve", vcr: { cassette_name: "get/domain_unresolvable", record: :once } do
      domain = "balhblahlbal123123123123.com"
      lambda { www.get(domain) }.should raise_error(DubDubDub::ResponseError)

      begin
        www.get(domain)
      rescue DubDubDub::ResponseError => e
        e.code.should == 404
      end
    end
  end

  describe '#crawl' do
    it "performs a GET request and returns a Nokogiri HTML document", vcr: { cassette_name: "crawl/basic", record: :once } do
      html = www.crawl "http://www.google.com"
      html.should be_a Nokogiri::HTML::Document
    end
  end

  describe '#browse' do
    it "performs a GET request with Mechanize and returns a Mechanize::Page", vcr: { cassette_name: "browse/basic", record: :once } do
      page = www.browse "http://www.google.com"
      page.should be_a Mechanize::Page
    end
  end

  describe '#follow' do
    it "follows url to the end", vcr: { cassette_name: "follow/base", record: :once } do
      www.follow("http://say.ly/TCc1CEp").should == "http://www.whosay.com/TomHanks/photos/148406"
      www.follow("http://t.co//qbJx26r").should == "http://twitter.com/twitter/status/76360760606986241/photo/1"
      www.follow("http://mypict.me/mMgLU").should == "http://mypict.me/mobile.php?id=336583610"
    end

    it "handles invalid uris", vcr: { cassette_name: "follow/invalid_uris", record: :once } do
      lambda { www.follow("http://rank.1new.biz/sharp-紙パック式クリーナー-床用吸い込み口タイプ-オ/") }.should_not raise_error(DubDubDub::URLFormatError)
    end

    it "handles https", vcr: { cassette_name: "follow/https", record: :once } do
      lambda { www.follow("https://www.youtube.com/watch?v=DM58Zdk7el0&feature=youtube_gdata_player") }.should_not raise_error(EOFError)
    end

    it "raises an exception if doesn't exist", vcr: { cassette_name: "follow/doesnt_exist", record: :once } do
      lambda { www.follow("http://cnnsadasdasdasdasdasd.com/asd") }.should raise_error(DubDubDub::ResponseError)

      begin
        www.follow("http://cnnsadasdasdasdasdasd.com/asd")
      rescue DubDubDub::ResponseError => e
        e.code.should == 404
        e.error.should_not be_nil
        e.message.should_not be_nil
      end
    end

    it "returns actual asset link for an alias link", vcr: { cassette_name: "follow/alias_link", record: :once } do
      www.follow("http://yfrog.us/evlb0z:medium").should == "http://img535.imageshack.us/img535/9845/lb0.mp4"
    end

    it "does not raise a EOFError", vcr: { cassette_name: "follow/eoferror", record: :once } do
      lambda { www.follow("http://www.soulpancake.com/post/1607/whats-your-beautiful-mess.html") }.should_not raise_error
    end

    it 'works with a proxy', vcr: { cassette_name: "follow/proxy", record: :once } do
      www.proxy = "198.154.114.100:8080"
      www.follow("http://yfrog.us/evlb0z:medium").should == "http://img535.imageshack.us/img535/9845/lb0.mp4"
    end

    it "works with relative path redirects", vcr: { cassette_name: "follow/relative_redirects", record: :once } do
      www.follow("http://www.retailmenot.com/out/4223117").should == "http://www.papajohns.com/index.html"
    end

    it "raises response error on a bad proxy", vcr: { cassette_name: "follow/proxy_forbidden", record: :once } do
      www.proxy = "190.202.116.101:3128"
      lambda { www.follow("http://yfrog.us/evlb0z:medium").should }.should raise_error(DubDubDub::ResponseError)
    end

    it "follows to the end for some types of urls", vcr: { cassette_name: "follow/all_the_way", record: :once } do
      www.follow("http://www.apmebf.com/fo122tenm4/elq/32A39898/4432424/2/2/2").should == "http://www.bedbathandbeyond.com/default.asp?utm_source=WhaleShark+Media%3A+RetailMeNot%2Ecom&utm_medium=affiliate&utm_term=&utm_campaign=Bed+Bath+and+Beyond+Product+Catalog&aid=10817676&pid=2210202&sid=&"
    end

    it "handles doesn't error out due to URI", vcr: { cassette_name: "follow/uri_error", record: :once } do
      url = www.follow "http://retailmenot.com/out/4231224"
      url.should == "http://www.toysrus.com/category/index.jsp?categoryId=3999911"
    end
  end
end
