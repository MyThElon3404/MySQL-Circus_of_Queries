## 1. Calculated Columns and Measures: How do you create them in Power BI Desktop?
#### Calculated Columns:
- Calculated columns are computed using DAX (Data Analysis Expressions) and are added to your data model as new columns. They are calculated row-by-row during data load or data refresh.
You use calculated columns when you need to add a column with a calculation that will be applied to every row in a table.

- Example 1: Creating a Calculated Column
  1. Open Power BI Desktop.
  2. Go to the Data view by clicking on the data icon on the left pane.
  3. Select the table where you want to add a calculated column.
  4. Click on "Modeling" in the ribbon and select "New Column".
  5. Enter the DAX formula. For instance, to calculate the total sales amount from quantity and unit price columns:
- DAX Formula -
  1. simple dax calculation -> 
  Total Sales = Sales[Quantity] * Sales[Unit Price]

  2. Creating a Conditional Calculated Column -> 
  Sales Category = IF(Sales[Total Sales] > 1000, "High", "Low")

#### Measures
- A measure in Power BI is a dynamic calculation that performs aggregations or computations based on data in your model. Measures are created using Data Analysis Expressions (DAX), a formula language specifically designed for working with data models.





















