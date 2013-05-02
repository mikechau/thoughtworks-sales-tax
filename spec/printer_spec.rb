require_relative '../lib/printer'

describe "printer" do

  items = [ 
            {name: "chocolate bear", qty: 1, price: 0.85, good: false, import: false, good_tax: 0.0, import_tax: 0.0, sales_tax: 0.0, total: 0.85}, 
            {name: "imported goldfish", qty: 1, price: 599.99, good: true, import: true, good_tax: 60.0, import_tax: 30.0, sales_tax: 90.0, total: 689.99}, 
            {name: "bullfrog", qty: 1, price: 10.99, good: true, import: false, good_tax: 1.1, import_tax: 0.0, sales_tax: 1.1, total: 12.09}
          ]

  purchases = Printer.new(items, 91.1, 702.93)

  it "should display the list of items" do
    list = []
    purchases.generate_items(items, list)
    list.should == ["1 chocolate bear: 0.85", "1 imported goldfish: 689.99", "1 bullfrog: 12.09"]
  end

  it "should display the totals" do 
    list = []
    purchases.generate_totals(5,5, list)
    list.should == ["Sales Total: 5.00", "Total: 5.00"]
  end

  it "should return true after printing the output" do
    results = ["1 chocolate bear: 0.85", "1 imported goldfish: 689.99", "1 bullfrog: 12.09"]
    purchases.display(results).should == true
  end

  it "should display the item qty, name, total price, sales tax and total" do
    purchases.execute
    purchases.output.should == ["1 chocolate bear: 0.85", "1 imported goldfish: 689.99", "1 bullfrog: 12.09", "Sales Total: 91.10", "Total: 702.93"]
  end
end