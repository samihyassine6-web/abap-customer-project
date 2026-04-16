*&---------------------------------------------------------------------*
*& Include          ZSEL_SALES_ORDER
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK blc WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: s_odate FOR lv_odate NO-EXTENSION OBLIGATORY.
SELECT-OPTIONS: s_creaby FOR lv_creaby NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK blc.
