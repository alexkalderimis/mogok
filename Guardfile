require 'active_support/core_ext'

guard 'spork' do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('spec/support/')
  watch('myapp.rb')           # for example, reload spork when myapp.rb is changed
end

guard 'rspec', :wait => 60, :all_after_pass => false, :cli => '--drb' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/factories/.+\.rb$})
  watch('spec/spec_helper.rb')                { "spec" }
  watch(%r{^spec/support/(.+)\.rb$})          { "spec" }
  watch('mogok.rb')                           { "spec" }
end
