#Method object for calculating averages
class Averger
  def initialize(response, current_time)
    @response = response
    @current_time = current_time
  end

  def calculate
    #otherwise, set up a place for the record to go
    # these are the pointers to create each hour range
    @everything = {}
    @sub_one = -1
    @sub_two = 0
    move_to_next_range
    #go through each of the records
    # until @hours_ago == 0 do
    @response.each do |record|
      while not_in_range? record
        record_current_range
      end

      @cpu_total += record.cpu
      @ram_total += record.ram
      @count += 1
    end

    record_current_range

    until @everything.length == 24
      record_current_range
    end

    @everything
  end

  def not_in_range?(record)
    !(record.created_at < @high_end && record.created_at > @low_end)
  end

  def record_current_range
    @count = 1 if @count == 0
    @cpu_average = @cpu_total/@count
    @ram_average = @ram_total/@count
    #set the key and values for the range and move to the next timeframe
    @everything[@range_label] = ["CPU average: #{@cpu_average}, RAM average: #{@ram_average}"]
    move_to_next_range
  end

  def move_to_next_range
    @cpu_total = 0
    @ram_total = 0
    @count = 0

    @sub_one += 1
    @sub_two += 1
    @high_end = @current_time - @sub_one.hour
    @low_end = @current_time - @sub_two.hour
    @range_label = "#{@high_end.to_formatted_s(:long)} to #{@low_end.to_formatted_s(:long)}"
  end
end

class RecordsController < ApplicationController
skip_before_filter :verify_authenticity_token
  def index
    @records = Record.all
    render json: @records
  end

  def show
    # todo: figure out how to get the records in time descending order
    # fix ability to get to next record in list instead of staying stuck
    # make sure time ranges with no records are still getting added with zeros for the values
    # iterate over the each minute of the first hour

    #get records for the last 24 hours from the database
    hours_ago = 24
    current_time = Time.now.utc
    response = Record.where(created_at: current_time - hours_ago.hour..current_time)
    response.order! 'created_at DESC'
    #exit early if there are no records found in the past 24 hours
    if response.length == 0
      render plain: "No records found for the past 24 hours"
    else
      averager = Averger.new response, current_time
      render json: averager.calculate
    end
  end



  def create
    @record = Record.new(record_params)
    if @record.save
      render json: @record
    end
  end

  private
  def record_params
    params.permit(:id, :cpu, :ram, :server_id)
  end
end
