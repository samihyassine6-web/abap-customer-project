*&---------------------------------------------------------------------*
*& Include          ZDATA_SALES_ORDER
*&---------------------------------------------------------------------*

DATA: lv_odate TYPE zdeodate_28.
DATA: lv_creaby TYPE zdecrby_28.
DATA: lt_final TYPE ztt_output.
DATA: lwa_final TYPE zstr_output.
DATA: lo_object TYPE REF TO zcl_sales_order.
DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.
DATA: lwa_fieldcat TYPE slis_fieldcat_alv.
