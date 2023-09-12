/* Nashville Housing Data
From: https://www.kaggle.com/datasets/tmthyjames/nashville-housing-data
Skills Used : CREATE, UPDATE, SELECT, CTE, JOINS, OREDR BY, GROUP BY
*/

---------------------------------------------------------------------------------------------


----- Standardising the Date format

ALTER TABLE 
   NashvilleHousing
ADD
   SaleDateStandard Date

--Adding a new column ^


UPDATE
     NashvilleHousing
SET
     SaleDateStandard = CONVERT(DATE, SALEDATE)



--An alternative way to change the Date type:

SELECT 
      SaleDate
	 ,CONVERT(Date, SaleDate) AS SaleDateStandard
FROM 
      NashvilleHousing 


---------------------------------------------------------------------------------------------


----- Populating missing property address data


SELECT
    a.ParcelID
   ,a.PropertyAddress
   ,b.ParcelID
   ,b.PropertyAddress
   ,ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
    NashvilleHousing AS a
JOIN 
    NashvilleHousing AS b
on 
    a.ParcelID = b.ParcelID
AND 
    a.[UniqueID ] <> b.[UniqueID ]
WHERE 
     a.PropertyAddress IS NULL


Update a
SET 
   PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
   NashvilleHousing AS a
JOIN 
   NashvilleHousing AS b
ON 
   a.ParcelID = b.ParcelID
AND 
   a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL



---------------------------------------------------------------------------------------------


----- Breaking out the property address into individual columns (Street, City)

SELECT *
FROM NashvilleHousing


SELECT 
      SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
     ,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) AS City
FROM 
      NashvilleHousing



ALTER TABLE 
      NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

UPDATE 
   NashvilleHousing
SET 
   PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

   --Substring to include all characters starting from character 1 all the way up to the last character before the ',' hence the (-1). 
   --This will be the street addess column


ALTER TABLE 
      NashvilleHousing
Add PropertySplitCity Nvarchar(255)

UPDATE 
    NashvilleHousing
SET
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

  --Substring to include all characters after the ',' up to the last character of the propertyadress
  --This will be the city column


---------------------------------------------------------------------------------------------


----- Breaking Owner Address into individual columns (St address, City, State)


SELECT
   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) AS OwnerSplitAddress
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) AS OwnerSplitCity
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) AS OwnerSplitState
FROM
   NashvilleHousing
--parsename only works with '.' so we have to replace the ','
--parsename also works backwards (right to left)
--so parsename,1 would be the state as its the furthest to the left, then city then st address

1.) ALTER TABLE 
    NashvilleHousing
ADD
    OwnerSplitAddress NVARCHAR(255);

UPDATE 
    NashvilleHousing
SET
    OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

2.) ALTER TABLE 
    NashvilleHousing
ADD
    OwnerSplitCity Nvarchar(255);

UPDATE 
    NashvilleHousing
SET
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

3.) ALTER TABLE 
    NashvilleHousing
ADD 
    OwnerSplitState Nvarchar(255);

UPDATE 
    NashvilleHousing
SET 
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


---------------------------------------------------------------------------------------------


----- Change Y and N to Yes and No in the "Sold as Vacant" field


SELECT
   DISTINCT(SoldAsVacant)
  ,COUNT(SoldAsVacant)
FROM
   NashvilleHousing
GROUP BY
   SoldAsVacant
ORDER BY 2
--we can see the count of Yes,No,Y and N

SELECT
    SoldAsVacant,
CASE   
       WHEN SoldAsVacant = 'Y' THEN 'YES'
	   WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM
   NashvilleHousing
--case statement to change Y and N to Yes and No

UPDATE
   NashvilleHousing
SET SoldAsVacant = CASE 
                       WHEN SoldAsVacant = 'Y' THEN 'YES'
	                   WHEN SoldAsVacant = 'N' THEN 'NO'
	                   ELSE SoldAsVacant
	                   END


---------------------------------------------------------------------------------------------


----- Removing duplicates


WITH RowNum_CTE AS(
Select *
	,ROW_NUMBER() 
	OVER ( PARTITION BY 
	             ParcelID
		    ,PropertyAddress
		    ,SalePrice
		    ,SaleDate
		    ,LegalReference
	ORDER BY	
	   UniqueID) row_num
	FROM
	  NashvilleHousing
		)

DELETE
FROM 
   RowNum_CTE
WHERE 
   row_num > 1


--------------------------------------------------------------------------------------------


----- Deleting unused columns


ALTER TABLE
      NashvilleHousing
DROP COLUMN
      OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


SELECT *
FROM NashvilleHousing



 
