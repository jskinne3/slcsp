# Usage: bundle exec rake spec

require_relative '../bin/calculate_slcsp'

describe '#rate_areas_for_zip' do
  zips = [
    {'zipcode' => '12345', 'state' => 'OK', 'rate_area' => 1},
    {'zipcode' => '12345', 'state' => 'OK', 'rate_area' => 2},
    {'zipcode' => '12345', 'state' => 'OK', 'rate_area' => 3},
    {'zipcode' => '54321', 'state' => 'OK', 'rate_area' => 9},
    {'zipcode' => '54321', 'state' => 'OK', 'rate_area' => 9}
  ]
  it 'should return multipe rate areas if unique' do
    expect(rate_areas_for_zip(zip: '12345', zips: zips)).to eq [["OK", "1"], ["OK", "2"], ["OK", "3"]]
  end
  it 'should return multipe rate areas if overlap' do
    expect(rate_areas_for_zip(zip: '54321', zips: zips)).to eq [["OK", "9"]]
  end
  it 'should return an empty array if zip code cannot be found' do
    expect(rate_areas_for_zip(zip: '00001', zips: zips)).to eq []
  end
end

describe '#rates_for_rate_area' do
  plans = [
    {'state' => 'OK', 'rate_area' => 1, 'rate' => 10.0},
    {'state' => 'OK', 'rate_area' => 2, 'rate' => 20.0},
    {'state' => 'OK', 'rate_area' => 5, 'rate' => 5.0},
    {'state' => 'IL', 'rate_area' => 5, 'rate' => 15.0},
    {'state' => 'IL', 'rate_area' => 5, 'rate' => 25.0},
  ]
  it 'returns multiple rates' do
    expect(rates_for_rate_area(rate_area: ['IL', '5'], plans: plans)).to eq [15.0, 25.0]
  end
  it 'returns a single rate' do
    expect(rates_for_rate_area(rate_area: ['OK', '2'], plans: plans)).to eq [20.0]
  end
  it 'returns an empty array' do
    expect(rates_for_rate_area(rate_area: ['IL', '1'], plans: plans)).to eq []
  end
end

describe '#plans_by_metal_level' do
  plans = [
    {'metal_level' => 'Bronze'},
    {'metal_level' => 'Silver'},
    {'metal_level' => 'Gold'}
  ]
  it 'should find silver plan' do
    expect(plans_by_metal_level(metal: 'Silver', plans: plans)).to eq [{'metal_level' => 'Silver'}]
  end
  it 'should return empty array when asked to find a nonexistent metal' do
    expect(plans_by_metal_level(metal: 'Unobtanium', plans: plans)).to eq []
  end
end

describe '#nth_lowest_rate' do
  it 'should handle floating points' do
    expect(nth_lowest_rate(n: 1, rates: [0.01])).to eq 0.01
  end
  it 'should should find the lowest rate among 2 rates' do
    expect(nth_lowest_rate(n: 1, rates: [5,10])).to eq 5
  end
  it 'should should find the 2nd lowest rate among 2 rates' do
    expect(nth_lowest_rate(n: 2, rates: [5,10])).to eq 10
  end
  it 'should should find the 2nd lowest rate among 3 rates' do
    expect(nth_lowest_rate(n: 2, rates: [5,10,15])).to eq 10
  end
  it 'should should find the 3nd lowest rate among 3 rates' do
    expect(nth_lowest_rate(n: 3, rates: [5,10,15])).to eq 15
  end
  it 'should return a rate when all rates are the same and asked for lowest' do
    expect(nth_lowest_rate(n: 1, rates: [5,5,5])).to eq 5
  end
  it 'should return nil when all rates are the same and asked for 2nd lowest' do
    expect(nth_lowest_rate(n: 2, rates: [5,5,5])).to eq nil
  end
  it 'should return nil when given zero rates' do
    expect(nth_lowest_rate(n: 1, rates: [])).to eq nil
  end
  it 'should should return nil when n is larger than rates length' do
    expect(nth_lowest_rate(n: 2, rates: [5])).to eq nil
  end

  describe '#benchmark_rate_in_area' do
  plans = [
    {'state' => 'AK', 'rate_area' => 1, 'rate' => 10.0},
    {'state' => 'AL', 'rate_area' => 1, 'rate' => 20.0},
    {'state' => 'AL', 'rate_area' => 1, 'rate' => 25.0},
    {'state' => 'AR', 'rate_area' => 1, 'rate' => 30.0},
    {'state' => 'AR', 'rate_area' => 1, 'rate' => 35.0},
    {'state' => 'AR', 'rate_area' => 2, 'rate' => 40.0},
    {'state' => 'AR', 'rate_area' => 2, 'rate' => 40.0}
  ]
    it 'find 2nd lowest rate distinguished by state' do
      expect(benchmark_rate_in_area(rate_area: ['AL', 1], plans: plans)).to eq "25.00"
    end
    it 'find 2nd lowest rate distinguished by number' do
      expect(benchmark_rate_in_area(rate_area: ['AR', 1], plans: plans)).to eq "35.00"
    end
    it 'return nil when only one rate in area' do
      expect(benchmark_rate_in_area(rate_area: ['AK', 1], plans: plans)).to eq nil
    end
    it 'handle identical plans' do
      expect(benchmark_rate_in_area(rate_area: ['AR', 2], plans: plans)).to eq nil
    end
  end

  # TODO: add tests for remaining methods in calculate_slcsp.rb
 
end
