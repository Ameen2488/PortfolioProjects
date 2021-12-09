
/*

Cleaning Data in SQL Queries

*/

Select *
From [Portfolio Project].dbo.Nashville_Housing


-- Standardise Date Format

Select SaleDate, CONVERT(Date, SaleDate)
From [Portfolio Project].dbo.Nashville_Housing

Update Nashville_Housing
Set SaleDate = CONVERT(Date, SaleDate)

Alter Table Nashville_Housing
Add SaleDate_Converted Date;

Select*
From [Portfolio Project].dbo.Nashville_Housing


Update Nashville_Housing
Set SaleDate_Converted = CONVERT(Date, SaleDate)

Select SaleDate_Converted
From [Portfolio Project].dbo.Nashville_Housing


-- Populate Property Address Data


Select*
From [Portfolio Project].dbo.Nashville_Housing
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.Nashville_Housing as a
Join [Portfolio Project].dbo.Nashville_Housing as b
     On a.ParcelID = b.ParcelID 
	 And a.[UniqueID] <> b.[UniqueID]
	 
Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project].dbo.Nashville_Housing as a
Join [Portfolio Project].dbo.Nashville_Housing as b
     On a.ParcelID = b.ParcelID 
	 And a.[UniqueID] <> b.[UniqueID]
	 where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project].dbo.Nashville_Housing
Order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From [Portfolio Project].dbo.Nashville_Housing

Alter Table Nashville_Housing
Add PropertySplitAddress Nvarchar(255);

Select*
From [Portfolio Project].dbo.Nashville_Housing


Update Nashville_Housing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table Nashville_Housing
Add PropertySplitCity Nvarchar(255);

Select*
From [Portfolio Project].dbo.Nashville_Housing


Update Nashville_Housing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select*
From [Portfolio Project].dbo.Nashville_Housing


Select OwnerAddress
From [Portfolio Project].dbo.Nashville_Housing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From [Portfolio Project].dbo.Nashville_Housing

Alter Table Nashville_Housing
Add OwnerSplitAddress Nvarchar(255);

Alter Table Nashville_Housing
Add OwnerSplitCity Nvarchar(255);

Alter Table Nashville_Housing
Add OwnerSplitState Nvarchar(255);


Update Nashville_Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Update Nashville_Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Update Nashville_Housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


Select*
From [Portfolio Project].dbo.Nashville_Housing



--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project].dbo.Nashville_Housing
Group By SoldAsVacant
Order by 2


Select SoldAsVacant, CASE When SoldAsVacant = 'Y' Then 'Yes'
                          When SoldAsVacant = 'N' Then 'No'
						  Else SoldAsVacant
						  End
From [Portfolio Project].dbo.Nashville_Housing


Update Nashville_Housing
Set SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
                          When SoldAsVacant = 'N' Then 'No'
						  Else SoldAsVacant
						  End
From [Portfolio Project].dbo.Nashville_Housing

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Portfolio Project].dbo.Nashville_Housing
Group By SoldAsVacant
Order by 2




--Remove Duplicates

With RowNumCTE as (
Select *,
     Row_Number() Over(
	 Partition By ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order By
				     UniqueID
					 ) row_num
From [Portfolio Project].dbo.Nashville_Housing
--Order By ParcelID 
)
Delete
From RowNumCTE
Where row_num>1
--Order by PropertyAddress



With RowNumCTE as (
Select *,
     Row_Number() Over(
	 Partition By ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order By
				     UniqueID
					 ) row_num
From [Portfolio Project].dbo.Nashville_Housing
--Order By ParcelID 
)Select*
From RowNumCTE
Where row_num>1
--Order by PropertyAddress



--Delete Unused Columns


Select*
From [Portfolio Project].dbo.Nashville_Housing

Alter Table [Portfolio Project].dbo.Nashville_Housing
Drop Column OwnerAddress, Taxdistrict, PropertyAddress, SaleDate, SaleDate_Revised

Alter Table [Portfolio Project].dbo.Nashville_Housing
Drop Column SaleDate, SaleDate_Revised

Select*
From [Portfolio Project].dbo.Nashville_Housing