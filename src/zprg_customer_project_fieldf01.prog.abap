*----------------------------------------------------------------------*
***INCLUDE ZPRG_CUSTOMER_PROJECT_FIELDF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> TEXT_001
*&      <-- LT_FIELDCAT
*&---------------------------------------------------------------------*
FORM fieldcat  USING    pv_colpos
                        pv_fieldname
                        pv_text
               CHANGING pt_fieldcat TYPE slis_t_fieldcat_alv.

  lwa_fieldcat-col_pos   = pv_colpos.
  lwa_fieldcat-fieldname = pv_fieldname.
  lwa_fieldcat-seltext_l = pv_text.
  APPEND lwa_fieldcat TO pt_fieldcat.
  CLEAR lwa_fieldcat.

ENDFORM.
