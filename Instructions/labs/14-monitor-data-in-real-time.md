# Lab14 - Monitor data in real time

## Overview

**The estimated time to complete the lab is 30 minutes**

In this lab, you will configure a report to use automatic page refresh. That way, it will be possible for report consumers to monitor real-time internet sales results.

In this lab, you learn how to:

- Use Performance analyzer to review refresh activities.

- Set up automatic page fresh.

- Create and use the change detection feature.

## Exercise 1: Setting Up Database using SQL Server Management Studio (SSMS).

In this exercise, you will set up Database using SQL Server Management Studio (SSMS)

### Task 1: Set up the database

In this task, you will use SQL Server Management Studio (SSMS) to setup the database by running two scripts.

1. To open SSMS, on the desktop, select the **SSMS** shortcut.

    ![](../images1/dp500_14-01.png)

2. In the **Connect to Server** window, ensure that the **Server name** is set to **localhost (1)**, and that the Authentication dropdown list is set to **Windows Authentication (2)** and select **Connect (3)**.
	
    ![](../images1/dp-500-lab14-1.png)

3. To open a script file, on the **File** menu, select **Open** > **File**.

4. In the **Open File** window, go to the **C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\14\Assets** folder.

5. Select the **1-Setup (1)** sql file and click **Open (2)**.

    ![](../images1/dp-500-lab14-2.png)

6. Review the script.

   >**Note**: This script creates a table named **FactInternetSalesRealTime**. A different script will load data into this table to simulate a real-time workload of internet sales orders.

7. To run a script, on the toolbar, select **Execute** (or press **F5**).

    ![](../images1/dp-500-lab14-3.png) 
	
8. To close the file, on the **File** menu, select **Close**.

9. Press **Ctrl+O** to access the **Open File** window. Select **2-InsertOrders (1)** sql file and click **Open (2)**

     ![](../images1/dp-500-lab14-4.png)
	
10. Review this script also.

    >**Note**: This script runs an infinite loop. For each loop, it inserts a sales order and then delays for a random period of 1-15 seconds.

11. Run the script, and leave it running until the end of the lab.

### Task 2: Set up Power BI Desktop

In this task, you will open a pre-developed Power BI Desktop solution.

1. To open File Explorer, on the taskbar, select the **File Explorer** shortcut.

    ![](../images1/dp500_14-08.png)

2. Go to the **C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\14\Starter** folder.

3. To open a pre-developed Power BI Desktop file, double-click the **Internet Sales - Monitor data in real time.pbix** file.

4. If Prompted select **Save** on **SQL Server database** page.
   
    ![](../images1/dp-500-lab14-(1).png)
 
5. If Prompted click **OK** on **Encryption Support** page.

6. To save the file, on the **File** ribbon tab, select **Save as**.

7. In the **Save As** window, go to the **C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\14\MySolution** folder.

8. Select **Save**.

### Task 3: Review the report

In this task, you will review the pre-developed report.

1. In Power BI Desktop, review the report page.

    ![](../images1/Mod14-Ex1-Task3-Step1.png)

    >**Note**: This report page has a title and two visuals. The card visual displays the number of sales orders, while the bar chart visual displays the sales amount for each bike subcategory.

2. To refresh the report, on the **View** ribbon tab, from inside the **Show** panes group, select **Performance analyzer**.

    ![](../images1/dp-500-lab14-5.png)

3. In the **Performance analyzer** pane (located to the right of the **Visualizations** pane), select **Start recording**.

    ![](../images1/dp-500-lab14-6.png)

     >**Note**: Performance analyzer inspects and displays the duration necessary to update or refresh the visuals. Each visual issues at least one query to the source database. For more information, see [Use Performance Analyzer to examine report element performance](https://docs.microsoft.com/power-bi/create-reports/desktop-performance-analyzer).

4. Select **Refresh visuals**.

    ![](../images1/dp-500-lab14-7.png)

5. Notice that the report visuals update to show the latest internet sales results.

    - When developing a report that connects to a local DirectQuery model, it's not possible to refresh the report by using the **Refresh** command (located on the **Home** ribbon tab). That's because Power BI Desktop refreshes the DirectQuery table connections instead. To refresh the report visuals, follow the steps you just did. When published to the Power BI service, report consumers will be able to select **Refresh** on the action bar to refresh the report visuals.

    - When you design a report for real-time analysis, there must be a better way than asking users to constantly refresh the report page. You will achieve that better way when you set up automatic page refresh in the next exercise.

## Exercise 2: Set up automatic page refresh

In this exercise, you will set up automatic page refresh and experiment by using the change detection feature.

>**Note**: Automatic page refresh requires at least one model table that's set to use DirectQuery storage mode.

### Task 1: Set up automatic page refresh

In this task, you will set up automatic page refresh.

1. To select the report page, first select an empty area of the report page (below the graph).

1. In the **Visualizations** pane, select the format icon (paint brush).

    ![](../images1/dp-500-lab14-8.png)

1. Switch the **Page refresh** setting (last in the list) to **On**.

     ![](../images1/dp-500-lab14-9.png)
	 
     >**Note**: Automatic page refresh is a page-level setting. You can enable it for specific pages in the report.
     >**Note**: First select an empty area of the report page (below the graph) or else you won't find **Page refresh** setting

1. In the **Performance analyzer** pane, notice that the report visuals just refreshed.

1. In the **Visualizations** pane, expand open the **Page refresh** settings and Notice that by default the page will refresh every 30 minutes.

    ![](../images1/dp-500-lab14-10.png)

1. Modify the settings to refresh the page every 5 seconds.

    ![](../images1/dp-500-lab14-11.png)

    >**Important**: This frequent refresh interval will help you efficiently work through this lab. But take care, because setting such a frequent refresh interval could seriously impact on the performance of the source database and other users viewing the report.

    >**Note**: Because an internet sales order loads every 1-15 seconds, sometimes the page refresh retrieves the same results (because the database recorded no orders in the last five seconds). Preferably, the report visuals only refresh when needed. You will set up the change detection feature to do that in the next task.

    >**Note**: Once published to the Power BI service, refresh intervals less than 30 minutes require that you save the report to a workspace assigned to Premium capacity. Also, a capacity admin must enable and set up the capacity to allow such frequent intervals. For more information, see [Automatic page refresh in Power BI](https://docs.microsoft.com/power-bi/create-reports/desktop-automatic-page-refresh).

### Task 2: Set up change detection

In this task, you will set up change detection.

1. In the **Page refresh** settings, set the **Refresh type** dropdown list to **Change detection**.

    ![](../images1/dp-500-lab14-12.png)
	
1. To create a change detection measure, select the **Add change detection** link.

    ![](../images1/dp-500-lab14-13.png)

1. In the **Change detection** window, notice that the default set up is to create a new measure.

	![](../images1/dp-500-lab14-14-1.png)

1. In the **Choose a calculation** dropdown list, select **Count (Distinct)**.

    ![](../images1/dp-500-lab14-14-2.png)

1. In the **Fields** pane (located at the right, inside the window), scroll down to locate the **Internet Sales** table.

1. Select the **Sales Order (1)** field, and notice that the window added it to the **Choose a field to apply it to (2)** box and for the **Check for changes every** setting, set it to **5 seconds (3)** and select **Apply (4)**.

    ![](../images1/dp-500-lab14-15.png)
	
1. In the **Data** pane, inside the **Internet Sales (1)** table, notice the addition of a **change detection measure (2)**.

    ![](../images1/dp-500-lab14-16.png)

    >**Note**: Power BI now uses the change detection measure to query the source database every five seconds. Each time, Power BI stores the result so it can compare it the next time it's used. When the results differ, it means the data has changed (in this case, the database inserted new internet sales orders). In this case, Power BI refreshes all report page visuals.

     >**Note**: Once published to the Power BI service, Power BI only supports change detection measures for Premium capacities.

1. In the **Performance analyzer** pane, select **Clear**.

     ![](../images1/dp-500-lab14-17.png)

1. Notice that Performance analyzer displays change detection queries.

1. Notice that sometimes multiple change detection queries happen before Power BI Desktop refreshes the report visuals.

    >**Note**: That's because the database inserted no new internet sales orders at that time. This set up is now more efficient because report visuals only refresh when necessary.

### Finish up

In this task, you will finish up.

1. Save the Power BI Desktop file.

    ![](../images1/dp500_14-26.png)

1. Close Power BI Desktop.

1. In SSMS, to stop running the script, on the toolbar, select **Stop** (or press **Alt+Break**).

    ![](../images1/dp-500-lab14-18.png)
	 
1. Close the script file.

1. Close SSMS.

   **Congratulations** on completing the task! Now, it's time to validate it. Here are the steps:  
   > - Navigate to the Lab Validation Page, from the upper right corner in the lab guide section.
   > - Hit the Validate button for the corresponding task. If you receive a success message, you can proceed to the next task. 
   > - If not, carefully read the error message and retry the step, following the instructions in the lab guide.
   > - If you need any assistance, please contact us at labs-support@spektrasystems.com. 

**You have successfully completed the lab**
