require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
    before(:each) do
        @entry_station = double("station")
        @exit_station = double("station")
    end

    describe '#initialize' do
      it "card has a balance" do
        expect(oystercard.balance).to eq(0)
      end

      it "has a empty list of journeys by default" do
        expect(oystercard.list_of_journeys).to eq([])
      end

    end

    describe '#top_up' do

      it { is_expected.to respond_to(:top_up).with(1).argument }

      it 'can top up the balance' do
        expect{ oystercard.top_up 1 }.to change{ oystercard.balance }.by 1
      end

      it "to raise an error if the maximum balance is exceeded" do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        oystercard.top_up(maximum_balance)
        expect{ oystercard.top_up 1 }.to raise_error 'maximum balance #{MAXIMUM_BALANCE} exceeded'
      end
    end

    # it { is_expected.to respond_to(:deduct).with(1).argument }

    # it "can deduct from the card" do
    #     expect{ subject.deduct 1 }.to change{ subject.balance }.by -1
    # end
    describe '#touch_in' do
      it { is_expected.to respond_to(:touch_in)}

      it "card touch in, card status changed to in use" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(@entry_station)
        expect(oystercard.in_journey?).to eq true
      end

      it "store entry station when touch in" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(@entry_station)
        expect(oystercard.entry_station).to eq(@entry_station)
      end

      it "raises an exception when user tries to touch in with less than £1 balance" do
        expect {oystercard.touch_in(@entry_station)}.to raise_error "minimum balance"
      end

    end

    describe '#touch_out' do

      it "card touch out, card status not in use" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        expect(oystercard.in_journey?).to eq false
      end

      it "charging the minimum fare on touch out" do
        expect {oystercard.touch_out(@exit_station)}.to change{oystercard.balance}.by(-1)
      end

      it "accepts an exit station" do
        oystercard.touch_out(@exit_station)
        expect(oystercard.exit_station).to eq(@exit_station)
      end

    end

    describe "#in_journey" do

      it "card touches in and we are in journey" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(@entry_station)
        expect(oystercard.in_journey?).to be true
      end

      it "card touches out and we are in journey" do
        oystercard.touch_out(@exit_station)
        expect(oystercard.in_journey?).to be false
      end

    end

    describe '#journey_log' do

      it "tells you your previous journeys" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(@entry_station)
        oystercard.touch_out(@exit_station)
        expect{oystercard.journey_log}.to output("#{@entry_station} to #{@exit_station}").to_stdout
      end

      it "touching in and out creates one journey" do
        oystercard.top_up(Oystercard::MINIMUM_BALANCE)
        oystercard.touch_in(@entry_station)
        oystercard.touch_out(@exit_station)
        expect(oystercard.journey_log.length).to eq(1)
      end

    end

end
