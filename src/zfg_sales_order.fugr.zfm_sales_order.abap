FUNCTION zfm_sales_order.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(SODATE) TYPE  ZTT_ODATE
*"     REFERENCE(SCREABY) TYPE  ZTT_CREABY
*"  EXPORTING
*"     REFERENCE(LT_OUTPUT) TYPE  ZTT_OUTPUT
*"  EXCEPTIONS
*"      WRONG_INPUT
*"----------------------------------------------------------------------
**"----------------------------------------------------------------------
**"*"Lokale Schnittstelle:
**"  IMPORTING
**"     REFERENCE(SODATE) TYPE  ZTT_ODATE
**"     REFERENCE(SCREABY) TYPE  ZTT_CREABY
**"  EXPORTING
**"     REFERENCE(LT_OUTPUT) TYPE  ZTT_OUTPUT
**"----------------------------------------------------------------------
*
  TYPES: BEGIN OF lty_ordh,
           ono    TYPE zdeono_28,
           creaby TYPE zdecrby_28,
         END OF lty_ordh.

  DATA: lt_ordh TYPE TABLE OF lty_ordh.
  DATA: lwa_ordh TYPE lty_ordh.

  TYPES: BEGIN OF lty_ordi,
           ono    TYPE zdeono_28,
           oin    TYPE zdeoin_28,
           itemid TYPE zdeitemid_28,
           meng   TYPE zdemeng_28,
           icost  TYPE zdeicost_28,
         END OF lty_ordi.

  DATA: lt_ordi TYPE TABLE OF lty_ordi.
  DATA: lt_temp_ordi TYPE TABLE OF lty_ordi.
  DATA: lwa_ordi TYPE lty_ordi.
  DATA: lwa_output TYPE zstr_output.
  DATA: lv_index TYPE i.

  TYPES: BEGIN OF lty_ztitemt,
           spras    TYPE spras,
           itemid   TYPE zdeitemid_28,
           itemdesc TYPE zdeitemdesc_28,
         END OF lty_ztitemt.

  DATA: lt_ztitemt TYPE TABLE OF lty_ztitemt.
  DATA: lwa_ztitemt TYPE lty_ztitemt.

  SELECT ono creaby
    FROM zordh_28
    INTO TABLE lt_ordh
    WHERE odate IN sodate AND creaby IN screaby.
  IF lt_ordh IS NOT INITIAL.
    SELECT ono oin itemid meng icost
      FROM zordi_28
      INTO TABLE lt_ordi
      FOR ALL ENTRIES IN lt_ordh
      WHERE ono = lt_ordh-ono.
  ELSE.
    RAISE wrong_input.
  ENDIF.

  IF lt_ordi IS NOT INITIAL.
    lt_temp_ordi = lt_ordi.
    SORT lt_temp_ordi BY itemid.
    DELETE ADJACENT DUPLICATES FROM lt_temp_ordi COMPARING itemid.
    SELECT spras itemid itemdesc
      FROM ztitemt_28
      INTO TABLE lt_ztitemt
      FOR ALL ENTRIES IN lt_temp_ordi
      WHERE itemid = lt_temp_ordi-itemid
      AND spras = sy-langu.
  ENDIF.

  SORT lt_ztitemt BY itemid.
  SORT lt_ordi BY ono.

  LOOP AT lt_ordh INTO lwa_ordh.
    READ TABLE lt_ordi INTO lwa_ordi WITH KEY ono = lwa_ordh-ono BINARY SEARCH.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
    ENDIF.
    LOOP AT lt_ordi INTO lwa_ordi FROM lv_index.  " WHERE ono = lwa_ordh-ono.
      IF lwa_ordh-ono = lwa_ordi-ono.
        lwa_output-ono = lwa_ordh-ono.
        lwa_output-oin    = lwa_ordi-oin.
        lwa_output-itemid = lwa_ordi-itemid.
        lwa_output-meng   = lwa_ordi-meng.
        lwa_output-icost  = lwa_ordi-icost.
        READ TABLE lt_ztitemt INTO lwa_ztitemt WITH KEY itemid = lwa_ordi-itemid BINARY SEARCH.
        IF sy-subrc = 0.
          lwa_output-itemdesc = lwa_ztitemt-itemdesc.
        ENDIF.
        APPEND lwa_output TO lt_output.
        CLEAR lwa_output.
      ELSE.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

ENDFUNCTION.
