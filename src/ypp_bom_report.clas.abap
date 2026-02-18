CLASS ypp_bom_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YPP_BOM_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response TYPE TABLE OF yresponcecds_bom.
    DATA:lt_current_output TYPE TABLE OF yresponcecds_bom.
    DATA:wa1 TYPE yresponcecds_bom.



    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).


TRY.
    DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
  CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    CLEAR lt_filter_cond.  " Ensure lt_filter_cond is initialized
ENDTRY.


 TYPES :  BEGIN OF st_qty,
   matnr1         type i_product-product,
   Qtytoproduce   type I_BillOfMaterialItemDEX_3-BillOfMaterialItemQuantity ,
 END OF st_qty.


 DATA: lt_temp TYPE TABLE OF st_qty,
       ls_temp TYPE st_qty.

    DATA:mat(18)  TYPE c.
    DATA:mat1(18) TYPE c.
    DATA: Reqty type p decimals 2.
    DATA: Reqty1 type p decimals 2.
    DATA: qty type p decimals 3.

    DATA(lr_material)  =  VALUE #( lt_filter_cond[ name   =  'BILLOFMATERIAL'  ]-range OPTIONAL ).
    DATA(lr_plant)  =  VALUE #( lt_filter_cond[ name   = 'PLANT' ]-range OPTIONAL ).
    DATA(lr_Reqbaseqty)  =  VALUE #( lt_filter_cond[ name   = 'REQBASEQTY' ]-range OPTIONAL ).
    DATA(lr_BillOfMaterialVariant)  =  VALUE #( lt_filter_cond[ name   = 'BILLOFMATERIALVARIANT' ]-range OPTIONAL ).


    LOOP AT lr_material ASSIGNING FIELD-SYMBOL(<ft>) .
     mat = <FT>-low.
     mat1 = <FT>-high.
     mat = |{ MAT ALPHA = IN } |.
     mat1 = |{ MAT1 ALPHA = IN } |.
     CLEAR:<FT>-low,<ft>-high.
    <FT>-low  = MAT.
    <ft>-high = MAT1.
    ENDLOOP.


    LOOP AT lr_Reqbaseqty ASSIGNING FIELD-SYMBOL(<ft1>) .
     Reqty = <FT1>-low.
     Reqty1 = <FT1>-high.
*     Reqty = |{ MAT ALPHA = IN } |.
*     Reqty = |{ MAT1 ALPHA = IN } |.
     CLEAR:<FT>-low,<ft>-high.
    <FT>-low  = MAT.
    <ft>-high = MAT1.
    ENDLOOP.

*************************************************************
****Data retrival and business logics goes here*****

*********
   DATA   Qtytoproduce TYPE P DECIMALS 3.
 DATA   lv_min_qtytoproduce TYPE P DECIMALS 3.
 data wa1_previous_material(40) type c.

    SELECT
        BillOfMaterialCategory,
        BillOfMaterial,
        Material,
        BillOfMaterialVariant,
        BillOfMaterialItemNodeNumber,
        BOMInstceInternalChangeNumber,
        BillOfMaterialComponent,
        BillOfMaterialItemQuantity,
        BillOfMaterialItemUnit,
        BillOfMaterialItemNumber,
        HeaderDescription,
        Plant,
        ProductDescription,
        ProductType,
        ProductGroup,
        MaterialBaseUnit,
        BOMHeaderBaseUnit,
        Baseqty,
        MatlWrhsStkQtyInMatlBaseUnit
       FROM
       ybom
       WHERE Material in @lr_material
       AND plant IN @lr_plant
       AND BillOfMaterialVariant IN @lr_billofmaterialvariant
       INTO TABLE @DATA(bom) .

DATA(COMPONENT) = bom[].

 SORT bom BY Material .
* DELETE ADJACENT DUPLICATES FROM bom COMPARING Material.

    LOOP AT bom INTO DATA(wa_tab) .
      MOVE-CORRESPONDING wa_tab TO wa1.
      wa1-billofmaterialvariant = wa_tab-billofmaterialvariant .
*     IF sy-tabix = 1.
      wa1-BillOfMaterial = wa_tab-material.
*    ELSE.
*      wa1-BillOfMaterial = wa_tab-billofmaterialcomponent.
*    ENDIF.
      wa1-BillOfMaterialItemNumber = wa_tab-BillOfMaterialItemNumber.
      wa1-productdescription = wa_tab-productdescription.
      wa1-Plant = wa_tab-Plant.
      wa1-billofmaterialitemquantity = wa_tab-billofmaterialitemquantity.
      wa1-billofmaterialcomponent = wa_tab-billofmaterialcomponent.
      wa1-producttype      =   wa_tab-producttype.
      wa1-productgroup        =   wa_tab-productgroup.
      wa1-matlwrhsstkqtyinmatlbaseunit      =   wa_tab-matlwrhsstkqtyinmatlbaseunit.
      wa1-Reqbaseqty = Reqty.
      wa1-Baseqty = wa_tab-Baseqty.

      wa1-Reqcompoqty = ( ( wa_tab-BillOfMaterialItemQuantity * Reqty ) / wa_tab-Baseqty ).
      IF wa_tab-BillOfMaterialItemQuantity <> 0.

WA1-Qtytoproduce = FLOOR( wa_tab-MatlWrhsStkQtyInMatlBaseUnit / wa_tab-BillOfMaterialItemQuantity * wa_tab-Baseqty ).


   ENDIF.

 delete lt_temp where matnr1 <> wa_tab-BillOfMaterial.

 loop at bom into data(wa_bom) where BillOfMaterial = wa_tab-BillOfMaterial.

*  MOVE-CORRESPONDING wa_bom TO ls_temp.

  ls_temp-Qtytoproduce = FLOOR( wa_bom-MatlWrhsStkQtyInMatlBaseUnit / wa_bom-BillOfMaterialItemQuantity * wa_bom-Baseqty ).
  ls_temp-matnr1 = wa_bom-BillOfMaterial.

*  MODIFY lt_temp from ls_temp.
APPEND ls_temp to lt_temp.

 endloop.

* select single min( Qtytoproduce ) as qty from lt_temp where BillOfMaterial = @wa_tab-BillOfMaterial
*      into @data(min_qty) .
  delete lt_temp where Qtytoproduce < 0.
  sort lt_temp by Qtytoproduce.
  read table lt_temp into data(ls) index 1.

  if ls-Qtytoproduce > 0 .
  WA1-Settoproduce = ls-Qtytoproduce.
  ENDIF.

*  IF
*  sy-tabix = 1 OR
*   wa1-BillOfMaterial <> wa1_previous_material.
*
*    " Output data for the previous material group
*    IF
*    sy-tabix <> 1 AND
*    lv_min_qtytoproduce >= 0 AND wa1_previous_material <> ''.
*      LOOP AT lt_response INTO DATA(wa_response).
*        IF wa_response-BillOfMaterial = wa1_previous_material.
*          wa_response-Settoproduce = lv_min_qtytoproduce.
*          MODIFY lt_response FROM wa_response.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*    CLEAR: lv_min_qtytoproduce.
*
*    " Initialize minimum for the new material group
*    IF wa1-Qtytoproduce >= 0.
*      lv_min_qtytoproduce = wa1-Qtytoproduce.
*    ENDIF.
*
*    wa1_previous_material = wa1-BillOfMaterial.
*
*  ELSE.
*    " For the same material, find the lowest positive Qtytoproduce
*    IF wa1-Qtytoproduce >= 0 AND
*       ( lv_min_qtytoproduce = 0 OR wa1-Qtytoproduce < lv_min_qtytoproduce ).
*      lv_min_qtytoproduce = wa1-Qtytoproduce.
*
*    ENDIF.
*  ENDIF.

  SHIFT wa1-BillOfMaterial LEFT DELETING LEADING '0'.
  SHIFT wa1-BillOfMaterialComponent LEFT DELETING LEADING '0'.
  SHIFT wa1_previous_material LEFT DELETING LEADING '0'.
  IF wa1 <> ''.
    APPEND wa1 TO lt_response.
  ENDIF.

  CLEAR : wa_tab, wa1.

ENDLOOP.

" Final output for the last material group
*IF lv_min_qtytoproduce > 0 AND wa1_previous_material <> ''.
*  LOOP AT lt_response INTO wa_response.
*    IF wa_response-BillOfMaterial = wa1_previous_material.
*      wa_response-Settoproduce = lv_min_qtytoproduce.
*      MODIFY lt_response FROM wa_response.
*    ENDIF.
*  ENDLOOP.
*ENDIF.

***************
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    TRY.
        """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*_Paging implementation
        IF lv_top < 0  .
          lv_top = lv_top * -1 .
        ENDIF.
        DATA(lv_start) = lv_skip + 1.
        DATA(lv_end)   = lv_top + lv_skip.
        APPEND LINES OF lt_response FROM lv_start TO lv_end TO lt_current_output.

        io_response->set_total_number_of_records( lines( lt_current_output ) ).
        io_response->set_data( lt_current_output ).

      CATCH cx_root INTO DATA(lv_exception).
        DATA(lv_exception_message) = cl_message_helper=>get_latest_t100_exception( lv_exception )->if_message~get_longtext( ).
    ENDTRY.
*    ENDIF.
  ENDMETHOD.
ENDCLASS.
