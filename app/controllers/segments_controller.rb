class SegmentsController < ApplicationController
  def index
    @segments = Segment.all
  end

  def show
    @segment = Segment.find params[:id]
    form_labels = {
      name: ['$view'],
      match: ['~', '$', '!', '^', '#', '!^', '!$', 'empty', '!empty'],
      property: ['page', 'url']
    }

    @options_for_select_match = Array.new
    form_labels[:match].each do |match|
      @options_for_select_match << [t("segments.filters.matches.#{match}"), match]
    end

    @options_for_select_name = Array.new
    form_labels[:name].each do |name|
      @options_for_select_name << [t("segments.filters.names.#{name}"), name]
    end

    @options_for_select_property = Array.new
    form_labels[:property].each do |property|
      @options_for_select_property << [t("segments.filters.properties.#{property}"), property]
    end
  end



end
