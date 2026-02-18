//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.sqlViewName: 'YBOM_1'

@EndUserText.label: 'BOM REPORT'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

define view YBOM
  as select from    I_MaterialBOMLink                                         as a
    left outer join I_BillOfMaterialItemDEX_3                                 as b  on(
       b.BillOfMaterial             = a.BillOfMaterial
       and b.BillOfMaterialVariant  = a.BillOfMaterialVariant
       and b.BillOfMaterialCategory = 'M'     )
       
    left outer join I_ProductDescription                                      as c  on(
       c.Product      = b.BillOfMaterialComponent
       and c.Language = 'E'     )
       
    left outer join I_Product                                                 as D  on(
       D.Product = b.BillOfMaterialComponent     )
       
    left outer join ZI_STOCKQUANTITYCURRENTVALUE_2 as E  on(
       E.Product               = b.BillOfMaterialComponent
       and E.Plant             = a.Plant
//       and E.StorageLocation   = 'ST01'
//       and E.ValuationAreaType = '1'
     )


    inner join      I_ProductDescription                                      as D1 on(
      D1.Product      = a.Material
      and D1.Language = 'E'
    )
    left outer join I_BillOfMaterialHeaderDEX_2                               as f  on(
       f.BillOfMaterial             = a.BillOfMaterial
       and f.BillOfMaterialVariant  = a.BillOfMaterialVariant
       and f.BillOfMaterialCategory = a.BillOfMaterialCategory
//       and f.BOMHeaderInternalChangeCount = b.BillOfMaterialItemNodeNumber
     )


{
  key a.BillOfMaterialCategory,
  key a.BillOfMaterial,
  key a.Material,
      b.BillOfMaterialVariant,
      b.BillOfMaterialItemNodeNumber,
      b.BOMInstceInternalChangeNumber,
      b.BillOfMaterialComponent,
      b.BillOfMaterialItemQuantity,
//      b.BillOfMaterialItemUnit,
        
   case 
    when b.BillOfMaterialItemUnit = 'ST' then 'PC'
    else b.BillOfMaterialItemUnit
end as BillOfMaterialItemUnit ,

      b.BillOfMaterialItemNumber,
      D1.ProductDescription         as HeaderDescription,
      a.Plant,
      c.ProductDescription,
      D.ProductGroup,
      D.ProductType,
      E.MaterialBaseUnit,

   
//      E.StorageLocation,
      f.BOMHeaderBaseUnit,
 f.BOMHeaderQuantityInBaseUnit as Baseqty,
@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
 sum(E.MatlWrhsStkQtyInMatlBaseUnit ) as MatlWrhsStkQtyInMatlBaseUnit




}

group by

   a.BillOfMaterialCategory,
   a.BillOfMaterial,
   a.Material,
      b.BillOfMaterialVariant,
      b.BillOfMaterialItemNodeNumber,
      b.BOMInstceInternalChangeNumber,
      b.BillOfMaterialComponent,
      b.BillOfMaterialItemNumber,
      D1.ProductDescription,
      a.Plant,
      f.BOMHeaderBaseUnit,
      c.ProductDescription,
      D.ProductGroup,
      D.ProductType,
      E.MaterialBaseUnit,
      f.BOMHeaderQuantityInBaseUnit, 
      b.BillOfMaterialItemQuantity,
    b.BillOfMaterialItemUnit


      



