select * 
from Nashvillehousing


--Converting the saledate into a date format

select saledate, convert(date, saledate) as DateConverted
from Nashvillehousing

ALTER TABLE Nashvillehousing 
ADD SaleDateConverted date

UPDATE Nashvillehousing 
SET SaleDateConverted = convert(date, saledate)

-- Populating PropertyAdress column 

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
from Nashvillehousing as a
join Nashvillehousing as b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid



UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress, b.propertyaddress)
from Nashvillehousing as a
join Nashvillehousing as b
	on a.parcelid = b.parcelid
	and a.uniqueid <> b.uniqueid

Select * 
from Nashvillehousing
where propertyaddress is null -- Gives an empty output, hence PropertyAddress column is populated.

--Breaking out the adress into individual columns (Address, City, State)
--PropertyAdress
Select propertyaddress, 
substring(propertyaddress, 1,CHARINDEX(',', propertyaddress)-1) as address,
substring(propertyaddress,CHARINDEX(',', propertyaddress)+1,len(propertyaddress)) as city
from Nashvillehousing

ALTER TABLE Nashvillehousing 
ADD PropertySplitaddress nvarchar(255)

UPDATE Nashvillehousing 
SET PropertySplitaddress = substring(propertyaddress, 1,CHARINDEX(',', propertyaddress)-1)

ALTER TABLE Nashvillehousing 
ADD PropertySplitCity nvarchar(255)

UPDATE Nashvillehousing 
SET PropertySplitCity = substring(propertyaddress,CHARINDEX(',', propertyaddress)+1,len(propertyaddress))

Select * 
from Nashvillehousing

--Owner address
Select owneraddress,
parsename(replace(owneraddress,',','.'),3) as address,
parsename(replace(owneraddress,',','.'),2) as city,
parsename(replace(owneraddress,',','.'),1) as state
from Nashvillehousing

ALTER TABLE Nashvillehousing 
ADD OwnerSplitaddress nvarchar(255)

UPDATE Nashvillehousing 
SET OwnerSplitaddress = parsename(replace(owneraddress,',','.'),3)

ALTER TABLE Nashvillehousing 
ADD OwnerSplitCity nvarchar(255)

UPDATE Nashvillehousing 
SET OwnerSplitCity = parsename(replace(owneraddress,',','.'),2)

ALTER TABLE Nashvillehousing 
ADD OwnerSplitState nvarchar(255)

UPDATE Nashvillehousing 
SET OwnerSplitState = parsename(replace(owneraddress,',','.'),1)

Select * 
from Nashvillehousing


--Changing the Y and N to Yes and no in the SoldAsVacant field.
Select distinct(soldasvacant), count(soldasvacant)
from Nashvillehousing
group by soldasvacant

Select soldasvacant,
	 case when soldasvacant = 'Y' THEN 'Yes'
		  when soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
		END
from Nashvillehousing

Update Nashvillehousing
SET soldasvacant =  case when soldasvacant = 'Y' THEN 'Yes'
		  when soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
		END


-- Removing Duplicates 
WITH rownumCTE 
as (
select *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, 
			 propertyaddress, 
			 saleprice, 
			 saledate, 
			 legalreference 
			 ORDER BY
			 uniqueID )
			 row_num
from Nashvillehousing
--order by parcelid 
)
Select * 
from rownumCTE
where row_num >1
order by parcelid

WITH rownumCTE 
as (
select *,
ROW_NUMBER() OVER (
PARTITION BY parcelid, 
			 propertyaddress, 
			 saleprice, 
			 saledate, 
			 legalreference 
			 ORDER BY
			 uniqueID )
			 row_num
from Nashvillehousing
--order by parcelid 
)
DELETE 
from rownumCTE
where row_num >1
--order by parcelid


-- Deleting unused columns
Select * 
from Nashvillehousing

ALTER Table Nashvillehousing
DROP COLUMN PropertyAddress, Owneraddress, saledate, taxdistrict 
