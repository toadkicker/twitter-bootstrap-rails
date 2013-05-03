require 'spec_helper'

describe 'bootstrap:install' do

  context "accepts arguments for stylesheets" do
    with_args :static do
      it "adds static assets" do
        subject.should generate 'app/assets/javascripts/application.js'
      end
    end
  end

  context "with no arguments" do
    it "copies the expected files to their locations" do
      files = ['app/assets/javascripts/application.js','app/assets/javascripts/bootstrap.js.coffee', 'app/assets/javascripts/bootstrap.js.coffee',
               'app/assets/stylesheets/bootstrap_and_overrides.css.less', 'config/locales/en.bootstrap.yml', 'app/assets/stylesheets/application.css']
      files.each do |f|
        subject.should generate(f)
      end
    end
  end
end
