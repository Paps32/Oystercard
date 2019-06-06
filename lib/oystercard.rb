class Oystercard

    attr_reader :entry_station, :state, :balance, :exit_station

    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1

    def initialize
      @balance = 0
    end

    def top_up(amount)
        fail 'maximum balance #{MAXIMUM_BALANCE} exceeded' if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def touch_in(station)
      raise "minimum balance" if @balance < MINIMUM_BALANCE
      @entry_station = station
      return station
    end

    def touch_out(exit_station)
      deduct(MINIMUM_BALANCE)
      @entry_station = nil
      @exit_station = exit_station
    end

    def in_journey?
      !@entry_station.nil?
    end

  private

    def deduct(amount)
      @balance -= amount
    end

end
