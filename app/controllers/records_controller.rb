class Averager
  def initialize(response, current_time, number_of_buckets, to_time)
    @number_of_buckets = number_of_buckets
    @response = response.where(created_at: current_time - to_time.call(number_of_buckets)..current_time)
    @current_time = current_time
    @to_time = to_time
  end

  def calculate
    @everything = {}
    move_to_next_range

    @response.each do |record|
      while not_in_range? record
        record_current_range
      end

      @cpu_total += record.cpu
      @ram_total += record.ram
      @count += 1
    end

    record_current_range

    until @everything.length == @number_of_buckets
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

    range_label = "#{@high_end.to_formatted_s(:long)} to #{@low_end.to_formatted_s(:long)}"
    @everything[range_label] = ["CPU average: #{@cpu_average}, RAM average: #{@ram_average}"]
    move_to_next_range
  end

  def move_to_next_range
    @cpu_total = 0
    @ram_total = 0
    @count = 0
    @offset ? @offset += 1 : @offset = 0
    set_range
  end

  def set_range
    @high_end = @current_time - @to_time.call(@offset)
    @low_end = @current_time - @to_time.call(@offset + 1)
  end

end

class RecordsController < ApplicationController
skip_before_filter :verify_authenticity_token
  def index
    @records = Record.all
    render json: @records
  end

  def show
    current_time = Time.now.utc
    response = Record.where(created_at: current_time - 24.hour..current_time)
    response.order! 'created_at DESC'

    if response.length == 0
      render plain: "No records found for the past 24 hours"
    else
      hour_averager = Averager.new response, current_time, 24, lambda {|timestamp| timestamp.hour }
      min_averager = Averager.new response, current_time, 60, lambda {|offset| offset.minute }
      render json: {:minutes => min_averager.calculate, :hours => hour_averager.calculate}
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
