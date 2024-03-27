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

To update the new format of the SaleDate column in our table, we execute the following query:

```sql

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

```

In the above query, we added a new column into the dataset with the new format for the sale dates and named it SaleDateConverted.  <br>

#### <ins>2. Impute Missing Values</ins> <br>

#### <ins>3. Address Parsing</ins> <br>

Here we will be separating the PropertyAddress and OwnerAddress columns into individual columns for address, city and state to make them easier for further analysis. We start with the PropertyAddress column which contains address and city information in one column and we want to separate them into two separate columns.

#### <ins>4. Standardize Abbreviations</ins> <br>

#### <ins>5. Data Deduplication</ins> <br>

#### <ins>6. Column Removal</ins> <br>
