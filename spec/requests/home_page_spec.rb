require 'spec_helper'

describe 'the home page' do
    subject { page }

    describe 'Home page' do
        before { visit '/' }
        it { should have_content('Yo') }
    end
end
