class Printer

  attr_reader :output

  def initialize(items, sales_tax, total_all)
    @items = items
    @sales_tax = sales_tax
    @total_all = total_all
    @output = []
  end

  def execute
    set_output
    display(@output)
    return @output
  end

  def set_output
    generate_items(@items, @output)
    generate_totals(@sales_tax, @total_all, @output)
  end

  def generate_items(items, list)
    items.each do |item|
      list << "#{item[:qty]} #{item[:name]}: #{"%.2f" % item[:total]}"
    end
  end

  def generate_totals(sales_tax_amt, total_all_amt, list)
    list << "Sales Total: #{"%.2f" % sales_tax_amt}"
    list << "Total: #{"%.2f" % total_all_amt}"
  end

  def display(output)
    puts output
    return true
  end

end