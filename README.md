# PROBLEM TWO: SALES TAXES
***
 Basic sales tax is applicable at a rate of 10% on all goods, except books, food, and medical products that are exempt. Import duty is an additional sales tax applicable on all imported goods at a rate of 5%, with no exemptions.

When I purchase items I receive a receipt which lists the name of all the items and their price (including tax), finishing with the total cost of the items, and the total amounts of sales taxes paid.  The rounding rules for sales tax are that for a tax rate of n%, a shelf price of p contains (np/100 rounded up to the nearest 0.05) amount of sales tax.

Write an application that prints out the receipt details for these shopping baskets...
***
### INPUT:

*Input 1*:
>1 book at 12.49  
>1 music CD at 14.99  
>1 chocolate bar at 0.85  

*Input 2*:
>1 imported box of chocolates at 10.00  
>1 imported bottle of perfume at 47.50  

*Input 3*:
>1 imported bottle of perfume at 27.99  
>1 bottle of perfume at 18.99  
>1 packet of headache pills at 9.75  
>1 box of imported chocolates at 11.25  

### OUTPUT

*Output 1*:
>1 book : 12.49  
>1 music CD: 16.49  
>1 chocolate bar: 0.85  
>Sales Taxes: 1.50  
>Total: 29.83  

*Output 2*:
>1 imported box of chocolates: 10.50  
>1 imported bottle of perfume: 54.65  
>Sales Taxes: 7.65  
>Total: 65.15  

*Output 3*:
>1 imported bottle of perfume: 32.19  
>1 bottle of perfume: 20.89  
>1 packet of headache pills: 9.75  
>1 imported box of chocolates: 11.85  
>Sales Taxes: 6.70  
>Total: 74.68  
  
***
## Introduction
This is for the Thoughtworks Coding Challenege, I am applying for a Junior Consultant Role / Entry Level Developer.  

### How to Run
`ruby generate.rb <filename>.txt`  
*Note*: The text file must be placed in the `input` folder. 3 files from the problem have been included for your convenience.  
#### Input Files:
- input1.txt
- input2.txt
- input3.txt
  
***
### Testing
Tests were done with `rspec`.  
`rspec spec/<filename>.rb` - individual test  
`rspec` - run all tests  
#### Test Files:
- input_spec.rb - tests for file input
- transform_spec.rb - tests for file input being parsed correctly
- calculator_spec.rb - tests for calculating sales tax and totals
- printer_spec.rb - tests for printing the output
- run_tax.rb - tests that the 3 input files output correctly
  
***
### Assumptions
1. The input text file follows the following syntax:
    <pre>
      1 book at 12.49
      qty, name, "at", price
    </pre>
2. Product Quantity is a positive integer
3. Price is a positive number
4. Items to be excluded from the goods sales tax (10%) is included in a text file called `exclusions.txt` placed in the input folder.
5. Imported items have the word `imported` in them.
  
***
### Flow
This is a high level overview of the script:
  <pre>
     +---------+
     |INPUT TXT|+---------+         +---------------+
     +---------+          +-------->|Input          |
                          |         |---------------|
     +--------------+     |         | Converts files|
     |EXCLUSIONS TXT|+----+         |  into an array|
     +--------------+               +---+-----------+
                                        |
                                        |
                                        |
                                        v
                                    +--------------------+             +-----------------------------+
                                    |Transform           +------------>|Calculator                   |
                                    |--------------------|             |-----------------------------|
                                    | Takes the array and|             | Updates the array of hashes |
                                    |  parses it into an |             |  for good_tax, import_tax,  |
                                    |  array of hashes   |             |  sales_tax, total_all       |
                                    |                    |             +-+---------------------------+
                                    | Flags true or false|               |
                                    |  for good/import   |               |
                                    |  taxes             |               |
                                    |                    |               |
                                    | Returns items with |               |
                                    |  a qty greater than|               |
                                    |  zero              |               |
                                    +--------------------+               |
                                                                         |
                                                                         |
                                                                         v
                                                                      +-------------------------------+
                                                                      | Printer                       |
                                                                      |-------------------------------|
                                                                      |  Takes the updated array from |
                                                                      |   Calculator and proceeds to  |
                                                                      |   generate a new array of the |
                                                                      |   items, sales_total, and of  |
                                                                      |   the entire total            |
                                                                      |                               |
                                                                      |  Prints the array             |
                                                                      +-------------------------------+
  </pre>

### How is the input file being parsed?
#### Example Input File:
> 1 book at 1.99  
> 1 book at 0.99

Essentially the input text file, gets converted into an array:
> [ "1 book at 1.99", "1 book at 0.99" ]

There is a simple validation to make sure there is clean input. Of the strings only the strings that have the word "at" are selected. Any strings without "at" are ignored. For the parsing process, "at" is essential.

Where it then gets split up:
> [ ["1", "book", "at" ,"1.99"], ["1", "book", "at", "0.99"] ]

After the array is split up, the array is converted into an hash. "at" becomes very useful here because it allows the script to determine the positioning of the items.
> ["1", "book", "at", "1.99"]  
> index: 0, 1, 2, 3

By knowing where "at" is located, which is index 2, we can assume anything between index 0 (which would be qty) and index 2 ("at") is the item name (index 0+1 to index 2-1). The price would be located at index 3 (index 2+1).  

So a hash is built with the following:
> name: string  
> qty: integer  
> price: float  
> good: boolean  
> import: boolean  
> good_tax: float  
> import_tax: float  
> sales_tax: float  
> total: float  

`good` and `import` act as flags which signal whether or not good tax or import tax should be applied.  

`good_tax`, `import_tax`, `sales_tax`, are initially set to 0.0 and will be updated via `calculator`. `Total` is simply set to `qty` * `price` and will be updated by calculator.  

### Thought Process and Review
As I was writing this, I broke the application into 4 major components:
- `Input` - where a file is taken and in and broken down into an array
- `Transform` - where that array is taken and parsed into an array of hashes
- `Calculator` - where that array of hashes is updated with the correct totals
- `Printer` - where the output is displayed
