VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr"
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :once }
end