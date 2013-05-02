class Transform

  attr_reader :items

  def initialize(list, exclusions)
    @list = list
    @exclusions = exclusions
    @items = []
  end

  def generate
    @items = clean(parser(@list))
  end

  def clean(parsed_list)
    items = parsed_list.select { |item| item[:qty] > 0 }
  end

  def parser(input_list)
    parsed_list = []
    list = cut(capture(input_list))
    list.each do |item|
      update_items(item, parsed_list)
    end
    return parsed_list
  end

  def capture(list)
    list.select { |item| item =~ /at/ }
  end

  def cut(items)
    items.map! { |item| item.downcase.strip.split(/\s/) }
  end

  def update_items(item, parsed_list)
    parsed_list << detect(item)
  end

  def detect(item)
    detected_item = { name: detect_name(item),
                      qty: detect_qty(item),
                      price: detect_price(item),
                      good: classify_good(item),
                      import: classify_import(item),
                      good_tax: value,
                      import_tax: value,
                      sales_tax: sales_tax(value, value),
                      total: calculate_total(item, value)
                    }
  end

  def detect_name(item)
    end_point = (item.index "at") - 1
    name = item[1..end_point].join(" ")
  end

  def detect_qty(item)
    item[0].to_i
  end

  def detect_price(item)
    start_point = (item.index "at") + 1
    end_point = item.size
    price = item[start_point..end_point]
    return price[0].to_f
  end

  def classify_good(item)
    intersection = item & @exclusions
    intersection = intersection.join(" ")
    return intersection != "" ? false : true
  end

  def classify_import(item)
    check_import = item.include? 'imported'
    return check_import == true ? true : false
  end

  def value
    0.0
  end

  def sales_tax(good_tax, import_tax)
    tax = good_tax + import_tax
  end

  def calculate_total(item, sales_tax)
    total = detect_qty(item) * detect_price(item) + sales_tax
  end

end