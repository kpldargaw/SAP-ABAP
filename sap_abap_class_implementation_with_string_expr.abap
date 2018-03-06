*&---------------------------------------------------------------------*
*& Report  zdga_test_01
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdga_test_01.

"CALL FUNCTION 'Z_AUTHORITY_CHECK' EXPORTING pi_bukrs = 2110.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: main,
                   func RETURNING value(p) TYPE string.
  PRIVATE SECTION.
    CLASS-DATA attr TYPE string VALUE `Hello`.
ENDCLASS.

CLASS demo IMPLEMENTATION.
  METHOD main.
    DATA txt TYPE string.
    txt = |{ attr }{ func( ) "a function
                     WIDTH = 6 ALIGN = RIGHT }{ attr }|.
    MESSAGE txt TYPE 'I'.
  ENDMETHOD.
  METHOD func.
    p = `world`.
    attr = '!'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).