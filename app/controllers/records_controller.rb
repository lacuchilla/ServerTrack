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
    @hours_ago = 24
    @current_time = Time.now.utc
    @response = Record.where(created_at: @current_time - @hours_ago.hour..@current_time)
    @response.order! 'created_at DESC'
    #exit early if there are no records found in the past 24 hours
    if @response.length == 0
      render plain: "No records found for the past 24 hours"
    else
      #otherwise, set up a place for the record to go
      @everything = {}
      # these are the pointers to create each hour range
      @sub_one = 0
      @sub_two = 1

      #set the default values to calculate cpu and ram averages
      @cpu_total = 0
      @ram_total = 0
      @count = 0

      #go through each of the records
      # until @hours_ago == 0 do
      @response.each do |record|

        #determine the range for the current iteration
        @high_end = @current_time - @sub_one.hour
        @low_end = @current_time - @sub_two.hour
        @range = @high_end..@low_end

        @range_label = "#{@high_end.to_formatted_s(:long)} to #{@low_end.to_formatted_s(:long)}"

        if !(record.created_at < @high_end && record.created_at > @low_end)
          #move to the next record (go back to line 31 with a new record)
          #check for zero

          @count = 1 if @count == 0
          #do the calculation

          @cpu_average = @cpu_total/@count
          @ram_average = @ram_total/@count
        #set the key and values for the range and move to the next timeframe
          @everything[@range_label] = ["CPU average: #{@cpu_average}, RAM average: #{@ram_average}"]
          @sub_one += 1
          @sub_two += 1
          # @hours_ago-=1
          #reset the defaults for calculation
          @cpu_total = 0
          @ram_total = 0
          @count = 0
        end

        @cpu_total += record.cpu
        @ram_total += record.ram
        @count += 1

        # next
      end

      @count = 1 if @count == 0
      #do the calculation
      @cpu_average = @cpu_total/@count
      @ram_average = @ram_total/@count
    #set the key and values for the range and move to the next timeframe
      @everything[@range_label] = ["CPU average: #{@cpu_average}, RAM average: #{@ram_average}"]

      until @everything.length == 24
        @sub_one += 1
        @sub_two += 1

        @high_end = @current_time - @sub_one.hour
        @low_end = @current_time - @sub_two.hour

        @range_label = "#{@high_end.to_formatted_s(:long)} to #{@low_end.to_formatted_s(:long)}"

        @everything[@range_label] = ["CPU average: 0, RAM average: 0"]
      end

render json: @everything
    end


    #   @count = 0
    #     @cpu_total = 0
    #     @ram_total = 0
    #     #set range
    #     @high_end = @current_time
    #     @low_end = @current_time-1.hour
    #     @range = @high_end..@low_end
    # @response.each do |record|
    #   #set up max and min time
    #   #@max_cap = @current_time - @second_hour.hour
    #   #@min_cap = @current_time - @first_hour.hour
    #   #set up label for current timeframe
    #   #@timespan = "#{@min_cap.to_formatted_s(:long)} to #{@max_cap.to_formatted_s(:long)}"
    #
    #
    #   #@everything["Average load values for #{params[:server_id]} server from #{@min_cap.to_formatted_s(:long)} to #{@max_cap.to_formatted_s(:long)}"] = "hi"
    #
    #
    #     #check the created_at time of each record]
    #     #if the created_at ime is within the timeframe
    #     if record.created_at < @high_end && record.created_at > @low_end
    #       #increase values
    #       @cpu_total += record.cpu
    #       @ram_total += record.ram
    #       @count += 1
    #
    #     else
    #     #if the created_at time is outside of the timeframe
    #     #check if there are no records found
    #       @range_label = "#{@high_end.to_formatted_s(:long)} to #{@low_end.to_formatted_s(:long)}"
    #       if @count == 0
    #         @everything[@range_label] = "No records for this timeframe"
    #         next
    #       else
    #     #otherwise divide the values
    #
    #         @cpu_average = @cpu_total/@count
    #         @ram_average = @ram_total/@count
    #     #assign value to the key of range
    #
    #         @everything[@range_label]= [@cpu_average, @ram_average]
    #     #increment values to set up the range boundaries for the next iteration
    #       @high_end+=1
    #       @low_end+=1
    #       #make new range label
    #
    #       #decrement limit
    #       @limit -=1
    #       #reset @count
    #       @count = 0
    #       next
    #     end
    #       end
    #     end
    #   end
    # end
    # render json: @everything
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
