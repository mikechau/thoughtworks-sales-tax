require_relative './lib/input'
require_relative './lib/transform'
require_relative './lib/calculator'
require_relative './lib/printer'
require_relative './lib/run_tax'

filename = ARGV.first
purchase = RunTax.new(filename)
purchase.execute