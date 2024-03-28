# Data Cleaning in SQL

### <ins>Dataset:</ins> <br> 

This project uses the "Nashville Housing Data" dataset, containing information on home values within the Nashville housing market.  Our objective is to explore various data cleaning techniques using Microsoft SQL Server.  The dataset, sourced from Kaggle, is publicly available. 

The dataset comprises 56,477 rows and 19 columns. These columns include: UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, and HalfBath. The presence of inconsistencies within the dataset makes it ideal for practicing data cleaning techniques. These inconsistencies include: 

- Incorrectly formatted date entries in the SaleDate column. 
- Missing values within the PropertyAddress column. 
- Inconsistent abbreviations in the SoldAsVacant column. 

Furthermore, we will perform the separation of entries in the PropertyAddress and OwnerAddress columns into three distinct columns, isolating Address, City, and State information to make them easier for any future analysis. Following data cleaning, we will remove duplicate rows and eliminate any unused columns.

### <ins>Objectives:</ins> <br> 

To address these inconsistencies, we will execute the following sequence of tasks: <br> 

1. **Reformat Data:** Convert the data type of the SaleDate column from date-time to date format. <br> 
2. **Impute Missing Values:** Populate the null values present within the PropertyAddress column. <br> 
3. **Address Parsing:** Break out Address, City, and State information into individual columns within both PropertyAddress and OwnerAddress columns. <br>
4. **Standardize Abbreviations:** Convert abbreviations in the SoldAsVacant column into their corresponding full forms. <br>
5. **Data Deduplication:** Remove and eliminate duplicate values. <br>
6. **Column Removal:** Delete any unused columns. <br>

-------------------------------------------------------------------------------------------------------------------  
<br>

#### <ins>1. Reformat Data</ins> <br>

The SaleDate column currently stores data in the DATETIME format. However, since sales hour information is not available to our us, converting this column to the DATE format will optimize storage efficiency and streamline subsequent data manipulation. The DATE format is sufficient for capturing the essential date information and simplifies querying processes.

Let's look at how the SaleDate column looks before we reformat it, and how we would like it to look after reformating. We do this by writing the following query:

```sql

SELECT SaleDate, CONVERT(date, SaleDate) AS SaleDateConverted -- This is to show how we want our data to look like.
FROM NashvilleHousing

```

Snipped of output: 

![SaleDate column reformatting](https://github.com/K-Seaba/SQL-Projects/assets/83554164/2ba3a3b2-ad67-45bb-82b2-38ccb5928eec)

To update the format of the SaleDate column in our table to the new format, we execute the following query:

```sql

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

```

In the above query, we added a new column into the dataset with the new format for the sale dates and named it SaleDateConverted.  <br>

#### <ins>2. Impute Missing Values</ins> <br>

In this step we'll be populating the cells with NULL values in the PropertyAddress column. This information is especially important considering that we are working with real estate data and knowing the address of a property in the market is very important and certainly more important than knowing the address of the property's owner, which may be different from the property adderess, i.e., not every owner of a property in the market lives in that property. <br>

Firstly, let's look at all the properties with missing addresses. To do so, we write the following query: <br>

```sql

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

```
Snipped of output: 

![Property addresses with null values](https://github.com/K-Seaba/SQL-Projects/assets/83554164/234ce080-c15d-4aa6-94f7-16696801ed29)

As seen in the above query output, there are 29 properties with missing addresses that we have to populate.  To do so, we need to have a closer look at the data. One key finding was that properties with the same ParcelID (with uniqueIDs not necessarily equal) had the same property address. This can be seen in the following query:

```sql

SELECT *
FROM NashvilleHousing AS N1
JOIN NashvilleHousing AS N2
ON N1.ParcelID = N2.ParcelID 
AND N1.[UniqueID ] <> N2.[UniqueID ]

```

In the above query, we used a self join on the NashvilleHousing data to get the rows with the same ParcelID and different uniqueIDs. The UniqueID comparison ensures we only consider addresses from distinct rows, preventing the potential for duplicate assignments.

Snipped of output: 

![Same ParcelID Same Adderess](https://github.com/K-Seaba/SQL-Projects/assets/83554164/da4e2f9d-358c-4ed9-bac7-99bdc531f955)

As can be seen in the output above, properties with the same ParcelID have the same PropertyAddress. This is a consistent theme throughout our dataset and we can use this knowledge to populate the cells with NULL values in the PropertyAddress column. <br>

Let's look at the following query.

```sql

SELECT N1.ParcelID, N1.PropertyAddress, N2.ParcelID, N2.PropertyAddress, ISNULL(N1.PropertyAddress, N2.PropertyAddress) AS populate
FROM NashvilleHousing AS N1
JOIN NashvilleHousing AS N2
ON N1.ParcelID = N2.ParcelID 
AND N1.[UniqueID ] <> N2.[UniqueID ]
WHERE N1.PropertyAddress IS NULL

```
In the above query we demonstrate how we will be using the ISNULL function to populate null values in the PropertyAddress column. This is achieved by identifying records with matching ParcelID values but distinct UniqueID values. When a null value exists in the PropertyAddress of the first joined table (N1), the corresponding address from the second joined table (N2) is used to fill the vacancy.

Snipped of output:

![To populate](https://github.com/K-Seaba/SQL-Projects/assets/83554164/0f2408cc-698c-491e-8dd4-560b863f6282)

Now that we have established a method to populate the NULL cells in the PropertyAddress column, we will now use it to update our dataset and eliminate the NULL cells. We use the following query:

```sql

UPDATE N1
SET PropertyAddress = ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing AS N1
JOIN NashvilleHousing AS N2
ON N1.ParcelID = N2.ParcelID 
AND N1.[UniqueID ] <> N2.[UniqueID ]
WHERE N1.PropertyAddress IS NULL

```
In the query above, we use the UPDATE statement to impliment the ISNULL function and populate the PropertAddress column. fter this step, the PropertyAddress column has been populated and therre are no more NULL cells. We can see this by running the following query:

```sql

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

```
Snipped of output:

![No nulls](https://github.com/K-Seaba/SQL-Projects/assets/83554164/6cd38951-5a6b-495d-9df7-8393b2a0ae84)

As we can see in the above output, there are no NULL cells left in the PropertyAddress column.

#### <ins>3. Address Parsing</ins> <br>

Here we will be separating the PropertyAddress and OwnerAddress columns into individual columns for address, city and state to make them easier for further analysis. We start with the PropertyAddress column which contains address and city information in one column and we want to separate them into two separate columns.

#### <ins>4. Standardize Abbreviations</ins> <br>

#### <ins>5. Data Deduplication</ins> <br>

#### <ins>6. Column Removal</ins> <br>
