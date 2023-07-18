
# Lab11 - Improve query performance with dual storage mode

## Overview

**The estimated time to complete the lab is 30 minutes**

In this lab, you will improve the performance of a composite model by setting some tables to use dual storage mode.

In this lab, you learn how to:

- Set dual storage mode.

- Use Performance analyzer to review refresh activities.

## Excercise 1: Set up Power BI Desktop

### Task 1: Set up Power BI Desktop

In this task, you will open a pre-developed Power BI Desktop solution.

1. To open File Explorer, on the taskbar, select the **File Explorer** shortcut.

   ![](../images/DP500-16-13.png)

1. Navigate to **C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\11\Starter** and **Double Click** on the the existing file to Open the file.

   ![](../images1/dp-500-lab11-1.png)
	
1. If prompted about a potential security risk, read the message, and then select **OK**

   ![](../images1/dp-500-lab11-2.png)
	
1. On the **SQL Server database** page, ensure **Use my current credentials (1)** is selected and  click **Save (2)**. 

   ![](../images1/dp-500-lab11-(3).png)
		
1. Select the **File** ribbon tab, select **Get data (1)** > **SQL Server database (2)**.

   ![](../images1/dp-500-lab11-(4).png)

1. On **SQL Server database** page specify the following and click **Ok (3)**.

    | Setting | Value |
    | --- | --- |
    | **Server** | **localhost** **(1)**|
    | **Database(optional)** | **AdventureWorksDW2022-DP500** **(2)**|
     
    ![](../images1/dp-500-lab11-5.png)
 
1. If prompted for Encryption Support,click on **OK** 

    ![](../images1/dp-500-lab11-6.png)

1. Select **Cancel** on the navigator pane.  	
						    
1. On the yellow warning bar that is displayed, click on **Apply changes**
 
    ![](../images1/dp-500-lab11-7.png)
	
1. If prompted to approve running a Native Database Query, select **Run**.

    ![](../images1/dp-500-lab11-8.png)
	
1. To save the file, on the **File** ribbon tab, select **Save as**.

1. In the **Save As** window, go to the **C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\11\MySolution** folder.

1. Select **Save**.

### Task 2: Review the report

In this task, you will review the pre-developed report.

1. In Power BI Desktop, at the bottom right corner in the status bar, notice that the storage mode is Mixed.

    ![](../images/dp500-12-1.png)

    >**Note**: A mixed model comprises tables from different source groups. This model has one import table that sources its data from an Excel workbook. The remaining tables use a DirectQuery connection to a SQL Server database, which is the data warehouse.

2. Review the report design.

    ![](../images/dp500-12-2.png)

    >**Note**: This report page has a title and two visuals. The slicer visual allows filtering by a single fiscal year, while the column chart visual displays quarterly sales and target amounts. You will improve the performance of the report by setting some tables to use dual storage mode.

### Task 3: Review the data model

In this task, you will review the pre-developed data model.

1. Switch to **Model** view.

    ![](../images1/dp-500-lab11-T1.png)

2. Use the model diagram to review the model design.

   ![](../images1/dp-500-lab11-T2.png)

    >**Note**: The model comprises three dimension tables and two fact tables. The **Sales** fact table represents sales order details, while the **Targets** table represents quarterly sales targets. It's a classic star schema design. The bar across the top of some of the tables indicate they use DirectQuery storage mode. Every table that has a blue bar belongs to the same source group.

## Excercise 2: Set up dual storage mode

In this exercise, you will set up dual storage mode.

>**Note**: A model table that uses dual storage mode uses both import and DirectQuery storage mode at the same time. Power BI determines the most efficient storage mode to use on a query by query basis, striving to use import mode whenever possible because it's faster.

### Task 1: Use Performance analyzer

In this task, you will open Performance analyzer and use it to inspect refresh events.

1. Switch to **Report** view.

    ![](../images1/dp-500-lab11-T3.png)

2. To inspect visual refresh events, on the **Optimize** ribbon tab, from inside the **Show** panes group, select **Performance analyzer**.

    ![](../images1/dp-500-lab11-T4.png)

3. In the **Performance analyzer** pane (located to the left of the **Visualizations** pane), select **Start recording**.

    ![](../images1/dp-500-lab11-T5.png)

    >**Note**: Performance analyzer inspects and displays the duration necessary to update or refresh the visuals. Each visual issues at least one query to the source database. For more information, see [Use Performance Analyzer to examine report element performance](https://docs.microsoft.com/power-bi/create-reports/desktop-performance-analyzer).

4. Select **Refresh visuals**.

    ![](../images1/dp-500-lab11-T6.png)

5. In the **Performance analyzer** pane, expand open the **Slicer (1)** visual, and notice the **Direct query (2)** event.

    ![](../images1/dp-500-lab11-T7.png)

    >**Note**: Whenever you see a direct query event, it tells you that Power BI used DirectQuery storage mode to retrieve the data from the source database.

6. Expand open the **Sales Result by Fiscal Quarter (1)** visual, and notice that it recorded a **Direct query (2)** event also.

    ![](../images1/dp-500-lab11-T8.png)

    >**Note**: You always set up a slicer visual by using one or more fields from the same table. It isn't possible to use fields from different tables to set up a slicer. What's more, a slicer almost always uses fields from a dimension table. So, to improve query performance of slicer visuals, ensure they store imported data. In this case, because the dimension tables use DirectQuery storage mode, you can set them to dual storage mode. Because dimension tables store few rows (relative to fact tables), it shouldn't result in an excessively large model cache.

### Task 2: Set up dual storage mode

In this task, you will set all dimension tables to use dual storage mode.

1. Switch to **Model** view.

2. Select the header of the **Product** table.

3. While pressing the **Ctrl** key, select the headers of the **Order Date** and **Sales Territory** tables also.

4. In the **Properties** pane, expand open the **Advanced** section.

5. In the **Storage mode** dropdown list, select **Dual**.

     ![](../images1/dp-500-lab11-T9.png)

6. When Storage mode dialog box is prompted, select **OK**.

   >**Note**: The warning informs you that it might take considerable time for Power BI Desktop to import data into the model tables.
	
7. If Pending changes window Pops-up, click on **close** and click on **Apply changes** on the top of the model view and repeat from the 4th steps.

   ![](../images1/dp-500-lab11-7.png)

8. In the model diagram, notice the striped bar across the top of each dimension table.

   ![](../images1/dp-500-lab11-T11.png)

   >**Note**: A striped bar indicates dual storage mode.

### Task 3: Review the report

In this task, you will review the pre-developed report.

1. Switch to **Report** view.

2. In the **Performance analyzer** pane, select **Clear**.

   ![](../images1/dp-500-lab11-T12.png)

3. Refresh the visuals.

    ![](../images1/dp-500-lab11-T13.png)

4. Notice that the slicer visual no longer uses a direct query connection.

   ![](../images1/dp-500-lab11-T14.png)

   >**Note**: Power BI queries the model cache of imported data, so the slicer now refreshes more quickly.

5. Notice, however, that the column chart visual still uses a direct query connection.

   >**Note**: That's because the **Sales Amount** field is a column of the **Sales** table, which uses DirectQuery store mode.

6. Select the column chart visuals, and then in the **Visualizations** pane, from inside the **Values** well, remove the **Sales Amount** field.

    ![](../images1/dp-500-lab11-T15.png)

7. Also remove the Variance and Variance Margin from the **Tooltips** well.

    ![](../images1/dp-500-lab11-T16.png)

    >**Note**: Both of these measures depend on the **Sales Amount** column.

8. In the **Performance analyzer** pane, expand open the last refresh event, and notice that the column chart visual no longer uses a direct query connection.

   >**Note**: That's because the column chart visual now only uses two tables, both of which are cached in the model. The **Order Date** table uses dual storage mode, while the **Targets** table uses import storage mode.

   >**Note**: You have now improved the performance of specific queries where Power BI can retrieve data from the model cache. The key takeaway is that dimension tables that relate to DirectQuery fact tables should usually be set to dual storage mode. That way, when queried by a slicer, the queries will be quick.

   >**Note**: You could further optimize the model to improve query performance by adding aggregations. However, that enhancement will be the learning objective of a different lab.

### Task 4: Finish up

In this task, you will finish up.

1. Save the Power BI Desktop file.

    ![](../images/DP500-16-25.png)

2. Close Power BI Desktop.

   **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:
   > - Navigate to the Lab Validation Page, from the upper right corner in the lab guide section.
   > - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task. 
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at labs-support@spektrasystems.com. 
   
**You have successfully completed the lab**
