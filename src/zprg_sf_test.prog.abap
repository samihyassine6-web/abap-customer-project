*&---------------------------------------------------------------------*
*& Report ZPRG_SF_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_sf_test.

DATA: lv_ono TYPE zdeono_28.
DATA: lv_creaby TYPE zdecrby_28.

TYPES: BEGIN OF lty_data,
         ono    TYPE zdeono_28,
         odate  TYPE zdeodate_28,
         creaby TYPE zdecrby_28,
       END OF lty_data.

DATA: lt_data TYPE TABLE OF lty_data.
DATA: lwa_data TYPE lty_data.

SELECT-OPTIONS: s_ono FOR lv_ono.
SELECT-OPTIONS: s_creaby FOR lv_creaby no INTERVALS no-EXTENSION.

SELECT ono odate creaby
  FROM zordh_28
  INTO TABLE lt_data
  WHERE ono IN s_ono
  AND creaby IN s_creaby.

  CALL FUNCTION '/1BCDWB/SF00000001'
    EXPORTING
*     ARCHIVE_INDEX              =
*     ARCHIVE_INDEX_TAB          =
*     ARCHIVE_PARAMETERS         =
*     CONTROL_PARAMETERS         =
*     MAIL_APPL_OBJ              =
*     MAIL_RECIPIENT             =
*     MAIL_SENDER                =
*     OUTPUT_OPTIONS             =
*     USER_SETTINGS              = 'X'
      pono_low                   = s_ono-low
      pono_high                  = s_ono-high
      pcreaby                    = s_creaby-low
      lt_output                  = lt_data
*   IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO            =
*     JOB_OUTPUT_OPTIONS         =
*   EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS                     = 5
            .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
