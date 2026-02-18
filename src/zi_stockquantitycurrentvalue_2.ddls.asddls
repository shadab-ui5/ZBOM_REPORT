@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_STOCKQUANTITYCURRENTVALUE_2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_STOCKQUANTITYCURRENTVALUE_2
   as select from   
    I_StockQuantityCurrentValue_2( P_DisplayCurrency: 'INR' ) 

{
key Product,
key Plant,
key StorageLocation,
key Supplier,
key SDDocument,
key SDDocumentItem,
key WBSElementInternalID,
key Customer,
key SpecialStockIdfgStockOwner,
//key InventoryStockType,
key InventorySpecialStockType,
key MaterialBaseUnit,
key Currency,
@Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
sum(MatlWrhsStkQtyInMatlBaseUnit ) as MatlWrhsStkQtyInMatlBaseUnit 
}

where ValuationAreaType = '1'
group by
 Product,
 Plant,
StorageLocation,
 Supplier,
 SDDocument,
 SDDocumentItem,
 WBSElementInternalID,
 Customer,
 SpecialStockIdfgStockOwner,
// InventoryStockType,
 InventorySpecialStockType,
 MaterialBaseUnit,
Currency
