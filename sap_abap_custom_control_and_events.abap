*&---------------------------------------------------------------------*
*& Report z_skpl_dga_ccontainer_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_skpl_dga_ccontainer_001.

CONSTANTS line_length TYPE i VALUE 256.

TYPES: BEGIN OF tt_tab,
         line(line_length) TYPE c,
       END OF tt_tab.

DATA: ok_code          LIKE sy-ucomm,
      custom_container TYPE REF TO cl_gui_custom_container,
      editor           TYPE REF TO cl_gui_textedit,
      repid            LIKE sy-repid,
      gt_tab           TYPE TABLE OF tt_tab,
      gs_line          LIKE LINE OF gt_tab,
      g_loaded         TYPE c,
      g_evnt_type(20)  TYPE c,
      gt_events type cntl_simple_events,
      gs_event like line of gt_events.

FORM import_text_from_file.
  editor->set_text_as_r3table( EXPORTING table = gt_tab EXCEPTIONS error_dp = 1 error_dp_create = 2 OTHERS = 3 ).
  IF sy-subrc NE 0.
    CALL FUNCTION 'popup_to_inform' EXPORTING titel = repid txt2 = '' txt1 = 'Error in set_text_as_r3table.'(600).
  ELSE.
    g_loaded = 'X'.
  ENDIF.

  cl_gui_cfw=>flush( ).
ENDFORM.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: catch_dbclick FOR EVENT dblclick OF cl_gui_textedit IMPORTING sender.
ENDCLASS.

"data: event_handler type ref to lcl_event_handler.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD catch_dbclick.
    sender->get_selection_pos( IMPORTING from_line = data(lv_sel_line) ).
    CALL FUNCTION 'POPUP_TO_INFORM' EXPORTING titel = 'Event notification:' txt1 = lv_sel_line txt2 = TEXT-002.
  ENDMETHOD.
ENDCLASS.



START-OF-SELECTION.
  SET SCREEN '100'.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'IMP'.
      PERFORM import_text_from_file.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  IF editor IS INITIAL.
    repid = sy-repid.
    CREATE OBJECT custom_container
      EXPORTING
        container_name              = 'MYCONTAINER1'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_dynpro_dynpro_link = 4
        lifetime_error              = 5
        OTHERS                      = 6.

    CREATE OBJECT editor EXPORTING parent = custom_container.
    SET HANDLER lcl_event_handler=>catch_dbclick FOR editor.

    gs_event-eventid = cl_gui_textedit=>event_double_click.
    append gs_event TO gt_events.

    editor->set_registered_events( events = gt_events ).

    DO 20 TIMES.
      WRITE TEXT-001 TO gs_line-line.
      APPEND gs_line TO gt_tab.
    ENDDO.



  ENDIF.

ENDMODULE.