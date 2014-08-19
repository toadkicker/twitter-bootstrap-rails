# encoding: utf-8
require 'spec_helper'
require 'action_view'
require 'active_support'
require 'rspec/active_model/mocks'

require_relative '../../../app/helpers/form_errors_helper'

include ActionView::Helpers
include ActionView::Context
include FormErrorsHelper

describe FormErrorsHelper, :type => :helper do
	before do
    @output_buffer = ''
    double
    @base_errors = ['base error meserrorssage', 'nasty error']
    @base_error = 'one base error'
    @errors = double('errors', :errors => ActionView::Template::Error)
    @new_post.stub(:errors).and_return(@errors)
  end

  describe 'when there is only one error on base' do
    before do
      @errors.stub(:[]).with(errors(:base)).and_return(@base_error)
    end

    it 'should render an alert with an unordered list' do
      form_for(@new_post) do |builder|
        builder.semantic_errors.should have_tag('.alert.alert-error ul.error-list li', @base_error)
      end
    end
  end

  describe 'when there is more than one error on base' do
    before do
      @errors.stub(:[]).with(errors(:base)).and_return(@base_errors)
    end

    it 'should render an unordered list' do
      form_for(@new_post) do |builder|
        builder.semantic_errors.should have_tag('.alert.alert-error ul.error-list')
        @base_errors.each do |error|
          builder.semantic_errors.should have_tag('.alert.alert-error ul.error-list li', error)
        end
      end
    end
  end

  describe 'when there are errors on title' do
    before do
      @errors.stub(:[]).with(errors(:title)).and_return(@title_errors)
      @errors.stub(:[]).with(errors(:base)).and_return([])
    end

    it 'should render an unordered list' do
      form_for(@new_post) do |builder|
        title_name = builder.send(:localized_string, :title, :title, :label) || builder.send(:humanized_attribute_name, :title)
        builder.semantic_errors(:title).should have_tag('.alert.alert-error ul.error-list li', title_name << " " << @title_errors.to_sentence)
      end
    end
  end

  describe 'when there are errors on title and base' do
    before do
      @errors.stub(:[]).with(errors(:title)).and_return(@title_errors)
      @errors.stub(:[]).with(errors(:base)).and_return(@base_error)
    end

    it 'should render an unordered list' do
      form_for(@new_post) do |builder|
        title_name = builder.send(:localized_string, :title, :title, :label) || builder.send(:humanized_attribute_name, :title)
        builder.semantic_errors(:title).should have_tag('.alert.alert-error ul.error-list li', title_name << " " << @title_errors.to_sentence)
        builder.semantic_errors(:title).should have_tag('.alert.alert-error ul.error-list li', @base_error)
      end
    end
  end

  describe 'when there are no errors' do
    before do
      @errors.stub(:[]).with(errors(:title)).and_return(nil)
      @errors.stub(:[]).with(errors(:base)).and_return(nil)
    end

    it 'should return nil' do
      form_for(@new_post) do |builder|
        builder.semantic_errors(:title).should be_nil
      end
    end
  end

  describe 'when there is one error on base and options with class is passed' do
    before do
      @errors.stub(:[]).with(errors(:base)).and_return(@base_error)
    end

    it 'should render an unordered list with given class' do
      form_for(@new_post) do |builder|
        builder.semantic_errors(:class => "awesome").should have_tag('.alert.alert-error.awesome ul.error-list li', @base_error)
      end
    end
  end

  describe 'when :base is passed in as an argument' do
    before do
      @errors.stub(:[]).with(errors(:base)).and_return(@base_error)
    end

    it 'should ignore :base and only render base errors once' do
      form_for(@new_post) do |builder|
        builder.semantic_errors(:base).should have_tag('ul li', :count => 1)
        builder.semantic_errors(:base).should_not have_tag('ul li', "Base #{@base_error}")
      end
    end
  end
end

ERRORS_SPAN = %{<span class="help-inline">Error</span>}