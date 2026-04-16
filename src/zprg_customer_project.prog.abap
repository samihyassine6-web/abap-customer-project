*&---------------------------------------------------------------------*
*& Report ZPRG_CUSTOMER_PROJECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprg_customer_project.

INCLUDE zdata_sales_order. " Data Declaration
INCLUDE zsel_sales_order.  " Select Options


*CALL FUNCTION 'ZFM_SALES_ORDER'
*  EXPORTING
*    sodate      = s_odate[]
*    screaby     = s_creaby[]
*  IMPORTING
*    lt_output   = lt_final
*  EXCEPTIONS
*    wrong_input = 1
*    OTHERS      = 2.
*
*IF sy-subrc <> 0.
*  MESSAGE: i013(zmessage).
*ENDIF.


CREATE OBJECT lo_object.

CALL METHOD lo_object->get_sales_orders
  EXPORTING
    sodate      = s_odate[]
    screaby     = s_creaby[]
  IMPORTING
    lt_output   = lt_final
  EXCEPTIONS
    wrong_input = 1
    OTHERS      = 2.
IF sy-subrc <> 0.
  MESSAGE: i013(zmessage).
ELSE.

* CREATE FIELD catalog Using modulusation technic
*--------------------------------------------------------------------*

  PERFORM fieldcat USING '1' 'ONO'      TEXT-001 CHANGING lt_fieldcat.
  PERFORM fieldcat USING '2' 'OIN'      TEXT-003 CHANGING lt_fieldcat.
  PERFORM fieldcat USING '3' 'ITEMID'   TEXT-004 CHANGING lt_fieldcat.
  PERFORM fieldcat USING '4' 'MENG'     TEXT-005 CHANGING lt_fieldcat.
  PERFORM fieldcat USING '5' 'ICOST'    TEXT-006 CHANGING lt_fieldcat.
  PERFORM fieldcat USING '6' 'ITEMDESC' TEXT-007 CHANGING lt_fieldcat.

* Data Binding
*--------------------------------------------------------------------*

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK        = ' '
*     I_BYPASSING_BUFFER       = ' '
*     I_BUFFER_ACTIVE          = ' '
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'PF_STATUS'
      i_callback_user_command  = 'USER_CM'
      i_callback_top_of_page   = 'TOP_OF_PAGE'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME         =
*     I_BACKGROUND_ID          = ' '
*     I_GRID_TITLE             =
*     I_GRID_SETTINGS          =
*     IS_LAYOUT                =
      it_fieldcat              = lt_fieldcat
*     IT_EXCLUDING             =
*     IT_SPECIAL_GROUPS        =
*     IT_SORT                  =
*     IT_FILTER                =
*     IS_SEL_HIDE              =
*     I_DEFAULT                = 'X'
*     I_SAVE                   = ' '
*     IS_VARIANT               =
*     IT_EVENTS                =
*     IT_EVENT_EXIT            =
*     IS_PRINT                 =
*     IS_REPREP_ID             =
*     I_SCREEN_START_COLUMN    = 0
*     I_SCREEN_START_LINE      = 0
*     I_SCREEN_END_COLUMN      = 0
*     I_SCREEN_END_LINE        = 0
*     I_HTML_HEIGHT_TOP        = 0
*     I_HTML_HEIGHT_END        = 0
*     IT_ALV_GRAPHICS          =
*     IT_HYPERLINK             =
*     IT_ADD_FIELDCAT          =
*     IT_EXCEPT_QINFO          =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER  =
*     ES_EXIT_CAUSED_BY_USER   =
    TABLES
      t_outtab                 = lt_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDIF.

FORM pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'SALES'.
ENDFORM.

FORM user_cm  USING r_ucomm LIKE sy-ucomm
                                  rs_selfield TYPE slis_selfield.
  DATA: lv_fname TYPE rs38l_fnam.
  DATA: lwa_control_parameters TYPE ssfctrlop.
  DATA: lwa_output_options TYPE ssfcompop.

  IF r_ucomm = 'SMARTFORMS'.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZSF_SALESORDERS'
      IMPORTING
        fm_name            = lv_fname
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    lwa_control_parameters-no_dialog = 'X'.
    lwa_control_parameters-preview = 'X'.
    lwa_output_options-tddest = 'LP01'.

    CALL FUNCTION lv_fname
      EXPORTING
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        control_parameters = lwa_control_parameters
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = lwa_output_options
*       user_settings      = 'X'
        podate_low         = s_odate-low
        podate_high        = s_odate-high
        pcreaby            = s_creaby-low
        lt_output          = lt_final
*     IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO    =
*       JOB_OUTPUT_OPTIONS =
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

  IF r_ucomm = 'ADOBEEFORMS'.
    MESSAGE: 'ADS Configuration error!' TYPE 'I'.
  ENDIF.
ENDFORM.

FORM top_of_page.

  DATA: lt_list TYPE slis_t_listheader.
  DATA: lwa_list TYPE slis_listheader.
  DATA: lv_date(30) TYPE c.
  DATA: lv_low(10) TYPE c.
  DATA: lv_high(10) TYPE c.

  lwa_list-typ = 'H'.
  lwa_list-info = TEXT-008.
  APPEND lwa_list TO lt_list.
  CLEAR lwa_list.

  IF s_odate-low IS NOT INITIAL AND s_odate-high IS INITIAL.
    CONCATENATE s_odate-low+6(2) '.' s_odate-low+4(2) '.' s_odate-low+0(4) INTO lv_low.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-009.
    lwa_list-info = lv_low.
    APPEND lwa_list TO lt_list.
    CLEAR lwa_list.
  ENDIF.

  IF s_odate-low IS NOT INITIAL AND s_odate-high IS NOT INITIAL.
    CONCATENATE s_odate-low+6(2) '.' s_odate-low+4(2) '.' s_odate-low+0(4) INTO lv_low.
    CONCATENATE s_odate-high+6(2) '.' s_odate-high+4(2) '.' s_odate-high+0(4) INTO lv_high.
    CONCATENATE lv_low TEXT-010 lv_high INTO lv_date SEPARATED BY space.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-009.
    lwa_list-info = lv_date.
    APPEND lwa_list TO lt_list.
    CLEAR lwa_list.
  ENDIF.

  IF s_creaby IS NOT INITIAL.
    lwa_list-typ = 'S'.
    lwa_list-key = TEXT-011.
    lwa_list-info = s_creaby-low.
    APPEND lwa_list TO lt_list.
    CLEAR lwa_list.
  ENDIF.

  lwa_list-typ = 'A'.
  lwa_list-info = TEXT-012.
  APPEND lwa_list TO lt_list.
  CLEAR lwa_list.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_list.

ENDFORM.

INCLUDE zprg_customer_project_fieldf01.
