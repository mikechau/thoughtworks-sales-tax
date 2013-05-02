class Calculator

  attr_reader :items, :total_all, :sales_tax

  def initialize(items)
    @items = items
    @good_tax_rate = 0.10
    @import_tax_rate = 0.05
    @nearest_cent = 1 / 0.05
    @total_all = 0.0
    @sales_tax = 0.0
  end

  def execute
    update_amounts
    set_totals
  end

  # Tax Calculations
  ## update_amounts runs set_tax to set the amount of tax for good and import and then takes those amounts and adds them to sales_tax and total through add_taxes
  def update_amounts
    @items = @items.each do |item|
      item[:good_tax] = set_tax(item[:good], item[:total], @good_tax_rate)
      item[:import_tax] = set_tax(item[:import], item[:total], @import_tax_rate)
      item[:sales_tax] = add_taxes(item[:sales_tax], item[:good_tax], item[:import_tax])
      item[:total] = add_taxes(item[:total], item[:good_tax], item[:import_tax])
    end
  end

  ## set_tax returns the item tax amount, it first checks if the tax flag  (good/import) is set to true, if true it runs compute_tax which calculates the tax amount and then rounds with round_tax. if the tax flag is false, it will return 0.0
  def set_tax(status, base_total, tax_rate)
    if status == true
      amt = compute_tax(base_total, tax_rate)
      round_tax(amt)
    else
      0.0
    end
  end

  ## get_tax runs compute_tax to calculate the item tax amount and the amount is rounded with round_tax
  def get_tax(item_price, tax_rate)
    amt = compute_tax(item_price, tax_rate)
    round_tax(amt)
  end

  ## compute_tax multiplies the item price by tax rate
  def compute_tax(item_price, tax_rate)
    item_price * tax_rate
  end

  ## round_tax takes the amount and multiplies it by the nearest_cent and then applys a ceil, and then it is divided by the nearest cent
  def round_tax(amt)
    ((amt * @nearest_cent).ceil / @nearest_cent)
  end

  ## adds good and import tax amounts and rounds the total up
  def add_taxes(amt, good_tax, import_tax)
    amt += good_tax + import_tax
    amt.round(2)
  end

  # Total Calculations
  ## set_totals sets the amounts for @sales_tax and @total_all by running compute_total
  def set_totals
    @sales_tax = compute_total('sales_tax')
    @total_all = compute_total('total')
  end

  ## compute total first runs capture_amounts to build a list of all the item totals and then it adds them together with generate_total
  def compute_total(type)
    list = capture_amounts(type)
    generate_total(list)
  end 

  ## capture_amounts maps out the totals from @items
  def capture_amounts(type)
    @items.map { |key, value| key[type.to_sym] }
  end

  ## generate_total takes an array of totals and adds them all together and rounds it up 
  def generate_total(list)
    list.inject(:+).round(2)
  end

end