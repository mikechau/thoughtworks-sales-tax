require_relative '../lib/input'
require_relative '../lib/transform'
require_relative '../lib/calculator'
require_relative '../lib/printer'

class RunTax

  def initialize(filename)
    @filename = filename
  end

  def input(filename)
    file = Input.new(filename)
  end

  def parse(file, exclusions)
    list = Transform.new(file, exclusions)
    list.generate
    return list
  end

  def calc(list)
    costs = Calculator.new(list)
    costs.execute
    return costs
  end

  def print(items, sales_tax, total)
    show = Printer.new(items, sales_tax, total)
    show.execute
    return show
  end

  def execute
    input = input(@filename)
    parsed_list = parse(input.items, input.exclusions)
    calculate = calc(parsed_list.items)
    print(calculate.items, calculate.sales_tax, calculate.total_all)
  end
end