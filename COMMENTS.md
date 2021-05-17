# Calculate the second lowest cost silver plan

A script to determine the second lowest cost silver plan (SLCSP) for a group of ZIP codes.

## Requirements

* Ruby (confirmed to work with versions 3.0.0 and 2.4.1)
* An input CSV file of zip codes to check, like [data/slcsp.csv](data/slcsp.csv)
* A CSV file of insurance plans, like [data/plans.csv](data/plans.csv)
* A CSV file of zip codes in the US, like [data/zips.csv](data/zips.csv)
* Bundler is needed to run the tests

## Running the script

From the main project directory, run:

`ruby bin/calculate_slcsp.rb`

Or, to use CSVs other than the default files, include pathnames as arguments:

`ruby bin/calculate_slcsp.rb input.csv plans.csv zips.csv`

The resulting CSV output is printed to the terminal

## Running the tests

`bundle install` to install rspec, then:

`bundle exec rake spec`
