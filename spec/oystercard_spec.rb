require 'oystercard'

describe Oystercard do
    before(:each) do
        @entry_station = double("station")
    end

    describe '#initialize' do
      it "card has a balance" do
        oystercard = Oystercard.new
        expect(subject.balance).to eq(0)
      end
    end

    describe '#top_up' do

      it { is_expected.to respond_to(:top_up).with(1).argument }

      it 'can top up the balance' do
        expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
      end

      it "to raise an error if the maximum balance is exceeded" do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        subject.top_up(maximum_balance)
        expect{ subject.top_up 1 }.to raise_error 'maximum balance #{MAXIMUM_BALANCE} exceeded'
      end
    end

    # it { is_expected.to respond_to(:deduct).with(1).argument }

    # it "can deduct from the card" do
    #     expect{ subject.deduct 1 }.to change{ subject.balance }.by -1
    # end
    describe '#touch_in' do
      it { is_expected.to respond_to(:touch_in)}

      it "card touch in, card status changed to in use" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(@entry_station)
        expect(subject.state).to eq true
      end

      it "store entry station when touch in" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(@entry_station)
        expect(subject.entry_station).to eq(@entry_station)
      end

      it "raises an exception when user tries to touch in with less than £1 balance" do
        expect {subject.touch_in(@entry_station)}.to raise_error "minimum balance"
      end
      
    end

    describe '#touch_out' do
    
      it "card touch out, card status not in use" do 
        subject.top_up(Oystercard::MINIMUM_BALANCE)    
        expect(subject.touch_out).to eq false
      end

      it "charging the minimum fare on touch out" do
        expect {subject.touch_out}.to change{subject.balance}.by(-1)
      end

    end
 
    describe "#in_journey" do

      it "card touches in and we are in journey" do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(@entry_station)
        expect(subject.in_journey?).to be true
      end

      it "card touches out and we are in journey" do
        subject.touch_out
        expect(subject.in_journey?).to be false
      end

    end

end

