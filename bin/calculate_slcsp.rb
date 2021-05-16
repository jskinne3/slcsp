require 'csv'

def rate_areas_for_zip(zip:, zips:)
  # Return rate areas (state/number pairs e.g. NY 1, IL 14) within zip
  row_matches = zips.select{|row| row['zipcode'] == zip}
  rate_tuples = row_matches.map{|i| [i['state'], i['rate_area'].to_s]}
  return rate_tuples.uniq  # array of arrays, or empty array
end

def rates_for_rate_area(rate_area:, plans:)
  # Find rates (0 or more) from plans operating in an area (state/number pair)
  in_area = plans.select{|r|
    r['state'] == rate_area[0] &&
    r['rate_area'].to_s == rate_area[1].to_s
  }
  return in_area.map{|p| p['rate'].to_f } # array of floats, or empty
end

def plans_by_metal_level(metal:, plans:)
  # Return subset of plans table within metal tier (e.g. Silver, Gold)
  plans.select{ |p| p['metal_level'] == metal }
end

def nth_lowest_rate(n:, rates:)
  # Find lowest, 2nd-lowest, etc. rate in an array of numbers
  # If impossible (e.g. 2nd-lowest in an array of only 1) return nil
  r = 0
  n.times do
    r = rates.delete(rates.min)
  end
  return r # float, integer, or nil
end

def benchmark_rate_in_area(rate_area:, plans:)
  # Output 2nd-lowest rate in a rate area with 2 decimal places
  rates = rates_for_rate_area(rate_area: rate_area, plans: plans)
  second_lowest = nth_lowest_rate(n: 2, rates: rates)
  second_lowest = '%.2f' % second_lowest if second_lowest.is_a? Float
  return second_lowest # string or nil
end

def get_inputs(input_file:, plans_file:, zips_file:)
  input = CSV.read(input_file, headers: true)
  plans = CSV.read(plans_file, headers: true)
  zips  = CSV.read(zips_file,  headers: true)
  return input, plans, zips
end

def calcualte_slcsp_rates_from_table(input:, plans:, zips:)
  # Iterate over input zips. Output benchmark rate for each zip, or if the
  # number of rates (or rate areas) is higher or lower than 1, print blank.
  for item in input
    rate_areas = rate_areas_for_zip(zip:item['zipcode'], zips: zips)
    if rate_areas.length == 1
      rate = benchmark_rate_in_area(rate_area: rate_areas[0], plans: plans)
      puts "#{item.to_s.strip}#{rate}"
    else
      puts item.to_s.strip
    end
  end
end

# Run if file is invoked from command line, guard from tests
if $0 == __FILE__

  # Gather optional command line arguments
  input = ARGV[0] ? ARGV[0] : 'data/slcsp.csv'
  plans = ARGV[1] ? ARGV[1] : 'data/plans.csv'
  zips  = ARGV[2] ? ARGV[2] : 'data/zips.csv'

  # Open 3 csv files: 2 data sources and 1 list of zips to calculate rates for
  input, plans, zips = get_inputs(
    input_file: input,
    plans_file: plans,
    zips_file:  zips
  )

  # Subset all plans to only Silver plans
  plans = plans_by_metal_level(metal: "Silver", plans: plans)

  # Calculate the SLCSP for all input file zips and print
  output = calcualte_slcsp_rates_from_table(
    input: input,
    plans: plans,
    zips:  zips
  )

end
