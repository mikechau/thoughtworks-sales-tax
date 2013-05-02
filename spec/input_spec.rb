require_relative "../lib/input"

describe "input" do 

  purchases = Input.new("input1.txt")

  it "should take the input file and turn it into an array" do
    purchases.items.class.should == Array
  end

  it "should take the exclusions file and turn it into an array" do
    purchases.exclusions.class.should == Array
  end

end