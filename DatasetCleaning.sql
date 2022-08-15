/*

Data Cleaning in SQL

*/


Select *
From hypnotic-pier-353714.NashvilleHousing


 -----------------------
-- Standardize Date Format
 -----------------------
Select saleDateConverted, CONVERT(Date,SaleDate)
From hypnotic-pier-353714.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

 -----------------------
-- Another Update option
 -----------------------
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 ---------------------------------
-- Populate Property Address data
 ---------------------------------
Select *
From hypnotic-pier-353714.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select un.ParcelID, un.PropertyAddress, deux.ParcelID, deux.PropertyAddress, ISNULL(un.PropertyAddress,deux.PropertyAddress)
From hypnotic-pier-353714.NashvilleHousing un
JOIN hypnotic-pier-353714.NashvilleHousing deux
	on un.ParcelID = deux.ParcelID
	AND un.[UniqueID ] <> deux.[UniqueID ]
Where un.PropertyAddress is null

Update un
SET PropertyAddress = ISNULL(un.PropertyAddress,deux.PropertyAddress)
From hypnotic-pier-353714.NashvilleHousing un
JOIN hypnotic-pier-353714.NashvilleHousing deux
	on un.ParcelID = deux.ParcelID
	AND un.[UniqueID ] <> deux.[UniqueID ]
Where un.PropertyAddress is null


-----------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
-----------------------------------

Select PropertyAddress
From hypnotic-pier-353714.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From hypnotic-pier-353714.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From hypnotic-pier-353714.NashvilleHousing





Select OwnerAddress
From hypnotic-pier-353714.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From hypnotic-pier-353714.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From hypnotic-pier-353714.NashvilleHousing




-----------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
-----------------------------------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From hypnotic-pier-353714.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From hypnotic-pier-353714.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--------------------------
-- Remove Duplicates
--------------------------
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

From hypnotic-pier-353714.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From hypnotic-pier-353714.NashvilleHousing


-----------------------
-- Delete Unused Columns
-----------------------


Select *
From hypnotic-pier-353714.NashvilleHousing


ALTER TABLE hypnotic-pier-353714.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

