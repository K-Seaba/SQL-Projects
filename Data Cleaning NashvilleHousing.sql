SELECT *
FROM NashvilleHousing

------------------------------------------------------------------------------------------------------

-- Change SaleDate from datetime format to date format

SELECT SaleDateConverted, CONVERT(date, SaleDate) -- This is to show how we want our data to look like.
FROM NashvilleHousing

ALTER TABLE Nashvillehousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

------------------------------------------------------------------------------------------------------

-- Populating Property Address data

SELECT N1.ParcelID, N1.PropertyAddress, N2.ParcelID, N2.PropertyAddress, ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing AS N1
JOIN NashvilleHousing AS N2
ON N1.ParcelID = N2.ParcelID 
AND N1.[UniqueID ] <> N2.[UniqueID ]
WHERE N1.PropertyAddress IS NULL

UPDATE N1
SET PropertyAddress = ISNULL(N1.PropertyAddress, N2.PropertyAddress)
FROM NashvilleHousing AS N1
JOIN NashvilleHousing AS N2
ON N1.ParcelID = N2.ParcelID 
AND N1.[UniqueID ] <> N2.[UniqueID ]
WHERE N1.PropertyAddress IS NULL

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT len(PropertyAddress)
FROM NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS 'Address',
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS 'City'
FROM NashvilleHousing

ALTER TABLE Nashvillehousing
ADD PropertySplitAddress Nvarchar(100)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashvillehousing
ADD PropertySplitCity Nvarchar(100)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


SELECT *
FROM NashvilleHousing



SELECT OwnerAddress
FROM NashvilleHousing


SELECT PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS 'OwnerSplitAddress', 
	PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS 'OwnerSplitCity', 
	PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS 'OwnerSplitState'
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(100),
	OwnerSplitCity Nvarchar(100),
	OwnerSplitState Nvarchar(100)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT *
FROM NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant, 
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END AS 'SoldAsVacant2'
FROM NashvilleHousing


SELECT *
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates (It's not adviseable to delete data from tables)

SELECT *
FROM NashvilleHousing

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate