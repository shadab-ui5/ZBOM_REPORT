@EndUserText.label: 'RESPONCE CDS'
//@EndUserText.label: 'Root'
@Metadata.allowExtensions: true
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:YPP_BOM_REPORT'
    }
}


define root custom entity Yresponcecds_BOM

{

      @UI.lineItem                 : [{ position: 10 }]
      @UI.selectionField           : [{position: 10}]
      @UI.identification           : [{position: 10}]
//      @Consumption.filter.mandatory: true
      @EndUserText.label           : 'Alternative'
  key BillOfMaterialVariant        : abap.char( 2 );


      @UI.lineItem                 : [{ position: 20 }]
      @UI.identification           : [{position: 20 }]
      @UI.selectionField           : [{position: 20}]
//      @Consumption.filter.mandatory: true
      @EndUserText.label           : 'Plant'
      @Consumption.valueHelpDefinition: [
      { entity                     :  { name:    'I_PlantStdVH',
             element               : 'Plant' }
      }]
  key Plant                        : abap.char( 4 );


      @UI.lineItem                 : [{ position: 30 }]
      @UI.selectionField           : [{position: 30}]
      @UI.identification           : [{position: 30}]
//      @Consumption.filter.mandatory: true
      @EndUserText.label           : 'Material'
      @Consumption.valueHelpDefinition: [
      { entity                     :  { name:    'ZPRODUCT__F4',
           element                 : 'Product' }
      }]
  key BillOfMaterial               : abap.char( 40 );

  key ParentMaterial               : abap.char( 40 );


      @UI.lineItem                 : [{ position: 40 }]
      @UI.identification           : [{position: 40}]
      //      @UI.selectionField           : [{position: 60}]
      @EndUserText.label           : 'Header Description'
  key HeaderDescription            : abap.char( 50 );


  key BOMHeaderBaseUnit            : abap.unit( 3 );

      @UI.lineItem                 : [{ position: 50 }]
      @UI.identification           : [{position: 50}]
      @EndUserText.label           : 'Header Base Qty.'
      @Semantics.quantity.unitOfMeasure: 'BOMHeaderBaseUnit'
  key Baseqty                      : abap.quan( 13, 3 );

      @UI.lineItem                 : [{ position: 60 }]
//      @UI.selectionField           : [{position: 60}]
      @UI.identification           : [{position: 60}]
  key BillOfMaterialCategory       : abap.char( 1 );


  key BillOfMaterialItemUnit       : abap.unit( 3 );

      @UI.lineItem                 : [{ position: 70 }]
      @UI.identification           : [{position: 70}]
      @EndUserText.label           : 'Item'
  key BillOfMaterialItemNumber     : abap.char( 4 );

      @UI.lineItem                 : [{ position: 80 }]
      @UI.identification           : [{position: 80}]
      @EndUserText.label           : 'Component'
  key BillOfMaterialComponent      : abap.char( 40 );


      @UI.lineItem                 : [{ position: 90 }]
      @UI.identification           : [{position: 90}]
      @EndUserText.label           : 'Component Description'
  key ProductDescription           : abap.char( 50 );


      @UI.lineItem                 : [{ position: 100 }]
      @UI.identification           : [{position: 100 }]
      @EndUserText.label           : 'Component Base  Qty.'
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
  key BillOfMaterialItemQuantity   : abap.quan( 13, 3 );


      @UI.lineItem                 : [{ position: 110 }]
      @UI.identification           : [{position: 110 }]
      @EndUserText.label           : 'Comp Mat Type'
  key ProductType                  : abap.char( 4 );


      @UI.lineItem                 : [{ position: 120 }]
      @UI.identification           : [{position: 120 }]
      @EndUserText.label           : 'Comp. Mat Group'
  key ProductGroup                 : abap.char( 9 );



  key MaterialBaseUnit             : abap.unit( 3 );

      @UI.lineItem                 : [{ position: 130 }]
      @UI.identification           : [{position: 130 }]
      @EndUserText.label           : 'Available Stock'
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  key MatlWrhsStkQtyInMatlBaseUnit : abap.quan( 17, 3 );




      @UI.lineItem                 : [{ position: 140 }]
      @UI.identification           : [{position: 140}]
      @UI.selectionField           : [{position: 50}]
      @EndUserText.label           : 'Required Qty.'
      @Consumption.filter.mandatory: true
      //      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
  key Reqbaseqty                   : abap.dec( 13, 3 );

      @UI.lineItem                 : [{ position: 150 }]
      @UI.identification           : [{position: 150}]
      @EndUserText.label           : 'Required Component Qty.'
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
  key Reqcompoqty                  : abap.quan( 13, 3 );

      //      @UI.lineItem                 : [{ position: 130 }]
      //      @UI.identification           : [{position: 130}]
      //      @EndUserText.label           : 'Available Stock'
      //      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      //  key Avlstock :  abap.quan( 13, 3 );

      @UI.lineItem                 : [{ position: 160 }]
      @UI.identification           : [{position: 160}]
      @EndUserText.label           : 'Qty to Produce'
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
  key Qtytoproduce                 : abap.quan( 13, 3 );

      @UI.lineItem                 : [{ position: 170 }]
      @UI.identification           : [{position: 170}]
      //      @Aggregation.default: #SUM
      @EndUserText.label           : 'Min. Set to be Produce'
      //      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
  key Settoproduce                 : abap.dec( 13, 3 );

}
