class Oystercard

    attr_reader :entry_station, :state, :balance, :exit_station

    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1

    def initialize
      @balance = 0
      @journey = {}
      @list_of_journeys = []
    end

    def top_up(amount)
        fail 'maximum balance #{MAXIMUM_BALANCE} exceeded' if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def touch_in(station)
      raise "minimum balance" if @balance < MINIMUM_BALANCE
      @entry_station = station
      @journey["entry station"] = @entry_station
      return station
    end

    def touch_out(exit_station)
      deduct(MINIMUM_BALANCE)
      @entry_station = nil
      @exit_station = exit_station
      @journey["exit station"] = @exit_station
    end

    def in_journey?
      !@entry_station.nil?
    end

    def journey_log
      @list_of_journeys << @journey
      @list_of_journeys.each do |index|
       print "#{index["entry station"]} to #{index["exit station"]}"
      end
    end

  private

    def deduct(amount)
      @balance -= amount
    end

end
