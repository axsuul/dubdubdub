# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rest-client'

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

    it "does not pass the method to client if that method doesn't exist within the client" do
      www = DubDubDub.new
      lambda { www.some_method_that_doesnt_exist }.should raise_error(NameError)
    end
  end

  describe '#client' do
    it "returns the client" do
      www.client.should be_a DubDubDub::Client
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
      www.proxy = "203.131.212.166"
      response = www.get "http://www.google.com"
    end
  end

  describe '#follow_url' do
    it "follows url to the end", vcr: { cassette_name: "follow_url/base", record: :once } do
      www.follow_url("http://say.ly/TCc1CEp").should == "http://www.whosay.com/TomHanks/photos/148406"
      www.follow_url("http://t.co//qbJx26r").should == "http://twitter.com/twitter/status/76360760606986241/photo/1"
      www.follow_url("http://mypict.me/mMgLU").should == "http://mypict.me/mobile.php?id=336583610"
    end

    it "returns the base url if it meets a passed in block", vcr: { cassette_name: "follow_url/block_base_url", record: :once } do
      www.follow_url("http://ow.ly/9Rp7p", until: lambda { |url| url =~ /ow\.ly/ }).should == "http://ow.ly/9Rp7p"
      www.follow_url("http://ow.ly/9Rp7p", until: lambda { |url| url =~ /bit\.ly/ }).should == "http://bit.ly/GMx5lu"
      www.follow_url("http://ow.ly/9Rp7p", until: lambda { |url| url =~ /bit\.lyyy/ }).should == "http://instagram.com/p/IbhSB6EKRQ/"
    end

    it "can pass in a block to get the url every step of the way", vcr: { cassette_name: "follow_url/pass_block_iteration", record: :once } do
      urls = []

      www.follow_url("http://ow.ly/9Rp7p") do |url|
        urls << url
      end

      urls.first.should == "http://ow.ly/9Rp7p"   # first url should be the initial one
      urls.count.should == 4
    end

    it "can pass in a block with the last url being the base url", vcr: { cassette_name: "follow_url/pass_block", record: :once } do
      urls = []

      www.follow_url("http://twitpic.com/92a2p5") do |url|
        urls << url
      end

      urls.count.should == 1
      urls.last.should == "http://twitpic.com/92a2p5"
    end

    it "handles invalid uris", vcr: { cassette_name: "follow_url/invalid_uris", record: :once } do
      lambda { www.follow_url("http://rank.1new.biz/sharp-紙パック式クリーナー-床用吸い込み口タイプ-オ/") }.should_not raise_error(URI::InvalidURIError)
      www.follow_url("http://rank.1new.biz/sharp-紙パック式クリーナー-床用吸い込み口タイプ-オ/").should == "http://rank.1new.biz/sharp-紙パック式クリーナー-床用吸い込み口タイプ-オ/"
    end

    it "handles https", vcr: { cassette_name: "follow_url/https", record: :once } do
      lambda { www.follow_url("https://www.youtube.com/watch?v=DM58Zdk7el0&feature=youtube_gdata_player") }.should_not raise_error(EOFError)
    end

    it "returns the same url if the name or service doesn't exist", vcr: { cassette_name: "follow_url/doesnt_exist", record: :once } do
      www.follow_url("http://cnnsadasdasdasdasdasd.com/asd").should == "http://cnnsadasdasdasdasdasd.com/asd"
    end

    it "returns actual asset link for an alias link", vcr: { cassette_name: "follow_url/alias_link", record: :once } do
      www.follow_url("http://yfrog.us/evlb0z:medium").should == "http://img535.imageshack.us/img535/9845/lb0.mp4"
    end

    it "does not raise a EOFError", vcr: { cassette_name: "follow_url/eoferror", record: :once } do
      lambda { www.follow_url("http://www.soulpancake.com/post/1607/whats-your-beautiful-mess.html") }.should_not raise_error
    end

    it 'works with a proxy', vcr: { cassette_name: "follow_url/proxy", record: :once } do
      www.proxy = "198.154.114.100:8080"
      www.follow_url("http://yfrog.us/evlb0z:medium").should == "http://img535.imageshack.us/img535/9845/lb0.mp4"
    end

    it "raises forbidden properly on a bad proxy", vcr: { cassette_name: "follow_url/proxy_forbidden", record: :once } do
      www.proxy = "190.202.116.101:3128"
      lambda { www.follow_url("http://yfrog.us/evlb0z:medium").should }.should raise_error(DubDubDub::Forbidden)
    end
  end
end
