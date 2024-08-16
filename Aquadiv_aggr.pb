
;{ Structures
;- Structures
Structure font
  id.i
  name.s
  size.i
  style.i
  color.l
EndStructure  

Structure sorts
  srow.l
  erow.l
  column.l
  xvalue.d
EndStructure  

Structure scroll
  boxx.i
  boxy.i
  boxwidth.i
  boxheight.i
  height.i
  posy.i
EndStructure  

Structure mark
  lower.s
  upper.s
EndStructure  

Structure com
  text.s
  x.d
  y.d
EndStructure  

Structure mergestruc
  x.d
  note.s
  Array set.d(0)
  Array tags.l(0)
EndStructure  

Structure par
  scalex.d
  scaley.d
  scaley2.d
  bound_low.d  ;aktuelle x begrenzung
  bound_up.d
  min.d   ;scale y
  max.d
  totalminx.d   ;x begrenzung des datensatzes
  totalmaxx.d
  min2.d
  max2.d
  minx.d
  maxx.d
  tag1.s
  tag2.s
  tag3.s
  title.s
  abscissa.s
  primaxis.s
  secaxis.s
EndStructure  

Structure xy ;Paar Structure für alle möglichen Wertepaar-Felder
  x.d
  y.d
EndStructure

Structure setxy 
  
  description.s
  
  Array draw.b(0)
  Array secondaxis.b(0)
  Array scale.d(0)
  Array drawscale.l(0)
  Array set.d(0,0)
  Array drawset.l(0,0)
  Array tags.l(0,0)
  Array header.s(0)
  Array notes.s(0)
  List comments.com()
  List meta.s()
  showcomment.b
EndStructure  

;}

;{ init
;-init
;Global fontname.s="Arial"
;Global fontsizesmall.i=11
;Global fontsizelarge.i=16
Global elapsedtime.i=ElapsedMilliseconds()
Global roundmode.w=%0000011101111111
Global FPU_ControlWord.w=%0000001101111111
Global hugenumber.d=Pow(10,25)
;Global font_large.i=LoadFont(#PB_Any,fontname,fontsizelarge)
;Global font_small.i=LoadFont(#PB_Any,fontname,fontsizesmall)
!fstcw [v_FPU_ControlWord]
;InitMouse()
InitSprite()
InitKeyboard()
UsePNGImageEncoder()
UseZipPacker()
;}

Macro invalid(file,row,column)
  (IsNAN(imp(file)\set(row,column)) Or imp(file)\tags(row,column)&#Bitdel)
EndMacro 

;{ Variables and Constants
;- Variables and Constants

Global markoption.i
Global unsaved.b=0
Global current_filename.s=""
Global preview_filename.s=""
Global restore_data.b=0
Global fontstandard.font
Global fontprimaxis.font
Global fontsecaxis.font
Global fontabscissa.font
Global fonttitle.font
Global fontlegend.font
Global fonteditor.font
Global fontcomment.font
Global maskgeneric.s="%dd.%mm.%yyyy %hh:%ii:%ss"
Global maskeditor.s
Global slope.d
Global absolute.d
Global filetype.l
Global n.l
Global directory.s
Global xpos.i
Global ypos.i
Global scrheight.i
Global scrwidth.i
Global selection_bar1.i
Global selection_bar2.i
Global imported.i
Global para.par
Global changed.b=1
Global selected.i=-1
Global imported.i=-1
Global bildchen=CreateImage(#PB_Any,10,10)
Global offset.i=100
Global offset2.i=70
Global offsetvert.i=40
Global interval_x.d
Global interval_y.d
Global interval_y2.d
Global decimals_x.i
Global decimals_y.i
Global decimals_y2.i
Global linelength.l
Global holelength.l
Global mx.i
Global my.i
Global valuex.d
Global valuey.d
Global valuey2.d
Global filterbreite.l
Global filtertype.l
Global filterdegree.l
Global filtersigma.d
Global line1.b
Global line2.b
Global selection_low.d
Global selection_high.d
Global is_time.b
Global mask1.s
Global mask2.s
Global optioninterpol.l
Global intervaltype.l
Global eccorrectiontype.l
Global temptype.l
Global temptype_eh.l
Global is_second.b
Global is_first.b
Global valuex_dropdown.d
Global valuey_dropdown.d
Global graphwidth.l
Global graphheight.l
Global firstdatacustom.l
Global datecolumncustom.l
Global timecolumncustom.l
Global columnseparator.l
Global decimalseparator.l
Global skiprows.i
Global datetimecustom.b
Global maskcustom.s
Global maskcustom2.s
Global is_time_custom.b
Global intervaltype_aggregation.l
Global interval_aggregation.d
Global option_aggregation.l
Global operationtype_aggregation.l
Global aggregate_direction.b
; Global from_aggregation.d
; Global to_aggregation.d
Global lffactor.d
Global colorscheme.b
Global gridx.b
Global gridy.b
Global gridy2.b
Global trans.b
Global inversx.b
Global inversy.b
Global logx.b
Global logy.b
Global logy2.b
Global expx.b
Global expy.b
Global expy2.b
Global usefilename.b
; Global Dim editorposition.i(0)
; Global NewList markers.mark()
Global rersterklick.b
Global legendheight.l
Global editorrows.i
Global editorcolumns.i
Global columnwidth.i=100
Global rowheight.i
;Global editorsteps.i
Global editorpos.i
Global wheelsteps.i=3
Global mcol.i
Global mrow.i
Global mfile.i
Global selcol.i
Global selrow.i
Global editorbar.scroll
Global Dim editorcols.i(0)

para\bound_low=0
para\bound_up=1

Global Dim imp.setxy(0)
;Global Dim conv.setxy(n)
;imp(0)\draw(0)=1
;Dim imp(0)\set.xy(200)

; For i=0 To ArraySize(imp(0)\set())
;   imp(0)\set(i)\x=i
;   imp(0)\set(i)\y=Sin(i/10)
; Next i  

#Bitmark=  %10000000000000000000000000000000
#Bithide=  %01000000000000000000000000000000
#Bitfilter=%00100000000000000000000000000000
#Bitinter= %00010000000000000000000000000000
#Bittrans= %00001000000000000000000000000000
#Bitscale= %00000100000000000000000000000000
#Bitconst= %00000010000000000000000000000000
#Bitdel=   %00000001000000000000000000000000
#Bittag1=  %00000000100000000000000000000000
#Bittag2=  %00000000010000000000000000000000
#Bittag3=  %00000000001000000000000000000000
#Bitaggr=  %00000000000100000000000000000000
#Bitshift= %00000000000010000000000000000000
#Bitedit=  %00000000000001000000000000000000
#Biteccorr=%00000000000000100000000000000000
#Bitehcorr=%00000000000000010000000000000000
#Bitplot=  %00111110000111110000000000000000
;#Bittag4=%00000000000000000000000000000000

#eol=Chr(13)+Chr(10)
#num_tolerance=0.000001

;}

;{ Enumeration
;-enumeration
Enumeration
  #Text_min_dummy
  #Option_Line1
  #Option_Circle1
  #Option_Line2
  #Option_Circle2
  #Option_markprim
  #Option_marksec
  #Option_markboth
  #Win_Plot
  #Win_Para
  #Win_translate
  #Win_scale
  #Win_filter
  #Win_import
  #Win_importpreview
  #Win_titles
  #Win_delcomment
  #Win_mergelists
  #Win_scaleaddition
  #Win_lfcorrection
  #Win_interpolate
  #Win_editmeta
  #Win_ehcorr
  #Win_aggregate
  #Win_editentry
  #Option_aggregate_linear
  #Option_aggregate_operation
  #String_EditEntry
  ;   #Text_aggregate_from
  ;   #Text_aggregate_to
  ;   #Spin_aggregate_from
  ;   #String_aggregate_to
  
  #Option_linearinter
  #Option_nearestneighbor
  #Option_lf1
  #Option_lf2
  #Option_lfcelsius
  #Option_lfkelvin
  #Option_ehcelsius
  #Option_ehkelvin
  #List_mergelist
  #combo_addlist1
  #combo_addlist2
  #combo_lf
  #combo_lftemp
  #combo_eh
  #combo_ehtemp
  #Text_Skiprows
  #Spin_Skiprows
  #Gadget_ImportListe
  ;   #Button_Import
  #Button_import_preview
  #Button_set_preview_file
  #Gadget_Importpreview
  #Button_apply_import
  #Option_File1
  #Option_File2
  #Option_filegeneric
  #Option_filegenericdate
  #Option_filecustom
  #Option_color1
  #Option_color2
  #Spin_FirstDataColumn
  #Spin_DateColumn
  #Spin_TimeColumn
  #Combo_ColumnSeparator
  #Combo_DecimalSeparator
  #String_MaskCustom
  #String_MaskCustom2
  #Checkbox_usefilename
  #String_MaskEditor
  #Text_aggregate_interval
  #Spin_aggregate_interval
  #String_aggregate_interval
  #Combo_aggregate_timeunit
  #Combo_operationtype
  #Text_FirstDataColumn
  #Text_DateColumn
  #Text_TimeColumn
  #Text_ColumnSeparator
  #Text_DecimalSeparator
  #Text_MaskCustom
  #Text_MaskCustom2
  #Text_MaskEditor
  #Text_lfinfo
  #Text_lfinfo2
  #Text_ehinfo
  #Text_lfdata
  #Text_lftemp
  #Text_ehdata
  #Text_ehtemp
  #Checkbox_date_time
  #Checkbox_is_time_custom
  ;   #Button_undelete
  #Button_prev
  #Button_next
  #Button_apply_filter
  #Button_help
  #Button_apply_lf_correction
  #Button_apply_eh_correction
  #Button_apply_interpolate
  #Button_apply_meta
  #Button_apply_aggregation
  #Button_apply_titles
  ;   #Button_savedata
  ;   #Button_loaddata
  #Text_Filter
  #Combo_Filter
  #Combo_interval
  #Option_aggregate_backward
  #Option_aggregate_center
  #Option_aggregate_forward
  #Checkbox_Filterselection
  #List_delcomment
  #Editor_entry
  #Button_apply_entryedit
  #String_min
  #String_min2
  #String_max
  #String_max2
  #Text_min2_dummy
  #Text_max_dummy
  #Text_max2_dummy
  #Text_datemask
  #Text_datemask2
  #Text_lffactor
  #Text_linelength
  #Text_holelength
  #Text_primaxis
  #Text_secaxis
  #Text_abscissa
  #Text_title
  #Text_tag1
  #Text_tag2
  #Text_tag3
  #Text_Font
  #String_primaxis
  #String_secaxis
  #String_abscissa
  #String_title
  #String_tag1
  #String_tag2
  #String_tag3
  #Button_Fonttitle
  #Button_Fontprimaxis
  #Button_Fontsecaxis
  #Button_Fontabscissa
  #Button_Fontlegend
  #Button_Fontstandard
  #Button_Fonteditor
  #Button_Fontcomment
  #Frame_primary
  #Frame_secondary
  #Frame_axes
  #Frame_abscissa
  #Text_maxx
  #Text_minx
  #Text_minx_dummy
  #Text_maxx_dummy
  #String_maxx
  #String_minx
  #Checkbox_minx
  #Checkbox_maxx
  #Checkbox_trans
  #Checkbox_inversx
  #Checkbox_inversy
  #Checkbox_expx
  #Checkbox_expy
  #Checkbox_expy2
  #Checkbox_logx
  #Checkbox_logy
  #Checkbox_logy2
  #Text_slopetranslate
  #String_slopetranslate
  #Text_absolutetranslate
  #String_absolutetranslate
  #Text_Infotranslate
  #Text_scaleaddition_info
  #Button_Gettranslation
  #Button_Apply_translation
  #Button_apply_scale
  #Button_apply_normalize
  #Button_apply_delcomment
  #Button_comment_select
  #Button_show_comment
  #button_apply_merge_lists
  #Button_mergelist_select
  #Button_apply_scale_addition
  #String_scale
  #String_normalize
  #String_datemask
  #String_datemask2
  #String_scaledadditiona
  #String_scaledadditionb
  #String_lffactor
  #Checkbox_interpret_as_time
  ;   #Text_datemaskinfo
  ;   #Text_datemaskinfo2
  #Editor_meta
  #Menu_file
  #Menu_popup
  #Menu_popup_plot
  #Menu_popup_import
  
  #Text_scaledadditiona
  #Text_scaledadditionb
  #Text_scaleaddition_graph1
  #Text_scaleaddition_graph2
  #Option_scaleaddition_add
  #Option_scaleaddition_sub
  #Option_scaleaddition_mul
  #Option_scaleaddition_div
  #Text_min
  #Text_min2
  #Text_max
  #Text_max2
  #Checkbox_min
  #Checkbox_min2
  #Checkbox_max
  #Checkbox_max2
  #Text_selected
  #Text_decimals_x
  #Text_decimals_y
  #Text_decimals_y2
  #Text_interval_x
  #Text_interval_y
  #Text_interval_y2
  #String_interval_x
  #String_interval_y
  #String_interval_y2
  #Spin_decimals_x
  #Spin_decimals_y
  #Spin_decimals_y2
  #Spin_Linelength
  #Spin_Holelength
  #Text_Filterwidth
  #Spin_Filterwidth
  #Text_Filteroption
  #String_Filtersigma
  #Spin_Filterdegree
  #Text_graphwidth
  #Text_graphheight
  #Spin_graphwidth
  #Spin_graphheight
  
  #Menu_Open ;1
  #Menu_Load_Autosave ;2
  #Menu_Save          ;3
  #Menu_Save_as       ;4
  #Menu_Import        ;5
  #Menu_Export        ;6
  #Menu_Copy_to_Clipboard ;7
  #Menu_Save_as_png       ;8
  #Menu_Save_as_emf       ;9
  #Menu_Quit              ;10
  #Menu_Select_all        ;11
  #Menu_Deselect_all      ;12
  #Menu_Mark_all          ;13
  #Menu_Undelete          ;14
  #Menu_Search_selection  ;15
  #Menu_Rename_entry      ;16
  #Menu_Duplicate_entry   ;17
  #Menu_Delete_entry      ;18
  #Menu_Delete_empty_entries
  #Menu_Rename_list       ;20
  #Menu_Delete_list       ;21
  #Menu_Duplicate_list    ;22
  #Menu_Edit_metadata     ;23
  #Menu_Delete_comments   ;24
  #Menu_Appearance        ;25
  #Menu_Filter            ;26
  #Menu_Interpolate       ;27
  #Menu_Translate         ;28
  #Menu_Graph_math        ;29
  #Menu_Add_constant      ;30
  #Menu_Scaling           ;31
  #Menu_Merge_entries     ;32
  #Menu_Merge_lists       ;33
  #Menu_Consolidate_lists ;34
  #Menu_Aggregate_lists   ;35
  #Menu_EC_correction     ;36
  #Menu_Eh_correction     ;37
  #Menu_Help              ;38
  #Menu_About             ;39
  #Menu_Add_comment       ;40
  #Menu_Mark_specififed   ;41
  #Menu_Grid_x            ;42
  #Menu_Grid_y            ;43
  #Menu_Grid_ysec         ;44
  #Menu_Crop_List
  
EndEnumeration 
;}

Procedure set_list()
  ;add new item to gadget list
  If imported>=0
    SetGadgetState(#Button_show_comment,imp(selected)\showcomment)
    ClearGadgetItems(#Gadget_ImportListe)   
    For i=0 To ArraySize(imp(selected)\draw())
      AddGadgetItem(#Gadget_ImportListe,-1,Str(i+1)+Chr(10)+imp(selected)\header(i))
      If imp(selected)\draw(i):SetGadgetItemState(#Gadget_ImportListe,i,GetGadgetItemState(#Gadget_ImportListe,i)|#PB_ListIcon_Selected):EndIf
      If imp(selected)\secondaxis(i):SetGadgetItemState(#Gadget_ImportListe,i,GetGadgetItemState(#Gadget_ImportListe,i)|#PB_ListIcon_Checked):EndIf
    Next i    
    SetGadgetText(#Text_selected,Str(selected+1)+". "+imp(selected)\description)    
  Else
    ClearGadgetItems(#Gadget_Importliste)
    SetGadgetText(#Text_selected,"")
  EndIf
  ;   change_edit_list()
EndProcedure 

Procedure get_minx_maxx()
  
  para\totalmaxx=-Pow(10,30)
  para\totalminx=Pow(10,30)
  For i=0 To imported
    For j=0 To ArraySize(imp(i)\scale())
      If imp(i)\scale(j)<para\totalminx:para\totalminx=imp(i)\scale(j):EndIf
      If imp(i)\scale(j)>para\totalmaxx:para\totalmaxx=imp(i)\scale(j):EndIf
    Next j
  Next i
  
  If GetGadgetState(#Checkbox_minx)
    para\bound_low=para\minx 
  Else 
    para\bound_low=para\totalminx
    para\minx=para\totalminx
    If is_time
      SetGadgetText(#Text_minx_dummy,FormatDate(maskgeneric,para\totalminx))
    Else  
      SetGadgetText(#Text_minx_dummy,StrD(para\totalminx))
    EndIf
  EndIf
  If GetGadgetState(#Checkbox_maxx)
    para\bound_up=para\maxx
  Else  
    para\bound_up=para\totalmaxx
    para\maxx=para\totalmaxx
    If is_time
      SetGadgetText(#Text_maxx_dummy,FormatDate(maskgeneric,para\totalmaxx))
    Else  
      SetGadgetText(#Text_maxx_dummy,StrD(para\totalmaxx))
    EndIf  
  EndIf
  
EndProcedure  

Procedure filter()
  
  breite.l=filterbreite-1
  files=ArraySize(imp()) 
  kernelsum.d  
  kernelsum_local.d
  temp.d
  Dim kernel.d(breite)
  unsaved=1
  
  Select filtertype  ;selection of filter kernels
    Case 1           ;mean      
      For l=0 To breite:kernel(l)=1:Next l:kernelsum=breite+1 
    Case 2  ;sobel
      kernel(0)=-1:kernel(1)=0:kernel(2)=1:kernelsum=1
    Case 3  ;laplace
      kernel(0)=1:kernel(1)=-2:kernel(2)=1:kernelsum=1
    Case 4  ;savitzky golay
      If filterdegree>3
        If breite=6
          kernel(0)=5:kernel(1)=-30:kernel(2)=75:kernel(3)=131:kernel(4)=75:kernel(5)=-30:kernel(6)=5:kernelsum=231
        ElseIf breite=8
          kernel(0)=15:kernel(1)=-55:kernel(2)=30:kernel(3)=135:kernel(4)=179:kernel(5)=135:kernel(6)=30:kernel(7)=-55:kernel(8)=15:kernelsum=429
        EndIf
      Else  
        If breite=4
          kernel(0)=-3:kernel(1)=12:kernel(2)=17:kernel(3)=12:kernel(4)=-3:kernelsum=35
        ElseIf breite=6
          kernel(0)=-2:kernel(1)=3:kernel(2)=6:kernel(3)=7:kernel(4)=6:kernel(5)=3:kernel(6)=-2:kernelsum=21
        ElseIf breite=8
          kernel(0)=-21:kernel(1)=14:kernel(2)=39:kernel(3)=54:kernel(4)=59:kernel(5)=54:kernel(6)=39:kernel(7)=14:kernel(8)=-21:kernelsum=231
        EndIf
      EndIf
    Case 5 ;gauß mean
      For l=0 To breite
        kernel(l)=Exp(-Pow(l-breite/2,2)/(2*Pow(filtersigma,2)))        
        kernelsum+kernel(l)
      Next l
  EndSelect
  
  For i=0 To files
    columns=ArraySize(imp(i)\set(),2)  
    rows=ArraySize(imp(i)\set(),1)
    new=columns
    For j=0 To columns  
      If imp(i)\draw(j)
        todo=0
        For k=0 To rows
          If imp(i)\tags(k,j)&#Bitmark:todo=1:EndIf
        Next k
        If todo Or Not GetGadgetState(#Checkbox_Filterselection)
          new+1
          ReDim imp(i)\set.d(rows,new)
          ReDim imp(i)\drawset.l(rows,new)
          ReDim imp(i)\tags.l(rows,new)
          ReDim imp(i)\header.s(new)
          ReDim imp(i)\draw.b(new)
          ReDim imp(i)\secondaxis.b(new)
          For k=0 To rows
            If imp(i)\tags(k,j)&#Bitmark Or (Not GetGadgetState(#Checkbox_Filterselection) And Not invalid(i,k,j))                
              temp=0
              Select filtertype
                Case 0 ;median  
                  Dim temparray.d(breite)
                  For l=0 To breite
                    If k+l-breite/2<0
                      temparray(l)=(imp(i)\set(0,j))
                    ElseIf k+l-breite/2>rows
                      temparray(l)=(imp(i)\set(rows,j))
                    Else  
                      temparray(l)=imp(i)\set(k+l-breite/2,j)
                    EndIf  
                  Next l
                  SortArray(temparray(),#PB_Sort_Ascending)
                  imp(i)\set(k,new)=temparray(breite/2)
                Case 1,2,3,4,5 ;simple kernels
                  kernelsum_local=kernelsum
                  For l=0 To breite; -breite/2 To breite/2
                    If k+l-breite/2<0:index=0:ElseIf k+l-breite/2>rows:index=rows:Else:index=k+l-breite/2:EndIf
                    If Not invalid(i,index,j);IsNAN(imp(i)\set(index,j)) And Not imp(i)\tags(index,j)&#Bitdel
                      temp+kernel(l)*imp(i)\set(index,j)
                    Else
                      kernelsum_local-kernel(l)
                    EndIf  
                  Next l
                  If Not kernelsum_local=0
                    imp(i)\set(k,new)=temp/kernelsum_local
                  Else
                    imp(i)\set(k,new)=NaN()
                  EndIf  
              EndSelect
              imp(i)\tags(k,new)=imp(i)\tags(k,j)|#Bitfilter
            Else
              imp(i)\set(k,new)=imp(i)\set(k,j)
              imp(i)\tags(k,new)=imp(i)\tags(k,j)
            EndIf
          Next k
          Select filtertype
            Case 0  
              imp(i)\header(new)=imp(i)\header(j)+" (Median Filtered)"
            Case 1  
              imp(i)\header(new)=imp(i)\header(j)+" (Mean Filtered)"
            Case 2
              imp(i)\header(new)=imp(i)\header(j)+" (Sobel Filtered)"
            Case 3
              imp(i)\header(new)=imp(i)\header(j)+" (Laplace Filtered)"
            Case 4
              imp(i)\header(new)=imp(i)\header(j)+" (Savitzky-Golay Filtered)"
            Case 5
              imp(i)\header(new)=imp(i)\header(j)+" (Gauß Filtered)"
          EndSelect
          imp(i)\draw(new)=1
          imp(i)\draw(j)=0
          imp(i)\secondaxis(new)=imp(i)\secondaxis(j)
          If i=selected:AddGadgetItem(#Gadget_ImportListe,-1,Str(new)+Chr(10)+imp(i)\header(new)):EndIf
          SetGadgetItemState(#Gadget_ImportListe,new,GetGadgetItemState(#Gadget_ImportListe,new)|#PB_ListIcon_Selected)
          SetGadgetItemState(#Gadget_ImportListe,j,GetGadgetItemState(#Gadget_ImportListe,j)&~#PB_ListIcon_Selected)
          changed=1
          If imp(i)\secondaxis(j):SetGadgetItemState(#Gadget_ImportListe,new,GetGadgetItemState(#Gadget_ImportListe,new)|#PB_ListIcon_Checked):EndIf
        EndIf
      EndIf
    Next j  
  Next i 
  
  
EndProcedure  

Procedure.b check_overwrite(filename.s)  ;gibts den Dateinamen schon?
  
  ok.b
  ok=0
  If ReadFile(0,filename)
    CloseFile(0)
    If MessageRequester("Warning","Overwrite "+GetFilePart(filename)+" ?",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes  
      If CreateFile(0,filename)
        ok=1
      Else  
        MessageRequester("Error","Could not open file"+#eol+"Probably the file is used by another program") 
      EndIf  
    Else
      MessageRequester("Warning","Saving aborted")
    EndIf
  ElseIf filename 
    If CreateFile(0,filename)
      ok=1
    Else  
      MessageRequester("Error","Could not create file")
    EndIf  
  EndIf
  
  ProcedureReturn ok
  
EndProcedure

Procedure interpolate()
  optioninterpol=GetGadgetState(#Option_linearinter)+2*GetGadgetState(#Option_nearestneighbor)
  If imported>=0
    unsaved=1
    files=ArraySize(imp())
    info.b=1
    
    For i=0 To files
      columns=ArraySize(imp(i)\draw())
      rows=ArraySize(imp(i)\scale())
      new=columns    
      For j=0 To columns
        If imp(i)\draw(j)
          k=-1
          found=0
          Repeat
            k+1
            If invalid(i,k,j):found=1:info=0:EndIf
          Until k=rows Or found
          If found
            imp(i)\draw(j)=0 
            new+1  
            ReDim imp(i)\set.d(rows,new)
            ReDim imp(i)\drawset.l(rows,new)
            ReDim imp(i)\tags.l(rows,new)
            ReDim imp(i)\header.s(new)
            ReDim imp(i)\draw.b(new)
            ReDim imp(i)\secondaxis.b(new)
            imp(i)\draw(new)=1
            imp(i)\header(new)=imp(i)\header(j)+" (Interpolated)"
            imp(i)\secondaxis(new)=imp(i)\secondaxis(j)
            k=-1
            Repeat
              k+1
              If invalid(i,k,j); imp(i)\tags(k,j)&#Bitdel Or IsNAN(imp(i)\set(k,j))               
                start=k
                If k<rows
                  Repeat
                    k+1
                  Until (Not invalid(i,k,j)) Or k=rows
                EndIf  
                If start=0 Or start=rows
                  If optioninterpol=2  ;event though theres nothing to match, nearest neighbor can do the job
                    If start=0
                      For l=0 To k
                        imp(i)\set(l,new)=imp(i)\set(k,j)
                        
                        imp(i)\tags(l,new)=imp(i)\tags(l,j)|#Bitinter&~#Bitdel
                      Next l  
                    Else
                      For l=start To rows
                        imp(i)\set(l,new)=imp(i)\set(start-1,j)
                        
                        imp(i)\tags(l,new)=imp(i)\tags(l,j)|#Bitinter&~#Bitdel
                      Next l  
                    EndIf  
                  Else  
                    For l=start To k
                      imp(i)\set(l,new)=imp(i)\set(l,j)
                      imp(i)\tags(l,new)=imp(i)\tags(l,j)
                    Next l
                  EndIf
                Else 
                  Select optioninterpol
                    Case 1    
                      
                      slope.d=(imp(i)\set(k,j)-imp(i)\set(start-1,j))/(imp(i)\scale(k)-imp(i)\scale(start-1))
                      For l=start To k
                        imp(i)\set(l,new)=imp(i)\set(start-1,j)+slope*(imp(i)\scale(l)-imp(i)\scale(start-1))
                        imp(i)\tags(l,new)=imp(i)\tags(l,j)|#Bitinter&~#Bitdel
                      Next l
                    Case 2
                      For l=start To k
                        If imp(i)\scale(l)-imp(i)\scale(start-1)<=imp(i)\scale(k)-imp(i)\scale(l)
                          imp(i)\set(l,new)=imp(i)\set(start-1,j)
                        Else
                          imp(i)\set(l,new)=imp(i)\set(k,j)
                        EndIf  
                        imp(i)\tags(l,new)=imp(i)\tags(l,j)|#Bitinter&~#Bitdel
                      Next l
                  EndSelect
                EndIf
              Else 
                imp(i)\set(k,new)=imp(i)\set(k,j)
                imp(i)\tags(k,new)=imp(i)\tags(k,j)
              EndIf  
            Until k>=rows  
          EndIf
        EndIf  
      Next j  
    Next i
    If info:MessageRequester("Information","No holes or nothing selected"):EndIf
    
  Else
    MessageRequester("Information","Import Data")
  EndIf
  
  set_list()
  changed=1
EndProcedure  

Procedure help()
  text.s="Buttons"+#eol+#eol
  text+"1         : Set tag 1 to selected range"+#eol
  text+"2         : Set tag 2 to selected range"+#eol
  text+"3         : Set tag 3 to selected range"+#eol
  text+"Space     : Hide selected range from automatic axis scaling"+#eol
  text+"Ctrl+1    : Remove tag 1 from selected range"+#eol
  text+"Ctrl+2    : Remove tag 2 from selected range"+#eol
  text+"Ctrl+3    : Remove tag 3 from selected range"+#eol
  text+"Ctrl+Space: Use selected range for automatic axis scaling"+#eol
  text+"Del       : Delete selected range"+#eol
  text+"Home      : Decrease lower selection"+#eol
  text+"PgUp      : Increase lower selection"+#eol
  text+"End       : Decrease upper selection"+#eol
  text+"PgUp      : Increase upper selection"+#eol
  text+"Shift+Home: Fast decrease lower selection"+#eol
  text+"Shift+PgUp: Fast increase lower selection"+#eol
  text+"Shift+End : Fast decrease upper selection"+#eol
  text+"Shift+PgUp: Fast increase upper selection"+#eol+#eol
  text+"%dd-Day %mm-Month %yy/%yyyy-Year"+#eol
  text+"%hh-Hours %ii-Minutes %ss-Seconds"
  
  MessageRequester("Help",text)
EndProcedure  

Procedure about()
  MessageRequester("About... ","GAEA Graphical Analyzing & Editing Application"+#eol+"Version 1.0b"+#eol+#eol+"For non-commercial use only"+#eol+"Copyright by Thomas Ritschel"+#eol+"University of Jena")
EndProcedure  

Procedure load_autosave()
  
  current_filename=""
  SetWindowTitle(#Win_Para,"GAEA | Restored Autosave")
  listsize.i
  rows.i
  columns.i
  newimported.i
  If ReadFile(0,"C:\windows\temp\GAEA.tmp")
  newimported=ReadInteger(0)+1+imported
  selected=ReadInteger(0)+imported+1
  ;FreeArray(imp())
  ReDim imp.setxy(newimported)
  For i=imported+1 To newimported
    ;desclen=ReadInteger(0)-1    
    rows=ReadInteger(0)
    columns=ReadInteger(0)
    imp(i)\showcomment=ReadByte(0)
    Dim imp(i)\set.d(rows,columns)
    Dim imp(i)\drawset.l(rows,columns)
    Dim imp(i)\tags.l(rows,columns)
    Dim imp(i)\draw.b(columns)
    Dim imp(i)\secondaxis.b(columns)
    Dim imp(i)\scale.d(rows)
    Dim imp(i)\drawscale.l(rows)
    Dim imp(i)\header.s(columns)
    Dim imp(i)\notes.s(rows)
    ReadData(0,@imp(i)\set(),(columns+1)*(rows+1)*SizeOf(Double))
    ReadData(0,@imp(i)\tags(),(columns+1)*(rows+1)*SizeOf(Long))
    ReadData(0,@imp(i)\draw(),(columns+1)*SizeOf(Byte))
    ReadData(0,@imp(i)\secondaxis(),(columns+1)*SizeOf(Byte))
    ReadData(0,@imp(i)\scale(),(rows+1)*SizeOf(Double))
    imp(i)\description=ReadString(0)
    For j=0 To columns
      ; headlen=ReadInteger(0)-1
      imp(i)\header(j)=ReadString(0)
    Next
    For j=0 To rows
      imp(i)\notes(j)=ReadString(0)
    Next j  
    listsize=ReadInteger(0)
    For j=0 To listsize
      AddElement(imp(i)\comments())
      imp(i)\comments()\x=ReadInteger(0)
      imp(i)\comments()\y=ReadInteger(0)
      imp(i)\comments()\text=ReadString(0)
    Next j
    listsize=ReadInteger(0)
    For j=0 To listsize
      AddElement(imp(i)\meta())
      imp(i)\meta()=ReadString(0)
    Next j 
  Next i
  imported=newimported
  CloseFile(0)
  
  changed=1
  set_list()
  get_minx_maxx()
  Else
  MessageRequester("Info","No Autosave found")
EndIf
EndProcedure  

Procedure init()
  
  !fstcw [v_FPU_ControlWord]
  ExamineDesktops()
  OpenPreferences("init.dat")
  If ReadPreferenceInteger("AQUADIV_auto_save_attention",0):If MessageRequester("GAEA did not shut down properly","Do you want to load the autosave?",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes:restore_data=1:EndIf:EndIf
  WritePreferenceInteger("AQUADIV_auto_save_attention",1)
  directory=ReadPreferenceString("AQUADIV_defaultdirectory",GetCurrentDirectory())
  xpos=ReadPreferenceInteger("AQUADIV_xpos",0)
  ypos=ReadPreferenceInteger("AQUADIV_ypos",660)
  If xpos-100>DesktopWidth(0) Or xpos<1:xpos=1:EndIf 
  If ypos-100>DesktopHeight(0) Or ypos<1:ypos=1:EndIf
  scrheight=ReadPreferenceInteger("AQUADIV_height",755)
  scrwidth=ReadPreferenceInteger("AQUADIV_width",1350)
  If scrwidth<200:scrwidth=200:EndIf
  If scrheight<200:scrheight=200:EndIf
  interval_x=ReadPreferenceDouble("AQUADIV_interval_x",1)
  interval_y=ReadPreferenceDouble("AQUADIV_interval_y",1)
  interval_y2=ReadPreferenceDouble("AQUADIV_interval_y2",1)
  decimals_x=ReadPreferenceInteger("AQUADIV_decimals_x",0)
  decimals_y=ReadPreferenceInteger("AQUADIV_decimals_y",0)
  decimals_y2=ReadPreferenceInteger("AQUADIV_decimals_y2",0)
  filterbreite=ReadPreferenceInteger("AQUADIV_filterwidth",3)
  filtertype=ReadPreferenceInteger("AQUADIV_filtertype",0)
  filtersigma=ReadPreferenceDouble("AQUADIV_filtersigma",1)
  filterdegree=ReadPreferenceInteger("AQUADIV_filterdegree",3)
  line1=ReadPreferenceInteger("AQUADIV_lineoption1",1)
  line2=ReadPreferenceInteger("AQUADIV_lineoption2",1)
  filetype=ReadPreferenceInteger("AQUADIV_filetype",1)
  is_time=ReadPreferenceInteger("AQUADIV_istime",1)
  mask1=ReadPreferenceString("AQUADIV_mask","%yy.%mm.%dd")
  mask2=ReadPreferenceString("AQUADIV_mask2","%hh:%ii:%ss")
  intervaltype=ReadPreferenceInteger("AQUADIV_intervaltype",0)
  optioninterpol=ReadPreferenceInteger("AQUADIV_interpolation",1)
  eccorrectiontype=ReadPreferenceInteger("AQUADIV_eccorrection",1)
  temptype=ReadPreferenceInteger("AQUADIV_temptype",1)
  linelength=ReadPreferenceInteger("AQUADIV_linelength",10)
  holelength=ReadPreferenceInteger("AQUADIV_holelength",10)
  para\tag1=ReadPreferenceString("AQUADIV_tag1","Tag 1")
  para\tag2=ReadPreferenceString("AQUADIV_tag2","Tag 2")
  para\tag3=ReadPreferenceString("AQUADIV_tag3","Tag 3")
  para\title=ReadPreferenceString("AQUADIV_title","Title")
  para\primaxis=ReadPreferenceString("AQUADIV_primaxis","Unit")
  para\secaxis=ReadPreferenceString("AQUADIV_secaxis","Unit")
  para\abscissa=ReadPreferenceString("AQUADIV_abscissa","Unit")
  temptype_eh=ReadPreferenceInteger("AQUADIV_temptype_eh",1)
  graphwidth=ReadPreferenceInteger("AQUADIV_graphwidth",1020)
  graphheight=ReadPreferenceInteger("AQUADIV_graphheight",400)
  firstdatacustom=ReadPreferenceInteger("AQUADIV_firstdatacolumn",3)
  datecolumncustom=ReadPreferenceInteger("AQUADIV_datecolumn",1)
  timecolumncustom=ReadPreferenceInteger("AQUADIV_timecolumn",2)
  columnseparator=ReadPreferenceInteger("AQUADIV_columnseparator",1)
  decimalseparator=ReadPreferenceInteger("AQUADIV_decimalseparator",1)
  skiprows=ReadPreferenceInteger("AQUADIV_skiprows",0)
  datetimecustom=ReadPreferenceInteger("AQUADIV_datetimecustom",0)
  maskcustom=ReadPreferenceString("AQUADIV_maskcustom","%yy.%mm.%dd")
  maskcustom2=ReadPreferenceString("AQUADIV_maskcustom2","%hh:%ii:%ss")
  maskeditor=ReadPreferenceString("AQUADIV_maskeditor","%dd.%mm.%yy %hh:%ii")
  is_time_custom=ReadPreferenceInteger("AQUADIV_istimecustom",0)
  usefilename=ReadPreferenceInteger("AQUADIV_usefilename",0)
  intervaltype_aggregation=ReadPreferenceInteger("AQUADIV_intervaltypeaggregation",0)
  interval_aggregation=ReadPreferenceDouble("AQUADIV_intervalaggregation",1)
  option_aggregation=ReadPreferenceInteger("AQUADIV_optionaggreagtion",1)
  aggregate_direction=ReadPreferenceInteger("AQUADIV_aggreagtedirection",1)
  operationtype_aggregation=ReadPreferenceInteger("AQUADIV_operationtypeaggregation",0)
  ;   from_aggregation=ReadPreferenceDouble("AQUADIV_fromaggregation",0)
  ;   to_aggregation=ReadPreferenceDouble("AQUADIV_toaggregation",1)
  lffactor=ReadPreferenceDouble("AQUADIV_lffactor",2)
  eccorrectiontype=ReadPreferenceInteger("AQUADIV_eccorrectiontype",1)
  gridx=ReadPreferenceInteger("AQUADIV_showgridx",0)
  gridy=ReadPreferenceInteger("AQUADIV_showgridy",0)
  gridy2=ReadPreferenceInteger("AQUADIV_showgridy2",0)
  trans=ReadPreferenceInteger("AQUADIV_trans",0)
  inversx=ReadPreferenceInteger("AQUADIV_inversx",0)
  inversy=ReadPreferenceInteger("AQUADIV_inversy",0)
  logx=ReadPreferenceInteger("AQUADIV_logx",0)
  logy=ReadPreferenceInteger("AQUADIV_logy",0)
  logy2=ReadPreferenceInteger("AQUADIV_logy2",0)
  expx=ReadPreferenceInteger("AQUADIV_expx",0)
  expy=ReadPreferenceInteger("AQUADIV_expy",0)
  expy2=ReadPreferenceInteger("AQUADIV_expy2",0)
  markoption=ReadPreferenceInteger("AQUADIV_markoption",3)
  colorscheme=ReadPreferenceInteger("AQUADIV_colorscheme",1)
  fonttitle\size=ReadPreferenceInteger("AQUADIV_fontsizetitle",11)
  fontprimaxis\size=ReadPreferenceInteger("AQUADIV_fontsizeprimaxis",11)
  fontsecaxis\size=ReadPreferenceInteger("AQUADIV_fontsizesecaxis",11)
  fontabscissa\size=ReadPreferenceInteger("AQUADIV_fontsizeabscissa",11)
  fontlegend\size=ReadPreferenceInteger("AQUADIV_fontsizelegend",16)
  fontstandard\size=ReadPreferenceInteger("AQUADIV_fontsizestandard",11)
  fonteditor\size=ReadPreferenceInteger("AQUADIV_fontsizeeditor",11)
  fontcomment\size=ReadPreferenceInteger("AQUADIV_fontsizecomment",11)
  fonttitle\name=ReadPreferenceString("AQUADIV_fontnametitle","Arial")
  fontprimaxis\name=ReadPreferenceString("AQUADIV_fontnameprimaxis","Arial")
  fontsecaxis\name=ReadPreferenceString("AQUADIV_fontnamesecaxis","Arial")
  fontabscissa\name=ReadPreferenceString("AQUADIV_fontnameabscissa","Arial")
  fontlegend\name=ReadPreferenceString("AQUADIV_fontnamelegend","Arial")
  fontstandard\name=ReadPreferenceString("AQUADIV_fontnamestandard","Arial")
  fonteditor\name=ReadPreferenceString("AQUADIV_fontnameeditor","Arial")
  fontcomment\name=ReadPreferenceString("AQUADIV_fontnamecomment","Arial")
  fonttitle\color=ReadPreferenceInteger("AQUADIV_fontcolortitle",0)
  fontprimaxis\color=ReadPreferenceInteger("AQUADIV_fontcolorprimaxis",0)
  fontsecaxis\color=ReadPreferenceInteger("AQUADIV_fontcolorsecaxis",0)
  fontabscissa\color=ReadPreferenceInteger("AQUADIV_fontcolorabscissa",0)
  fontlegend\color=ReadPreferenceInteger("AQUADIV_fontcolorlegend",0)
  fontstandard\color=ReadPreferenceInteger("AQUADIV_fontcolorstandard",0)
  fonteditor\color=ReadPreferenceInteger("AQUADIV_fontcoloreditor",0)
  fontcomment\color=ReadPreferenceInteger("AQUADIV_fontcolorcomment",0)
  fonttitle\style=ReadPreferenceInteger("AQUADIV_fontstyletitle",0)
  fontprimaxis\style=ReadPreferenceInteger("AQUADIV_fontstyleprimaxis",0)
  fontsecaxis\style=ReadPreferenceInteger("AQUADIV_fontstylesecaxis",0)
  fontabscissa\style=ReadPreferenceInteger("AQUADIV_fontstyleabscissa",0)
  fontlegend\style=ReadPreferenceInteger("AQUADIV_fontstylelegend",0)
  fontstandard\style=ReadPreferenceInteger("AQUADIV_fontstylestandard",0)
  fonteditor\style=ReadPreferenceInteger("AQUADIV_fontstyleeditor",0)
  fontcomment\style=ReadPreferenceInteger("AQUADIV_fontstylecomment",0)
  fonttitle\id=LoadFont(#PB_Any,fonttitle\name,fonttitle\size,fonttitle\style)
  fontprimaxis\id=LoadFont(#PB_Any,fontprimaxis\name,fontprimaxis\size,fontprimaxis\style)
  fontsecaxis\id=LoadFont(#PB_Any,fontsecaxis\name,fontsecaxis\size,fontsecaxis\style)
  fontabscissa\id=LoadFont(#PB_Any,fontabscissa\name,fontabscissa\size,fontabscissa\style)
  fontlegend\id=LoadFont(#PB_Any,fontlegend\name,fontlegend\size,fontlegend\style)
  fontstandard\id=LoadFont(#PB_Any,fontstandard\name,fontstandard\size,fontstandard\style)
  fonteditor\id=LoadFont(#PB_Any,fonteditor\name,fonteditor\size,fonteditor\style)
  fontcomment\id=LoadFont(#PB_Any,fontcomment\name,fontcomment\size,fontcomment\style)
  
  ClosePreferences()    
  
EndProcedure  

Procedure.l farbe(tag.l,nr.l)
  
  result.l
  red.l
  green.l
  blue.l
  
  Select colorscheme
    Case 1
      If tag&#Bittag1:red=200+6*nr:Else:red=16*Sqr(nr*30):EndIf
      If tag&#Bittag2:green=150+12*nr:Else:green=16*Sqr(nr*30):EndIf
      If tag&#Bittag3:blue=200+6*nr:Else:blue=16*Sqr(nr*30):EndIf
    Case 2
      While nr>8:nr-8:Wend
      Select nr
        Case 0:red=0:green=0:blue=0  
        Case 1:red=170:green=0:blue=0      
        Case 2:red=0:green=0:blue=190 
        Case 3:red=0:green=170:blue=0
        Case 4:red=130:green=0:blue=150 
        Case 5:red=130:green=130:blue=0
        Case 6:red=0:green=130:blue=150
        Case 7:red=80:green=80:blue=100
      EndSelect    
      If tag&#Bittag1:red+(255-red)/3:green+(255-green)/3:blue+(255-blue)/3:EndIf
      If tag&#Bittag2:red+(255-red)/3:green+(255-green)/3:blue+(255-blue)/3:EndIf
      If tag&#Bittag3:red+(255-red)/3:green+(255-green)/3:blue+(255-blue)/3:EndIf
  EndSelect
  ProcedureReturn RGB(red,green,blue)
  ;   While nr>24
  ;     nr-24
  ;   Wend  
  ;   Select nr
  ;     Case 1:result=RGB(170,100,100)      
  ;     Case 2:result=RGB(100,170,100) 
  ;     Case 3:result=RGB(100,100,170)
  ;     Case 4:result=RGB(130,130,130) 
  ;     Case 5:result=RGB(170,100,170) 
  ;     Case 6:result=RGB(170,170,100) 
  ;     Case 7:result=RGB(100,170,170) 
  ;     Case 8:result=RGB(0,0,0) 
  ;     Case 9:result=RGB(70,70,70) 
  ;     Case 10:result=RGB(230,70,70)
  ;     Case 11:result=RGB(70,230,70) 
  ;     Case 12:result=RGB(70,70,230) 
  ;     Case 13:result=RGB(230,230,30) 
  ;     Case 14:result=RGB(230,30,230) 
  ;     Case 15:result=RGB(30,230,230) 
  ;     Case 16:result=RGB(255,0,0) 
  ;     Case 17:result=RGB(0,255,0) 
  ;     Case 18:result=RGB(0,0,255)
  ;     Case 19:result=RGB(100,0,255) 
  ;     Case 20:result=RGB(0,100,255) 
  ;     Case 21:result=RGB(0,255,100) 
  ;     Case 22:result=RGB(100,255,0) 
  ;     Case 23:result=RGB(255,0,100)    
  ;     Case 24:result=RGB(255,100,0) 
  ;   EndSelect
  
  ;   ProcedureReturn result  
  
EndProcedure 

Procedure undelete()
  
  unsaved=1
  For k=0 To ArraySize(imp())
    For j=0 To ArraySize(imp(k)\set(),2)
      If imp(k)\draw(j)
        For i=0 To ArraySize(imp(k)\set(),1)
          If Not IsNAN(imp(k)\set(i,j))
            imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bitdel
          EndIf
        Next i
      EndIf
    Next j 
  Next k
  changed=1  
  
EndProcedure  

Procedure transfer_values(renew.b)
  
  Static min.i=-1
  Static min2.i=-1
  Static max.i=-1
  Static max2.i=-1
  Static interval_x_alt.d
  Static interval_y_alt.d
  Static interval_y2_alt.d
  Static decimals_x_alt.i
  Static decimals_y_alt.i
  Static decimals_y2_alt.i
  Static filtertype_alt.i=-1
  Static line1_alt.b
  Static line2_alt.b
  Static is_time_alt.b=-1
  Static mask1_alt.s
  Static mask2_alt.s
  Static maskeditor_alt.s
  Static intervaltype_alt.l
  Static showcomment_alt.b
  Static linelength_alt.l
  Static holelength_alt.l
  Static graphheight_alt.l
  Static graphwidth_alt.l
  Static filetype_alt.l
  Static datetimecustom_alt.b
  Static is_time_custom_alt.b
  Static usefilename_alt.b=-1
  Static interval_aggregation_alt.d
  Static intervaltype_aggregation_alt.l
  Static option_aggregation_alt.l
  Static operationtype_aggregation_alt.l
  Static aggregate_direction_alt.b
  Static lffactor_alt.d
  Static eccorrectiontype_alt.i
  Static minx.i=-1
  Static maxx.i=-1
  Static maxxvalue.d=1
  Static minxvalue.d=0
  Static first.b=1
  Static colorscheme_alt.b=-1
  Static trans_alt.b=-1
  Static inversx_alt.b=-1
  Static inversy_alt.b=-1
  Static logx_alt.b=-1
  Static logy_alt.b=-1
  Static logy2_alt.b=-1
  Static expx_alt.b=-1
  Static expy_alt.b=-1
  Static expy2_alt.b=-1
  Static markoption_alt.i
  If first:intervaltype_alt=intervaltype:EndIf ;needed for first run, else interval is converted
  If renew
    min=-1
    min2=-1
    max=-1
    max2=-1
    interval_x_alt=0
    interval_y_alt=0
    interval_y2_alt=0
    decimals_x_alt=0
    decimals_y_alt=0
    decimals_y2_alt=0
    filtertype_alt=-1
    line1_alt=0
    line2_alt=0
    ;is_time_alt=-1
    mask1_alt=""
    mask2_alt=""
    maskeditor_alt=""
    intervaltype_alt=0
    showcomment_alt=0
    linelength_alt=0
    holelength_alt=0
    graphheight_alt=0
    graphwidth_alt=0
    filetype_alt=0
    datetimecustom_alt=0
    is_time_custom_alt=0
    usefilename_alt=-1
    interval_aggregation_alt=0
    intervaltype_aggregation_alt=0
    option_aggregation_alt=0
    operationtype_aggregation_alt=0
    aggregate_direction_alt=0
    lffactor_alt=0
    eccorrectiontype_alt=0
    minx=-1
    maxx=-1
    maxxvalue=1
    minxvalue=0
    colorscheme_alt=-1
    trans_alt=-1
    inversx_alt=-1
    inversy_alt=-1
    logx_alt=-1
    logy_alt=-1
    logy2_alt=-1
    expx_alt=-1
    expy_alt=-1
    expy2_alt=-1
    markoption_alt=0
  EndIf
  
  If IsWindow(#Win_lfcorrection)
    lffactor=ValD(GetGadgetText(#String_lffactor))/100
    If Not lffactor_alt=lffactor:lffactor_alt=lffactor:changed=1:EndIf
    eccorrectiontype=GetGadgetState(#Option_lf1)+2*GetGadgetState(#Option_lf2)
    If Not eccorrectiontype=eccorrectiontype_alt
      changed=1:eccorrectiontype_alt=eccorrectiontype
      If eccorrectiontype=1
        HideGadget(#Text_lffactor,0)
        HideGadget(#String_lffactor,0)
      Else
        HideGadget(#Text_lffactor,1)
        HideGadget(#String_lffactor,1)
      EndIf  
    EndIf  
  EndIf  
  
  If IsWindow(#Win_import)
    filetype=GetGadgetState(#Option_File1)+2*GetGadgetState(#Option_File2)+3*GetGadgetState(#Option_filegeneric)+4*GetGadgetState(#Option_filegenericdate)+5*GetGadgetState(#Option_filecustom)
    is_time_custom=GetGadgetState(#Checkbox_is_time_custom)
    If is_time_custom=0:datetimecustom=0:SetGadgetState(#Checkbox_date_time,0):EndIf
    datetimecustom=GetGadgetState(#Checkbox_date_time)
    firstdatacustom=GetGadgetState(#Spin_FirstDataColumn)
    datecolumncustom=GetGadgetState(#Spin_DateColumn)
    timecolumncustom=GetGadgetState(#Spin_TimeColumn)
    columnseparator=GetGadgetState(#Combo_ColumnSeparator)
    decimalseparator=GetGadgetState(#Combo_DecimalSeparator)
    skiprows=GetGadgetState(#Spin_Skiprows)
    maskcustom=GetGadgetText(#String_MaskCustom)
    maskcustom2=GetGadgetText(#String_MaskCustom2) 
    usefilename=GetGadgetState(#Checkbox_usefilename)
    If Not filetype=filetype_alt Or Not datetimecustom=datetimecustom_alt Or Not is_time_custom=is_time_custom_alt
      datetimecustom_alt=datetimecustom
      filetype_alt=filetype
      is_time_custom_alt=is_time_custom
      If filetype=5 ;Custom
        HideGadget(#Checkbox_is_time_custom,0)
        HideGadget(#Spin_FirstDataColumn,0)
		HideGadget(#Spin_skiprows,0)
        If datetimecustom
          HideGadget(#Spin_DateColumn,0)
          HideGadget(#Text_DateColumn,0)
        Else  
          HideGadget(#Spin_DateColumn,1)
          HideGadget(#Text_DateColumn,1)
        EndIf  
        HideGadget(#Spin_TimeColumn,0)
        HideGadget(#Combo_ColumnSeparator,0)
        HideGadget(#Combo_DecimalSeparator,0)
        HideGadget(#Text_FirstDataColumn,0) 
        HideGadget(#Text_TimeColumn,0)
        HideGadget(#Text_ColumnSeparator,0)
        HideGadget(#Text_DecimalSeparator,0)
        If is_time_custom
          HideGadget(#Checkbox_date_time,0)
          HideGadget(#Text_MaskCustom2,0)
          HideGadget(#String_MaskCustom2,0)
          If datetimecustom
            HideGadget(#Text_MaskCustom,0)
            HideGadget(#String_MaskCustom,0)
          Else
            HideGadget(#Text_MaskCustom,1)
            HideGadget(#String_MaskCustom,1)
          EndIf  
        Else
          HideGadget(#Checkbox_date_time,1)
          HideGadget(#Text_MaskCustom,1)
          HideGadget(#String_MaskCustom,1)
          HideGadget(#Text_MaskCustom2,1)
          HideGadget(#String_MaskCustom2,1)
        EndIf  
      Else
	    HideGadget(#Spin_skiprows,1)
        HideGadget(#Checkbox_is_time_custom,1)
        HideGadget(#Spin_FirstDataColumn,1)
        HideGadget(#Spin_DateColumn,1)
        HideGadget(#Spin_TimeColumn,1)
        HideGadget(#Combo_ColumnSeparator,1)
        HideGadget(#Combo_DecimalSeparator,1)
        HideGadget(#Text_FirstDataColumn,1)     
        HideGadget(#Text_DateColumn,1)
        HideGadget(#Text_TimeColumn,1)
        HideGadget(#Text_ColumnSeparator,1)
        HideGadget(#Text_DecimalSeparator,1)
        HideGadget(#Checkbox_date_time,1)
        HideGadget(#Text_MaskCustom,1)
        HideGadget(#String_MaskCustom,1)
        HideGadget(#Text_MaskCustom2,1)
        HideGadget(#String_MaskCustom2,1)
      EndIf  
    EndIf
  EndIf  
  
  graphwidth=GetGadgetState(#Spin_graphwidth)
  graphheight=GetGadgetState(#Spin_graphheight)
  If Not graphwidth=graphwidth_alt:graphwidth_alt=graphwidth:changed=1:EndIf
  If Not graphheight=graphheight_alt:graphheight_alt=graphheight:changed=1:EndIf
  If imported>=0
    imp(selected)\showcomment=GetGadgetState(#Button_show_comment)
    If Not imp(selected)\showcomment=showcomment_alt:showcomment_alt=imp(selected)\showcomment:changed=1:EndIf
  EndIf
  mask1=GetGadgetText(#String_datemask)
  mask2=GetGadgetText(#String_datemask2)
  maskeditor=GetGadgetText(#String_MaskEditor)
  If Not mask1=mask1_alt:mask1_alt=mask1:changed=1:EndIf
  If Not mask2=mask2_alt:mask2_alt=mask2:changed=1:EndIf
  If Not maskeditor=maskeditor_alt:maskeditor_alt=maskeditor:changed=1:EndIf
  is_time=GetGadgetState(#Checkbox_interpret_as_time)
  
  If Not is_time=is_time_alt
    If is_time
      HideGadget(#Text_datemask,0)
      HideGadget(#Text_datemask2,0)
      HideGadget(#String_datemask,0)
      HideGadget(#String_datemask2,0)
      HideGadget(#Combo_interval,0)   
      If IsWindow(#Win_aggregate)
        HideGadget(#String_aggregate_interval,1)
        HideGadget(#Spin_aggregate_interval,0)
        HideGadget(#Combo_aggregate_timeunit,0)
      EndIf
      SetGadgetText(#String_minx,FormatDate(maskgeneric,para\minx))
      SetGadgetText(#String_maxx,FormatDate(maskgeneric,para\maxx))
      SetGadgetText(#Text_minx_dummy,FormatDate(maskgeneric,para\minx))
      SetGadgetText(#Text_maxx_dummy,FormatDate(maskgeneric,para\maxx))
    Else
      If Not first
        Select intervaltype
          Case 0
            SetGadgetText(#String_interval_x,StrD(interval_x))
          Case 1
            SetGadgetText(#String_interval_x,StrD(interval_x/60))
          Case 2
            SetGadgetText(#String_interval_x,StrD(interval_x/60/60))
          Case 3
            SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24))
          Case 4
            SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31))
          Case 5
            SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31/12))
        EndSelect 
      EndIf
      first=0
      HideGadget(#Text_datemask,1)
      HideGadget(#Text_datemask2,1)
      HideGadget(#String_datemask,1)
      HideGadget(#String_datemask2,1)
      HideGadget(#Combo_interval,1)
      If IsWindow(#Win_aggregate)
        HideGadget(#String_aggregate_interval,0)
        HideGadget(#Spin_aggregate_interval,1)
        HideGadget(#Combo_aggregate_timeunit,1)
      EndIf
      SetGadgetText(#String_minx,StrD(para\minx))
      SetGadgetText(#String_maxx,StrD(para\maxx))
      SetGadgetText(#Text_minx_dummy,StrD(para\minx))
      SetGadgetText(#Text_maxx_dummy,StrD(para\maxx))
    EndIf  
    is_time_alt=is_time:changed=1
  EndIf  
  
  If is_time
    intervaltype=GetGadgetState(#Combo_interval)    
    If Not intervaltype=intervaltype_alt
      Select intervaltype
        Case 0
          SetGadgetText(#String_interval_x,StrD(interval_x))
        Case 1
          SetGadgetText(#String_interval_x,StrD(interval_x/60))
        Case 2
          SetGadgetText(#String_interval_x,StrD(interval_x/60/60))
        Case 3
          SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24))
        Case 4
          SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31))
        Case 5
          SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31/12))
      EndSelect     
      intervaltype_alt=intervaltype:changed=1
    EndIf
    Select intervaltype
      Case 0
        interval_x=ValD(GetGadgetText(#String_interval_x))
      Case 1
        interval_x=ValD(GetGadgetText(#String_interval_x))*60
      Case 2
        interval_x=ValD(GetGadgetText(#String_interval_x))*60*60
      Case 3
        interval_x=ValD(GetGadgetText(#String_interval_x))*60*60*24
      Case 4
        interval_x=ValD(GetGadgetText(#String_interval_x))*60*60*24*31
      Case 5
        interval_x=ValD(GetGadgetText(#String_interval_x))*60*60*24*31*12
    EndSelect 
  Else
    interval_x=ValD(GetGadgetText(#String_interval_x))
  EndIf
  
  If IsWindow(#Win_aggregate)
    If is_time
      intervaltype_aggregation=GetGadgetState(#Combo_aggregate_timeunit)
      ;       If Not intervaltype_aggregation=intervaltype_aggregation_alt
      ;         Select intervaltype_aggregation
      ;           Case 0
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation))
      ;           Case 1
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60))
      ;           Case 2
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60))
      ;           Case 3
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24))
      ;           Case 4
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24/31))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24/31))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24/31))
      ;           Case 5
      ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24/31/12))
      ;             SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24/31/12))
      ;             SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24/31/12))
      ;         EndSelect     
      ;         intervaltype_aggregation_alt=intervaltype_aggregation:changed=1
      ;       EndIf
      ;       Select intervaltype_aggregation
      ;         Case 0
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))
      ;         Case 1
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))*60
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))*60
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))*60
      ;         Case 2
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))*60*60
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))*60*60
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))*60*60
      ;         Case 3
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))*60*60*24
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))*60*60*24
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))*60*60*24
      ;         Case 4
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))*60*60*24*31
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))*60*60*24*31
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))*60*60*24*31
      ;         Case 5
      ;           interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval))*60*60*24*31*12
      ;           from_aggregation=ValD(GetGadgetText(#String_aggregate_from))*60*60*24*31*12
      ;           to_aggregation=ValD(GetGadgetText(#String_aggregate_to))*60*60*24*31*12
      ;       EndSelect 
    EndIf
    If is_time:interval_aggregation=ValD(GetGadgetText(#Spin_aggregate_interval)):Else:interval_aggregation=ValD(GetGadgetText(#String_aggregate_interval)):EndIf
    aggregate_direction=GetGadgetState(#Option_aggregate_backward)+2*GetGadgetState(#Option_aggregate_center)+3*GetGadgetState(#Option_aggregate_forward)
    ; from_aggregation=ValD(GetGadgetText(#Spin_aggregate_from))
    ;to_aggregation=ValD(GetGadgetText(#Spin_aggregate_to))
    ;     EndIf
    option_aggregation=GetGadgetState(#Option_aggregate_linear)+2*GetGadgetState(#Option_aggregate_operation)
    If Not option_aggregation_alt=option_aggregation
      option_aggregation_alt=option_aggregation
      If option_aggregation=1
        HideGadget(#Combo_operationtype,1)
        HideGadget(#Option_aggregate_backward,1)
        HideGadget(#Option_aggregate_center,1)
        HideGadget(#Option_aggregate_forward,1)
        ;         HideGadget(#String_aggregate_to,1)
      Else
        HideGadget(#Combo_operationtype,0)
        HideGadget(#Option_aggregate_backward,0)
        HideGadget(#Option_aggregate_center,0)
        HideGadget(#Option_aggregate_forward,0)
        ;         HideGadget(#String_aggregate_to,0)
      EndIf 
      changed=1
    EndIf
    ;     If Not from_aggregation=from_aggregation_alt:from_aggregation_alt=from_aggregation:changed=1:EndIf
    ;     If Not to_aggregation=to_aggregation_alt:to_aggregation_alt=to_aggregation:changed=1:EndIf
    If Not aggregate_direction_alt=aggregate_direction:aggregate_direction_alt=aggregate_direction:changed=1:EndIf
    operationtype_aggregation=GetGadgetState(#Combo_operationtype)
    If Not operationtype_aggregation_alt=operationtype_aggregation:operationtype_aggregation_alt=operationtype_aggregation:changed=1:EndIf
  EndIf  
  
  If Not interval_x_alt=interval_x:changed=1:interval_x_alt=interval_x:EndIf
  interval_y=ValD(GetGadgetText(#String_interval_y))
  If Not interval_y_alt=interval_y:changed=1:interval_y_alt=interval_y:EndIf
  interval_y2=ValD(GetGadgetText(#String_interval_y2))
  If Not interval_y2_alt=interval_y2:changed=1:interval_y2_alt=interval_y2:EndIf
  
  decimals_x=GetGadgetState(#Spin_decimals_x)
  If Not decimals_x_alt=decimals_x:changed=1:decimals_x_alt=decimals_x:EndIf
  decimals_y=GetGadgetState(#Spin_decimals_y)
  If Not decimals_y_alt=decimals_y:changed=1:decimals_y_alt=decimals_y:EndIf
  decimals_y2=GetGadgetState(#Spin_decimals_y2)
  If Not decimals_y2_alt=decimals_y2:changed=1:decimals_y2_alt=decimals_y2:EndIf
  trans=GetGadgetState(#checkbox_trans)
  If Not trans_alt=trans:changed=1:trans_alt=trans:EndIf
  inversx=GetGadgetState(#checkbox_inversx)
  If Not inversx_alt=inversx:changed=1:inversx_alt=inversx:EndIf
  inversy=GetGadgetState(#checkbox_inversy)
  If Not inversy_alt=inversy:changed=1:inversy_alt=inversy:EndIf
  
  ;logx=GetGadgetState(#checkbox_logx)
  ;If Not logx_alt=logx:changed=1:logx_alt=logx:EndIf
  logy=GetGadgetState(#checkbox_logy)
  If Not logy_alt=logy:changed=1:logy_alt=logy:EndIf
  logy2=GetGadgetState(#checkbox_logy2)
  If Not logy2_alt=logy2:changed=1:logy2_alt=logy2:EndIf
  expx=GetGadgetState(#checkbox_expx)
  If Not expx_alt=expx:changed=1:expx_alt=expx:EndIf
  expy=GetGadgetState(#checkbox_expy)
  If Not expy_alt=expy:changed=1:expy_alt=expy:EndIf
  expy2=GetGadgetState(#checkbox_expy2)
  If Not expy2_alt=expy2:changed=1:expy2_alt=expy2:EndIf  
  
  linelength=GetGadgetState(#Spin_Linelength)
  If Not linelength=linelength_alt:changed=1:linelength_alt=linelength:EndIf
  holelength=GetGadgetState(#Spin_Holelength)
  If Not holelength=holelength_alt:changed=1:holelength_alt=holelength:EndIf
  line1=GetGadgetState(#Option_Line1)+2*GetGadgetState(#Option_Circle1)
  If Not line1_alt=line1:changed=1:line1_alt=line1:EndIf
  line2=GetGadgetState(#Option_Line2)+2*GetGadgetState(#Option_Circle2)
  If Not line2_alt=line2:changed=1:line2_alt=line2:EndIf
  markoption=GetGadgetState(#Option_markprim)+2*GetGadgetState(#Option_marksec)+3*GetGadgetState(#Option_markboth)
  If Not markoption_alt=markoption:changed=1:markoption_alt=markoption:EndIf
  
  If Not GetGadgetState(#Checkbox_min)=min
    min=GetGadgetState(#Checkbox_min)
    hide=1
  EndIf
  If Not GetGadgetState(#Checkbox_min2)=min2
    min2=GetGadgetState(#Checkbox_min2)
    hide=1
  EndIf
  If Not GetGadgetState(#Checkbox_max)=max
    max=GetGadgetState(#Checkbox_max)
    hide=1
  EndIf
  If Not GetGadgetState(#Checkbox_max2)=max2
    max2=GetGadgetState(#Checkbox_max2)
    hide=1
  EndIf
  
  If Not GetGadgetState(#Checkbox_minx)=minx
    minx=GetGadgetState(#Checkbox_minx)
    hide=1
  EndIf
  If Not GetGadgetState(#Checkbox_maxx)=maxx
    maxx=GetGadgetState(#Checkbox_maxx)
    hide=1
  EndIf
  
  If hide
    changed=1
    If min
      HideGadget(#String_min,0)
      HideGadget(#Text_min_dummy,1)      
    Else
      HideGadget(#String_min,1)
      HideGadget(#Text_min_dummy,0)
      para\min=ValD(GetGadgetText(#Text_min_dummy))
    EndIf
    If min2
      HideGadget(#String_min2,0)
      HideGadget(#Text_min2_dummy,1)      
    Else
      HideGadget(#String_min2,1)
      HideGadget(#Text_min2_dummy,0)
      para\min2=ValD(GetGadgetText(#Text_min2_dummy))
    EndIf  
    If max
      HideGadget(#String_max,0)
      HideGadget(#Text_max_dummy,1)    
    Else
      HideGadget(#String_max,1)
      HideGadget(#Text_max_dummy,0)
      para\max=ValD(GetGadgetText(#Text_max_dummy))
    EndIf  
    If max2
      HideGadget(#String_max2,0)
      HideGadget(#Text_max2_dummy,1)      
    Else
      HideGadget(#String_max2,1)
      HideGadget(#Text_max2_dummy,0)
      para\max2=ValD(GetGadgetText(#Text_max2_dummy))
    EndIf
    If minx
      HideGadget(#String_minx,0)
      HideGadget(#Text_minx_dummy,1)      
    Else
      HideGadget(#String_minx,1)
      HideGadget(#Text_minx_dummy,0)
      If is_time
        para\minx=ParseDate(maskgeneric,GetGadgetText(#Text_minx_dummy))
      Else  
        para\minx=ValD(GetGadgetText(#Text_minx_dummy))
      EndIf  
    EndIf
    If maxx
      HideGadget(#String_maxx,0)
      HideGadget(#Text_maxx_dummy,1)    
    Else
      HideGadget(#String_maxx,1)
      HideGadget(#Text_maxx_dummy,0)
      If is_time
        para\maxx=ParseDate(maskgeneric,GetGadgetText(#Text_maxx_dummy))
      Else  
        para\maxx=ValD(GetGadgetText(#Text_maxx_dummy))
      EndIf
    EndIf
  EndIf
  
  If min:para\min=ValD(GetGadgetText(#String_min)):EndIf
  If min2:para\min2=ValD(GetGadgetText(#String_min2)):EndIf
  If max:para\max=ValD(GetGadgetText(#String_max)):EndIf
  If max2:para\max2=ValD(GetGadgetText(#String_max2)):EndIf
  If minx
    If is_time
      para\minx=ParseDate(maskgeneric,GetGadgetText(#String_minx))
    Else  
      para\minx=ValD(GetGadgetText(#String_minx))
    EndIf
  Else
    para\minx=para\totalminx
  EndIf
  If Not minxvalue=para\minx:minxvalue=para\minx:para\bound_low=minxvalue:EndIf
  If maxx
    If is_time
      para\maxx=ParseDate(maskgeneric,GetGadgetText(#String_maxx))
    Else  
      para\maxx=ValD(GetGadgetText(#String_maxx))
    EndIf  
  Else  
    para\maxx=para\totalmaxx
  EndIf
  If Not maxxvalue=para\maxx:maxxvalue=para\maxx:para\bound_up=maxxvalue:EndIf
  
  If imported>=0
    For i=0 To CountGadgetItems(#Gadget_ImportListe)-1
      If GetGadgetItemState(#Gadget_ImportListe,i)&#PB_ListIcon_Selected=#PB_ListIcon_Selected
        imp(selected)\draw(i)=1
      Else
        imp(selected)\draw(i)=0
      EndIf
      If GetGadgetItemState(#Gadget_ImportListe,i)&#PB_ListIcon_Checked=#PB_ListIcon_Checked
        imp(selected)\secondaxis(i)=1
      Else
        imp(selected)\secondaxis(i)=0
      EndIf  
    Next i
  EndIf
  
  If IsWindow(#win_filter)
    filtersigma=ValD(GetGadgetText(#String_Filtersigma))
    filterdegree=GetGadgetState(#Spin_Filterdegree)
    filtertype=GetGadgetState(#Combo_Filter)    
    If (EventGadget()=#Spin_Filterwidth And (EventType()=#PB_EventType_Down Or EventType()=#PB_EventType_Up)) Or Not filtertype=filtertype_alt
      filtertype_alt=filtertype
      If filtertype=4
        HideGadget(#String_Filtersigma,1)
        HideGadget(#Spin_Filterdegree,0)
        HideGadget(#Text_Filteroption,0)
        SetGadgetText(#Text_Filteroption,"Degree")
      ElseIf filtertype=5
        HideGadget(#String_Filtersigma,0)
        HideGadget(#Spin_Filterdegree,1)
        HideGadget(#Text_Filteroption,0)
        SetGadgetText(#Text_Filteroption,"Sigma")
      Else
        HideGadget(#String_Filtersigma,1)
        HideGadget(#Spin_Filterdegree,1)
        HideGadget(#Text_Filteroption,1)
      EndIf 
      filterbreite=GetGadgetState(#Spin_Filterwidth)
      If Not filterbreite%2 And Not (EventType()=#PB_EventType_Up Or EventType()=#PB_EventType_Down):filterbreite+1:EndIf
      If EventType()=#PB_EventType_Up
        filterbreite+1
      ElseIf EventType()=#PB_EventType_Down
        filterbreite-1
      EndIf
      If filterbreite<3:filterbreite=3:EndIf
      If filtertype=2 Or filtertype=3
        If Not filterbreite=3:filterbreite=3:EndIf   
      EndIf  
      If filtertype=4
        If filterbreite>9:filterbreite=9:EndIf
        If filterdegree>3
          If filterbreite<7:filterbreite=7:EndIf
        Else
          If filterbreite<5:filterbreite=5:EndIf
        EndIf
      EndIf      
      SetGadgetState(#Spin_Filterwidth,filterbreite)    
    EndIf
  EndIf  
  
  If IsWindow(#Win_titles)
    colorscheme=GetGadgetState(#Option_color1)+GetGadgetState(#Option_color2)*2
    If Not colorscheme=colorscheme_alt:changed=1:colorscheme_alt=colorscheme:EndIf  
  EndIf  
  
EndProcedure

Procedure open_window()
  
  OpenWindow(#Win_Para, xpos, ypos, 850, 490, "GAEA | "+directory,  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_MinimizeGadget)
  If CreateMenu(#Menu_file, WindowID(#win_para))    ; hier beginnt das Erstellen des Menüs...
    MenuTitle("File")
    MenuItem(#Menu_Open, "Open..."   +Chr(9)+"Ctrl+O")
    MenuItem(#Menu_Load_Autosave, "Restore Autosave"   +Chr(9)+"Ctrl+R")
    MenuItem(#Menu_Save, "Save"   +Chr(9)+"Ctrl+S")
    MenuItem(#Menu_Save_as, "Save as..."   +Chr(9)+"Alt+S")
    MenuItem(#Menu_Import, "Import..."+Chr(9)+"Ctrl+I")
    MenuItem(#Menu_Export, "Export current list..."+Chr(9)+"Ctrl+E")
    MenuBar()
    MenuItem(#Menu_Copy_to_Clipboard, "Copy to Clipboard")
    MenuItem(#Menu_Save_as_png, "Save as .png...")
    MenuItem(#Menu_Save_as_emf, "Save as .emf...")
    MenuBar()
    MenuItem(#Menu_Quit, "Quit"  +Chr(9)+"Esc")
    MenuTitle("Edit")
    MenuItem(#Menu_Select_all, "Select all"+Chr(9)+"A")
    MenuItem(#Menu_Deselect_all, "Deselect all"+Chr(9)+"D")
    MenuItem(#Menu_Mark_all, "Mark all"+Chr(9)+"M")
    MenuItem(#Menu_Undelete, "Undelete"+Chr(9)+"U")
    MenuBar()
    OpenSubMenu("Entry")
    ;       MenuItem(#Menu_Edit_entry, "Edit..."+Chr(9)+"E")
    MenuItem(#Menu_Rename_entry, "Rename..."+Chr(9)+"R")
    MenuItem(#Menu_Duplicate_entry, "Duplicate"+Chr(9)+"Ctrl+D")
    MenuItem(#Menu_Delete_entry, "Delete"+Chr(9)+"Del")    
    CloseSubMenu()
    MenuBar()
    OpenSubMenu("List") 
    MenuItem(#Menu_Rename_list, "Rename..."+Chr(9)+"Alt+R")
    MenuItem(#Menu_Delete_list, "Delete"+Chr(9)+"Alt+Del")
    MenuItem(#Menu_Duplicate_list, "Duplicate"+Chr(9)+"Alt+D")
    MenuItem(#Menu_Delete_empty_entries,"Delete empty entries")
    MenuItem(#Menu_Crop_List,"Crop List to Selection"+Chr(9)+"Ctrl+C")
    CloseSubMenu()
    MenuBar()
    MenuItem(#Menu_Edit_metadata, "Edit meta data..."+Chr(9)+"Ctrl+M")
    MenuItem(#Menu_Delete_comments, "Delete comments..."+Chr(9)+"Ctrl+Del")
    MenuItem(#Menu_Appearance, "Appearance..."+Chr(9)+"Ctrl+T")
    MenuTitle("Tools")        
    MenuItem(#Menu_Filter, "Filter..."+Chr(9)+"F")
    MenuItem(#Menu_Interpolate, "Interpolate..."+Chr(9)+"I")
    MenuItem(#Menu_Translate, "Translate..."+Chr(9)+"T")
    MenuItem(#Menu_Graph_math, "Graph Math..."+Chr(9)+"Ctrl+A")
    MenuItem(#Menu_Add_constant, "Add Constant Graph..."+Chr(9)+"N")
    MenuItem(#Menu_Scaling, "Scaling..."+Chr(9)+"S")
    MenuTitle("Merging/Aggregation")
    MenuItem(#Menu_Merge_entries, "Merge selected entries"+Chr(9)+"Alt+E")
    MenuItem(#Menu_Merge_lists, "Merge lists..."+Chr(9)+"Alt+L")
    MenuItem(#Menu_Consolidate_lists, "Consolidate current list..."+Chr(9)+"Alt+C")
    MenuItem(#Menu_Aggregate_lists, "Aggregate list..."+Chr(9)+"Alt+A")
    MenuTitle("Corrections")
    MenuItem(#Menu_EC_correction, "EC Correction..."+Chr(9)+"Alt+G")
    MenuItem(#Menu_Eh_correction, "Eh Correction..."+Chr(9)+"Alt+H")
    MenuTitle("Help")
    MenuItem(#Menu_Help,"Help...")
    MenuItem(#Menu_About,"About...")
  EndIf
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_O, #Menu_Open)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_R, #Menu_Load_Autosave)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_S, #Menu_Save)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_S, #Menu_Save_as)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_I, #Menu_Import)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_E, #Menu_Export)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_D, #Menu_Duplicate_list)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_T, #Menu_Appearance)
  ;AddKeyboardShortcut(#Win_para, #PB_Shortcut_Escape, 5)
  ;AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_A, 6)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_D, 7)
  ;AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_M, 8)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_U, 9)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_E, 10)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_L, 27)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_M, 11)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_Delete, 12)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_Delete, #Menu_Delete_list)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Control|#PB_Shortcut_Delete, #Menu_Delete_comments)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_F, 15)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_I, 16)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_T, 17)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_A, 18)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_N, 19)
  ;   AddKeyboardShortcut(#Win_para, #PB_Shortcut_S, 20)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_E, #Menu_Merge_entries)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_L, #Menu_Merge_lists)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_C, #Menu_Consolidate_lists)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_G, #Menu_EC_correction)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_H, #Menu_Eh_correction)
  AddKeyboardShortcut(#Win_para, #PB_Shortcut_Alt|#PB_Shortcut_A, #Menu_Aggregate_lists)
  
  ListIconGadget(#Gadget_ImportListe, 10, 50, 400, 380,"2nd axis",70,#PB_ListIcon_CheckBoxes|#PB_ListIcon_MultiSelect|#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(#Gadget_ImportListe, 1," data", 326)
  ;   ButtonGadget(#Button_delete_entries,10,400,150,20,"Remove selected entries")
  ;   ButtonGadget(#Button_delete_list,10,420,150,20,"Remove current list")
  ;   ButtonGadget(#Button_edit_meta,160,400,150,20,"Edit Meta Data...")
  ButtonGadget(#Button_show_comment,10,440,150,20,"Show Comments",#PB_Button_Toggle)
  
  OptionGadget(#Option_markprim,200,440,100,20,"mark primary")
  OptionGadget(#Option_marksec,300,440,100,20,"mark secondary")
  OptionGadget(#Option_markboth,400,440,100,20,"mark both")
  SetGadgetState(#Option_markprim+markoption-1,1)
  
  ButtonGadget(#Button_prev,10,20,20,20,"<")
  ButtonGadget(#Button_next,390,20,20,20,">")
  TextGadget(#Text_selected,40,23,350,20,"")
  
  FrameGadget(#Frame_primary, 420, 10, 170, 90, "Primary Axis") 
  CheckBoxGadget(#Checkbox_min,540,30,40,20,"fix")
  TextGadget(#Text_min,430,33,40,20,"min:")
  StringGadget(#String_min,470,30,60,20,StrD(para\min))
  TextGadget(#Text_min_dummy,470,33,60,20,StrD(para\min))
  CheckBoxGadget(#Checkbox_max,540,55,40,20,"fix")
  TextGadget(#Text_max,430,58,40,20,"max:")
  StringGadget(#String_max,470,55,60,20,StrD(para\max))
  TextGadget(#Text_max_dummy,470,58,60,20,StrD(para\max))
  OptionGadget(#Option_Line1,430,75,50,20,"Line")
  OptionGadget(#Option_Circle1,500,75,50,20,"Circle")
  SetGadgetState(#Option_Line1+line1-1,1)
  
  TextGadget(#Text_linelength,770,22,60,20,"Dashed Line")
  SpinGadget(#Spin_Linelength,770,40,60,20,1,1000,#PB_Spin_Numeric)
  SetGadgetState(#Spin_Linelength,linelength)
  TextGadget(#Text_holelength,770,62,60,20,"Dashed Gap")
  SpinGadget(#Spin_Holelength,770,80,60,20,1,1000,#PB_Spin_Numeric)
  SetGadgetState(#Spin_Holelength,holelength)
  
  FrameGadget(#Frame_secondary, 590, 10, 170, 90, "Secondary Axis") 
  CheckBoxGadget(#Checkbox_min2,710,30,40,20,"fix")
  TextGadget(#Text_min2,600,33,40,20,"min:")
  StringGadget(#String_min2,640,30,60,20,StrD(para\min2))
  TextGadget(#Text_min2_dummy,640,33,60,20,StrD(para\min2))
  CheckBoxGadget(#Checkbox_max2,710,55,40,20,"fix")
  TextGadget(#Text_max2,600,58,40,20,"max:")
  StringGadget(#String_max2,640,55,60,20,StrD(para\max2))
  TextGadget(#Text_max2_dummy,640,58,60,20,StrD(para\max2))
  OptionGadget(#Option_Line2,600,75,50,20,"Line")
  OptionGadget(#Option_Circle2,670,75,50,20,"Circle")
  SetGadgetState(#Option_Line2+line2-1,1)
  
  FrameGadget(#Frame_abscissa, 420, 100, 270, 70, "Abscissa")
  CheckBoxGadget(#Checkbox_minx,640,120,40,20,"fix")
  CheckBoxGadget(#Checkbox_maxx,640,145,40,20,"fix")
  TextGadget(#Text_minx,430,123,40,20,"min:")
  TextGadget(#Text_maxx,430,148,40,20,"max:")
  StringGadget(#String_minx,470,120,160,20,StrD(para\minx))
  TextGadget(#Text_minx_dummy,470,123,160,20,StrD(para\minx))
  StringGadget(#String_maxx,470,145,160,20,StrD(para\maxx))
  TextGadget(#Text_maxx_dummy,470,148,160,20,StrD(para\maxx))
  ;   ButtonGadget(#Button_Import,420,390,100,20,"Import data...")
  ;   ButtonGadget(#Button_undelete,520,390,100,20,"Undelete")
  ;   ButtonGadget(#Button_unselect_all,520,410,100,20,"Deselect all")
  ;   ButtonGadget(#Button_merge_lists,620,370,100,20,"Merge lists...")
  ;   ButtonGadget(#Button_consolidate,620,390,100,20,"Consolidate list")
  ;   ButtonGadget(#Button_interpolate,620,410,100,20,"Interpolate...")
  ;   ButtonGadget(#Button_translate,620,430,100,20,"Translation...")
  ;   ButtonGadget(#Button_scale,520,430,100,20,"Scaling...")
  ;   ButtonGadget(#Button_filter,420,430,100,20,"Filter...")
  ;   ButtonGadget(#Button_edit_entry,420,410,100,20,"Edit Entry...")
  ;ButtonGadget(#Button_help,730,390,100,40,"HELP")
  ;   ButtonGadget(#Button_delcomment,520,370,100,20,"Del Comment...")
  ;   ButtonGadget(#Button_scale_addition,420,370,100,20,"Scaled Addition...")
  ;   ButtonGadget(#Button_lf_correction,420,350,100,20,"EC Correction...")
  ;   ButtonGadget(#Button_export_list,420,330,100,20,"Export list...")
  ;   ButtonGadget(#Button_addconstant,520,350,100,20,"Add Constant...")
  ;   ButtonGadget(#Button_merge_entries,620,350,100,20,"Merge Entries")
  ;   ButtonGadget(#Button_savedata,520,330,100,20,"Save Data...")
  ;   ButtonGadget(#Button_loaddata,620,330,100,20,"Load Data...")
  
  FrameGadget(#Frame_axes,420,170,350,210,"Axis")
  TextGadget(#Text_decimals_x,430,253,80,20,"decimals x")
  SpinGadget(#Spin_decimals_x, 520, 250, 50, 20, 0, 5000,#PB_Spin_Numeric)
  SetGadgetState(#Spin_decimals_x,decimals_x)
  TextGadget(#Text_decimals_y,430,273,80,20,"decimals y")
  SpinGadget(#Spin_decimals_y, 520, 270, 50, 20, 0, 5000,#PB_Spin_Numeric)
  SetGadgetState(#Spin_decimals_y,decimals_y)
  TextGadget(#Text_decimals_y2,430,293,80,20,"decimals y sec.")
  SpinGadget(#Spin_decimals_y2, 520, 290, 50, 20, 0, 5000,#PB_Spin_Numeric)
  SetGadgetState(#Spin_decimals_y2,decimals_y2)
  TextGadget(#Text_interval_y,430,213,80,20,"interval y")
  StringGadget(#String_interval_y,520,210,50,20,StrD(interval_y))
  TextGadget(#Text_interval_y2,430,233,80,20,"interval y sec.")
  StringGadget(#String_interval_y2,520,230,50,20,StrD(interval_y2))
  TextGadget(#Text_interval_x,430,193,80,20,"interval x")
  StringGadget(#String_interval_x,520,190,50,20,StrD(interval_x))
  If is_time
    Select intervaltype
      Case 0
        SetGadgetText(#String_interval_x,StrD(interval_x))
      Case 1
        SetGadgetText(#String_interval_x,StrD(interval_x/60))
      Case 2
        SetGadgetText(#String_interval_x,StrD(interval_x/60/60))
      Case 3
        SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24))
      Case 4
        SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31))
      Case 5
        SetGadgetText(#String_interval_x,StrD(interval_x/60/60/24/31/12))
    EndSelect
  EndIf
  ComboBoxGadget(#Combo_interval,580,190,150,20)
  AddGadgetItem(#Combo_interval,-1,"Seconds")
  AddGadgetItem(#Combo_interval,-1,"Minutes")
  AddGadgetItem(#Combo_interval,-1,"Hours")
  AddGadgetItem(#Combo_interval,-1,"Days")
  AddGadgetItem(#Combo_interval,-1,"Months")
  AddGadgetItem(#Combo_interval,-1,"Years")
  SetGadgetState(#Combo_interval,intervaltype)
  CheckBoxGadget(#Checkbox_interpret_as_time,580,210,150,20,"x data is date/time")
  SetGadgetState(#Checkbox_interpret_as_time,is_time)
  TextGadget(#text_datemask,580,233,90,20,"Date Mask Axis")
  StringGadget(#String_datemask,670,230,90,20,mask1)
  TextGadget(#text_datemask2,580,253,90,20,"Date Mask Axis")
  StringGadget(#String_datemask2,670,250,90,20,mask2)
  TextGadget(#Text_MaskEditor,580,273,90,20,"Date Mask Editor")
  StringGadget(#String_MaskEditor,670,270,90,20,maskeditor)
  ;TextGadget(#Text_datemaskinfo,580,273,188,20,"%dd-Day %mm-Month %yy/%yyyy-Year")
  ;TextGadget(#Text_datemaskinfo2,580,293,180,20,"%hh-Hours %ii-Minutes %ss-Seconds")
  CheckBoxGadget(#Checkbox_trans,430,310,70,20,"transpose"):SetGadgetState(#Checkbox_trans,trans)
  CheckBoxGadget(#Checkbox_inversx,510,310,120,20,"inverse horizontal axis"):SetGadgetState(#Checkbox_inversx,inversx)
  CheckBoxGadget(#Checkbox_inversy,640,310,120,20,"inverse vertical axis"):SetGadgetState(#Checkbox_inversy,inversy)
  ;CheckBoxGadget(#Checkbox_logx,530,330,70,20,"log x"):SetGadgetState(#Checkbox_logx,logx)
  CheckBoxGadget(#Checkbox_logy,430,330,70,20,"log y"):SetGadgetState(#Checkbox_logy,logy)
  CheckBoxGadget(#Checkbox_logy2,510,330,50,20,"log y2"):SetGadgetState(#Checkbox_logy2,logy2)
  CheckBoxGadget(#Checkbox_expx,430,350,70,20,"exp x"):SetGadgetState(#Checkbox_expx,expx)
  CheckBoxGadget(#Checkbox_expy,510,350,70,20,"exp y"):SetGadgetState(#Checkbox_expy,expy)
  CheckBoxGadget(#Checkbox_expy2,590,350,50,20,"exp y2"):SetGadgetState(#Checkbox_expy2,expy2)
  
  TextGadget(#Text_graphwidth,420,403,70,20,"Graph Width")
  SpinGadget(#Spin_graphwidth,500,400,80,20,1,1920,#PB_Spin_Numeric):SetGadgetState(#Spin_graphwidth,graphwidth)
  TextGadget(#Text_graphheight,600,403,70,20,"Graph Height")
  SpinGadget(#Spin_graphheight,680,400,80,20,1,1080,#PB_Spin_Numeric):SetGadgetState(#Spin_graphheight,graphheight)
  
  changed=1
  
EndProcedure  

Procedure set_scale()
  
  min.d
  min2.d
  max.d
  max2.d
  
  max=-Pow(10,30)
  min=Pow(10,30)
  max2=-Pow(10,30)
  min2=Pow(10,30)
  
  ;loop over data to find mins and maxes
  
  For i=0 To ArraySize(imp())
    For j=0 To ArraySize(imp(i)\draw())
      If imp(i)\draw(j)
        If imp(i)\secondaxis(j)
          For k=0 To ArraySize(imp(i)\set(),1)
            If Not invalid(i,k,j) And Not imp(i)\tags(k,j)&#Bithide
              ;               If logy2
              ;                 If Log10(imp(i)\set(k,j))>max2:max2=Log10(imp(i)\set(k,j)):EndIf
              ;                 If Log10(imp(i)\set(k,j))<min2:min2=Log10(imp(i)\set(k,j)):EndIf
              ;               Else  
              If imp(i)\set(k,j)>max2:max2=imp(i)\set(k,j):EndIf
              If imp(i)\set(k,j)<min2:min2=imp(i)\set(k,j):EndIf
              ;               EndIf  
            EndIf
          Next k  
        Else  
          For k=0 To ArraySize(imp(i)\set(),1)
            If Not invalid(i,k,j) And Not imp(i)\tags(k,j)&#Bithide
              ;               If logy
              ;                 If Log10(imp(i)\set(k,j))>max:max=Log10(imp(i)\set(k,j)):EndIf
              ;                 If Log10(imp(i)\set(k,j))<min:min=Log10(imp(i)\set(k,j)):EndIf
              ;               Else  
              If imp(i)\set(k,j)>max:max=imp(i)\set(k,j):EndIf
              If imp(i)\set(k,j)<min:min=imp(i)\set(k,j):EndIf
              ;               EndIf  
            EndIf
          Next k
        EndIf
      EndIf
    Next j
  Next i
  
  ;transfer maxes and mins to text gadget or get maxes and mins from strings
  If GetGadgetState(#Checkbox_min):min=para\min:Else:para\min=min:SetGadgetText(#Text_min_dummy,StrD(para\min)):SetGadgetText(#String_min,StrD(para\min)):EndIf
  If GetGadgetState(#Checkbox_max):max=para\max:Else:para\max=max:SetGadgetText(#Text_max_dummy,StrD(para\max)):SetGadgetText(#String_max,StrD(para\max)):EndIf
  If GetGadgetState(#Checkbox_min2):min2=para\min2:Else:para\min2=min2:SetGadgetText(#Text_min2_dummy,StrD(para\min2)):SetGadgetText(#String_min2,StrD(para\min2)):EndIf
  If GetGadgetState(#Checkbox_max2):max2=para\max2:Else:para\max2=max2:SetGadgetText(#Text_max2_dummy,StrD(para\max2)):SetGadgetText(#String_max2,StrD(para\max2)):EndIf
  
  If Not GetGadgetState(#Checkbox_minx)
    If is_time
      SetGadgetText(#Text_minx_dummy,FormatDate(maskgeneric,para\minx))
      SetGadgetText(#String_minx,FormatDate(maskgeneric,para\minx))   
    Else
      SetGadgetText(#Text_minx_dummy,StrD(para\minx))
      SetGadgetText(#String_minx,StrD(para\minx))
    EndIf  
  EndIf
  If Not GetGadgetState(#Checkbox_maxx)
    If is_time
      SetGadgetText(#Text_maxx_dummy,FormatDate(maskgeneric,para\maxx))
      SetGadgetText(#String_maxx,FormatDate(maskgeneric,para\maxx))     
    Else  
      SetGadgetText(#Text_maxx_dummy,StrD(para\maxx))
      SetGadgetText(#String_maxx,StrD(para\maxx))
    EndIf  
  EndIf
  
  If logy:para\max=Log10(para\max):para\min=Log10(para\min):EndIf
  If logy2:para\max2=Log10(para\max2):para\min2=Log10(para\min2):EndIf
  
  If para\max=para\min:para\max+1:EndIf
  If para\max2=para\min2:para\max2+1:EndIf
  If trans
    para\scaley=graphwidth/(para\max-para\min)
    para\scaley2=graphwidth/(para\max2-para\min2)
    para\scalex=graphheight/(para\bound_up-para\bound_low) 
  Else  
    para\scaley=graphheight/(para\max-para\min)
    para\scaley2=graphheight/(para\max2-para\min2)
    para\scalex=graphwidth/(para\bound_up-para\bound_low) 
  EndIf
EndProcedure  

Procedure textemf(handle.i,x.i,y.i,text.s)
  TextOut_(handle,x,y,text,Len(text))
EndProcedure  

Procedure lineemf(handle.i,x1.i,y1.i,x2.i,y2.i)
  MoveToEx_(handle,x1,y1,0)
  LineTo_(handle,x2,y2)
EndProcedure  

Procedure drawline(x1.i,y1.i,x2.i,y2.i,thick.i,color.l)
  For i=-Round((thick-1)/2,#PB_Round_Up) To Round((thick-1)/2,#PB_Round_Down)
    For j=-Round((thick-1)/2,#PB_Round_Up) To Round((thick-1)/2,#PB_Round_Down)
      LineXY(x1+i,y1+j,x2+i,y2+j,color)
    Next j
  Next i
EndProcedure

Procedure.d ThickLine(x1.i,y1.i,x2.i,y2.i,thick.i,color.l,mode.i,phase.d,type.b,handle.i)
  
  Static alternate.b=1
  
  If IsNAN(phase):alternate=1:phase=0:EndIf
  deltax.l=x2-x1
  deltay.l=y2-y1
  If alternate:norm.d=linelength/Sqr(deltax*deltax+deltay*deltay):Else:norm.d=holelength/Sqr(deltax*deltax+deltay*deltay):EndIf
  
  drawlen.d
  
  drawy.d;deltay*norm*(1-phase/linelength)
  drawx.d;deltax*norm*(1-phase/linelength)
         ; drawlen=Sqr(Pow(drawx,2)+Pow(drawy,2))
  posx.d=x1
  posy.d=y1
  maxlen.d
  
  If mode=1
    If type=1
      lineemf(handle,x1,y1,x2,y2)
    Else  
      drawline(x1,y1,x2,y2,thick,color)
    EndIf  
    ProcedureReturn 0
  ElseIf mode=2
    
    
    If Not (deltax=0 And deltay=0)
      
      ;   posx=x1
      ;   posy=y1
      Repeat
        
        maxlen=Sqr(Pow(x2-posx,2)+Pow(y2-posy,2))
        If alternate
          norm=linelength/Sqr(deltax*deltax+deltay*deltay)
          drawy=deltay*norm*(1-phase/linelength)
          
          drawx=deltax*norm*(1-phase/linelength)
          
        Else
          norm=holelength/Sqr(deltax*deltax+deltay*deltay)
          drawy=deltay*norm*(1-phase/holelength)
          
          drawx=deltax*norm*(1-phase/holelength)
        EndIf
        
        
        drawlen=Sqr(Pow(drawx,2)+Pow(drawy,2))
        
        If drawlen<=maxlen
          phase=0
          If alternate
            If type=1
              lineemf(handle,posx,posy,posx+drawx,posy+drawy)  
            Else  
              drawline(posx,posy,posx+drawx,posy+drawy,thick,color)
            EndIf
          EndIf
          If alternate=1:alternate=0:Else:alternate=1:EndIf
          ;If phase+#num_tolerance>=linelength:phase=0:EndIf
          ;If alternate:drawline(posx,posy,posx+drawx,posy+drawy,thick,color):EndIf
          posx+drawx
          posy+drawy
          If drawlen=maxlen:done=1:EndIf
        Else
          phase+maxlen
          ;If phase+#num_tolerance>=linelength:phase=0:If alternate=1:alternate=0:Else:alternate=1:EndIf:EndIf
          If alternate
            If type=1  
              lineemf(handle,posx,posy,x2,y2)
            Else
              drawline(posx,posy,x2,y2,thick,color)
            EndIf
          EndIf
          done=1
        EndIf  
        ;If deltax>=0:drawx=min(posx+deltax*norm*(1-phase/linelength),x2):Else:drawx=-min(-(posx+deltax*norm*(1-phase/linelength)),-x2):EndIf
        ;If deltay>=0:drawy=min(posy+deltay*norm*(1-phase/linelength),y2):Else:drawy=-min(-(posy+deltay*norm*(1-phase/linelength)),-y2):EndIf 
        ;drawlen=Sqr(Pow(drawx-posx,2)+Pow(drawy-posy,2))
        ;   phase+drawlen
        ;   If phase+#num_tolerance>=linelength:phase=0:If alternate=1:alternate=0:Else:alternate=1:EndIf:EndIf
        ;   If alternate:drawline(posx,posy,drawx,drawy,thick,color):EndIf
        ;      posx=drawx
        ;      posy=drawy
      Until done;drawx=x2 And drawy=y2;drawlen<linelength
      
    Else  
      
      If alternate
        If type=1  
          lineemf(handle,x1,y1,x2,y2)
        Else  
          drawline(x1,y1,x2,y2,thick,color)
        EndIf  
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn phase
  
EndProcedure

Procedure.s get_exp(value.d,decimals.i)
  temp.s
  If value=0
    ProcedureReturn "0"
  ElseIf value<0
    temp="-"+StrD(Abs(value)/Pow(10,Round(Log10(Abs(value)),#PB_Round_Down)),decimals)+"E"+Str(Round(Log10(Abs(value)),#PB_Round_Down))
  Else
    temp=StrD(value/Pow(10,Round(Log10(value),#PB_Round_Down)),decimals)+"E"+Str(Round(Log10(value),#PB_Round_Down))
  EndIf
  ProcedureReturn temp
EndProcedure 

Procedure.i tagsnr(input.i,nrtotag.b)
  result.i
  If nrtotag
    Select input
      Case 0
        result=0
      Case 1
        result=#Bittag1
      Case 2
        result=#Bittag2
      Case 3
        result=#Bittag3
      Case 4
        result=#Bittag1|#Bittag2
      Case 5
        result=#Bittag1|#Bittag3
      Case 6
        result=#Bittag2|#Bittag3
      Case 7
        result=#Bittag1|#Bittag2|#Bittag3
    EndSelect    
  Else
    Select input&(#Bittag1|#Bittag2|#Bittag3)
      Case 0
        result=0
      Case #Bittag1
        result=1
      Case #Bittag2
        result=2
      Case #Bittag3
        result=3
      Case #Bittag1|#Bittag2
        result=4
      Case #Bittag1|#Bittag3
        result=5
      Case #Bittag2|#Bittag3
        result=6
      Case #Bittag1|#Bittag2|#Bittag3
        result=7        
    EndSelect   
  EndIf  
  
  ProcedureReturn result
EndProcedure  

Procedure draw_plot(bild.i,type.b) ;type=0:screen type=1:emf type=2:png
  
  Static selected_old.i
  If Not selected_old=selected:editorpos=0:selected_old=selected:EndIf
  Static offset_alt.i
  Static offset2_alt.i
  scaletext.s
  scaletext2.s
  textlength.i
  textlength2.i
  fontscale.d=0.4
  
  If para\title="":offsetvert=40:Else:offsetvert=70:EndIf
  If Not para\secaxis="" And trans:offsetvert+50:EndIf
  
  phase.d=NaN()
  If type=1    
    emffontstd=CreateFont_(fontstandard\size*1.55,0,0,0,Bool(fontstandard\style&#PB_Font_Bold)*700,Bool(fontstandard\style&#PB_Font_Italic),Bool(fontstandard\style&#PB_Font_Underline),Bool(fontstandard\style&#PB_Font_StrikeOut),0,0,0,0,0,fontstandard\name)
    emffonttitle=CreateFont_(fonttitle\size*1.55,0,0,0,Bool(fonttitle\style&#PB_Font_Bold)*700,Bool(fonttitle\style&#PB_Font_Italic),Bool(fonttitle\style&#PB_Font_Underline),Bool(fonttitle\style&#PB_Font_StrikeOut),0,0,0,0,0,fonttitle\name)
    emffontprim=CreateFont_(fontprimaxis\size*1.55,0,0,0,Bool(fontprimaxis\style&#PB_Font_Bold)*700,Bool(fontprimaxis\style&#PB_Font_Italic),Bool(fontprimaxis\style&#PB_Font_Underline),Bool(fontprimaxis\style&#PB_Font_StrikeOut),0,0,0,0,0,fontprimaxis\name)
    emffontprimvert=CreateFont_(fontprimaxis\size*1.55,0,900,900,Bool(fontprimaxis\style&#PB_Font_Bold)*700,Bool(fontprimaxis\style&#PB_Font_Italic),Bool(fontprimaxis\style&#PB_Font_Underline),Bool(fontprimaxis\style&#PB_Font_StrikeOut),0,0,0,0,0,fontprimaxis\name)
    emffontsec=CreateFont_(fontsecaxis\size*1.55,0,0,0,Bool(fontsecaxis\style&#PB_Font_Bold)*700,Bool(fontsecaxis\style&#PB_Font_Italic),Bool(fontsecaxis\style&#PB_Font_Underline),Bool(fontsecaxis\style&#PB_Font_StrikeOut),0,0,0,0,0,fontsecaxis\name)
    emffontsecvert=CreateFont_(fontsecaxis\size*1.55,0,900,900,Bool(fontsecaxis\style&#PB_Font_Bold)*700,Bool(fontsecaxis\style&#PB_Font_Italic),Bool(fontsecaxis\style&#PB_Font_Underline),Bool(fontsecaxis\style&#PB_Font_StrikeOut),0,0,0,0,0,fontsecaxis\name)
    emffontabscissa=CreateFont_(fontabscissa\size*1.55,0,0,0,Bool(fontabscissa\style&#PB_Font_Bold)*700,Bool(fontabscissa\style&#PB_Font_Italic),Bool(fontabscissa\style&#PB_Font_Underline),Bool(fontabscissa\style&#PB_Font_StrikeOut),0,0,0,0,0,fontabscissa\name)
    emffontabscissavert=CreateFont_(fontabscissa\size*1.55,0,900,900,Bool(fontabscissa\style&#PB_Font_Bold)*700,Bool(fontabscissa\style&#PB_Font_Italic),Bool(fontabscissa\style&#PB_Font_Underline),Bool(fontabscissa\style&#PB_Font_StrikeOut),0,0,0,0,0,fontabscissa\name)
    emffontlegend=CreateFont_(fontlegend\size*1.55,0,0,0,Bool(fontlegend\style&#PB_Font_Bold)*700,Bool(fontlegend\style&#PB_Font_Italic),Bool(fontlegend\style&#PB_Font_Underline),Bool(fontlegend\style&#PB_Font_StrikeOut),0,0,0,0,0,fontlegend\name)
    emffontcom=CreateFont_(fontcomment\size*1.55,0,0,0,Bool(fontcomment\style&#PB_Font_Bold)*700,Bool(fontcomment\style&#PB_Font_Italic),Bool(fontcomment\style&#PB_Font_Underline),Bool(fontcomment\style&#PB_Font_StrikeOut),0,0,0,0,0,fontcomment\name)
    SelectObject_(bild,emffontstd)
    Dim penbrushes.i(4,8,7)
    For j=0 To 8
      For k=0 To 7
        penbrushes(0,j,k)=CreateSolidBrush_(farbe(tagsnr(k,1),j))
      Next k  
    Next j
    For i=1 To 4
      For j=0 To 8
        For k=0 To 7
          penbrushes(i,j,k)=CreatePen_(#PS_SOLID,i,farbe(tagsnr(k,1),j)) 
        Next k 
      Next j  
    Next i
    dummybild=CreateImage(#PB_Any,200,200)
    StartDrawing(ImageOutput(dummybild))
    DrawingFont(FontID(fontstandard\id)) 
    SelectObject_(bild,penbrushes(1,0,0))
  Else
    StartDrawing(ImageOutput(bild))
    DrawingFont(FontID(fontstandard\id))    
    DrawingMode(#PB_2DDrawing_Default)
    BackColor(RGB(255,255,255))
    FrontColor(RGB(0,0,0))
    Box(0,0,scrwidth,scrheight,RGB(255,255,255))
  EndIf
  Dim names.s(0)
  files=ArraySize(imp())
  is_second=0
  is_first=0
  count1=-1
  
  DrawingFont(FontID(fonttitle\id))
  textlength=DrawText(1,1,para\title,RGB(255,255,255))
  DrawingFont(FontID(fontabscissa\id))
  textlength2=DrawText(1,1,para\abscissa,RGB(255,255,255))
  DrawingFont(FontID(fontprimaxis\id))
  textlengthprim=DrawText(1,1,para\primaxis,RGB(255,255,255))
  DrawingFont(FontID(fontsecaxis\id))
  textlengthsec=DrawText(1,1,para\secaxis,RGB(255,255,255))
  If type=1
    If trans
      lineemf(bild,offset-5,graphheight+offsetvert,offset+graphwidth+3,graphheight+offsetvert)
      lineemf(bild,offset,offsetvert-5,offset,graphheight+offsetvert+5)
      lineemf(bild,offset-5,offsetvert,offset+graphwidth,offsetvert) 
    Else  
      lineemf(bild,offset-5,graphheight+offsetvert,offset+graphwidth+3,graphheight+offsetvert)
      lineemf(bild,offset,offsetvert-5,offset,graphheight+offsetvert+5)
      lineemf(bild,offset+graphwidth,offsetvert-5,offset+graphwidth,graphheight+offsetvert+5)
    EndIf
    SelectObject_(bild,emffonttitle)
    textemf(bild,offset+(graphwidth-textlength)/2,20,para\title)
    If trans
      SelectObject_(bild,emffontabscissavert)
      textemf(bild,30,offsetvert+(graphheight+textlength2)/2,para\abscissa)
    Else  
      SelectObject_(bild,emffontabscissa)
      If mask2=""
        textemf(bild,offset+(graphwidth-textlength2)/2,offsetvert+graphheight+40,para\abscissa)
      Else  
        textemf(bild,offset+(graphwidth-textlength2)/2,offsetvert+graphheight+60,para\abscissa)
      EndIf
    EndIf
    If trans
      SelectObject_(bild,emffontprim)
      textemf(bild,offset+(graphwidth-textlengthprim)/2,offsetvert+graphheight+40,para\primaxis)
    Else
      SelectObject_(bild,emffontprimvert)
      textemf(bild,30,offsetvert+(graphheight+textlengthprim)/2,para\primaxis)
    EndIf
    If trans
      SelectObject_(bild,emffontsec)
      textemf(bild,offset+(graphwidth-textlengthsec)/2,60,para\secaxis)
    Else  
      SelectObject_(bild,emffontsecvert)
      textemf(bild,offset+graphwidth+offset2-35,offsetvert+(graphheight+textlengthsec)/2,para\secaxis)
    EndIf  
    SelectObject_(bild,emffontstd)
  Else
    If trans
      LineXY(offset-5,graphheight+offsetvert,offset+graphwidth+3,graphheight+offsetvert)
      LineXY(offset,offsetvert-5,offset,graphheight+offsetvert+5)
      LineXY(offset-5,offsetvert,offset+graphwidth,offsetvert)      
    Else  
      LineXY(offset-5,graphheight+offsetvert,offset+graphwidth+3,graphheight+offsetvert)
      LineXY(offset,offsetvert-5,offset,graphheight+offsetvert+5)
      LineXY(offset+graphwidth,offsetvert-5,offset+graphwidth,graphheight+offsetvert+5)    
    EndIf      
    DrawingFont(FontID(fonttitle\id))
    DrawText(offset+(graphwidth-textlength)/2,20,para\title)
    DrawingFont(FontID(fontabscissa\id))
    If trans
      DrawRotatedText(30,offsetvert+(graphheight+textlength2)/2,para\abscissa,90)
    Else  
      If mask2="" 
        DrawText(offset+(graphwidth-textlength2)/2,offsetvert+graphheight+40,para\abscissa) 
      Else  
        DrawText(offset+(graphwidth-textlength2)/2,offsetvert+graphheight+60,para\abscissa)
      EndIf
    EndIf
    DrawingFont(FontID(fontprimaxis\id))
    If trans
      DrawText(offset+(graphwidth-textlengthprim)/2,offsetvert+graphheight+40,para\primaxis)
    Else  
      DrawRotatedText(30,offsetvert+(graphheight+textlengthprim)/2,para\primaxis,90)
    EndIf  
    DrawingFont(FontID(fontsecaxis\id))
    If trans
      DrawText(offset+(graphwidth-textlengthsec)/2,60,para\secaxis)
    Else
      DrawRotatedText(offset+graphwidth+offset2-35,offsetvert+(graphheight+textlengthsec)/2,para\secaxis,90)
    EndIf  
    DrawingFont(FontID(fontstandard\id))
  EndIf
  
  For k=0 To files
    column.i=ArraySize(imp(k)\set(),2)
    size.i=ArraySize(imp(k)\set(),1)
    ; Dim drawgraph.d(size,column)
    ; Dim drawscale.d(size)
    
    tag1.b
    tag2.b
    tag3.b
    tag12.b
    tag13.b
    tag23.b
    tag123.b
    edited.b
    
    ;     If Not type
    ;       If is_time
    ;         DrawText(offset,graphheight+offsetvert+100,"Selected Range from: "+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",selection_low)+" To "+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",selection_high))
    ;       Else    
    ;         DrawText(offset,graphheight+offsetvert+100,"Selected Range from: "+StrD(selection_low)+" to "+StrD(selection_high))
    ;       EndIf
    ;       count=0
    ;       ForEach markers()
    ;         count+1
    ;         DrawText(offset+147,graphheight+offsetvert+100+count*20,markers()\lower)
    ;         DrawText(offset+302,graphheight+offsetvert+100+count*20,markers()\upper)
    ;       Next 
    ;     EndIf
    
    ;convert x data to scale
    For i=0 To size
      imp(k)\drawscale(i)=Round((imp(k)\scale(i)-para\bound_low)*para\scalex,#PB_Round_Nearest)
    Next i
    
    ;convert y data to scale
    For j=0 To column
      If imp(k)\draw(j)
        If imp(k)\secondaxis(j)=1
          is_second=1
          For i=0 To size 
            If logy2
              imp(k)\drawset(i,j)=Round((Log10(imp(k)\set(i,j))-para\min2)*para\scaley2,#PB_Round_Nearest)
            Else  
              imp(k)\drawset(i,j)=Round((imp(k)\set(i,j)-para\min2)*para\scaley2,#PB_Round_Nearest)
            EndIf  
          Next i
        Else 
          is_first=1
          For i=0 To size 
            If logy
              imp(k)\drawset(i,j)=Round((Log10(imp(k)\set(i,j))-para\min)*para\scaley,#PB_Round_Nearest)
            Else  
              imp(k)\drawset(i,j)=Round((imp(k)\set(i,j)-para\min)*para\scaley,#PB_Round_Nearest)
            EndIf  
          Next i
        EndIf
      EndIf
    Next j
    ;draw each graph as line
    For j=0 To column
      If imp(k)\draw(j)        
        count1+1;:If count1>10:count1=0:EndIf
        ReDim names.s(count1)
        names(count1)=imp(k)\description+": "+imp(k)\header(j)
        For i=0 To size
          If imp(k)\tags(i,j)&#Bittag1
            tag1=1
            If imp(k)\tags(i,j)&#Bittag2
              tag12=1
              If imp(k)\tags(i,j)&#Bittag3
                tag123=1
              EndIf
            ElseIf imp(k)\tags(i,j)&#Bittag3
              tag13=1  
            EndIf
          EndIf
          If imp(k)\tags(i,j)&#Bittag2
            tag2=1
            If imp(k)\tags(i,j)&#Bittag3
              tag23=1
            EndIf  
          EndIf
          If imp(k)\tags(i,j)&#Bittag3
            tag3=1  
          EndIf    
          If imp(k)\tags(i,j)&#Bitplot:mode=2:edited=1:Else:mode=1:EndIf  
          If imp(k)\tags(i,j)&#Bitdel; Or imp(k)\tags(i+1,j)&#Bitdel
            thick=0
          ElseIf imp(k)\tags(i,j)&#Bithide
            thick=1
          ElseIf imp(k)\tags(i,j)&#Bitmark
            thick=4
          Else
            thick=2
          EndIf          
          If (imp(k)\secondaxis(j) And line2=2) Or (Not imp(k)\secondaxis(j) And line1=2) 
            If imp(k)\drawscale(i)<=graphwidth*(1-trans)+trans*graphheight And imp(k)\drawscale(i)>=0 And Not IsNAN(imp(k)\set(i,j)) 
              If thick
                If type=1
                  SelectObject_(bild,penbrushes(thick,count1%9,tagsnr(imp(k)\tags(i,j),0)))
                  SelectObject_(bild,penbrushes(0,count1%9,tagsnr(imp(k)\tags(i,j),0)))
                  If trans
                    If inversx
                      If inversy
                        Ellipse_(bild,graphwidth-imp(k)\drawset(i,j)+offset-thick,offsetvert+imp(k)\drawscale(i)-thick,graphwidth-imp(k)\drawset(i,j)+offset+thick,offsetvert+imp(k)\drawscale(i)+thick)
                      Else
                        Ellipse_(bild,graphwidth-imp(k)\drawset(i,j)+offset-thick,graphheight+offsetvert-imp(k)\drawscale(i)-thick,graphwidth-imp(k)\drawset(i,j)+offset+thick,graphheight+offsetvert-imp(k)\drawscale(i)+thick)
                      EndIf  
                    Else  
                      If inversy
                        Ellipse_(bild,imp(k)\drawset(i,j)+offset-thick,offsetvert+imp(k)\drawscale(i)-thick,imp(k)\drawset(i,j)+offset+thick,offsetvert+imp(k)\drawscale(i)+thick)
                      Else  
                        Ellipse_(bild,imp(k)\drawset(i,j)+offset-thick,graphheight+offsetvert-imp(k)\drawscale(i)-thick,imp(k)\drawset(i,j)+offset+thick,graphheight+offsetvert-imp(k)\drawscale(i)+thick)
                      EndIf
                    EndIf
                  Else
                    If inversx
                      If inversy
                        Ellipse_(bild,graphwidth-imp(k)\drawscale(i)+offset-thick,offsetvert+imp(k)\drawset(i,j)-thick,graphwidth-imp(k)\drawscale(i)+offset+thick,offsetvert+imp(k)\drawset(i,j)+thick)
                      Else
                        Ellipse_(bild,graphwidth-imp(k)\drawscale(i)+offset-thick,graphheight+offsetvert-imp(k)\drawset(i,j)-thick,graphwidth-imp(k)\drawscale(i)+offset+thick,graphheight+offsetvert-imp(k)\drawset(i,j)+thick)
                      EndIf  
                    Else  
                      If inversy
                        Ellipse_(bild,imp(k)\drawscale(i)+offset-thick,offsetvert+imp(k)\drawset(i,j)-thick,imp(k)\drawscale(i)+offset+thick,offsetvert+imp(k)\drawset(i,j)+thick)
                      Else  
                        Ellipse_(bild,imp(k)\drawscale(i)+offset-thick,graphheight+offsetvert-imp(k)\drawset(i,j)-thick,imp(k)\drawscale(i)+offset+thick,graphheight+offsetvert-imp(k)\drawset(i,j)+thick)
                      EndIf
                    EndIf
                  EndIf  
                Else
                  If trans
                    If inversx
                      If inversy
                        Circle(graphwidth-imp(k)\drawset(i,j)+offset,offsetvert+imp(k)\drawscale(i),thick,farbe(imp(k)\tags(i,j),count1%9))
                      Else
                        Circle(graphwidth-imp(k)\drawset(i,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i),thick,farbe(imp(k)\tags(i,j),count1%9))
                      EndIf  
                    Else  
                      If inversy
                        Circle(imp(k)\drawset(i,j)+offset,offsetvert+imp(k)\drawscale(i),thick,farbe(imp(k)\tags(i,j),count1%9))
                      Else  
                        Circle(imp(k)\drawset(i,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i),thick,farbe(imp(k)\tags(i,j),count1%9))
                      EndIf  
                    EndIf  
                  Else
                    If inversx
                      If inversy
                        Circle(graphwidth-imp(k)\drawscale(i)+offset,offsetvert+imp(k)\drawset(i,j),thick,farbe(imp(k)\tags(i,j),count1%9))
                      Else
                        Circle(graphwidth-imp(k)\drawscale(i)+offset,graphheight+offsetvert-imp(k)\drawset(i,j),thick,farbe(imp(k)\tags(i,j),count1%9))
                      EndIf  
                    Else
                      If inversy
                        Circle(imp(k)\drawscale(i)+offset,offsetvert+imp(k)\drawset(i,j),thick,farbe(imp(k)\tags(i,j),count1%9))
                      Else  
                        Circle(imp(k)\drawscale(i)+offset,graphheight+offsetvert-imp(k)\drawset(i,j),thick,farbe(imp(k)\tags(i,j),count1%9))
                      EndIf
                    EndIf  
                  EndIf  
                EndIf  
              EndIf
            EndIf
          Else
            If i<size
              If Not invalid(k,i+1,j);(IsNAN(imp(k)\set(i+1,j)) Or imp(k)\tags(i+1,j)&#Bitdel)
                If imp(k)\drawscale(i+1)<=graphwidth*(1-trans)+trans*graphheight And imp(k)\drawscale(i)>=0 And Not IsNAN(imp(k)\set(i,j))
                  If thick
                    If type=1
                      SelectObject_(bild,penbrushes(thick,count1%9,tagsnr(imp(k)\tags(i,j),0)))
                    EndIf
                    If trans
                      If inversx
                        If inversy
                          phase=thickLine(graphwidth-imp(k)\drawset(i,j)+offset,offsetvert+imp(k)\drawscale(i),graphwidth-imp(k)\drawset(i+1,j)+offset,offsetvert+imp(k)\drawscale(i+1),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)
                        Else
                          phase=thickLine(graphwidth-imp(k)\drawset(i,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i),graphwidth-imp(k)\drawset(i+1,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i+1),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)
                        EndIf  
                      Else
                        If inversy
                          phase=thickLine(imp(k)\drawset(i,j)+offset,offsetvert+imp(k)\drawscale(i),imp(k)\drawset(i+1,j)+offset,offsetvert+imp(k)\drawscale(i+1),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)
                        Else
                          phase=thickLine(imp(k)\drawset(i,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i),imp(k)\drawset(i+1,j)+offset,graphheight+offsetvert-imp(k)\drawscale(i+1),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)
                        EndIf  
                      EndIf  
                    Else
                      If inversx
                        If inversy
                          phase=thickLine(graphwidth-imp(k)\drawscale(i)+offset,offsetvert+imp(k)\drawset(i,j),graphwidth-imp(k)\drawscale(i+1)+offset,offsetvert+imp(k)\drawset(i+1,j),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)                                                   
                        Else
                          phase=thickLine(graphwidth-imp(k)\drawscale(i)+offset,graphheight+offsetvert-imp(k)\drawset(i,j),graphwidth-imp(k)\drawscale(i+1)+offset,graphheight+offsetvert-imp(k)\drawset(i+1,j),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild) 
                        EndIf  
                      Else
                        If inversy
                          phase=thickLine(imp(k)\drawscale(i)+offset,offsetvert+imp(k)\drawset(i,j),imp(k)\drawscale(i+1)+offset,offsetvert+imp(k)\drawset(i+1,j),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)                          
                        Else  
                          phase=thickLine(imp(k)\drawscale(i)+offset,graphheight+offsetvert-imp(k)\drawset(i,j),imp(k)\drawscale(i+1)+offset,graphheight+offsetvert-imp(k)\drawset(i+1,j),thick,farbe(imp(k)\tags(i,j),count1%9),mode,phase,type,bild)
                        EndIf
                      EndIf  
                    EndIf  
                  EndIf 
                EndIf
              EndIf
            Else
              phase=0
            EndIf
          EndIf          
        Next i        
      EndIf
      phase=NaN()
    Next j
  Next k
  
  ypoint.i
  ypoint2.i
  xpoint.i
  
  If type=1
    SelectObject_(bild,penbrushes(1,0,0))
    SelectObject_(bild,emffontprim)
  EndIf  
  
  DrawingFont(FontID(fontprimaxis\id))
  
  scalerange_y.d=para\max-para\min
  startscale_y.d=Round(para\min/interval_y,#PB_Round_Up)*interval_y
  endscale_y.d=Round(para\max/interval_y,#PB_Round_Down)*interval_y
  n_ticks_y.i=Round((endscale_y-startscale_y)/interval_y,#PB_Round_Down) 
  
  If trans
    length1.l=DrawText(1,1,StrD(endscale_y,decimals_y),RGB(255,255,255))
    stepy.i=Round(n_ticks_y*length1/graphwidth,#PB_Round_Up)
  Else  
    stepy.i=Round(n_ticks_y*22/graphheight,#PB_Round_Up)
  EndIf
  
  If stepy=0:stepy=1:EndIf
  i=0 
  While i<=n_ticks_y
    If trans
      If inversx
        ypoint=offset+graphwidth-((startscale_y+i*interval_y)-para\min)/(scalerange_y)*graphwidth
      Else  
        ypoint=offset+((startscale_y+i*interval_y)-para\min)/(scalerange_y)*graphwidth
      EndIf  
    Else
      If inversy
        ypoint=offsetvert+((startscale_y+i*interval_y)-para\min)/(scalerange_y)*graphheight
      Else  
        ypoint=graphheight+offsetvert-((startscale_y+i*interval_y)-para\min)/(scalerange_y)*graphheight
      EndIf  
    EndIf  
    If type=1
      If gridy
        If trans
          For j=0 To graphheight Step 3
            lineemf(bild,ypoint,offsetvert+j,ypoint,offsetvert+j+1)
          Next j         
        Else  
          For j=0 To graphwidth Step 3
            lineemf(bild,offset+j,ypoint,offset+j+1,ypoint)
          Next j
        EndIf
      EndIf
      If trans
        lineemf(bild,ypoint,graphheight+offsetvert+2,ypoint,graphheight+offsetvert)
      Else  
        lineemf(bild,offset-2,ypoint,offset,ypoint)
      EndIf  
    Else
      If gridy
        If trans
          For j=0 To graphheight Step 3
            LineXY(ypoint,offsetvert+j,ypoint,offsetvert+j+1,RGB(0,0,0))
          Next j         
        Else  
          For j=0 To graphwidth Step 3
            LineXY(offset+j,ypoint,offset+j+1,ypoint,RGB(0,0,0))
          Next j
        EndIf  
      EndIf
      If trans
        LineXY(ypoint,graphheight+offsetvert+2,ypoint,graphheight+offsetvert,RGB(0,0,0)) 
      Else  
        LineXY(offset-2,ypoint,offset,ypoint,RGB(0,0,0)) 
      EndIf  
    EndIf  
    If expy
      If logy
        scaletext=get_exp(Pow(10,startscale_y+i*interval_y),decimals_y)
      Else  
        scaletext=get_exp(startscale_y+i*interval_y,decimals_y)  
      EndIf  
    Else 
      If logy
        scaletext=StrD(Pow(10,startscale_y+i*interval_y),decimals_y)
      Else
        scaletext=StrD(startscale_y+i*interval_y,decimals_y)
      EndIf  
    EndIf
    ;If Len(scaletext)>longest:longest=Len(scaletext):EndIf
    
    textlength=DrawText(1,1,scaletext,RGB(255,255,255),RGB(255,255,255))
    If textlength>longest:longest=textlength:EndIf
    
    If type=1
      If trans
        textemf(bild,ypoint-Len(scaletext)*fontprimaxis\size*fontscale,graphheight+offsetvert+20,scaletext)
      Else  
        textemf(bild,offset-10-textlength,ypoint-fontprimaxis\size*fontscale*2,scaletext)
      EndIf  
    Else
      If trans
        DrawText(ypoint-Len(scaletext)*fontprimaxis\size*fontscale,graphheight+offsetvert+20,scaletext)
      Else  
        DrawText(offset-10-textlength,ypoint-fontprimaxis\size*fontscale*2,scaletext)
      EndIf  
    EndIf  
    i+stepy
  Wend
  If Not trans
    If para\primaxis=""
      offset=longest+40
      ;If longest+50>offset:offset=longest+40:Else:offset=100:EndIf
    Else 
      offset=longest+80
      ;If longest+90>offset:offset=longest+80:Else:offset=140:EndIf
    EndIf
    If Not offset=offset_alt:offset_alt=offset:StopDrawing():ProcedureReturn 0:EndIf
  EndIf
  
  DrawingFont(FontID(fontsecaxis\id))
  If type=1
    SelectObject_(bild,emffontsec)
  EndIf  
  scalerange_y2.d=para\max2-para\min2
  
  startscale_y2.d=Round(para\min2/interval_y2,#PB_Round_Up)*interval_y2
  endscale_y2.d=Round(para\max2/interval_y2,#PB_Round_Down)*interval_y2
  n_ticks_y2.i=Round((endscale_y2-startscale_y2)/interval_y2,#PB_Round_Down)
  
  If trans
    length1.l=DrawText(1,1,StrD(endscale_y2,decimals_y2),RGB(255,255,255))
    stepy2.i=Round(n_ticks_y2*length1/graphwidth,#PB_Round_Up)
  Else  
    stepy2.i=Round(n_ticks_y2*22/graphheight,#PB_Round_Up)
  EndIf  
  If stepy2=0:stepy2=1:EndIf
  i=0:longest=0 
  
  While i<=n_ticks_y2
    If trans
      If inversx
        ypoint=offset+graphwidth-((startscale_y2+i*interval_y2)-para\min2)/(scalerange_y2)*graphwidth
      Else  
        ypoint2=offset+((startscale_y2+i*interval_y2)-para\min2)/(scalerange_y2)*graphwidth
      EndIf  
    Else
      If inversy
        ypoint=offsetvert+((startscale_y2+i*interval_y2)-para\min2)/(scalerange_y2)*graphheight
      Else  
        ypoint2=graphheight+offsetvert-((startscale_y2+i*interval_y2)-para\min2)/(scalerange_y2)*graphheight
      EndIf  
    EndIf
    If type=1
      If gridy2
        If trans
          For j=0 To graphheight Step 3
            lineemf(bild,ypoint2,offsetvert+j,ypoint2,offsetvert+j+1)
          Next j          
        Else  
          For j=0 To graphwidth Step 3
            lineemf(bild,offset+j,ypoint2,offset+j+1,ypoint2)
          Next j
        EndIf  
      EndIf
      If trans
        lineemf(bild,ypoint2,offsetvert-2,ypoint2,offsetvert)
      Else  
        lineemf(bild,offset+graphwidth+2,ypoint2,offset+graphwidth,ypoint2)
      EndIf  
    Else
      If gridy2
        If trans
          For j=0 To graphheight Step 3
            LineXY(ypoint2,offsetvert+j,ypoint2,offsetvert+j+1,RGB(0,0,0))
          Next j         
        Else         
          For j=0 To graphwidth Step 3
            LineXY(offset+j,ypoint2,offset+j+1,ypoint2,RGB(0,0,0))
          Next j 
        EndIf
      EndIf
      If trans
        LineXY(ypoint2,offsetvert-2,ypoint2,offsetvert,RGB(0,0,0))
      Else  
        LineXY(offset+graphwidth+2,ypoint2,offset+graphwidth,ypoint2,RGB(0,0,0))
      EndIf  
    EndIf
    If expy2
      If logy2
        scaletext=get_exp(Pow(10,startscale_y2+i*interval_y2),decimals_y2)
      Else  
        scaletext=get_exp(startscale_y2+i*interval_y2,decimals_y2)  
      EndIf  
    Else 
      If logy2
        scaletext=StrD(Pow(10,startscale_y2+i*interval_y2),decimals_y2)
      Else
        scaletext=StrD(startscale_y2+i*interval_y2,decimals_y2)
      EndIf  
    EndIf
    ;If Len(scaletext)>longest:longest=Len(scaletext):EndIf
    textlength=DrawText(1,1,scaletext,RGB(255,255,255))
    If textlength>longest:longest=textlength:EndIf
    If type=1
      If trans
        textemf(bild,ypoint2-fontsecaxis\size*fontscale*Len(scaletext),offsetvert-30,scaletext)
      Else  
        textemf(bild,offset+graphwidth+10,ypoint2-fontsecaxis\size*fontscale*2,scaletext)
      EndIf  
    Else 
      If trans
        DrawText(ypoint2-fontsecaxis\size*fontscale*Len(scaletext),offsetvert-30,scaletext)
      Else  
        DrawText(offset+graphwidth+10,ypoint2-fontsecaxis\size*fontscale*2,scaletext)
      EndIf  
    EndIf  
    i+stepy2
  Wend
  If Not trans
    If para\secaxis=""
      offset2=longest+30
    Else  
      offset2=longest+70
    EndIf  
  EndIf
  If Not offset2=offset2_alt:offset2_alt=offset2:changed=1:EndIf
  
  scalerange_x.d=para\bound_up-para\bound_low
  
  startscale_x.d=Round(para\bound_low/interval_x,#PB_Round_Up)*interval_x
  endscale_x.d=Round(para\bound_up/interval_x,#PB_Round_Down)*interval_x 
  n_ticks_x.i=Round((endscale_x-startscale_x)/interval_x,#PB_Round_Nearest)
  StopDrawing()
  tempbild=CreateImage(#PB_Any,200,200)
  StartDrawing(ImageOutput(tempbild))
  DrawingFont(FontID(fontabscissa\id))
  
  If is_time
    length1.l=DrawText(1,1,FormatDate(mask1,Round(endscale_x,#PB_Round_Nearest)))
    length2.l=DrawText(1,1,FormatDate(mask2,Round(endscale_x,#PB_Round_Nearest)))
  Else
    length1.l=DrawText(1,1,StrD(endscale_x,decimals_x))
  EndIf
  If length1<length2:length1=length2:EndIf:length1+2
  If trans
    stepx.i=Round(n_ticks_x*22/graphheight,#PB_Round_Up)
  Else
    stepx.i=Round(n_ticks_x*length1/graphwidth,#PB_Round_Up)
  EndIf  
  If stepx=0:stepx=1:EndIf
  StopDrawing()
  FreeImage(tempbild)
  
  If type=1
    StartDrawing(ImageOutput(dummybild))
    SelectObject_(bild,emffontabscissa) 
  Else
    StartDrawing(ImageOutput(bild))    
    BackColor(RGB(255,255,255))
    FrontColor(RGB(0,0,0))
  EndIf
  DrawingFont(FontID(fontabscissa\id))
  
  i=0:longest=0
  While i<=n_ticks_x 
    If trans
      If inversy
        xpoint=offsetvert+((startscale_x+i*interval_x)-para\bound_low)/(scalerange_x)*graphheight
      Else  
        xpoint=graphheight+offsetvert-((startscale_x+i*interval_x)-para\bound_low)/(scalerange_x)*graphheight
      EndIf  
    Else
      If inversx
        xpoint=graphwidth+offset-((startscale_x+i*interval_x)-para\bound_low)/(scalerange_x)*graphwidth
      Else  
        xpoint=offset+((startscale_x+i*interval_x)-para\bound_low)/(scalerange_x)*graphwidth
      EndIf  
    EndIf  
    If type=1
      If gridx
        If trans
          For j=0 To graphwidth Step 3
            lineemf(bild,offset+j,xpoint,offset+j+1,xpoint)
          Next j
        Else  
          For j=0 To graphheight Step 3
            lineemf(bild,xpoint,offsetvert+j,xpoint,offsetvert+j+1)
          Next j
        EndIf  
      EndIf 
      If trans
        lineemf(bild,offset,xpoint,offset-2,xpoint)
      Else  
        lineemf(bild,xpoint,graphheight+offsetvert,xpoint,graphheight+offsetvert+2)
      EndIf  
    Else 
      If gridx
        If trans
          For j=0 To graphwidth Step 3
            LineXY(offset+j,xpoint,offset+j+1,xpoint,RGB(0,0,0))
          Next j         
        Else  
          For j=0 To graphheight Step 3
            LineXY(xpoint,offsetvert+j,xpoint,offsetvert+j+1,RGB(0,0,0))
          Next j
        EndIf
      EndIf 
      If trans
        LineXY(offset,xpoint,offset-2,xpoint,RGB(0,0,0))
      Else  
        LineXY(xpoint,graphheight+offsetvert,xpoint,graphheight+offsetvert+2,RGB(0,0,0))
      EndIf  
    EndIf  
    If expx
      If logx
        scaletext=get_exp(Pow(10,startscale_x+i*interval_x),decimals_x)
      Else
        scaletext=get_exp(startscale_x+i*interval_x,decimals_x)
      EndIf  
    Else
      If logx
        scaletext=StrD(Pow(10,startscale_x+i*interval_x),decimals_x) 
      Else
        If is_time
          scaletext=FormatDate(mask1,Round(startscale_x+i*interval_x,#PB_Round_Nearest))
          scaletext2=FormatDate(mask2,Round(startscale_x+i*interval_x,#PB_Round_Nearest))
          If trans
            scaletext+" "+scaletext2
          EndIf  
        Else  
          scaletext=StrD(startscale_x+i*interval_x,decimals_x)
        EndIf  
      EndIf            
    EndIf  
    
    textlength=DrawText(1,1,scaletext,RGB(255,255,255),RGB(255,255,255))
    If textlength>longest:longest=textlength:EndIf
    
    If type=1
      If trans
        textemf(bild,offset-10-textlength,xpoint-10,scaletext)
      Else  
        textemf(bild,xpoint-Len(scaletext)*fontabscissa\size*fontscale,graphheight+offsetvert+10,scaletext)
      EndIf  
    Else
      If trans
        DrawText(offset-10-textlength,xpoint-10,scaletext)
      Else
        DrawText(xpoint-Len(scaletext)*fontabscissa\size*fontscale,graphheight+offsetvert+10,scaletext)
      EndIf  
    EndIf  
    If scaletext2 
      If type=1
        textemf(bild,xpoint-Len(scaletext)*fontabscissa\size*fontscale,graphheight+offsetvert+30,scaletext2)  
      Else  
        DrawText(xpoint-Len(scaletext)*fontabscissa\size*fontscale,graphheight+offsetvert+30,scaletext2)
      EndIf
    EndIf
    i+stepx
  Wend
  
  If trans
    If para\abscissa=""
      offset=longest+40
      ;If longest+50>offset:offset=longest+40:Else:offset=100:EndIf
    Else 
      offset=longest+80
      ;If longest+90>offset:offset=longest+80:Else:offset=140:EndIf
    EndIf
    If Not offset=offset_alt:offset_alt=offset:StopDrawing():ProcedureReturn 0:EndIf
  EndIf
  
  DrawingFont(FontID(fontcomment\id))
  If type=1
    SelectObject_(bild,emffontcom)
  EndIf  
  DrawingMode(#PB_2DDrawing_Transparent)
  For i=0 To files
    If imp(i)\showcomment
      ;count=1      
      ForEach imp(i)\comments()    
        comx.i=Round((imp(i)\comments()\x-para\bound_low)*para\scalex,#PB_Round_Nearest)
        If logy
          comy.i=Round((Log10(imp(i)\comments()\y)-para\min)*para\scaley,#PB_Round_Nearest)
        Else  
          comy.i=Round((imp(i)\comments()\y-para\min)*para\scaley,#PB_Round_Nearest)
        EndIf  
        If comx>0 And comx<graphwidth And comy>0 And comy<graphheight
          If type=1
            ;textemf(bild,offset+comx,graphheight+offsetvert-20-comy,Str(count)+". "+imp(i)\comments()\text)
            textemf(bild,offset+comx,graphheight+offsetvert-20-comy,imp(i)\comments()\text)
          Else
            If trans
              If inversx
                If inversy
                  ;DrawText(offset+graphwidth-comy,offsetvert+comx,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+graphwidth-comy,offsetvert+comx,imp(i)\comments()\text)
                Else  
                  ;DrawText(offset+graphwidth-comy,graphheight+offsetvert-20-comx,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+graphwidth-comy,graphheight+offsetvert-20-comx,imp(i)\comments()\text)
                EndIf 
              Else
                If inversy
                  ;DrawText(offset+comy,offsetvert+comx,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+comy,offsetvert+comx,imp(i)\comments()\text)
                Else  
                  ;DrawText(offset+comy,graphheight+offsetvert-20-comx,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+comy,graphheight+offsetvert-20-comx,imp(i)\comments()\text)
                EndIf  
              EndIf
            Else
              If inversx
                If inversy
                  DrawText(offset+graphwidth-comx,offsetvert+comy,imp(i)\comments()\text)
                  ;DrawText(offset+graphwidth-comx,offsetvert+comy,Str(count)+". "+imp(i)\comments()\text)
                Else  
                  ;DrawText(offset+graphwidth-comx,graphheight+offsetvert-20-comy,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+graphwidth-comx,graphheight+offsetvert-20-comy,imp(i)\comments()\text)
                EndIf 
              Else
                If inversy
                  ;DrawText(offset+comx,offsetvert+comy,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+comx,offsetvert+comy,imp(i)\comments()\text)
                Else  
                  ;DrawText(offset+comx,graphheight+offsetvert-20-comy,Str(count)+". "+imp(i)\comments()\text)
                  DrawText(offset+comx,graphheight+offsetvert-20-comy,imp(i)\comments()\text)
                EndIf  
              EndIf  
            EndIf  
          EndIf    
        EndIf
       ; count+1
      Next
    EndIf
  Next i
  ;legend
  count=0
  
  ;   If logy:para\max=Pow(10,para\max):para\min=Pow(10,para\min):EndIf
  ;   If logy2:para\max2=Pow(10,para\max2):para\min2=Pow(10,para\min2):EndIf
  
  DrawingFont(FontID(fontlegend\id))
  If type=1
    SelectObject_(bild,emffontlegend)
  EndIf  
  phase=NaN()
  For i=0 To count1
    If type=1:SelectObject_(bild,penbrushes(2,i%9,0)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(0,i%9),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,names(i))
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,names(i))
    EndIf  
    count+1
  Next i
  If edited
    If type=1:SelectObject_(bild,penbrushes(2,0,0)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,0,2,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,"Edited Data")
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,"Edited Data")
    EndIf  
    count+1
  EndIf
  If tag1
    If type=1:SelectObject_(bild,penbrushes(2,0,1)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag1,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1)
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1)
    EndIf  
    count+1    
  EndIf
  If tag2
    If type=1:SelectObject_(bild,penbrushes(2,0,2)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag2,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag2)
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag2)
    EndIf  
    count+1    
  EndIf
  If tag3
    If type=1:SelectObject_(bild,penbrushes(2,0,3)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag3,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag3)
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag3)
    EndIf  
    count+1
  EndIf
  If tag12
    If type=1:SelectObject_(bild,penbrushes(2,0,4)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag1|#Bittag2,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag2)
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag2)
    EndIf  
    count+1
  EndIf
  If tag13
    If type=1:SelectObject_(bild,penbrushes(2,0,5)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag1|#Bittag3,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag3)
    Else  
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag3)
    EndIf  
    count+1
  EndIf
  If tag23
    If type=1:SelectObject_(bild,penbrushes(2,0,6)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag2|#Bittag3,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag2+" + "+para\tag3)
    Else
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag2+" + "+para\tag3)
    EndIf  
    count+1
  EndIf
  If tag123
    If type=1:SelectObject_(bild,penbrushes(2,0,7)):EndIf
    thickline(graphwidth+offset+offset2,offsetvert+10+count*20,graphwidth+100+offset+offset2,offsetvert+10+count*20,2,farbe(#Bittag1|#Bittag2|#Bittag3,0),1,0,type,bild)
    If type=1
      textemf(bild,graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag2+" + "+para\tag3)
    Else
      DrawText(graphwidth+110+offset+offset2,offsetvert+3+count*20,para\tag1+" + "+para\tag2+" + "+para\tag3)
    EndIf  
    count+1
  EndIf  
  legendheight=count
  
  If type=0
    DrawingMode(#PB_2DDrawing_Default)
    DrawingFont(FontID(fonteditor\id))
    editorheight.i=ScreenHeight()-offsetvert-graphheight-80
    editorwidth.i=graphwidth
    offseteditor.i=offsetvert+graphheight+60
    rowheight=fonteditor\size+6 
    maxeditorcolumns.i=Round(editorwidth/columnwidth,#PB_Round_Down)-1
    editorrows.i=Round(editorheight/rowheight,#PB_Round_Down)-2
    If editorrows>ArraySize(imp(selected)\scale()):editorrows=ArraySize(imp(selected)\scale()):EndIf
    If selected>=0  
      If editorpos<0:editorpos=0:EndIf
      If editorpos+editorrows>ArraySize(imp(selected)\scale()):editorpos=ArraySize(imp(selected)\scale())-editorrows:EndIf
   EndIf  
    
    DrawText(offset,offseteditor,"Scale")
    For i=0 To editorrows
      somethingmarked=RGB(255,255,255)
      For j=0 To ArraySize(imp(selected)\set(),2)
        If imp(selected)\draw(j) And imp(selected)\tags(i+editorpos,j)&#Bitmark:somethingmarked=RGB(150,255,150):EndIf
      Next  
      If is_time
        DrawText(offset,offseteditor+(i+1)*rowheight,FormatDate(maskeditor,imp(selected)\scale(i+editorpos)),0,somethingmarked)
      Else  
        DrawText(offset,offseteditor+(i+1)*rowheight,StrD(imp(selected)\scale(i+editorpos)),0,somethingmarked)
      EndIf  
    Next i    
  
    count=-1
    For j=0 To ArraySize(imp(selected)\set(),2)
      If imp(selected)\draw(j)
        count+1
        ReDim editorcols.i(count)
        editorcols(count)=j
        DrawText(offset+columnwidth*(count+1),offseteditor,imp(selected)\header(j),RGB(0,0,0),RGB(255,255,255))
        For i=0 To editorrows
          If Not invalid(selected,i+editorpos,j)
            If imp(selected)\tags(i+editorpos,j)&#Bitmark 
              DrawText(offset+columnwidth*(count+1),offseteditor+(i+1)*rowheight,StrD(imp(selected)\set(i+editorpos,j)),farbe(imp(selected)\tags(i+editorpos,j),0),RGB(200,100,100))
            Else  
              DrawText(offset+columnwidth*(count+1),offseteditor+(i+1)*rowheight,StrD(imp(selected)\set(i+editorpos,j)),farbe(imp(selected)\tags(i+editorpos,j),0))
            EndIf
          EndIf
        Next i
        If count>=maxeditorcolumns-2:Break(1):EndIf
      EndIf  
    Next j
    count+1
    DrawText(offset+columnwidth*(count+1),offseteditor,"Notes",RGB(0,0,0),RGB(255,255,255))
    For i=0 To editorrows  
      DrawText(offset+columnwidth*(count+1),offseteditor+(i+1)*rowheight,imp(selected)\notes(i+editorpos)) 
    Next i 
    editorcolumns=count
    x1=selcol+1
    y1=selrow-editorpos
    If y1>=0 And y1<=editorrows And x1<=editorcolumns+1
      LineXY(offset+columnwidth*(x1),offseteditor+(y1+1)*rowheight,offset+columnwidth*(x1+1),offseteditor+(y1+1)*rowheight,RGB(100,100,100))
      LineXY(offset+columnwidth*(x1),offseteditor+(y1+2)*rowheight,offset+columnwidth*(x1+1),offseteditor+(y1+2)*rowheight,RGB(100,100,100))
      LineXY(offset+columnwidth*(x1),offseteditor+(y1+1)*rowheight,offset+columnwidth*(x1),offseteditor+(y1+2)*rowheight,RGB(100,100,100))
      LineXY(offset+columnwidth*(x1+1),offseteditor+(y1+1)*rowheight,offset+columnwidth*(x1+1),offseteditor+(y1+2)*rowheight,RGB(100,100,100))
    EndIf
    editorbar\height=Round((editorrows+1)*(editorrows+1)*rowheight/(ArraySize(imp(selected)\scale())+1),#PB_Round_Up)
    If Not (ArraySize(imp(selected)\scale())-editorrows)=0
      editorbar\posy=editorpos*((editorrows+1)*rowheight-editorbar\height)/((ArraySize(imp(selected)\scale())-editorrows))
    Else
      editorbar\posy=0
    EndIf  
    editorbar\boxx=offset+columnwidth*(count+2)-1
    editorbar\boxy=offseteditor+rowheight-1
    editorbar\boxwidth=22
    editorbar\boxheight=(editorrows+1)*rowheight+2
    Box(editorbar\boxx,editorbar\boxy,editorbar\boxwidth,editorbar\boxheight,RGB(150,150,150))
    If Not ArraySize(imp(selected)\scale())-editorrows=0
      Box(editorbar\boxx+1,editorbar\boxy+1+editorbar\posy,20,Round(editorbar\height,#PB_Round_Up),RGB(200,200,200))
    Else
      Box(editorbar\boxx+1,editorbar\boxy+1,editorbar\boxwidth-2,Round(editorbar\height,#PB_Round_Up),RGB(200,200,200))
    EndIf
  EndIf
  
  StopDrawing()
  
  If type=1
    DeleteObject_(emffonttitle)
    DeleteObject_(emffontstd)
    DeleteObject_(emffontprim)
    DeleteObject_(emffontprimvert)
    DeleteObject_(emffontsec)
    DeleteObject_(emffontsecvert)
    DeleteObject_(emffontlegend)
    DeleteObject_(emffontabscissa)
    For i=0 To 4  ;drawing is done, free pens and brushes
      For j=0 To 8
        For k=0 To 7
          DeleteObject_(penbrushes(i,j,k))
        Next k  
      Next j
    Next i  
    FreeImage(dummybild)
  EndIf  
  
  ProcedureReturn 1
  
EndProcedure

Procedure shut_down()
  If unsaved
    If   MessageRequester("Warning","Really Quit?"+#eol+"There are unsaved changes!",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes 
      quit=1
    EndIf  
  ElseIf MessageRequester("Warning","Really Quit?",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes       
    quit=1
  EndIf
  If quit
    ;write data to preferences
    If Not OpenPreferences("init.dat")
      CreatePreferences("init.dat")  
    EndIf
    WritePreferenceInteger("AQUADIV_auto_save_attention",0)
    WritePreferenceString("AQUADIV_defaultdirectory",directory) 
    WritePreferenceInteger("AQUADIV_xpos",WindowX(#Win_Para))
    WritePreferenceInteger("AQUADIV_ypos",WindowY(#Win_Para))
    WritePreferenceInteger("AQUADIV_height",ScreenHeight())
    WritePreferenceInteger("AQUADIV_width",ScreenWidth())
    WritePreferenceDouble("AQUADIV_interval_x",interval_x)
    WritePreferenceDouble("AQUADIV_interval_y",interval_y)
    WritePreferenceDouble("AQUADIV_interval_y2",interval_y2)
    WritePreferenceInteger("AQUADIV_decimals_x",decimals_x)
    WritePreferenceInteger("AQUADIV_decimals_y",decimals_y)
    WritePreferenceInteger("AQUADIV_decimals_y2",decimals_y2)
    WritePreferenceInteger("AQUADIV_filterwidth",filterbreite)
    WritePreferenceInteger("AQUADIV_filtertype",filtertype)
    WritePreferenceDouble("AQUADIV_filtersigma",filtersigma)
    WritePreferenceInteger("AQUADIV_filterdegree",filterdegree)
    WritePreferenceInteger("AQUADIV_lineoption1",line1)
    WritePreferenceInteger("AQUADIV_lineoption2",line2)
    WritePreferenceInteger("AQUADIV_filetype",filetype)
    WritePreferenceInteger("AQUADIV_istime",is_time)
    WritePreferenceString("AQUADIV_mask",mask1)
    WritePreferenceString("AQUADIV_mask2",mask2)
    WritePreferenceInteger("AQUADIV_intervaltype",intervaltype)
    WritePreferenceInteger("AQUADIV_interpolation",optioninterpol)
    WritePreferenceInteger("AQUADIV_eccorrection",eccorrectiontype)
    WritePreferenceInteger("AQUADIV_temptype",temptype)
    WritePreferenceInteger("AQUADIV_linelength",linelength)
    WritePreferenceInteger("AQUADIV_holelength",holelength)
    WritePreferenceString("AQUADIV_tag1",para\tag1)
    WritePreferenceString("AQUADIV_tag2",para\tag2)
    WritePreferenceString("AQUADIV_tag3",para\tag3)
    WritePreferenceString("AQUADIV_title",para\title)
    WritePreferenceString("AQUADIV_primaxis",para\primaxis)
    WritePreferenceString("AQUADIV_secaxis",para\secaxis)
    WritePreferenceString("AQUADIV_abscissa",para\abscissa)
    WritePreferenceInteger("AQUADIV_temptype_eh",temptype_eh)
    WritePreferenceInteger("AQUADIV_graphwidth",graphwidth)
    WritePreferenceInteger("AQUADIV_graphheight",graphheight)
    WritePreferenceInteger("AQUADIV_firstdatacolumn",firstdatacustom)
    WritePreferenceInteger("AQUADIV_datecolumn",datecolumncustom)
    WritePreferenceInteger("AQUADIV_timecolumn",timecolumncustom)
    WritePreferenceInteger("AQUADIV_columnseparator",columnseparator)
    WritePreferenceInteger("AQUADIV_decimalseparator",decimalseparator)
    WritePreferenceInteger("AQUADIV_skiprows",skiprows)
    WritePreferenceInteger("AQUADIV_datetimecustom",datetimecustom)
    WritePreferenceString("AQUADIV_maskcustom",maskcustom)
    WritePreferenceString("AQUADIV_maskcustom2",maskcustom2)
    WritePreferenceString("AQUADIV_maskeditor",maskeditor)
    WritePreferenceInteger("AQUADIV_istimecustom",is_time_custom)
    WritePreferenceInteger("AQUADIV_usefilename",usefilename)
    WritePreferenceInteger("AQUADIV_intervaltypeaggregation",intervaltype_aggregation)
    WritePreferenceDouble("AQUADIV_intervalaggregation",interval_aggregation)
    WritePreferenceInteger("AQUADIV_optionaggreagtion",option_aggregation)
    WritePreferenceInteger("AQUADIV_aggreagtedirection",aggregate_direction)
    WritePreferenceInteger("AQUADIV_operationtypeaggregation",operationtype_aggregation)
    ;     WritePreferenceDouble("AQUADIV_fromaggregation",from_aggregation)
    ;     WritePreferenceDouble("AQUADIV_toaggregation",to_aggregation)
    WritePreferenceDouble("AQUADIV_lffactor",lffactor)
    WritePreferenceInteger("AQUADIV_eccorrectiontype",eccorrectiontype)
    WritePreferenceInteger("AQUADIV_showgridx",gridx)
    WritePreferenceInteger("AQUADIV_showgridy",gridy)
    WritePreferenceInteger("AQUADIV_showgridy2",gridy2)
    WritePreferenceInteger("AQUADIV_trans",trans)
    WritePreferenceInteger("AQUADIV_inversx",inversx)
    WritePreferenceInteger("AQUADIV_inversy",inversy)
    WritePreferenceInteger("AQUADIV_logx",logx)
    WritePreferenceInteger("AQUADIV_logy",logy)
    WritePreferenceInteger("AQUADIV_logy2",logy2)
    WritePreferenceInteger("AQUADIV_expx",expx)
    WritePreferenceInteger("AQUADIV_expy",expy)
    WritePreferenceInteger("AQUADIV_expy2",expy2)
    WritePreferenceInteger("AQUADIV_markoption",markoption)
    WritePreferenceInteger("AQUADIV_colorscheme",colorscheme)
    WritePreferenceInteger("AQUADIV_fontsizetitle",fonttitle\size)
    WritePreferenceInteger("AQUADIV_fontsizeprimaxis",fontprimaxis\size)
    WritePreferenceInteger("AQUADIV_fontsizesecaxis",fontsecaxis\size)
    WritePreferenceInteger("AQUADIV_fontsizeabscissa",fontabscissa\size)
    WritePreferenceInteger("AQUADIV_fontsizelegend",fontlegend\size)
    WritePreferenceInteger("AQUADIV_fontsizestandard",fontstandard\size)
    WritePreferenceInteger("AQUADIV_fontsizeeditor",fonteditor\size)
    WritePreferenceInteger("AQUADIV_fontsizecomment",fontcomment\size)
    WritePreferenceString("AQUADIV_fontnametitle",fonttitle\name)
    WritePreferenceString("AQUADIV_fontnameprimaxis",fontprimaxis\name)
    WritePreferenceString("AQUADIV_fontnamesecaxis",fontsecaxis\name)
    WritePreferenceString("AQUADIV_fontnameabscissa",fontabscissa\name)
    WritePreferenceString("AQUADIV_fontnamelegend",fontlegend\name)
    WritePreferenceString("AQUADIV_fontnamestandard",fontstandard\name)
    WritePreferenceString("AQUADIV_fontnameeditor",fonteditor\name)
    WritePreferenceString("AQUADIV_fontnamecomment",fontcomment\name)
    WritePreferenceInteger("AQUADIV_fontcolortitle",fonttitle\color)
    WritePreferenceInteger("AQUADIV_fontcolorprimaxis",fontprimaxis\color)
    WritePreferenceInteger("AQUADIV_fontcolorsecaxis",fontsecaxis\color)
    WritePreferenceInteger("AQUADIV_fontcolorabscissa",fontabscissa\color)
    WritePreferenceInteger("AQUADIV_fontcolorlegend",fontlegend\color)
    WritePreferenceInteger("AQUADIV_fontcolorstandard",fontstandard\color)
    WritePreferenceInteger("AQUADIV_fontcoloreditor",fonteditor\color)
    WritePreferenceInteger("AQUADIV_fontcolorcomment",fontcomment\color)
    WritePreferenceInteger("AQUADIV_fontstyletitle",fonttitle\style)
    WritePreferenceInteger("AQUADIV_fontstyleprimaxis",fontprimaxis\style)
    WritePreferenceInteger("AQUADIV_fontstylesecaxis",fontsecaxis\style)
    WritePreferenceInteger("AQUADIV_fontstyleabscissa",fontabscissa\style)
    WritePreferenceInteger("AQUADIV_fontstylelegend",fontlegend\style)
    WritePreferenceInteger("AQUADIV_fontstylestandard",fontstandard\style)
    WritePreferenceInteger("AQUADIV_fontstyleeditor",fonteditor\style)
    WritePreferenceInteger("AQUADIV_fontstylecomment",fontcomment\style)
    
    ClosePreferences()    
    End
    
  EndIf
EndProcedure

Procedure draw_range(inside.i,pushed.i)
  If IsScreenActive() Or GetActiveWindow()=#Win_Para
    ClearScreen(RGB(255, 255, 255))
    StartDrawing(ScreenOutput())  
    DrawingFont(FontID(fontstandard\id))
    DrawImage(ImageID(bildchen),0,0)
    If pushed And Not selection_bar1=selection_bar2
      If trans
        LineXY(offset,selection_bar1,offset+graphwidth,selection_bar1,RGB(150,150,150))
        LineXY(offset,selection_bar2,offset+graphwidth,selection_bar2,RGB(150,150,150))       
      Else  
        LineXY(selection_bar1,offsetvert,selection_bar1,graphheight+offsetvert,RGB(150,150,150))
        LineXY(selection_bar2,offsetvert,selection_bar2,graphheight+offsetvert,RGB(150,150,150)) 
      EndIf
    EndIf
    If inside
      ;DrawText(1020+offset+70,100,"                                    ",RGB(255,255,255),RGB(255,255,255))
      If is_time
        DrawText(graphwidth+offset+offset2,offsetvert+23+legendheight*20,"x: "+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",valuex),RGB(0,0,0),RGB(255,255,255))
      Else  
        DrawText(graphwidth+offset+offset2,offsetvert+23+legendheight*20,"x: "+StrD(valuex),RGB(0,0,0),RGB(255,255,255))
      EndIf
      ;DrawText(1020+offset+70,120,"                                    ",RGB(255,255,255),RGB(255,255,255))
      If is_first:DrawText(graphwidth+offset+offset2,offsetvert+43+legendheight*20,"y: "+StrD(valuey),RGB(0,0,0),RGB(255,255,255)):EndIf
      ;DrawText(1020+offset+70,140,"                                    ",RGB(255,255,255),RGB(255,255,255))
      If is_second:DrawText(graphwidth+offset+offset2,offsetvert+63+legendheight*20,"y2: "+StrD(valuey2),RGB(0,0,0),RGB(255,255,255)):EndIf
      ;DrawText(1020+offset+70,160,"                                    ",RGB(255,255,255),RGB(255,255,255))
    EndIf  
    StopDrawing()  
  EndIf
  FlipBuffers()
  
EndProcedure   

Procedure.b active(file.i,column.i)
  
  Select markoption
    Case 1
      If Not imp(file)\secondaxis(column):ProcedureReturn 1:EndIf
    Case 2
      If imp(file)\secondaxis(column):ProcedureReturn 1:EndIf
    Case 3
      ProcedureReturn 1
  EndSelect    
      ProcedureReturn 0
      
EndProcedure  

Procedure get_mouse(event.i)
  
  Static mouse.par
  Static ersterklick.b
  Static ersterklickscroll.b
  Static mx_old.i
  Static my_old.i
  Static baroffset.i
  
  files=ArraySize(imp())
  
  inside.i
  mx=WindowMouseX(#Win_Plot)
  my=WindowMouseY(#Win_Plot)
  
  If mx>=offset And mx<=offset+(editorcolumns+2)*columnwidth And my>=graphheight+offsetvert+60 And my<=(graphheight+offsetvert+60+(editorrows+2)*rowheight)
    intable=1
  EndIf  
  If mx>=offset And mx<=graphwidth+offset And my=>offsetvert And my<=graphheight+offsetvert  
    DisableMenuItem(#Menu_popup_plot,#Menu_Add_comment,0)
    If Not rersterklick
      If trans
        If inversx
          valuey_dropdown=para\min+(graphwidth-mx+offset)/graphwidth*(para\max-para\min)
        Else
          valuey_dropdown=para\min+(mx-offset)/graphwidth*(para\max-para\min)
        EndIf  
        If inversy
          valuex_dropdown=para\bound_up-(graphheight-my+offsetvert)/graphheight*(para\bound_up-para\bound_low) 
        Else
          valuex_dropdown=para\bound_up-(my-offsetvert)/graphheight*(para\bound_up-para\bound_low)                        
        EndIf  
      Else
        If inversx
          valuex_dropdown=para\bound_low+(graphwidth-mx+offset)/graphwidth*(para\bound_up-para\bound_low)
        Else  
          valuex_dropdown=para\bound_low+(mx-offset)/graphwidth*(para\bound_up-para\bound_low)
        EndIf
        If inversy
          valuey_dropdown=para\max-(graphheight-my+offsetvert)/graphheight*(para\max-para\min)
        Else  
          valuey_dropdown=para\max-(my-offsetvert)/graphheight*(para\max-para\min)
        EndIf  
      EndIf 
      If logy:valuey_dropdown=Pow(10,valuey_dropdown):EndIf
    EndIf
    inside=1
    If trans
      If inversy
        valuex=para\bound_up-(graphheight-my+offsetvert)/graphheight*(para\bound_up-para\bound_low)
      Else  
        valuex=para\bound_up-(my-offsetvert)/graphheight*(para\bound_up-para\bound_low)
      EndIf
      If inversx
        valuey=para\min+(graphwidth-mx+offset)/graphwidth*(para\max-para\min)
        valuey2=para\min2+(graphwidth-mx+offset)/graphwidth*(para\max2-para\min2) 
      Else  
        valuey=para\min+(mx-offset)/graphwidth*(para\max-para\min)
        valuey2=para\min2+(mx-offset)/graphwidth*(para\max2-para\min2)     
      EndIf
    Else  
      If inversx
        valuex=para\bound_low+(graphwidth-mx+offset)/graphwidth*(para\bound_up-para\bound_low)
      Else  
        valuex=para\bound_low+(mx-offset)/graphwidth*(para\bound_up-para\bound_low)
      EndIf
      If inversy
        valuey=para\max-(graphheight-my+offsetvert)/graphheight*(para\max-para\min)
        valuey2=para\max2-(graphheight-my+offsetvert)/graphheight*(para\max2-para\min2)       
      Else  
        valuey=para\max-(my-offsetvert)/graphheight*(para\max-para\min)
        valuey2=para\max2-(my-offsetvert)/graphheight*(para\max2-para\min2)
      EndIf  
    EndIf
    If logy:valuey=Pow(10,valuey):EndIf
    If logy2:valuey2=Pow(10,valuey2):EndIf
  Else
    DisableMenuItem(#Menu_popup_plot, #Menu_Add_comment, 1)
  EndIf 
  
  If intable And Not selected=-1
    mcol=Round((mx-offset)/100,#PB_Round_Down)-1
    mrow=Round((my-offsetvert-60-graphheight-rowheight)/rowheight,#PB_Round_Down)
    mfile=selected
    If Not mrow=-1:mrow+editorpos:EndIf
;     If Not mcol=-1
;       count=-1
;       j=-1
;       Repeat 
;         j+1
;         If imp(mfile)\draw(j):count+1:EndIf
;       Until count=mcol Or j=ArraySize(imp(selected)\set(),2)
;       mcol=j
;     EndIf  

    If event=#WM_LBUTTONDOWN      
      If KeyboardPushed(#PB_Key_LeftControl) And mcol>=0 And mcol<editorcolumns
        imp(selected)\tags(mrow,editorcols(mcol))!#Bitmark
      EndIf 
      If KeyboardPushed(#PB_Key_LeftShift) And selcol>=0 And selcol<editorcolumns And mcol>=0 And mcol<editorcolumns
        If imp(selected)\tags(selrow,editorcols(mcol))&#Bitmark:desel=1:EndIf
        If mcol>selcol
          
        If mrow>selrow
          For i=0 To mrow-selrow
            For j=0 To mcol-selcol
            If desel
              imp(selected)\tags(selrow+i,editorcols(selcol+j))&~#Bitmark
            Else
              imp(selected)\tags(selrow+i,editorcols(selcol+j))|#Bitmark
            EndIf
            Next j
          Next i  
        Else
          For i=0 To selrow-mrow
            For j=0 To mcol-selcol
            If desel
              imp(selected)\tags(mrow+i,editorcols(selcol+j))&~#Bitmark
            Else  
              imp(selected)\tags(mrow+i,editorcols(selcol+j))|#Bitmark
            EndIf  
            Next j
          Next i          
        EndIf
      Else
        
        
                If mrow>selrow
          For i=0 To mrow-selrow
            For j=0 To selcol-mcol
            If desel
              imp(selected)\tags(selrow+i,editorcols(mcol+j))&~#Bitmark
            Else
              imp(selected)\tags(selrow+i,editorcols(mcol+j))|#Bitmark
            EndIf
            Next j
          Next i  
        Else
          For i=0 To selrow-mrow
            For j=0 To selcol-mcol
            If desel
              imp(selected)\tags(mrow+i,editorcols(mcol+j))&~#Bitmark
            Else  
              imp(selected)\tags(mrow+i,editorcols(mcol+j))|#Bitmark
            EndIf  
            Next j
          Next i          
        EndIf
        
        
        
        EndIf
      EndIf  
      selcol=mcol
      selrow=mrow;Round((my-offsetvert-60-graphheight-rowheight)/rowheight,#PB_Round_Down)
      changed=1
    EndIf  
    If event=#WM_LBUTTONDBLCLK
      text.s   
      If (mrow=-1 And mcol>=0 And mcol<editorcolumns) Or mrow>=0
        OpenWindow(#Win_editentry,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Edit Value")
        If (mrow=-1 And mcol>=0 And mcol<editorcolumns)
          text=imp(selected)\header(editorcols(mcol))
        Else         
          If mcol=-1
            If is_time
              text=FormatDate(maskgeneric,imp(selected)\scale(mrow))
            Else
              text=StrD(imp(selected)\scale(mrow))
            EndIf  
          ElseIf mcol=editorcolumns
            text=imp(selected)\notes(mrow)
          Else 
            text=StrD(imp(selected)\set(mrow,editorcols(mcol)))
          EndIf
        EndIf
        StringGadget(#String_EditEntry,10,10,180,20,text)
        ButtonGadget(#Button_apply_entryedit,10,50,100,20,"Apply")
      EndIf
    EndIf
    If event=#WM_LBUTTONUP
      If ersterklick
        ersterklick=0:changed=1
      EndIf
      If ersterklickscroll
          ersterklickscroll=0:changed=1
        EndIf  
    EndIf
  Else
    If KeyboardPushed(#PB_Key_LeftControl)   
      If event=#WM_LBUTTONDOWN
        If trans
          selection_bar1=my
          selection_bar2=selection_bar1
          If inversy
            mouse\bound_low=(my-offsetvert)/para\scalex+para\bound_low 
          Else  
            mouse\bound_low=(-my+graphheight+offsetvert)/para\scalex+para\bound_low 
          EndIf  
        Else  
          selection_bar1=mx
          selection_bar2=selection_bar1
          If inversx
            mouse\bound_low=(graphheight-mx+offset)/para\scalex+para\bound_low
          Else  
            mouse\bound_low=(mx-offset)/para\scalex+para\bound_low
          EndIf  
        EndIf  
        ersterklick=1
      EndIf
    ElseIf KeyboardPushed(#PB_Key_LeftShift)
      If event=#WM_LBUTTONDOWN
        
      EndIf  
    Else  
      If event=#WM_LBUTTONDOWN
        If mx>editorbar\boxx And mx<editorbar\boxx+editorbar\boxwidth And my>editorbar\boxy And my<editorbar\boxy+editorbar\boxheight
          If my>editorbar\boxy+editorbar\posy And my<editorbar\boxy+editorbar\posy+editorbar\height 
            baroffset=my-editorbar\boxy-editorbar\posy  ;baroffeset bei dezentralem anklicken des bars
          Else
            baroffset=0
          EndIf  
          editorpos=(my-baroffset-editorbar\boxy)*(ArraySize(imp(selected)\set(),1)-editorrows)/(editorbar\boxheight-editorbar\height)
          ersterklickscroll=1:changed=1
        Else  
          If trans
            selection_bar1=my
            selection_bar2=selection_bar1
            If inversy
              mouse\bound_low=(my-offsetvert)/para\scalex+para\bound_low 
            Else  
              mouse\bound_low=(-my+graphheight+offsetvert)/para\scalex+para\bound_low    
            EndIf  
          Else  
            selection_bar1=mx
            selection_bar2=selection_bar1
            If inversx
              mouse\bound_low=(graphwidth-mx+offset)/para\scalex+para\bound_low
            Else  
              mouse\bound_low=(mx-offset)/para\scalex+para\bound_low
            EndIf  
          EndIf
          ersterklick=1
        EndIf
      EndIf
    EndIf
    If KeyboardPushed(#PB_Key_LeftControl)
      If event=#WM_LBUTTONUP
        If trans
          If inversy
            mouse\bound_up=(my-offsetvert)/para\scalex+para\bound_low
          Else
            mouse\bound_up=(-my+graphheight+offsetvert)/para\scalex+para\bound_low
          EndIf  
        Else
          If inversx
            mouse\bound_up=(graphwidth-mx+offset)/para\scalex+para\bound_low
          Else  
            mouse\bound_up=(mx-offset)/para\scalex+para\bound_low
          EndIf  
        EndIf  
        ersterklick=0:changed=1:firstright=0
        selection_bar1=-1
        selection_bar2=-1
        If mouse\bound_low>mouse\bound_up
          Swap mouse\bound_low,mouse\bound_up
        EndIf
        If mouse\bound_low=mouse\bound_up
          mouse\bound_low=para\minx
          mouse\bound_up=para\maxx
        EndIf 
        para\bound_up=mouse\bound_up
        para\bound_low=mouse\bound_low
      EndIf
    ElseIf KeyboardPushed(#PB_Key_LeftShift)
      If event=#WM_LBUTTONUP
        ersterklick=0:changed=1:firstleft=0
        selection_bar1=-1
        selection_bar2=-1
        If trans
          If inversy
            px.i=my-offsetvert
          Else  
            px.i=-my+graphheight+offsetvert
          EndIf
          If inversx
            py.i=graphwidth-mx+offset
          Else  
            py.i=mx-offset
          EndIf  
        Else 
          If inversx
            px.i=graphwidth-mx+offset
          Else  
            px.i=mx-offset
          EndIf 
          If inversy
            py.i=my-offsetvert
          Else
            py.i=graphheight-(my-offsetvert)
          EndIf  
        EndIf  
        count=1
        found=0
        While Not found
          For k=0 To files ;now search for nearest match
            rows=ArraySize(imp(k)\set(),1)
            columns=ArraySize(imp(k)\set(),2)
            For j=0 To columns
              If imp(k)\draw(j)
                For i=0 To rows                  
                  If Sqr(Pow(px-imp(k)\drawscale(i),2)+Pow(py-imp(k)\drawset(i,j),2))<=count And Not invalid(k,i,j) And active(k,j)
                    found=1
                    If imp(k)\tags(i,j)&#Bitmark
                      imp(k)\tags(i,j)&~#Bitmark
                    Else
                      imp(k)\tags(i,j)|#Bitmark
                    EndIf                      
                  EndIf                   
                Next i
              EndIf
            Next j
          Next k
          count+1
          If count>Sqr(Pow(graphheight,2)+Pow(graphwidth,2)):Break(1):EndIf
        Wend
      EndIf      
    Else  
      ;left mouse button released
      If event=#WM_LBUTTONUP
        If ersterklickscroll
          ersterklickscroll=0:changed=1
        Else  
          If trans
            If inversy
              mouse\bound_up=(my-offsetvert)/para\scalex+para\bound_low
            Else  
              mouse\bound_up=(-my+graphheight+offsetvert)/para\scalex+para\bound_low
            EndIf  
          Else
            If inversx
              mouse\bound_up=(graphwidth-mx+offset)/para\scalex+para\bound_low
            Else  
              mouse\bound_up=(mx-offset)/para\scalex+para\bound_low
            EndIf  
          EndIf  
          ersterklick=0:changed=1:firstleft=0
          selection_bar1=-1
          selection_bar2=-1
          If mouse\bound_low>mouse\bound_up
            Swap mouse\bound_low,mouse\bound_up
          EndIf 
          For k=0 To files
            rows=ArraySize(imp(k)\set(),1)
            columns=ArraySize(imp(k)\set(),2)
            For i=0 To rows        
              If imp(k)\scale(i)>=mouse\bound_low And imp(k)\scale(i)<=mouse\bound_up
                For j=0 To columns
                  ;If active(k,j)
                  If imp(k)\draw(j) And Not invalid(k,i,j) And active(k,j);imp(k)\tags(i,j)&#Bitdel And Not IsNAN(imp(k)\set(i,j)) 
                    imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bitmark
                  Else  
                    imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bitmark
                  EndIf  
                  ;EndIf
                Next j
              Else
                If Not KeyboardPushed(#PB_Key_LeftAlt)
                ;If active(k,j)
                For j=0 To columns
                  imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bitmark
                Next j  
                EndIf
              EndIf
            Next i
          Next k
        EndIf
      EndIf
    EndIf
    ;mid mouse button
    If event=#WM_MBUTTONDOWN
      para\bound_low=para\minx
      para\bound_up=para\maxx
      changed=1
    EndIf
    
    ;move mouse while holding left button
    If event=#WM_MOUSEMOVE
      draw_range(inside,ersterklick)
      If ersterklick
      If trans
        selection_bar2=my
        If inversy
          mouse\bound_up=(my-offsetvert)/para\scalex+para\bound_low  
        Else  
          mouse\bound_up=(-my+graphheight+offsetvert)/para\scalex+para\bound_low       
        EndIf
      Else  
        selection_bar2=mx
        If inversx
          mouse\bound_up=(graphwidth-mx+offset)/para\scalex+para\bound_low 
        Else  
          mouse\bound_up=(mx-offset)/para\scalex+para\bound_low 
        EndIf  
      EndIf
      EndIf
    EndIf
    
  EndIf  
  
  If event=#WM_RBUTTONDOWN
    rersterklick=1
    DisplayPopupMenu(#Menu_popup_plot,WindowID(#Win_plot))
  EndIf 
  
  If event=#WM_MOUSEWHEEL
    mous.w=((EventwParam()>>16)&$FFFF)   
    editorpos-(mous/100)*wheelsteps
    changed=1
  EndIf 
  
  If event=#WM_MOUSEMOVE And ersterklickscroll
    editorpos=(my-baroffset-editorbar\boxy)*(ArraySize(imp(selected)\set(),1)-editorrows)/(editorbar\boxheight-editorbar\height)
    changed=1
  EndIf  
  
  If selected>=0
    If editorpos<0:editorpos=0:EndIf
    If editorpos+editorrows>ArraySize(imp(selected)\scale()):editorpos=ArraySize(imp(selected)\scale())-editorrows:EndIf
  EndIf  
  
EndProcedure   

Procedure delete_selected_entries()
  If imported>=0
    unsaved=1
    For i=0 To ArraySize(imp(selected)\draw())
      If imp(selected)\draw(i):ok=1:EndIf
    Next i  
    If ok
      If MessageRequester("Warning","Delete selected entries from current list?",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes
        temp.setxy
        count.l=-1
        column=ArraySize(imp(selected)\draw())
        rows=ArraySize(imp(selected)\scale())
        For i=0 To column
          If Not imp(selected)\draw(i):count+1:EndIf
        Next i
        If count>=0
          Dim temp\set.d(rows,count)
          Dim temp\drawset.l(rows,count)
          Dim temp\tags.l(rows,count)
          Dim temp\secondaxis.b(count)
          Dim temp\header.s(count)
          Dim temp\draw.b(count)
          count=-1
          For i=0 To column
            If Not imp(selected)\draw(i)
              count+1
              For j=0 To rows
                temp\set(j,count)=imp(selected)\set(j,i)
                temp\tags(j,count)=imp(selected)\tags(j,i)
              Next j
              temp\draw(count)=imp(selected)\draw(i)
              temp\secondaxis(count)=imp(selected)\secondaxis(i)
              temp\header(count)=imp(selected)\header(i)
            EndIf  
          Next i
          ReDim imp(selected)\set.d(rows,count)
          ReDim imp(selected)\drawset.l(rows,count)
          ReDim imp(selected)\tags.l(rows,count)
          ReDim imp(selected)\secondaxis.b(count)
          ReDim imp(selected)\header.s(count)
          ReDim imp(selected)\draw.b(count)
          CopyArray(temp\header(),imp(selected)\header())
          CopyArray(temp\set(),imp(selected)\set())
          CopyArray(temp\tags(),imp(selected)\tags())
          CopyArray(temp\draw(),imp(selected)\draw())
          CopyArray(temp\secondaxis(),imp(selected)\secondaxis())
        Else
          MessageRequester("Warning","Only one entry left"+#eol+"Remove entire list instead")
        EndIf
        set_list()
      EndIf
    Else
      MessageRequester("Information","Nothing selected")
    EndIf
  Else
    MessageRequester("Information","Import Data")
  EndIf
  
  
EndProcedure  

Procedure delete_list()
  
  If imported>=0
    If MessageRequester("Warning","Delete current list?",#PB_MessageRequester_YesNo)=#PB_MessageRequester_Yes
      unsaved=1
      If imported>0
        Dim temp.setxy(imported-1)
        count.l=-1
        For i=0 To imported
          If Not i=selected
            count+1
            CopyStructure(@imp(i),@temp(count),setxy)
          EndIf    
        Next i
        FreeArray(imp())
        imported-1
        selected-1
        If selected<0:selected+1:EndIf
        Dim imp.setxy(imported)
        For i=0 To imported
          CopyStructure(@temp(i),@imp(i),setxy)
        Next i 
        get_minx_maxx()
        changed=1
      Else
        Dim imp(0)\set.d(0,0)
        Dim imp(0)\drawset.l(0,0)
        Dim imp(0)\tags.l(0,0)
        Dim imp(0)\secondaxis.b(0)
        Dim imp(0)\draw.b(0)
        Dim imp(0)\header.s(0)
        Dim imp(0)\scale.d(0)
        Dim imp(0)\drawscale.l(0)
        Dim imp(0)\notes.s(0)
        ClearList(imp(0)\comments())
        ClearList(imp(0)\meta())
        imp(0)\description=""
        imported-1
        selected-1
      EndIf
      set_list()
    EndIf
  Else
    MessageRequester("Information","Nothing to delete")
  EndIf  
  
  
EndProcedure  

Procedure preview()
  If IsWindow(#Win_importpreview):CloseWindow(#Win_importpreview):EndIf
  
  OpenWindow(#Win_importpreview,WindowX(#Win_import)+380,WindowY(#Win_para),380,200,"Import Preview")
  ListIconGadget(#Gadget_Importpreview,10,10,360,180,"scale",40,#PB_ListIcon_GridLines)
    
  tempf.s
  spalte.i
  info.b=1
  trenn.s
  firstcolumn.i
  comma.s
  date.i
  time.i
  mask.s
  columns.i
  rows.i
  rowtext.s
  

  OpenFile(0,preview_filename)
          firstcolumn=firstdatacustom
          Select columnseparator
            Case 0
              trenn=Chr(9)
            Case 1
              trenn=","
            Case 2
              trenn=";"
            Case 3
              trenn=Chr(32)
          EndSelect   
          Select decimalseparator
            Case 0   
              comma="."
            Case 1
              comma=","
          EndSelect
;           If is_time_custom
            If datetimecustom
              date=datecolumncustom
              time=timecolumncustom
            Else  
              time=-1
              date=timecolumncustom
            EndIf  
;           Else
;             date=-1:time=-1
;           EndIf
          If datetimecustom
            mask=maskcustom+maskcustom2
          Else
            mask=maskcustom2
          EndIf            
          tempf=ReadString(0)
          columns=CountString(tempf,trenn)-firstcolumn+1
          If columns>10:columns=10:EndIf
          If columns>=0
            For i=0 To columns
              If usefilename
                AddGadgetColumn(#Gadget_Importpreview,i+2,GetFilePart(tempf),40)
                ;imp(imported)\header(i)=imp(imported)\description   
              Else
                AddGadgetColumn(#Gadget_Importpreview,i+2,StringField(tempf,i+firstcolumn,trenn),40)
                ;imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
              EndIf  
            Next i
          EndIf
          FileSeek(0,0)
          rows=-1
          tempf=ReadString(0):If Not usefilename:tempf=ReadString(0):EndIf  
          While tempf
            rows+1
            If Not is_time_custom
              If StringField(tempf,date,trenn)="":rows-1:EndIf
            Else  
              If time=-1
                If ParseDate(mask,StringField(tempf,date,trenn))=-1:rows-1:EndIf
              Else        
                If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1:rows-1:EndIf
              EndIf
            EndIf
            tempf=ReadString(0)
          Wend
          FileSeek(0,0):If Not usefilename:tempf=ReadString(0):EndIf
          For i=1 To skiprows:ReadString(0):Next i
          If columns>=0 And rows>=0
        ;size the arrays
        
        
        ;loop over data and write arrays
        j=-1
        bad_entry.b
        Repeat
          bad_entry=0
          j+1
          rowtext=""
          tempf=ReadString(0)
          If Not is_time_custom; time=-1 And date=-1
            If StringField(tempf,date,trenn)=""
              j-1:bad_entry=1
            Else  
              rowtext+StringField(tempf,date,trenn)
              ;imp(imported)\scale(j)=ValD(StringField(tempf,date,trenn))
            EndIf  
          Else  
            If time=-1
              If ParseDate(mask,StringField(tempf,date,trenn))=-1
                j-1:bad_entry=1
              Else  
                rowtext+ParseDate(mask,StringField(tempf,date,trenn))
                ;imp(imported)\scale(j)=ParseDate(mask,StringField(tempf,date,trenn))
              EndIf  
            Else
              If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1
                j-1:bad_entry=1
              Else
                rowtext+ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))
                ;imp(imported)\scale(j)=ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))
              EndIf  
            EndIf
          EndIf
          If Not bad_entry
            For i=0 To columns            
              If StringField(tempf,i+firstcolumn,trenn)="---" Or StringField(tempf,i+firstcolumn,trenn)="[10]" Or (ValD(StringField(tempf,i+firstcolumn,trenn))=0 And Not Mid(StringField(tempf,i+firstcolumn,trenn),1,1)="0")
                rowtext+Chr(10)
                ;imp(imported)\set(j,i)=NaN():imp(imported)\tags(j,i)&#Bitdel
              Else  
                rowtext+Chr(10)+StringField(ReplaceString(tempf,comma,"."),i+firstcolumn,trenn)
                ;imp(imported)\set(j,i)=ValD(StringField(ReplaceString(tempf,comma,"."),i+firstcolumn,trenn))
              EndIf  
            Next i  
          EndIf
          AddGadgetItem(#Gadget_Importpreview,-1,rowtext)
        Until tempf="" Or j>10
        
        ;     While Not (StringField(tempf,1,Chr(9))="1. Ableitung DBK" Or Eof(0))
        ;       rows+1
        ;       imp(imported)\scale(rows)=ValD(StringField(tempf,1,Chr(9)))
        ;       For i=0 To columns
        ;         imp(imported)\set(rows,i)=ValD(StringField(tempf,i+2,Chr(9)))
        ;       Next i  
        ;       tempf=ReadString(0)
        ;     Wend
      EndIf
          
          CloseFile(0)
    
EndProcedure  

Procedure import_data()
  
  tempf.s
  spalte.i
  info.b=1
  trenn.s
  firstcolumn.i
  comma.s
  date.i
  time.i
  mask.s
  columns.i
  rows.i
  
  ;open File call
  tempf=OpenFileRequester("Select Sample File",directory+"*.*","Alle Dateien (*.*)|*.*",0,#PB_Requester_MultiSelection)
  If tempf
    directory=GetPathPart(tempf)
  Else
    ;CloseWindow(#Win_import)
    ProcedureReturn 0
  EndIf  
  
  Dim files.s(0)  
  n_files=-1
  Repeat  
    n_files+1
    ReDim files.s(n_files)
    files(n_files)=tempf
    tempf=NextSelectedFileName()    
  Until tempf=""
  
  If ReadFile(0,files(0))
    filefound=1
  ElseIf files(0)
    MessageRequester("Error","Could not open file") 
  EndIf   
  CloseFile(0)
  
  If filefound
    info=0
    For l=0 To n_files
      ReadFile(0,files(l)) 
      imported+1
      selected=imported
      ReDim imp.setxy(imported)
      ;imp(imported)\description=Str(imported+1)+". "+"Mess-Stelle: "+LTrim(StringField(GetFilePart(files(l),#PB_FileSystem_NoExtension),1," "),"0");Str(imported+1)+". "+GetFilePart(files(l),#PB_FileSystem_NoExtension)
      ;counting the rows and columns
      Select filetype
        Case 1
          imp(imported)\description="Mess-Stelle: "+LTrim(StringField(GetFilePart(files(l),#PB_FileSystem_NoExtension),1," "),"0")          
          firstcolumn=3
          trenn=";"
          comma=","
          date=1
          time=2
          mask="%dd.%mm.%yyyy%hh:%ii:%ss"
          rows=-1
          tempf=ReadString(0)
          While tempf
            rows+1
            If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1:rows-1:EndIf
            tempf=ReadString(0)
          Wend  
          FileSeek(0,0)
          tempf=ReadString(0)
          columns=CountString(tempf,trenn)-firstcolumn+1
          If columns>=0
            Dim imp(imported)\header.s(columns)
            For i=0 To columns
              imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
            Next i    
          EndIf
          FileSeek(0,0):tempf=ReadString(0)
        Case 2
          imp(imported)\description="Mess-Stelle: "+LTrim(StringField(GetFilePart(files(l),#PB_FileSystem_NoExtension),1,"_"),"0")
          rows=-1  
          For i=0 To 14:tempf=ReadString(0):AddElement(imp(selected)\meta()):imp(selected)\meta()=tempf:Next i
          tempf=ReadString(0):tempf=ReadString(0)
          trenn=";"
          columns=CountString(tempf,trenn)-3
          firstcolumn=3
          If columns>=0
            Dim imp(imported)\header.s(columns)
            For i=0 To columns
              imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
            Next i
          EndIf 
          ;           FileSeek(0,0)
          ;           For i=0 To 16:tempf=ReadString(0):Next i          
          comma=","
          date=2
          time=-1          
          mask="%dd.%mm.%yy %hh:%ii:%ss"
          tempf=ReadString(0)
          While tempf
            rows+1
            If ParseDate(mask,StringField(tempf,date,trenn))=-1:rows-1:EndIf
            tempf=ReadString(0)
          Wend
          FileSeek(0,0):For i=0 To 16:tempf=ReadString(0):Next i 
        Case 3  ;generic
          imp(imported)\description=GetFilePart(files(l),#PB_FileSystem_NoExtension)             
          firstcolumn=2
          trenn=Chr(9)
          comma="."
          date=1
          time=-1
          mask="%dd.%mm.%yyyy%hh:%ii:%ss"          
          tempf=ReadString(0)
          columns=CountString(tempf,trenn)-firstcolumn+1
          If columns>=0
            Dim imp(imported)\header.s(columns)
            For i=0 To columns
              If usefilename  ;CHECK THIS
                imp(imported)\header(i)=imp(imported)\description
              Else  
                imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
              EndIf  
            Next i
          EndIf
          FileSeek(0,0)
          rows=-1
          tempf=ReadString(0)
          If Not usefilename:tempf=ReadString(0):EndIf
          ; If ValD(StringField(tempf,date,trenn))=0 And Not StringField(tempf,date,trenn)="0":tempf=ReadString(0):EndIf
          While tempf
            rows+1
            If StringField(tempf,date,trenn)="":rows-1:EndIf
            tempf=ReadString(0)
          Wend  
          FileSeek(0,0):If Not usefilename:tempf=ReadString(0):EndIf
        Case 4 ;generic date
          imp(imported)\description=GetFilePart(files(l),#PB_FileSystem_NoExtension)    
          firstcolumn=3
          trenn=Chr(9)
          comma="."
          date=1
          time=2
          mask="%dd.%mm.%yyyy%hh:%ii:%ss"          
          tempf=ReadString(0)
          columns=CountString(tempf,trenn)-firstcolumn+1
          If columns>=0
            Dim imp(imported)\header.s(columns)
            For i=0 To columns
              If usefilename
                imp(imported)\header(i)=imp(imported)\description
              Else  
                imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
              EndIf  
            Next i 
          EndIf
          FileSeek(0,0)
          rows=-1
          tempf=ReadString(0)
          If Not usefilename:tempf=ReadString(0):EndIf
          ;If ValD(StringField(tempf,date,trenn))=0 And Not StringField(tempf,date,trenn)="0":tempf=ReadString(0):EndIf
          While tempf
            rows+1
            If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1:rows-1:EndIf
            tempf=ReadString(0)
          Wend 
          FileSeek(0,0):If Not usefilename:tempf=ReadString(0):EndIf
        Case 5
          imp(imported)\description=GetFilePart(files(l),#PB_FileSystem_NoExtension)           
          firstcolumn=firstdatacustom
          Select columnseparator
            Case 0
              trenn=Chr(9)
            Case 1
              trenn=","
            Case 2
              trenn=";"
            Case 3
              trenn=Chr(32)
          EndSelect   
          Select decimalseparator
            Case 0   
              comma="."
            Case 1
              comma=","
          EndSelect
;           If is_time_custom
            If datetimecustom
              date=datecolumncustom
              time=timecolumncustom
            Else  
              time=-1
              date=timecolumncustom
            EndIf  
;           Else
;             date=-1:time=-1
;           EndIf
          If datetimecustom
            mask=maskcustom+maskcustom2
          Else
            mask=maskcustom2
          EndIf            
          tempf=ReadString(0)
          columns=CountString(tempf,trenn)-firstcolumn+1
          If columns>=0
            Dim imp(imported)\header.s(columns)
            For i=0 To columns
              If usefilename
                imp(imported)\header(i)=imp(imported)\description
              Else  
                imp(imported)\header(i)=StringField(tempf,i+firstcolumn,trenn)
              EndIf  
            Next i
          EndIf
          FileSeek(0,0)
          rows=-1
          tempf=ReadString(0):If Not usefilename:tempf=ReadString(0):EndIf  
          For i=1 To skiprows:ReadString(0):Next i
          While tempf
            rows+1
            If Not is_time_custom
              If StringField(tempf,date,trenn)="":rows-1:EndIf
            Else  
              If time=-1
                If ParseDate(mask,StringField(tempf,date,trenn))=-1:rows-1:EndIf
              Else        
                If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1:rows-1:EndIf
              EndIf
            EndIf
            tempf=ReadString(0)
          Wend
          FileSeek(0,0):If Not usefilename:tempf=ReadString(0):EndIf
          For i=1 To skiprows:ReadString(0):Next i
      EndSelect
      If columns>=0 And rows>=0
        ;size the arrays
        
        Dim imp(imported)\set.d(rows,columns)
        Dim imp(imported)\drawset.l(rows,columns)
        Dim imp(imported)\tags.l(rows,columns)
        Dim imp(imported)\scale.d(rows)
        Dim imp(imported)\drawscale.l(rows)
        Dim imp(imported)\secondaxis.b(columns)      
        Dim imp(imported)\draw.b(columns)
        Dim imp(imported)\notes.s(rows)
        
        ;loop over data and write arrays
        j=-1
        bad_entry.b
        Repeat
          bad_entry=0
          j+1
          tempf=ReadString(0)
          If Not is_time_custom; time=-1 And date=-1
            If StringField(tempf,date,trenn)=""
              j-1:bad_entry=1
            Else  
              imp(imported)\scale(j)=ValD(StringField(tempf,date,trenn))
            EndIf  
          Else  
            If time=-1
              If ParseDate(mask,StringField(tempf,date,trenn))=-1
                j-1:bad_entry=1
              Else  
                imp(imported)\scale(j)=ParseDate(mask,StringField(tempf,date,trenn))
              EndIf  
            Else
              If ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))=-1
                j-1:bad_entry=1
              Else  
                imp(imported)\scale(j)=ParseDate(mask,StringField(tempf,date,trenn)+StringField(tempf,time,trenn))
              EndIf  
            EndIf
          EndIf
          If Not bad_entry
            For i=0 To columns            
              If StringField(tempf,i+firstcolumn,trenn)="---" Or StringField(tempf,i+firstcolumn,trenn)="[10]" Or (ValD(StringField(ReplaceString(tempf,comma,"."),i+firstcolumn,trenn))=0 And Not Mid(StringField(tempf,i+firstcolumn,trenn),1,1)="0")
                imp(imported)\set(j,i)=NaN():imp(imported)\tags(j,i)&#Bitdel
              Else  
                imp(imported)\set(j,i)=ValD(StringField(ReplaceString(tempf,comma,"."),i+firstcolumn,trenn))
              EndIf  
            Next i  
          EndIf  
        Until tempf=""
        
        ;     While Not (StringField(tempf,1,Chr(9))="1. Ableitung DBK" Or Eof(0))
        ;       rows+1
        ;       imp(imported)\scale(rows)=ValD(StringField(tempf,1,Chr(9)))
        ;       For i=0 To columns
        ;         imp(imported)\set(rows,i)=ValD(StringField(tempf,i+2,Chr(9)))
        ;       Next i  
        ;       tempf=ReadString(0)
        ;     Wend
      EndIf
      CloseFile(0)
      
    Next l 
  EndIf
  
  If (Not info) And columns>=0 And rows>=0
    MessageRequester("Information","Data imported")
  Else
    MessageRequester("Information","no Data imported")
  EndIf
  
  
  ;reset scale
  get_minx_maxx()
  changed=1
  set_list()
  
EndProcedure  

Procedure consolidate()
  ;repair inconsistent unsteady x axis
  
  If imported>=0   ;stuff here?
    
    unsaved=1
    imported+1
    ReDim imp.setxy(imported)
    imp(imported)\description=imp(selected)\description+" consolidated"
    rows=ArraySize(imp(selected)\set(),1)
    columns=ArraySize(imp(selected)\set(),2)
    
    Dim merged.mergestruc(rows)   ;array for easy sorting
    For i=0 To rows
      Dim merged(i)\set.d(columns)
      Dim merged(i)\tags.l(columns)
    Next i
    For i=0 To rows  ;fill merged()
      merged(i)\x=imp(selected)\scale(i)
      merged(i)\note=imp(selected)\notes(i)
      For j=0 To columns
        merged(i)\set(j)=imp(selected)\set(i,j)
        merged(i)\tags(j)=imp(selected)\tags(i,j)        
      Next j
    Next i
    
    SortStructuredArray(merged(),#PB_Sort_Ascending,OffsetOf(mergestruc\x),TypeOf(mergestruc\x)) 
    count=0
    growingx.d=merged(0)\x
    For i=1 To rows
      If merged(i)\x>growingx:count+1:growingx=merged(i)\x:EndIf      
    Next i  
    Dim imp(imported)\set.d(count,columns)
    Dim imp(imported)\drawset.l(count,columns)
    Dim imp(imported)\tags.l(count,columns)
    Dim imp(imported)\scale.d(count)
    Dim imp(imported)\drawscale.l(count)
    Dim imp(imported)\secondaxis.b(columns)    
    Dim imp(imported)\draw.b(columns)
    Dim imp(imported)\header.s(columns)
    Dim imp(imported)\notes.s(count)
    ;copy values from temp array to new dataset
    For j=0 To columns
      imp(imported)\secondaxis(j)=imp(selected)\secondaxis(j)
      imp(imported)\draw(j)=imp(selected)\draw(j)
      imp(imported)\header(j)=imp(selected)\header(j)
    Next j   
    imp(imported)\showcomment=imp(selected)\showcomment
    CopyList(imp(selected)\comments(),imp(imported)\comments())
    count=-1
    k=-1
    Repeat
      k+1
      count+1
      growingx.d=merged(k)\x
      l=k
      found=0
      Repeat
        If l<rows:If merged(l+1)\x<=growingx:l+1:Else:found=1:EndIf:EndIf
      Until l=rows Or found 
      imp(imported)\scale(count)=merged(k)\x
      imp(imported)\notes(count)=merged(k)\note
      For j=0 To columns
        imp(imported)\set(count,j)=NaN()
        For i=k To l         
          If Not IsNAN(merged(i)\set(j))
            imp(imported)\set(count,j)=merged(i)\set(j)
            imp(imported)\tags(count,j)=merged(i)\tags(j)
            Break(1)
          EndIf
        Next i    
      Next j  
      k=l
    Until k=rows    
    selected=imported
    changed=1
    set_list()    
    MessageRequester("Information","done")
  Else
    MessageRequester("Information","Import data")
  EndIf
  
  
  ;   numbers.l=0
  ;   files.l=ArraySize(imp())
  ;   sfile.i=-1
  ;   scolumn.i=-1
  ;   Dim merged.d(1,0)
  ;   Dim tags.l(0)
  ;   text.s
  ;   newrows.i  
  ;   
  ;   While get_smallest(@sfile,@scolumn)  ;create new array 
  ;     found=1
  ;     newrows=ArraySize(imp(sfile)\scale())
  ;     oldrows=ArraySize(merged(),2)
  ;     ReDim merged.d(1,oldrows+newrows)  
  ;     ReDim tags.l(oldrows+newrows)
  ;     For i=0 To newrows
  ;       merged(0,oldrows+i)=imp(sfile)\scale(i)
  ;       merged(1,oldrows+i)=imp(sfile)\set(i,scolumn)
  ;       tags(oldrows+i)=imp(sfile)\tags(i,scolumn)
  ;     Next i
  ;     imp(sfile)\draw(scolumn)=0
  ;     text+imp(sfile)\header(scolumn)+"+"
  ;   Wend
  ;   
  ;   If found
  ;     imported+1
  ;     ReDim imp.setxy(imported)
  ;     imp(imported)\description="continued entry"
  ;     count=-1
  ;     nextscale=-Pow(10,30)
  ;     For i=0 To ArraySize(merged(),2)
  ;       If merged(0,i)>nextscale:nextscale=merged(0,i):count+1:EndIf
  ;     Next i
  ;     Dim imp(imported)\draw.b(0)
  ;     Dim imp(imported)\set.d(count,0)
  ;     Dim imp(imported)\tags.l(count,0)
  ;     Dim imp(imported)\secondaxis.b(0)
  ;     Dim imp(imported)\scale.d(count)
  ;     Dim imp(imported)\header.s(0) 
  ;     imp(imported)\header(0)=Mid(text,1,Len(text)-1)
  ;     count=-1
  ;     nextscale=-Pow(10,30)
  ;     For i=0 To ArraySize(merged(),2)
  ;       If merged(0,i)>nextscale:nextscale=merged(0,i)
  ;         count+1
  ;         imp(imported)\set(count,0)=merged(1,i)
  ;         imp(imported)\scale(count)=merged(0,i)
  ;         imp(imported)\tags(count,0)=tags(i)
  ;       EndIf
  ;       imp(imported)\draw(0)=1
  ;     Next i  
  ;   Else
  ;     MessageRequester("Information","Nothing to merge")
  ;   EndIf
  ;   set_list()
  ;   changed=1
  
EndProcedure  

Procedure get_translation()
  astart.l
  aende.l
  start.l
  ende.l
  slope.d
  absolute.d
  files=ArraySize(imp())
  For i=0 To files
    rows=ArraySize(imp(i)\set(),1)
    columns=ArraySize(imp(i)\set(),2)
    new=columns
    For j=0 To columns
      If imp(i)\draw(j)
        k=-1
        Repeat  ;get selection beginning/end
          k+1
          found=0
          If imp(i)\tags(k,j)&#Bitmark
            info=0:found=1:start=k:astart=k-1
            Repeat 
              k+1
            Until k=rows Or Not (imp(i)\tags(k,j)&#Bitmark Or invalid(i,k,j))
            aende=k  
            ende=k-1:k=rows
          EndIf  
        Until k=rows
        If Not found:start=0:ende=rows:EndIf
        ;try to find plausible parameters
        fertig=0                                ;andererstart/anderesende are next adjacent non-deleted entries used to match translation
        Repeat 
          If astart>0                   
            If invalid(i,astart,j);imp(i)\tags(astart,j)&#Bitdel Or IsNAN(imp(i)\set(astart,j))
              astart-1
            Else
              fertig=1
            EndIf
          Else
            fertig=1
          EndIf
        Until fertig
        fertig=0
        Repeat
          If ende>start
            
            If invalid(i,ende,j);imp(i)\tags(ende,j)&#Bitdel Or IsNAN(imp(i)\set(ende,j))
              ende-1
            Else
              fertig=1
            EndIf
          Else
            fertig=1
          EndIf
        Until fertig
        
        If astart=0 Or rows=aende  ;exception handling if selection is at boundary of data range
          slope=0                
          If astart=0 And aende=rows:absolute=0:ElseIf astart=0:absolute=imp(i)\set(aende,j)-imp(i)\set(ende,j):Else:absolute=imp(i)\set(astart,j)-imp(i)\set(start,j):EndIf
        Else                
          slope=((imp(i)\set(aende,j)-imp(i)\set(astart,j))/(imp(i)\scale(aende)-imp(i)\scale(astart)))
          absolute=imp(i)\set(astart,j)-imp(i)\set(start,j)+slope*(imp(i)\scale(start)-imp(i)\scale(astart))
          slope-((imp(i)\set(ende,j)-imp(i)\set(start,j))/(imp(i)\scale(ende)-imp(i)\scale(start)))
        EndIf
      EndIf 
      If found:Break(2):EndIf
    Next j  
  Next i  
  
  SetGadgetText(#String_slopetranslate,StrD(slope))     
  SetGadgetText(#String_absolutetranslate,StrD(absolute))      
  
EndProcedure  

Procedure translate()
  
  info.l=1
  astart.l
  aende.l
  start.l
  ende.l
  slope.d=ValD(GetGadgetText(#String_slopetranslate))
  absolute.d=ValD(GetGadgetText(#String_absolutetranslate))
  unsaved=1
  files=ArraySize(imp())
  For i=0 To files
    rows=ArraySize(imp(i)\set(),1)
    columns=ArraySize(imp(i)\set(),2)
    new=columns
    For j=0 To columns
      If imp(i)\draw(j)
        k=-1
        Repeat  ;get selection beginning/end
          k+1
          found=0
          If imp(i)\tags(k,j)&#Bitmark
            info=0:found=1:start=k:astart=k-1
            Repeat 
              k+1
            Until k=rows Or Not (imp(i)\tags(k,j)&#Bitmark Or invalid(i,k,j));(imp(i)\tags(k,j)&#Bitmark Or imp(i)\tags(k,j)&#Bitdel)
            aende=k  
            If k=rows:ende=k:Else:ende=k-1:EndIf:k=rows
          EndIf  
        Until k=rows
        If Not found:start=0:ende=rows:Break(1):EndIf
        imp(i)\draw(j)=0 
        new+1  
        ReDim imp(i)\set.d(rows,new)
        ReDim imp(i)\drawset.l(rows,new)
        ReDim imp(i)\tags.l(rows,new)
        ReDim imp(i)\header.s(new)
        ReDim imp(i)\draw.b(new)
        ReDim imp(i)\secondaxis.b(new)
        imp(i)\draw(new)=1
        imp(i)\header(new)=imp(i)\header(j)+" (Translated)"
        imp(i)\secondaxis(new)=imp(i)\secondaxis(j)
        For k=0 To rows
          If Not (k>=start And k<=ende)
            imp(i)\tags(k,new)=imp(i)\tags(k,j)
            imp(i)\set(k,new)=imp(i)\set(k,j)                
          Else
            imp(i)\set(k,new)=imp(i)\set(k,j)+(imp(i)\scale(k)-imp(i)\scale(start))*slope+absolute
            imp(i)\tags(k,new)=imp(i)\tags(k,j)|#Bittrans
            imp(i)\tags(k,j)=imp(i)\tags(k,j)&~#Bitmark
          EndIf
        Next k
        
      EndIf  
    Next j  
  Next i  
  
  If info:MessageRequester("Information","Nothing to translate"):Else:changed=1:set_list():EndIf
  
  
EndProcedure  

Procedure scale_data()
  unsaved=1
  max.d
  info.l=1
  normalize.d=ValD(GetGadgetText(#String_normalize))
  scale.d=ValD(GetGadgetText(#String_scale))
  files=ArraySize(imp())
  For i=0 To files     ;loop over all selected and apply normalization/scaling
    rows=ArraySize(imp(i)\set(),1)
    columns=ArraySize(imp(i)\set(),2)
    new=columns
    For j=0 To columns
      If imp(i)\draw(j)
        k=-1
        Repeat   ;find beginning/end of selection
          k+1
          found=0
          If imp(i)\tags(k,j)&#Bitmark
            info=0:found=1:start=k
            Repeat 
              k+1
            Until k=rows Or (Not imp(i)\tags(k,j)&#Bitmark And Not invalid(i,k,j))
            If k=rows:ende=k:Else:ende=k-1:EndIf
            k=rows
          EndIf  
        Until k=rows
        If found
          imp(i)\draw(j)=0 
          new+1  
          ReDim imp(i)\set.d(rows,new)
          ReDim imp(i)\drawset.l(rows,new)
          ReDim imp(i)\tags.l(rows,new)
          ReDim imp(i)\header.s(new)
          ReDim imp(i)\draw.b(new)
          ReDim imp(i)\secondaxis.b(new)
          imp(i)\draw(new)=1
          imp(i)\header(new)=imp(i)\header(j)+" (Scaled)"
          imp(i)\secondaxis(new)=imp(i)\secondaxis(j)
          If EventGadget()=#Button_apply_normalize   ;get normalization scalar
            max=-Pow(10,30)
            For k=start To ende
              If imp(i)\set(k,j)>max And Not invalid(i,k,j):max=imp(i)\set(k,j):EndIf
            Next k            
            scale=1/max
          EndIf 
          For k=0 To rows   ;apply scaling
            If Not (k>=start And k<=ende)
              imp(i)\tags(k,new)=imp(i)\tags(k,j)
              imp(i)\set(k,new)=imp(i)\set(k,j)                
            Else
              imp(i)\set(k,new)=scale*imp(i)\set(k,j)
              imp(i)\tags(k,new)=imp(i)\tags(k,j)|#Bitscale
              imp(i)\tags(k,j)=imp(i)\tags(k,j)&~#Bitmark
            EndIf
          Next k
        EndIf
      EndIf  
    Next j  
  Next i  
  
  If info:MessageRequester("Information","Nothing to scale (no selection)"):Else:changed=1:set_list():EndIf
  
  
EndProcedure  

Procedure merge_lists()
  
  unsaved=1
  files.l=ArraySize(imp())
  Dim mergetemp.i(2,0)
  count=-1
  For i=0 To files
    If GetGadgetItemState(#List_mergelist,i)
      count+1
      ReDim mergetemp.i(2,count)
      mergetemp(0,count)=i
      mergetemp(1,count)=ArraySize(imp(i)\set(),1)
      mergetemp(2,count)=ArraySize(imp(i)\set(),2)
    EndIf  
  Next i  
  ;   nr1.l=GetGadgetState(#combo_mergelist1)
  ;   nr2.l=GetGadgetState(#combo_mergelist2)
  
  If count>0
    imported+1
    ReDim imp.setxy(imported)
    For i=0 To count 
      If i<count
        imp(imported)\description+imp(mergetemp(0,i))\description+" and "
      Else
        imp(imported)\description+imp(mergetemp(0,i))\description+" merged"
      EndIf  
      newrow+mergetemp(1,i)
      newcol+mergetemp(2,i)
    Next i  
    newrow+count
    newcol+count
    Dim merged.mergestruc(newrow)
    For i=0 To newrow
      Dim merged(i)\set.d(newcol)
      Dim merged(i)\tags.l(newcol)
    Next i
    For i=0 To newrow
      For j=0 To newcol
        merged(i)\set(j)=NaN()
      Next j  
    Next i  
    i=-1
    For k=0 To count 
      For l=0 To mergetemp(1,k)  ;fill merged()
        i+1
        j=-1
        For m=0 To k-1
          j+mergetemp(2,m)+1
        Next m
        merged(i)\x=imp(mergetemp(0,k))\scale(l)
        merged(i)\note+imp(mergetemp(0,k))\notes(l)
        For m=0 To mergetemp(2,k)
          j+1
          merged(i)\set(j)=imp(mergetemp(0,k))\set(l,m)
          merged(i)\tags(j)=imp(mergetemp(0,k))\tags(l,m)
        Next m
      Next l
    Next k
    SortStructuredArray(merged(),#PB_Sort_Ascending,OffsetOf(mergestruc\x),TypeOf(mergestruc\x)) 
    count1=0
    growingx.d=merged(0)\x
    For i=1 To newrow
      If merged(i)\x>growingx:count1+1:growingx=merged(i)\x:EndIf      
    Next i  
    Dim imp(imported)\set.d(count1,newcol)
    Dim imp(imported)\drawset.l(count1,newcol)
    Dim imp(imported)\tags.l(count1,newcol)
    Dim imp(imported)\scale.d(count1)
    Dim imp(imported)\drawscale.l(count1)
    Dim imp(imported)\secondaxis.b(newcol)    
    Dim imp(imported)\draw.b(newcol)
    Dim imp(imported)\header.s(newcol)
    Dim imp(imported)\notes.s(count1)
    ;copy values from temp array to net dataset
    j=-1
    For k=0 To count
      If imp(mergetemp(0,k))\showcomment:imp(imported)\showcomment=1:EndIf
      NewList temp.com()
      CopyList(imp(mergetemp(0,k))\comments(),temp())
      MergeLists(temp(),imp(imported)\comments())      
      For l=0 To mergetemp(2,k)
        j+1
        imp(imported)\secondaxis(j)=imp(mergetemp(0,k))\secondaxis(l)
        imp(imported)\draw(j)=imp(mergetemp(0,k))\draw(l)
        imp(imported)\header(j)=imp(mergetemp(0,k))\header(l)
      Next l  
    Next k
    count=-1
    k=-1
    Repeat
      k+1
      count+1
      growingx.d=merged(k)\x
      l=k
      found=0
      Repeat
        If l<newrow:If merged(l+1)\x<=growingx:l+1:Else:found=1:EndIf:EndIf
      Until l=newrow Or found 
      imp(imported)\scale(count)=merged(k)\x
      imp(imported)\notes(count)=merged(k)\note
      For j=0 To newcol
        imp(imported)\set(count,j)=NaN()
        For i=k To l         
          If Not IsNAN(merged(i)\set(j)):imp(imported)\set(count,j)=merged(i)\set(j):imp(imported)\tags(count,j)=merged(i)\tags(j):Break(1):EndIf
        Next i    
      Next j  
      k=l
    Until k=newrow  
    MessageRequester("Information","done")
  Else  
    MessageRequester("Information","Invalid Selection")
  EndIf
  
  
EndProcedure  

Procedure scaled_addition()
  
  unsaved=1
  columns.l=ArraySize(imp(selected)\set(),2)
  nr1.l=GetGadgetState(#combo_addlist1)
  nr2.l=GetGadgetState(#combo_addlist2)
  operator.b=GetGadgetState(#Option_scaleaddition_add)+2*GetGadgetState(#Option_scaleaddition_sub)+3*GetGadgetState(#Option_scaleaddition_mul)+4*GetGadgetState(#Option_scaleaddition_div)
  factor1.d=ValD(GetGadgetText(#String_scaledadditiona))  
  factor2.d=ValD(GetGadgetText(#String_scaledadditionb)) 
  new=ArraySize(imp(selected)\set(),2)+1
  rows=ArraySize(imp(selected)\set(),1)
  ReDim imp(selected)\set.d(rows,new)
  ReDim imp(selected)\drawset.l(rows,new)
  ReDim imp(selected)\tags.l(rows,new)
  ReDim imp(selected)\header.s(new)
  ReDim imp(selected)\draw.b(new)
  ReDim imp(selected)\secondaxis.b(new)
  imp(selected)\draw(new)=1
  imp(selected)\header(new)=imp(selected)\header(nr1)+" and "+imp(selected)\header(nr2)
  For i=0 To rows
    If invalid(selected,i,nr1);IsNAN(imp(selected)\set(i,nr1)) Or imp(selected)\tags(i,nr1)&#Bitdel
      imp(selected)\set(i,new)=factor2*imp(selected)\set(i,nr2)
      imp(selected)\tags(i,new)=imp(selected)\tags(i,nr2)
    ElseIf invalid(selected,i,nr2);IsNAN(imp(selected)\set(i,nr2)) Or imp(selected)\tags(i,nr2)&#Bitdel 
      imp(selected)\set(i,new)=factor1*imp(selected)\set(i,nr1)
      imp(selected)\tags(i,new)=imp(selected)\tags(i,nr1)
    Else  
      Select operator
        Case 1
          imp(selected)\set(i,new)=factor1*imp(selected)\set(i,nr1)+factor2*imp(selected)\set(i,nr2)
        Case 2
          imp(selected)\set(i,new)=factor1*imp(selected)\set(i,nr1)-factor2*imp(selected)\set(i,nr2)
        Case 3
          imp(selected)\set(i,new)=factor1*imp(selected)\set(i,nr1)*factor2*imp(selected)\set(i,nr2)
        Case 4
          imp(selected)\set(i,new)=factor1*imp(selected)\set(i,nr1)/(factor2*imp(selected)\set(i,nr2))
      EndSelect    
      imp(selected)\tags(i,new)=imp(selected)\tags(i,nr1)|imp(selected)\tags(i,nr2)
    EndIf  
  Next i
  changed=1
  set_list()
  
EndProcedure  

Procedure ec_corr()
  
  unsaved=1
  nr1.l=GetGadgetState(#combo_lf)
  nr2.l=GetGadgetState(#combo_lftemp)
  If eccorrectiontype=2
    lfalpha.d=0.962144
    lfn.d=0.965078
    lfa.d=-0.198058
    lfb.d=-1.992186
    lfc.d=231.17628
    lfd.d=86.39123
  EndIf  
  temptype=GetGadgetState(#Option_lfcelsius)+2*GetGadgetState(#Option_lfkelvin)
  If temptype=2:tempoffset.d=273.15:EndIf
  found=0
  rows=ArraySize(imp(selected)\set(),1)
  For i=0 To rows
    If Not invalid(selected,i,nr1) And invalid(selected,i,nr2):found=1:EndIf
  Next i
  If Not found
    
    new=ArraySize(imp(selected)\set(),2)+1
    ReDim imp(selected)\set.d(rows,new)
    ReDim imp(selected)\drawset.l(rows,new)
    ReDim imp(selected)\tags.l(rows,new)
    ReDim imp(selected)\header.s(new)
    ReDim imp(selected)\draw.b(new)
    ReDim imp(selected)\secondaxis.b(new)
    imp(selected)\draw(new)=1
    imp(selected)\header(new)=imp(selected)\header(nr1)+" (EC Corrected)"
    Select eccorrectiontype
      Case 1
        For i=0 To rows
          If Not invalid(selected,i,nr1);(Not IsNAN(imp(selected)\set(i,nr1))) And (Not imp(selected)\tags(i,nr1)&#Bitdel)
            imp(selected)\set(i,new)=1/(1+lffactor*(imp(selected)\set(i,nr2)-25-tempoffset))*imp(selected)\set(i,nr1)
            imp(selected)\tags(i,new)=imp(selected)\tags(i,nr1)|#Biteccorr
          Else  
            imp(selected)\set(i,new)=NaN()
          EndIf  
        Next i
      Case 2
        For i=0 To rows
          If Not invalid(selected,i,nr1);(Not IsNAN(imp(selected)\set(i,nr1))) And (Not imp(selected)\tags(i,nr1)&#Bitdel)
            imp(selected)\set(i,new)=1.116*((1-lfalpha)+lfalpha*Pow(lfa+Exp(lfb+lfc/(imp(selected)\set(i,nr2)-tempoffset+lfd)),lfn))*imp(selected)\set(i,nr1)
            imp(selected)\tags(i,new)=imp(selected)\tags(i,nr1)|#Biteccorr
          Else  
            imp(selected)\set(i,new)=NaN()
          EndIf
        Next i
    EndSelect 
    changed=1
    set_list()
  Else
    MessageRequester("Warning","Temperature Data does not match EC data"+#eol+"Try to interpolate Temperature to get missing values"+#eol+"Aggregation of data might also help")
  EndIf  
  
EndProcedure  

Procedure add_constant()
  
  If imported>=0
    unsaved=1
    tempf.s=InputRequester("Input Request","Insert Constant","1")
    const.d=ValD(tempf)
    If const Or Mid(tempf,1,1)="0"
      
      rows=ArraySize(imp(selected)\set(),1)
      new=ArraySize(imp(selected)\set(),2)+1      
      
      ReDim imp(selected)\set.d(rows,new)
      ReDim imp(selected)\drawset.l(rows,new)
      ReDim imp(selected)\tags.l(rows,new)
      ReDim imp(selected)\header.s(new)
      ReDim imp(selected)\draw.b(new)
      ReDim imp(selected)\secondaxis.b(new)
      imp(selected)\draw(new)=1
      imp(selected)\header(new)="Constant"
      
      For k=0 To rows  
        imp(selected)\set(k,new)=const
        imp(selected)\tags(k,new)=#Bitconst
      Next k  
      
    EndIf
    changed=1
    set_list()
  Else
    MessageRequester("Information","Import Data")
  EndIf  
EndProcedure  

Procedure merge_entries()
  
  If imported>=0
    unsaved=1
    rows.l=ArraySize(imp(selected)\set(),1)
    columns.l=ArraySize(imp(selected)\set(),2)
    For i=0 To columns
      If imp(selected)\draw(i):found+1:EndIf
    Next i
    If found>1
      found=0
      For i=1 To rows
        If imp(selected)\scale(i)<=imp(selected)\scale(i-1):found=1:Break(1):EndIf
      Next i  
      If Not found
        Dim sorter.sorts(0)
        count=-1
        For i=0 To columns      
          If imp(selected)\draw(i)
            count+1
            ReDim sorter.sorts(count)
            sorter(count)\column=i
            For j=0 To rows
              If Not invalid(selected,j,i):sorter(count)\xvalue=imp(selected)\scale(j):sorter(count)\srow=j:Break(1):EndIf
            Next j  
          EndIf  
        Next i
        SortStructuredArray(sorter(),#PB_Sort_Ascending,OffsetOf(sorts\xvalue),TypeOf(sorts\xvalue))
        
        new=columns+1
        ReDim imp(selected)\set.d(rows,new)
        ReDim imp(selected)\drawset.l(rows,new)
        ReDim imp(selected)\tags.l(rows,new)
        ReDim imp(selected)\header.s(new)
        ReDim imp(selected)\draw.b(new)
        ReDim imp(selected)\secondaxis.b(new)
        imp(selected)\draw(new)=1
        For i=0 To count
          imp(selected)\header(new)+imp(selected)\header(sorter(i)\column)+" + "
        Next i
        imp(selected)\header(new)=Mid(imp(selected)\header(new),1,Len(imp(selected)\header(new))-3)+" (merged)"
        For i=0 To rows
          imp(selected)\set(i,new)=NaN()
        Next i  
        For i=0 To count
          For j=rows To 0 Step -1
            If Not invalid(selected,j,sorter(i)\column):sorter(i)\erow=j:Break(1):EndIf
          Next j
          
        Next i
        For i=0 To count
          For j=sorter(i)\srow To sorter(i)\erow
            imp(selected)\set(j,new)=imp(selected)\set(j,sorter(i)\column)
            imp(selected)\tags(j,new)=imp(selected)\tags(j,sorter(i)\column)
          Next j  
        Next i 
        changed=1
        set_list()
        
      Else
        MessageRequester("Warning","inconsistent x-axis found"+#eol+"Consolidate list first")
      EndIf 
    Else
      MessageRequester("Information","Select at least two entries")
    EndIf
  Else
    MessageRequester("Information","Import Data")
  EndIf
EndProcedure  

Procedure set_comment_list()
 If IsWindow(#Win_delcomment) 
  ClearGadgetItems(#List_delcomment)
            count=1          
          ForEach imp(selected)\comments()
            AddGadgetItem(#List_delcomment,-1,Str(count)+". "+imp(selected)\comments()\text)
            count+1  
          Next 
          SetGadgetState(#List_delcomment,0)
          EndIf
EndProcedure 

Procedure edit_meta()
  unsaved=1
  ClearList(imp(selected)\meta())
  For i=1 To CountGadgetItems(#Editor_meta)
    AddElement(imp(selected)\meta())
    imp(selected)\meta()=GetGadgetItemText(#editor_meta,i-1)
  Next   
  
EndProcedure  

Procedure export_list()
  
  tempf.s
  tempf=SaveFileRequester("Select File",directory+imp(selected)\description+"_export","Text (*.txt)|*.txt|Alle Dateien (*.*)|*.*",0)
  If tempf 
    directory=GetPathPart(tempf)
  EndIf
  If SelectedFilePattern()=0 And Not GetExtensionPart(tempf)="txt"
    tempf+".txt"    
  EndIf
  
  If check_overwrite(tempf)
    trenn.s=Chr(9)
    text.s="scale"+trenn
    If is_time:text+"Date"+trenn+"Time"+trenn+"Date+Time"+trenn:EndIf
    columns=ArraySize(imp(selected)\set(),2)
    rows=ArraySize(imp(selected)\set(),1)
    ForEach imp(selected)\meta()
      WriteStringN(0,imp(selected)\meta())
    Next
    For i=0 To columns
      If i<columns
        text+imp(selected)\header(i)+trenn;+"notes"+trenn
      Else
        text+imp(selected)\header(i)+trenn+"notes"
      EndIf
    Next i
    WriteStringN(0,text)
    For i=0 To rows
      text=StrD(imp(selected)\scale(i))+trenn
      If is_time:text+FormatDate("%dd.%mm.%yyyy",imp(selected)\scale(i))+trenn+FormatDate("%hh:%ii:%ss",imp(selected)\scale(i))+trenn+FormatDate("%dd.%mm.%yyyy %hh:%ii:%ss",imp(selected)\scale(i))+trenn:EndIf
      For j=0 To columns
        If j<columns
          If invalid(selected,i,j);IsNAN(imp(selected)\set(i,j)) Or imp(selected)\tags(i,j)&#Bitdel
            text+trenn
          Else  
            text+StrD(imp(selected)\set(i,j))+trenn
          EndIf 
          ;text+Mid(RSet(Bin(imp(selected)\tags(i,j)),32,"0"),1,16)+"B"+trenn
        Else
          If invalid(selected,i,j);IsNAN(imp(selected)\set(i,j)) Or imp(selected)\tags(i,j)&#Bitdel
            text+""+trenn+imp(selected)\notes(i)
          Else  
            text+StrD(imp(selected)\set(i,j))+trenn+imp(selected)\notes(i)
          EndIf  
          ;text+Mid(RSet(Bin(imp(selected)\tags(i,j)),32,"0"),1,16)+"B"
        EndIf  
      Next j
      WriteStringN(0,text)
    Next i
    CloseFile(0)
  EndIf  
  
EndProcedure  

Procedure load_data()
  
  tempf.s
  ;open File call
  tempf=OpenFileRequester("Select Sample File",directory+"*.gdf","GAEA Data File (*.gdf)|*.gdf",0)
  If tempf
    directory=GetPathPart(tempf)
  EndIf
  
  If ReadFile(0,tempf)
    filefound=1
  ElseIf tempf
    MessageRequester("Error","Could not open file") 
  EndIf   
  
  listsize.i
  rows.i
  columns.i
  newimported.i
  If filefound
    current_filename=tempf
    SetWindowTitle(#Win_Para,"GAEA | "+current_filename)
    CloseFile(0)
    If OpenPack(0,tempf)
      packerfound=1
      UncompressPackFile(0,tempf+"_tmp","GAEA Data")
      ClosePack(0)
      ReadFile(0,tempf+"_tmp")
    Else
      ReadFile(0,tempf)
    EndIf  
    newimported=ReadInteger(0)+1+imported
    selected=ReadInteger(0)+imported+1
    ;FreeArray(imp())
    ReDim imp.setxy(newimported)
    For i=imported+1 To newimported
      ;desclen=ReadInteger(0)-1    
      rows=ReadInteger(0)
      columns=ReadInteger(0)
      imp(i)\showcomment=ReadByte(0)
      Dim imp(i)\set.d(rows,columns)
      Dim imp(i)\drawset.l(rows,columns)
      Dim imp(i)\tags.l(rows,columns)
      Dim imp(i)\draw.b(columns)
      Dim imp(i)\secondaxis.b(columns)
      Dim imp(i)\scale.d(rows)
      Dim imp(i)\drawscale.l(rows)
      Dim imp(i)\header.s(columns)
      Dim imp(i)\notes.s(rows)
      ReadData(0,@imp(i)\set(),(columns+1)*(rows+1)*SizeOf(Double))
      ReadData(0,@imp(i)\tags(),(columns+1)*(rows+1)*SizeOf(Long))
      ReadData(0,@imp(i)\draw(),(columns+1)*SizeOf(Byte))
      ReadData(0,@imp(i)\secondaxis(),(columns+1)*SizeOf(Byte))
      ReadData(0,@imp(i)\scale(),(rows+1)*SizeOf(Double))
      imp(i)\description=ReadString(0)
      For j=0 To columns
        ; headlen=ReadInteger(0)-1
        imp(i)\header(j)=ReadString(0)
      Next
      For j=0 To rows
        imp(i)\notes(j)=ReadString(0)
      Next j  
      listsize=ReadInteger(0)
      For j=0 To listsize
        AddElement(imp(i)\comments())
        imp(i)\comments()\x=ReadInteger(0)
        imp(i)\comments()\y=ReadInteger(0)
        imp(i)\comments()\text=ReadString(0)
      Next j
      listsize=ReadInteger(0)
      For j=0 To listsize
        AddElement(imp(i)\meta())
        imp(i)\meta()=ReadString(0)
      Next j 
    Next i
    imported=newimported
    CloseFile(0)
    If packerfound
      DeleteFile(tempf+"_tmp")
    EndIf   
    MessageRequester("Information","Data loaded")
  EndIf
  
  changed=1
  set_list()
  get_minx_maxx()
  
EndProcedure  

Procedure auto_save()
  
  If selected=-1:ProcedureReturn 0:EndIf
  
  CreateFile(0,"C:\windows\temp\GAEA.tmp")
  WriteInteger(0,imported)
  WriteInteger(0,selected)
  For i=0 To imported
    ;desclen=StringByteLength(imp(i)\description)
    rows=ArraySize(imp(i)\set(),1)
    columns=ArraySize(imp(i)\set(),2)
    ;WriteInteger(0,desclen)    
    WriteInteger(0,rows)
    WriteInteger(0,columns)
    WriteByte(0,imp(i)\showcomment)
    WriteData(0,@imp(i)\set(),(columns+1)*(rows+1)*SizeOf(Double))
    WriteData(0,@imp(i)\tags(),(columns+1)*(rows+1)*SizeOf(Long))
    WriteData(0,@imp(i)\draw(),(columns+1)*SizeOf(Byte))
    WriteData(0,@imp(i)\secondaxis(),(columns+1)*SizeOf(Byte))
    WriteData(0,@imp(i)\scale(),(rows+1)*SizeOf(Double))
    WriteStringN(0,imp(i)\description)
    For j=0 To columns
      ;headlen=StringByteLength(imp(i)\header(j))
      ;headlen=Len(imp(i)\header(j))
      ;WriteInteger(0,headlen)
      WriteStringN(0,imp(i)\header(j))
    Next
    For j=0 To rows
      WriteStringN(0,imp(i)\notes(j))
    Next j  
    ;FirstElement(imp(i)\comments()) 
    WriteInteger(0,ListSize(imp(i)\comments())-1)
    ForEach imp(i)\comments()
      WriteInteger(0,imp(i)\comments()\x)
      WriteInteger(0,imp(i)\comments()\y)
      WriteStringN(0,imp(i)\comments()\text)
    Next
    WriteInteger(0,ListSize(imp(i)\meta())-1)
    ForEach imp(i)\meta()
      WriteStringN(0,imp(i)\meta())
    Next 
  Next i
  
  CloseFile(0)
  
EndProcedure  

Procedure save_data()
  
  If selected=-1:MessageRequester("Information","Nothing to save"):ProcedureReturn 0:EndIf
  tempf.s
  If current_filename=""
    tempf=SaveFileRequester("Select File",directory+"SaveFile","GAEA Data File (*.gdf)|*.gdf|Alle Dateien (*.*)|*.*",0)
  Else
    tempf=SaveFileRequester("Select File",current_filename,"GAEA Data File (*.gdf)|*.gdf|Alle Dateien (*.*)|*.*",0)
  EndIf  
  If tempf 
    directory=GetPathPart(tempf)
    current_filename=tempf
    SetWindowTitle(#Win_Para,"GAEA | "+current_filename)
  EndIf
  If SelectedFilePattern()=0 And Not GetExtensionPart(tempf)="gdf"
    tempf+".gdf"    
  EndIf
  
  rows.i
  columns.i
  listsize.i
  ;desclen.i
  ;headlen.i
  If check_overwrite(tempf)
    CloseFile(0)
    CreateFile(0,tempf)
    WriteInteger(0,imported)
    WriteInteger(0,selected)
    For i=0 To imported
      ;desclen=StringByteLength(imp(i)\description)
      rows=ArraySize(imp(i)\set(),1)
      columns=ArraySize(imp(i)\set(),2)
      ;WriteInteger(0,desclen)    
      WriteInteger(0,rows)
      WriteInteger(0,columns)
      WriteByte(0,imp(i)\showcomment)
      WriteData(0,@imp(i)\set(),(columns+1)*(rows+1)*SizeOf(Double))
      WriteData(0,@imp(i)\tags(),(columns+1)*(rows+1)*SizeOf(Long))
      WriteData(0,@imp(i)\draw(),(columns+1)*SizeOf(Byte))
      WriteData(0,@imp(i)\secondaxis(),(columns+1)*SizeOf(Byte))
      WriteData(0,@imp(i)\scale(),(rows+1)*SizeOf(Double))
      WriteStringN(0,imp(i)\description)
      For j=0 To columns
        ;headlen=StringByteLength(imp(i)\header(j))
        ;headlen=Len(imp(i)\header(j))
        ;WriteInteger(0,headlen)
        WriteStringN(0,imp(i)\header(j))
      Next
      For j=0 To rows
        WriteStringN(0,imp(i)\notes(j))
      Next j  
      ;FirstElement(imp(i)\comments()) 
      WriteInteger(0,ListSize(imp(i)\comments())-1)
      ForEach imp(i)\comments()
        WriteInteger(0,imp(i)\comments()\x)
        WriteInteger(0,imp(i)\comments()\y)
        WriteStringN(0,imp(i)\comments()\text)
      Next
      WriteInteger(0,ListSize(imp(i)\meta())-1)
      ForEach imp(i)\meta()
        WriteStringN(0,imp(i)\meta())
      Next 
    Next i
    
;     pack=CreatePack(#PB_Any, tempf)
;     AddPackFile(pack,tempf+"_tmp","GAEA Data")
;     CloseFile(0)
;     ClosePack(pack)
;     DeleteFile(tempf+"_tmp")
    MessageRequester("Information","Data saved")
    unsaved=0
  EndIf 
  
EndProcedure  

Procedure add_comment()
  
  If imported>=0
    unsaved=1
    imp(selected)\showcomment=1
    SetGadgetState(#Button_show_comment,1)
    AddElement(imp(selected)\comments()) 
    imp(selected)\comments()\text=InputRequester("New Comment", "Type Text for Comment", "")
    imp(selected)\comments()\x=valuex_dropdown
    imp(selected)\comments()\y=valuey_dropdown
    changed=1
  Else
    MessageRequester("Information","Import data")    
  EndIf
  rersterklick=0
  set_comment_list()
  
EndProcedure  

Procedure select_all()
  For i=0 To ArraySize(imp())
    For j=0 To ArraySize(imp(i)\draw())
      imp(i)\draw(j)=1
    Next j  
  Next i
  set_list()
  changed=1
EndProcedure

Procedure mark_all()
  For k=0 To ArraySize(imp())
    For j=0 To ArraySize(imp(k)\set(),2)           
      If imp(k)\draw(j)
        For i=0 To ArraySize(imp(k)\set(),1)
          imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bitmark
        Next i
      EndIf  
    Next j       
  Next k
  ;change_edit_list()
  changed=1
EndProcedure  

Procedure unselect_all()
  For i=0 To ArraySize(imp())
    For j=0 To ArraySize(imp(i)\draw())
      imp(i)\draw(j)=0
    Next j  
  Next i
  set_list()
  changed=1
EndProcedure  

Procedure del_comment()
  
  ;   If count>1
  For i=CountGadgetItems(#List_delcomment) To 1 Step -1
    If GetGadgetItemState(#List_delcomment,i)
      SelectElement(imp(selected)\comments(),i-1)
        DeleteElement(imp(selected)\comments(),1) 
    EndIf  
  Next i  
unsaved=1
;   Else
;     MessageRequester("Warning","No Comments there")
;   EndIf
  
  
  
  changed=1
EndProcedure  

Procedure eh_corr()
 unsaved=1 
  nr1.l=GetGadgetState(#combo_eh)
  nr2.l=GetGadgetState(#combo_ehtemp)
  ; factor.d=ValD(GetGadgetText(#String_lffactor))/100
  ;eccorrectiontype=GetGadgetState(#Option_lf1)+2*GetGadgetState(#Option_lf2)
  ;       If eccorrectiontype=2
  ;         lfalpha.d=0.962144
  ;         lfn.d=0.965078
  ;         lfa.d=-0.198058
  ;         lfb.d=-1.992186
  ;         lfc.d=231.17628
  ;         lfd.d=86.39123
  ;       EndIf  
  temptype_eh=GetGadgetState(#Option_ehcelsius)+2*GetGadgetState(#Option_ehkelvin)
  If temptype_eh=2:tempoffset.d=273.15:EndIf
  found=0
  rows=ArraySize(imp(selected)\set(),1)
  For i=0 To rows
    If Not invalid(selected,i,nr1) And invalid(selected,i,nr2):found=1:EndIf
  Next i
  If Not found
    
    new=ArraySize(imp(selected)\set(),2)+1
    ReDim imp(selected)\set.d(rows,new)
    ReDim imp(selected)\drawset.l(rows,new)
    ReDim imp(selected)\tags.l(rows,new)
    ReDim imp(selected)\header.s(new)
    ReDim imp(selected)\draw.b(new)
    ReDim imp(selected)\secondaxis.b(new)
    imp(selected)\draw(new)=1
    imp(selected)\header(new)=imp(selected)\header(nr1)+" (Eh Corrected)"
    ;Select eccorrectiontype
    ; Case 1
    For i=0 To rows
      If Not invalid(selected,i,nr1)
        imp(selected)\set(i,new)=imp(selected)\set(i,nr1)-0.198*(imp(selected)\set(i,nr2)-25-tempoffset)+Sqr(50230.214-294.67714*(imp(selected)\set(i,nr2)-tempoffset))
        imp(selected)\tags(i,new)=imp(selected)\tags(i,nr1)|#Bitehcorr 
      Else  
        imp(selected)\set(i,new)=NaN()
      EndIf  
    Next i
    ;           Case 2
    ;             For i=0 To rows
    ;               If (Not IsNAN(imp(selected)\set(i,nr1))) And (Not imp(selected)\tags(i,nr1)&#Bitdel)
    ;                 imp(selected)\set(i,new)=1.116*((1-lfalpha)+lfalpha*Pow(lfa+Exp(lfb+lfc/(imp(selected)\set(i,nr2)-tempoffset+lfd)),lfn))*imp(selected)\set(i,nr1)
    ;               Else  
    ;                 imp(selected)\set(i,new)=NaN()
    ;               EndIf
    ;             Next i
    ;         EndSelect 
    changed=1
    set_list()
  Else
    MessageRequester("Warning","Temperature Data does not match Eh data"+#eol+"Try to interpolate Temperature to get missing values")
  EndIf  
  
  
  
EndProcedure  

Procedure.d aggregate_operation(Array inputarray.d(1),mode.l)
  
  length.i=ArraySize(inputarray())
  result.d
  temp.d
  Select mode
    Case 0
      count=0
      For i=0 To length
        If Not IsNAN(inputarray(i))
          temp+inputarray(i)
          count+1
        EndIf  
      Next i
      result=temp/count
    Case 1 
      SortArray(inputarray(),#PB_Sort_Ascending)
      If Not length%2
        result=inputarray(length/2)
      Else
        upper.i=Round(length/2,#PB_Round_Up)
        lower.i=Round(length/2,#PB_Round_Down)
        result=0.5*(inputarray(upper)+inputarray(lower))
      EndIf  
    Case 2
      temp=Pow(10,30)
      For i=0 To length
        If inputarray(i)<temp:temp=inputarray(i):EndIf
      Next i  
      result=temp
    Case 3
      temp=-Pow(10,30)
      For i=0 To length
        If inputarray(i)>temp:temp=inputarray(i):EndIf
      Next i
      result=temp
    Case 4
      temp=0
      For i=0 To length
        temp+inputarray(i)
      Next i  
      result=temp
  EndSelect
  ProcedureReturn result
  
EndProcedure  

Procedure.i getdate(dateinput.i)
  result.i
  Select intervaltype_aggregation
    Case 0
      result=Second(dateinput)
    Case 1
      result=Minute(dateinput)
    Case 2
      result=Hour(dateinput)
    Case 3
      result=Day(dateinput)
    Case 4 
      result=Month(dateinput)
    Case 5
      result=Year(dateinput)
  EndSelect   
  ProcedureReturn result
EndProcedure  

Procedure aggregation()
  
  count.i
  found=0
  oldrow=ArraySize(imp(selected)\set(),1)
  For i=1 To oldrow
    If imp(selected)\scale(i)<=imp(selected)\scale(i-1):found=1:Break(1):EndIf
  Next i  
  If Not found
    unsaved=1
    slope.d
    imported+1
    ReDim imp.setxy(imported)  
    columns=ArraySize(imp(selected)\set(),2)
    rows=ArraySize(imp(selected)\scale())
    If is_time
      ;interval_start.d=Round(imp(selected)\scale(0)/interval_aggregation,#PB_Round_Up)*interval_aggregation
      tempdate=getdate(imp(selected)\scale(0))
      newrow=0;Round(imp(selected)\scale(oldrow)/interval_aggregation,#PB_Round_Down)-Round(imp(selected)\scale(0)/interval_aggregation,#PB_Round_Up)
      Dim newscale.d(0)
      temptime.i=imp(selected)\scale(0)
      Repeat
        temptime-1
      Until Not tempdate=getdate(temptime)
      temptime+1
      newscale(0)=temptime
      ;tempdate=getdate(imp(selected)\scale(0))
      ;temptime=imp(selected)\scale(0)
      count=0
      Repeat
        If is_time:temptime+60:Else:temptime+1:EndIf ;;HIER IS KRITISCH; 
        If Not tempdate=getdate(temptime)
          count+1
          tempdate=getdate(temptime)
        EndIf 
        If count=interval_aggregation
          If temptime>=imp(selected)\scale(rows):finish_it=1:EndIf
          count=0
          newrow+1
          ReDim newscale.d(newrow)
          newscale(newrow)=temptime
        EndIf  
      Until finish_it 
    Else
      interval_start.d=Round(imp(selected)\scale(0)/interval_aggregation,#PB_Round_Up)*interval_aggregation
      newrow=Round(imp(selected)\scale(oldrow)/interval_aggregation,#PB_Round_Down)-Round(imp(selected)\scale(0)/interval_aggregation,#PB_Round_Up)
      Dim newscale.d(newrow)
      For i=0 To newrow
        newscale(i)=interval_start+i*interval_aggregation
      Next i  
    EndIf
    ;     newrow+1
    ; ;     temptime=imp(selected)\scale(rows)
    ; ;     tempdate=getdate(temptime)
    ;     ReDim newscale.d(newrow)
    ;     count=0
    ;     Repeat 
    ;       temptime+1
    ;       If Not tempdate=getdate(temptime)
    ;         count+1
    ;         tempdate=getdate(temptime)
    ;       EndIf      
    ;     Until count=interval_aggregation
    ;     newscale(newrow)=temptime
    If newrow>oldrow:MessageRequester("Warning","Aggregation Interval too small"+#eol+"Aggregation to this would increase number of points"):imported-1:ProcedureReturn 0:EndIf
    Dim imp(imported)\set.d(newrow,columns)
    Dim imp(imported)\drawset.l(newrow,columns)
    Dim imp(imported)\tags.l(newrow,columns)
    Dim imp(imported)\scale.d(newrow)
    CopyArray(newscale(),imp(imported)\scale())
    FreeArray(newscale())
    Dim imp(imported)\drawscale.l(newrow)
    Dim imp(imported)\secondaxis.b(columns)    
    Dim imp(imported)\draw.b(columns)
    Dim imp(imported)\header.s(columns)
    Dim imp(imported)\notes.s(newrow)
    CopyArray(imp(selected)\secondaxis(),imp(imported)\secondaxis())
    CopyArray(imp(selected)\draw(),imp(imported)\draw())
    For i=0 To columns
      imp(selected)\draw(i)=0
      imp(imported)\header(i)=imp(selected)\header(i)+" (aggregated)"
    Next i
    If option_aggregation=1
      imp(imported)\description=imp(selected)\description+" aggregated (linear)"
    Else  
      Select operationtype_aggregation
        Case 0
          imp(imported)\description=imp(selected)\description+" aggregated (mean)"
        Case 1
          imp(imported)\description=imp(selected)\description+" aggregated (median)"
        Case 2
          imp(imported)\description=imp(selected)\description+" aggregated (min)"
        Case 3
          imp(imported)\description=imp(selected)\description+" aggregated (max)"
        Case 4
          imp(imported)\description=imp(selected)\description+" aggregated (sum)"
      EndSelect
    EndIf
    If option_aggregation=1
      For i=0 To newrow
        For j=0 To columns
          k=-1
          Repeat
            k+1
          Until (imp(selected)\scale(k)>=imp(imported)\scale(i) And Not invalid(selected,k,j)) Or k=oldrow
          ende=k          
          While (imp(selected)\scale(k)>imp(imported)\scale(i) Or invalid(selected,k,j)) And start>0
            k-1
          Wend
          start=k
          If start=ende
            imp(imported)\set(i,j)=imp(selected)\set(start,j)
          Else
            slope=(imp(selected)\set(ende,j)-imp(selected)\set(start,j))/(imp(selected)\scale(ende)-imp(selected)\scale(start))
            imp(imported)\set(i,j)=(imp(imported)\scale(i)-imp(selected)\scale(start))*slope+imp(selected)\set(start,j)
          EndIf          
          imp(imported)\tags(i,j)=imp(imported)\tags(i,j)|#Bitaggr
        Next j        
      Next i  
    Else   
      startd.d
      ended.d
      endindex=-1
      For i=0 To newrow
        Select aggregate_direction
          Case 1
            If i>0
              startd=imp(imported)\scale(i-1)
              ended=imp(imported)\scale(i)
            Else
              startd=NaN()
              ended=NaN()
            EndIf 
          Case 2
            If i>0 And i<newrow
              startd=0.5*imp(imported)\scale(i-1)+0.5*imp(imported)\scale(i)
              ended=0.5*imp(imported)\scale(i)+0.5*imp(imported)\scale(i+1)
            Else
              If i>0
                startd=0.5*imp(imported)\scale(newrow-1)+0.5*imp(imported)\scale(newrow)
                ended=imp(imported)\scale(newrow)
              Else
                startd=imp(imported)\scale(0)
                ended=0.5*imp(imported)\scale(0)+0.5*imp(imported)\scale(1)
              EndIf  
            EndIf  
          Case 3 
            If i<newrow
              startd=imp(imported)\scale(i)
              ended=imp(imported)\scale(i+1)
            Else
              startd=NaN()
              ended=NaN()
            EndIf  
        EndSelect
        startindex=endindex+1
          Repeat
            endindex+1
            If endindex>rows:Break(1):EndIf
          Until imp(selected)\scale(endindex)>ended
          endindex-1
        For j=0 To columns
          anzahl=-1
          Dim temp.d(0)

          For l=startindex To endindex
           ; If imp(selected)\scale(l)>=start And imp(selected)\scale(l)<=ende
              If Not invalid(selected,l,j)
                anzahl+1
                ReDim temp(anzahl)
                temp(anzahl)=imp(selected)\set(l,j)
              EndIf  
            ;EndIf  
          Next l  
          Debug anzahl
          If anzahl>=0
            imp(imported)\set(i,j)=aggregate_operation(temp(),operationtype_aggregation)          
          Else
            imp(imported)\set(i,j)=NaN()
          EndIf
          imp(imported)\tags(i,j)=imp(imported)\tags(i,j)|#Bitaggr
          FreeArray(temp())      
        Next j        
      Next i 
    EndIf 
    changed=1
    selected=imported
    If para\totalminx>imp(imported)\scale(0):para\totalminx=imp(imported)\scale(0):para\minx=para\totalminx:EndIf
    If para\totalmaxx<imp(imported)\scale(newrow):para\totalmaxx=imp(imported)\scale(newrow):para\maxx=para\totalmaxx:EndIf
    set_scale()
    set_list()
    MessageRequester("Information","done")
  Else
    MessageRequester("Information","inconsistent x-axis found"+#eol+"Consolidate list first")
  EndIf
  
EndProcedure  

Procedure duplicate()
  
  If selected>=0   ;stuff here?
    unsaved=1
    imported+1
    ReDim imp.setxy(imported)
    
    rows=ArraySize(imp(selected)\set(),1)
    columns=ArraySize(imp(selected)\set(),2)
    
    Dim imp(imported)\set.d(rows,columns)
    Dim imp(imported)\drawset.l(rows,columns)
    Dim imp(imported)\tags.l(rows,columns)
    Dim imp(imported)\scale.d(rows)
    Dim imp(imported)\drawscale.l(rows)
    Dim imp(imported)\secondaxis.b(columns)    
    Dim imp(imported)\draw.b(columns)
    Dim imp(imported)\header.s(columns)
    Dim imp(imported)\notes.s(rows)
    
    CopyStructure(@imp(selected),@imp(imported),setxy)
    imp(imported)\description=imp(selected)\description+" duplicated"
    ;copy values from temp array to new dataset
    
    selected=imported
    changed=1
    set_list()    
    MessageRequester("Information","done")
  Else
    MessageRequester("Information","Nothing selected")
  EndIf
  
EndProcedure  

Procedure duplicate_entries()
  
  unsaved=1
  rows=ArraySize(imp(selected)\set(),1)
  columns=ArraySize(imp(selected)\set(),2)
  For i=0 To columns
    If imp(selected)\draw(i)     
      new=ArraySize(imp(selected)\set(),2)+1       
      ReDim imp(selected)\set.d(rows,new)
      ReDim imp(selected)\drawset.l(rows,new)
      ReDim imp(selected)\tags.l(rows,new)
      ReDim imp(selected)\header.s(new)
      ReDim imp(selected)\draw.b(new)
      ReDim imp(selected)\secondaxis.b(new)
      For j=0 To rows
        imp(selected)\set(j,new)=imp(selected)\set(j,i)
        imp(selected)\tags(j,new)=imp(selected)\tags(j,i)
      Next j  
      imp(selected)\draw(new)=1
      imp(selected)\header(new)=imp(selected)\header(i)
    EndIf  
  Next i  
  set_list()
  changed=1
EndProcedure

Procedure.b choose(a.d,b.d,mode.i,tol.d)
  Select mode
    Case 0
      If a+#num_tolerance+tol>b And a-#num_tolerance-tol<b:ProcedureReturn 1:EndIf
    Case 1
      If a<b:ProcedureReturn 1:EndIf
    Case 2
      If a<=b:ProcedureReturn 1:EndIf
    Case 3
      If a>b:ProcedureReturn 1:EndIf
    Case 4
      If a>=b:ProcedureReturn 1:EndIf
  EndSelect
  ProcedureReturn 0
EndProcedure  

Procedure save()
  
  If selected=-1:MessageRequester("Information","Nothing to save"):ProcedureReturn 0:EndIf
  If Not current_filename=""  
    CreateFile(0,current_filename)
    WriteInteger(0,imported)
    WriteInteger(0,selected)
    For i=0 To imported
      ;desclen=StringByteLength(imp(i)\description)
      rows=ArraySize(imp(i)\set(),1)
      columns=ArraySize(imp(i)\set(),2)
      ;WriteInteger(0,desclen)    
      WriteInteger(0,rows)
      WriteInteger(0,columns)
      WriteByte(0,imp(i)\showcomment)
      WriteData(0,@imp(i)\set(),(columns+1)*(rows+1)*SizeOf(Double))
      WriteData(0,@imp(i)\tags(),(columns+1)*(rows+1)*SizeOf(Long))
      WriteData(0,@imp(i)\draw(),(columns+1)*SizeOf(Byte))
      WriteData(0,@imp(i)\secondaxis(),(columns+1)*SizeOf(Byte))
      WriteData(0,@imp(i)\scale(),(rows+1)*SizeOf(Double))
      WriteStringN(0,imp(i)\description)
      For j=0 To columns
        ;headlen=StringByteLength(imp(i)\header(j))
        ;headlen=Len(imp(i)\header(j))
        ;WriteInteger(0,headlen)
        WriteStringN(0,imp(i)\header(j))
      Next
      For j=0 To rows
        WriteStringN(0,imp(i)\notes(j))
      Next j  
      ;FirstElement(imp(i)\comments()) 
      WriteInteger(0,ListSize(imp(i)\comments())-1)
      ForEach imp(i)\comments()
        WriteInteger(0,imp(i)\comments()\x)
        WriteInteger(0,imp(i)\comments()\y)
        WriteStringN(0,imp(i)\comments()\text)
      Next
      WriteInteger(0,ListSize(imp(i)\meta())-1)
      ForEach imp(i)\meta()
        WriteStringN(0,imp(i)\meta())
      Next 
    Next i
    
;     pack=CreatePack(#PB_Any,current_filename)
;     AddPackFile(pack,current_filename+"_tmp","GAEA Data")
    CloseFile(0)
;     ClosePack(pack)
;     DeleteFile(current_filename+"_tmp")
    MessageRequester("Information","Data saved")
    unsaved=0
  Else  
    save_data()
  EndIf
  
EndProcedure  

Procedure delete_empty_entries()
  
    If selected>=0   ;stuff here?
    unsaved=1
    imported+1
    ReDim imp.setxy(imported)
    
    columns=0
    rows=ArraySize(imp(selected)\set(),1)
    Dim imp(imported)\scale.d(rows)
    Dim imp(imported)\drawscale.l(rows)
    Dim imp(imported)\notes.s(rows)
    ;columns=ArraySize(imp(selected)\set(),2)
    
    Dim imp(imported)\set.d(rows,columns)
    Dim imp(imported)\drawset.l(rows,columns)
    Dim imp(imported)\tags.l(rows,columns)
    
    Dim imp(imported)\secondaxis.b(columns)    
    Dim imp(imported)\draw.b(columns)
    Dim imp(imported)\header.s(columns)
    
    columns=-1
    For i=0 To ArraySize(imp(selected)\set(),2)
      found=0      
      For j=0 To rows
        If Not IsNAN(imp(selected)\set(j,i)):found=1:Break(1):EndIf
      Next j
      If found
        columns+1
        ReDim imp(imported)\set.d(rows,columns)
        ReDim imp(imported)\drawset.l(rows,columns)
        ReDim imp(imported)\tags.l(rows,columns)
        ReDim imp(imported)\secondaxis.b(columns)    
        ReDim imp(imported)\draw.b(columns)
        ReDim imp(imported)\header.s(columns)
        imp(imported)\header(columns)=imp(selected)\header(i)
        imp(imported)\draw(columns)=imp(selected)\draw(i)
        imp(imported)\secondaxis(columns)=imp(selected)\secondaxis(i)
        For j=0 To rows
          imp(imported)\set(j,columns)=imp(selected)\set(j,i)
          imp(imported)\drawset(j,columns)=imp(selected)\drawset(j,i)
          imp(imported)\tags(j,columns)=imp(selected)\tags(j,i)          
        Next j  
      EndIf      
    Next i  
    
    
    imp(imported)\description=imp(selected)\description+" emptied"
    ;copy values from temp array to new dataset
    
    selected=imported
    changed=1
    set_list()    
    MessageRequester("Information","done")
  Else
    MessageRequester("Information","Nothing selected")
  EndIf
  
  
EndProcedure  

Procedure crop_list()
  
  If selected>=0   ;stuff here?
    
    columns=ArraySize(imp(selected)\set(),2)
    rows=-1 
    
    Dim selectedrows.i(0)
    For i=0 To ArraySize(imp(selected)\set(),1)
      For j=0 To columns
        If imp(selected)\tags(i,j)&#Bitmark
          rows+1
          ReDim selectedrows.i(rows)
          selectedrows(rows)=i  
          Break(1)
        EndIf
      Next j  
    Next i  
    CallDebugger
    If rows>=0
    unsaved=1
    imported+1
    ReDim imp.setxy(imported)
    
    Dim imp(imported)\scale.d(rows)
    Dim imp(imported)\drawscale.l(rows)
    Dim imp(imported)\notes.s(rows)
    ;columns=ArraySize(imp(selected)\set(),2)
    
    Dim imp(imported)\set.d(rows,columns)
    Dim imp(imported)\drawset.l(rows,columns)
    Dim imp(imported)\tags.l(rows,columns)
    
    Dim imp(imported)\secondaxis.b(columns)    
    Dim imp(imported)\draw.b(columns)
    Dim imp(imported)\header.s(columns)    
    
    For i=0 To columns
      imp(imported)\header(i)=imp(selected)\header(i)  
    Next i  
    
    For i=0 To rows
      imp(imported)\notes(i)=imp(selected)\notes(selectedrows(i))
      imp(imported)\scale(i)=imp(selected)\scale(selectedrows(i))
      For j=0 To columns
        imp(imported)\set(i,j)=imp(selected)\set(selectedrows(i),j)
        imp(imported)\tags(i,j)=imp(selected)\tags(selectedrows(i),j)
      Next j
    Next i  
    
    imp(imported)\description=imp(selected)\description+" cropped"
    ;copy values from temp array to new dataset
    
    selected=imported
    changed=1
    set_scale()
    set_list()        
    MessageRequester("Information","done")
  Else
    MessageRequester("Information","Nothing selected")
  EndIf
Else
  MessageRequester("Information","No data")
  EndIf
EndProcedure  

Procedure select_from_menu()
  
  tempf.s
  tempbild.l
  
  Select EventMenu()
    Case #Menu_Open  
      load_data()
    Case #Menu_Save
      save()
    Case #Menu_Save_as
      save_data()
    Case #Menu_Import
      If Not IsWindow(#Win_import)
        OpenWindow(#Win_import,WindowX(#Win_para)+100,WindowY(#Win_para)+100,380,220,"Import")
        OptionGadget(#Option_File1,10,10,100,20,"Druckdaten")
        OptionGadget(#Option_File2,10,30,100,20,"SDC Daten")
        OptionGadget(#Option_filegeneric,10,50,100,20,"Generic")
        OptionGadget(#Option_filegenericdate,10,70,150,20,"Generic (Date/Time)")
        OptionGadget(#Option_FileCustom,10,90,150,20,"Custom")        
        SetGadgetState(#Option_File1+filetype-1,1)
        ButtonGadget(#Button_set_preview_file,10,115,100,20,"Set Preview File")
        ButtonGadget(#Button_import_preview,10,135,100,20,"Preview")
        ButtonGadget(#Button_apply_import,10,160,100,20,"Import data")
        CheckBoxGadget(#Checkbox_is_time_custom,160,10,100,20,"Is Time"):SetGadgetState(#Checkbox_is_time_custom,is_time_custom)
        CheckBoxGadget(#Checkbox_date_time,270,10,100,20,"Date/Time"):SetGadgetState(#Checkbox_date_time,datetimecustom)
        TextGadget(#Text_TimeColumn,160,50,100,20,"Time Column")
        SpinGadget(#Spin_TimeColumn,270,50,50,20,1,9999,#PB_Spin_Numeric):SetGadgetState(#Spin_TimeColumn,timecolumncustom)
        TextGadget(#Text_DateColumn,160,30,100,20,"Date Column")
        SpinGadget(#Spin_DateColumn,270,30,50,20,1,9999,#PB_Spin_Numeric):SetGadgetState(#Spin_DateColumn,datecolumncustom)
        TextGadget(#Text_FirstDataColumn,160,70,100,20,"First Data Column")
        SpinGadget(#Spin_FirstDataColumn,270,70,50,20,1,9999,#PB_Spin_Numeric):SetGadgetState(#Spin_FirstDataColumn,firstdatacustom)
        TextGadget(#Text_skiprows,160,90,100,20,"Skip Rows")
        SpinGadget(#Spin_Skiprows,270,90,50,20,0,9999,#PB_Spin_Numeric):SetGadgetState(#Spin_Skiprows,skiprows)
        TextGadget(#Text_ColumnSeparator,160,110,100,20,"Column Separator")
        ComboBoxGadget(#Combo_ColumnSeparator,270,110,100,20)
        AddGadgetItem(#Combo_ColumnSeparator,-1,"Tab")
        AddGadgetItem(#Combo_ColumnSeparator,-1,"Comma")
        AddGadgetItem(#Combo_ColumnSeparator,-1,"Semicolon")
        AddGadgetItem(#Combo_ColumnSeparator,-1,"Space")
        SetGadgetState(#Combo_ColumnSeparator,columnseparator)
        TextGadget(#Text_DecimalSeparator,160,130,100,20,"Decimal Separator")
        ComboBoxGadget(#Combo_DecimalSeparator,270,130,100,20)
        AddGadgetItem(#Combo_DecimalSeparator,-1,"Point")
        AddGadgetItem(#Combo_DecimalSeparator,-1,"Comma")
        SetGadgetState(#Combo_DecimalSeparator,decimalseparator)
        TextGadget(#Text_MaskCustom,160,150,100,20,"Mask Date")
        StringGadget(#String_MaskCustom,270,150,100,20,maskcustom)
        TextGadget(#Text_MaskCustom2,160,170,100,20,"Mask Time")
        StringGadget(#String_MaskCustom2,270,170,100,20,maskcustom2)
        CheckBoxGadget(#Checkbox_usefilename,160,190,150,20,"Use filename as header"):SetGadgetState(#Checkbox_usefilename,usefilename)
      Else
        SetActiveWindow(#Win_import)
      EndIf
    Case #Menu_Export
      export_list()
    Case #Menu_Quit
      shut_down()
    Case #Menu_Select_all
      select_all()
    Case #Menu_Deselect_all
      unselect_all()
    Case #Menu_Mark_all
      mark_all()
    Case #Menu_Undelete
      undelete()
    Case #Menu_Search_selection
      lowest=Pow(10,15)      
      For j=0 To ArraySize(imp(selected)\set(),2)
        If imp(selected)\draw(j)
          For i=0 To ArraySize(imp(selected)\set(),1)
            If imp(selected)\tags(i,j)&#Bitmark And i<lowest:found=1:lowest=i:EndIf  
          Next i  
        EndIf
      Next j
      If Not found
        MessageRequester("Information","No Selection in current list")
      Else  
        editorpos=lowest
        If editorpos+editorrows>ArraySize(imp(selected)\scale()):editorpos=ArraySize(imp(selected)\scale())-editorrows:EndIf
      EndIf
      changed=1
    Case #Menu_Edit_metadata     
      If imported>=0 
        If Not IsWindow(#Win_editmeta)
          OpenWindow(#Win_editmeta,WindowX(#Win_para)+100,WindowY(#Win_para)+100,400,300,"Meta Data")
          EditorGadget(#Editor_meta,10,10,380,260)
          ForEach imp(selected)\meta()
            AddGadgetItem(#Editor_meta,-1,imp(selected)\meta())
          Next   
          ButtonGadget(#Button_apply_meta,10,275,80,20,"OK")
        Else  
          SetActiveWindow(#Win_editmeta)
        EndIf
      Else
        MessageRequester("Information","Import Data")
      EndIf      
    Case #Menu_Delete_entry
      delete_selected_entries()
    Case #Menu_Delete_list
      delete_list()
    Case #Menu_Delete_empty_entries
      delete_empty_entries()
    Case #Menu_Delete_comments     
      If selected>=0
        If Not IsWindow(#Win_delcomment)
          OpenWindow(#Win_delcomment,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Select Comment")
          ButtonGadget(#Button_apply_delcomment,10,170,70,20,"Delete") 
          ButtonGadget(#Button_comment_select,10,150,70,20,"(De)Select all")    
          ListViewGadget(#List_delcomment,10,10,150,140,#PB_ListView_ClickSelect)
          set_comment_list()
        Else
          SetActiveWindow(#Win_delcomment)        
        EndIf
      Else
        MessageRequester("Information","Nothing to delete")
      EndIf      
    Case #Menu_Filter
      If Not IsWindow(#Win_filter)
        OpenWindow(#Win_filter,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Filter")
        ButtonGadget(#Button_apply_filter,10,90,70,20,"Apply Filter")
        TextGadget(#Text_Filter,10,13,70,20,"Filtertype")        
        ComboBoxGadget(#Combo_Filter,85,10,80,20)
        AddGadgetItem(#Combo_Filter,-1,"Median")
        AddGadgetItem(#Combo_Filter,-1,"Mean")
        AddGadgetItem(#Combo_Filter,-1,"Sobel")
        AddGadgetItem(#Combo_Filter,-1,"LaPlace")
        AddGadgetItem(#Combo_Filter,-1,"Savitzky-Golay")
        AddGadgetItem(#Combo_Filter,-1,"Gauß")
        SetGadgetState(#Combo_Filter,filtertype)
        TextGadget(#Text_Filterwidth,10,33,70,20,"Filter Width")
        SpinGadget(#Spin_Filterwidth,85,30,80,20,3,9999,#PB_Spin_Numeric|#PB_Spin_ReadOnly)
        SetGadgetState(#Spin_Filterwidth,filterbreite)
        CheckBoxGadget(#Checkbox_Filterselection,85,90,80,20,"only selected")
        TextGadget(#Text_Filteroption,10,63,70,20,"")
        StringGadget(#String_Filtersigma,85,60,80,20,StrD(filtersigma))
        SpinGadget(#Spin_Filterdegree,85,60,80,20,2,5,#PB_Spin_Numeric|#PB_Spin_ReadOnly)
        SetGadgetState(#Spin_Filterdegree,filterdegree)
      Else  
        SetActiveWindow(#Win_filter)
      EndIf
    Case #Menu_Interpolate
      If Not IsWindow(#Win_interpolate)
        OpenWindow(#Win_interpolate,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Interpolation")        
        ButtonGadget(#Button_apply_interpolate,10,160,80,20,"OK")        
        OptionGadget(#Option_linearinter,10,50,180,20,"linear interpolation")
        OptionGadget(#Option_nearestneighbor,10,70,180,20,"nearest neighbor")        
        SetGadgetState(#Option_linearinter+optioninterpol-1,1)
      Else  
        SetActiveWindow(#Win_interpolate)
      EndIf
    Case #Menu_Translate
      If Not IsWindow(#Win_translate)
        OpenWindow(#Win_translate,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Translation")
        TextGadget(#Text_Infotranslate,10,10,180,40,"Translation according to y(new)=y(old)+m*Delta_x+n")
        TextGadget(#Text_slopetranslate,10,50,80,20,"m")
        StringGadget(#String_slopetranslate,100,50,80,20,"0")
        TextGadget(#Text_absolutetranslate,10,70,80,20,"n")
        StringGadget(#String_absolutetranslate,100,70,80,20,"1")
        ButtonGadget(#Button_Gettranslation,10,130,180,20,"Guess m and n")  
        ButtonGadget(#Button_Apply_translation,10,90,80,20,"Apply")
      Else
        SetActiveWindow(#Win_translate)
      EndIf
    Case #Menu_Graph_math
      If imported>=0
        columns=ArraySize(imp(selected)\set(),2)
        If columns>0   ;are two entries here?
          If Not IsWindow(#Win_scaleaddition)
            OpenWindow(#Win_scaleaddition,WindowX(#Win_para)+100,WindowY(#Win_para)+100,250,220,"Graph Math")
            OptionGadget(#Option_scaleaddition_add,10,100,40,20,"add")
            OptionGadget(#Option_scaleaddition_sub,50,100,40,20,"sub")
            OptionGadget(#Option_scaleaddition_mul,90,100,40,20,"mul")
            OptionGadget(#Option_scaleaddition_div,130,100,40,20,"div")
            SetGadgetState(#Option_scaleaddition_add,1)
            TextGadget(#Text_scaleaddition_info,10,120,230,20,"(factor 1)*(graph 1)[operator](factor 2)*(graph 2)")
            ButtonGadget(#Button_apply_scale_addition,10,190,180,20,"OK")
            TextGadget(#Text_scaledadditiona,10,143,100,20,"factor 1")
            TextGadget(#Text_scaledadditionb,10,163,100,20,"factor 2")
            StringGadget(#String_scaledadditiona,120,140,70,20,"1")
            StringGadget(#String_scaledadditionb,120,160,70,20,"1")
            TextGadget(#Text_scaleaddition_graph1,10,13,180,17,"graph 1")
            ComboBoxGadget(#combo_addlist1,10,30,180,20)
            For i=0 To columns
              AddGadgetItem(#combo_addlist1,-1,imp(selected)\header(i))
            Next i 
            SetGadgetState(#combo_addlist1,0)
            TextGadget(#Text_scaleaddition_graph2,10,53,180,17,"graph 2")
            ComboBoxGadget(#combo_addlist2,10,70,180,20)
            For i=0 To columns
              AddGadgetItem(#combo_addlist2,-1,imp(selected)\header(i))
            Next i
            SetGadgetState(#combo_addlist2,1)
          Else
            SetActiveWindow(#Win_scaleaddition)
          EndIf  
        Else
          MessageRequester("Information","Not enough Data available in current list")
        EndIf
      Else
        MessageRequester("Information","Import Data")
      EndIf
    Case #Menu_Add_constant
      add_constant()
    Case #Menu_Scaling
      If Not IsWindow(#Win_scale)
        OpenWindow(#Win_scale,WindowX(#Win_para)+100,WindowY(#Win_para)+100,200,200,"Scaling")        
        ButtonGadget(#Button_apply_scale,10,50,80,20,"Scale by...")
        StringGadget(#String_scale,100,50,80,20,"1")
        ButtonGadget(#Button_apply_normalize,10,70,80,20,"Normalize to...")
        StringGadget(#String_normalize,100,70,80,20,"1")
      Else
        SetActiveWindow(#Win_scale)
      EndIf
    Case #Menu_Merge_entries
      merge_entries()
    Case #Menu_Merge_lists
      files=ArraySize(imp())
      If files>0   ;are two lists here?
        If Not IsWindow(#Win_mergelists)
          OpenWindow(#Win_mergelists,WindowX(#Win_para)+100,WindowY(#Win_para)+100,400,400,"Merge Lists")  
          ButtonGadget(#Button_mergelist_select,10,340,180,20,"(De)Select all")
          ButtonGadget(#button_apply_merge_lists,10,360,180,20,"OK")          
          ListViewGadget(#List_mergelist,10,10,380,320,#PB_ListView_ClickSelect)
          For i=0 To files
            AddGadgetItem(#List_mergelist,-1,imp(i)\description)
          Next i 
        Else  
          SetActiveWindow(#Win_mergelists)
        EndIf
      Else
        MessageRequester("Information","Nothing to merge")
      EndIf      
    Case #Menu_Consolidate_lists
      consolidate()
    Case #Menu_EC_correction     
      If imported>=0
        If Not IsWindow(#Win_lfcorrection)
          columns=ArraySize(imp(selected)\header())
          OpenWindow(#Win_lfcorrection,WindowX(#Win_para)+100,WindowY(#Win_para)+100,370,200,"EC Correction")          
          ButtonGadget(#Button_apply_lf_correction,10,160,80,20,"OK")
          TextGadget(#Text_lfdata,10,13,80,20,"Data Column")
          ComboBoxGadget(#combo_lf,100,10,180,20)          
          For i=0 To columns
            AddGadgetItem(#combo_lf,-1,imp(selected)\header(i))
          Next i 
          SetGadgetState(#combo_lf,0)
          TextGadget(#Text_lftemp,10,33,80,20,"Temp. Column")
          ComboBoxGadget(#combo_lftemp,100,30,180,20)
          For i=0 To columns
            AddGadgetItem(#combo_lftemp,-1,imp(selected)\header(i))
          Next i
          TextGadget(#Text_lfinfo,150,53,100,20,"EC/(1+k*(T-Tref))")
          TextGadget(#Text_lfinfo2,150,73,210,20,"1.116*EC*((1-a)+a*(A+EXP(B+C/(T+D)))^n)")   
          SetGadgetState(#combo_lftemp,1)          
          OptionGadget(#Option_lf1,10,50,120,20,"linear correction")
          OptionGadget(#Option_lf2,10,70,120,20,"nonlinear correction")
          TextGadget(#text_lffactor,10,133,100,20,"Correction factor [%]")
          StringGadget(#String_lffactor,120,130,70,20,StrD(lffactor))
          OptionGadget(#Option_lfcelsius,10,90,180,20,"Celsius")
          OptionGadget(#Option_lfkelvin,10,110,180,20,"Kelvin")
          SetGadgetState(#Option_lf1+eccorrectiontype-1,1)
          SetGadgetState(#Option_lfcelsius+temptype-1,1)
        Else
          SetActiveWindow(#Win_lfcorrection)
        EndIf  
      Else
        MessageRequester("Information","Import data")
      EndIf      
    Case #Menu_Eh_correction    
      If imported>=0
        If Not IsWindow(#Win_ehcorr)
          columns=ArraySize(imp(selected)\header())
          OpenWindow(#Win_ehcorr,WindowX(#Win_para)+100,WindowY(#Win_para)+100,350,200,"Eh Correction")          
          ButtonGadget(#Button_apply_eh_correction,10,160,80,20,"OK")
          TextGadget(#Text_ehdata,10,13,80,20,"Data Column")
          ComboBoxGadget(#combo_eh,100,10,180,20)          
          For i=0 To columns
            AddGadgetItem(#combo_eh,-1,imp(selected)\header(i))
          Next i 
          SetGadgetState(#combo_eh,0)
          TextGadget(#Text_ehtemp,10,33,80,20,"Temp. Column")
          ComboBoxGadget(#combo_ehtemp,100,30,180,20)
          For i=0 To columns
            AddGadgetItem(#combo_ehtemp,-1,imp(selected)\header(i))
          Next i
          SetGadgetState(#combo_ehtemp+eccorrectiontype-1,1)
          TextGadget(#Text_ehinfo,10,53,250,20,"Eh-0.198*(T-Tref)+Sqrt(50230.214-294.67714*T)")
          OptionGadget(#Option_ehcelsius,10,90,180,20,"Celsius")
          OptionGadget(#Option_ehkelvin,10,110,180,20,"Kelvin")
          SetGadgetState(#Option_ehcelsius+temptype_eh-1,1)
        Else
          SetActiveWindow(#Win_ehcorr)
        EndIf  
      Else
        MessageRequester("Information","Import data")
      EndIf
    Case #Menu_Add_comment
      add_comment()
    Case #Menu_Copy_to_Clipboard
      tempbild=CreateImage(#PB_Any,scrwidth,scrheight,32)
      draw_plot(tempbild,2)
      ClearClipboard()
      SetClipboardImage(tempbild)
      FreeImage(tempbild)
    Case #Menu_Save_as_png
      tempf=SaveFileRequester("Select File",directory+"ExportImage","Bild (*.png)|*.png",0)
      If tempf
        directory=GetPathPart(tempf)        
      EndIf      
      If SelectedFilePattern()=0 And Not GetExtensionPart(tempf)="png"
        tempf+".png"
      EndIf      
      If check_overwrite(tempf)
        CloseFile(0)
        tempbild=CreateImage(#PB_Any,scrwidth,scrheight,32)  
        draw_plot(tempbild,2) 
        StartDrawing(ImageOutput(tempbild))
          DrawingMode(#PB_2DDrawing_AlphaChannel)
          For i=0 To scrwidth-1
          For j=0 To scrheight-1
           temppoint.l=Point(i,j)
         If Red(temppoint)=255 And Green(temppoint)=255 And Blue(temppoint)=255
          Plot(i,j,RGBA(255,255,255,0))
        EndIf  
      Next j  
    Next i
    StopDrawing()
        SaveImage(tempbild,tempf,#PB_ImagePlugin_PNG)
        FreeImage(tempbild)
      EndIf
    Case #Menu_Save_as_emf 
      tempf=SaveFileRequester("Select File",directory+"ExportImage","Bild (*.emf)|*.emf",0)
      If tempf
        directory=GetPathPart(tempf)        
      EndIf      
      If SelectedFilePattern()=0 And Not GetExtensionPart(tempf)="emf"
        tempf+".emf"
      EndIf      
      If check_overwrite(tempf)
        CloseFile(0)
        hdc=CreateEnhMetaFile_(0,tempf,0,0)
        draw_plot(hdc,1)
        emfcomment.s="Exported Graph created by GAEA"
        GdiComment_(hdc,StringByteLength(emfcomment),emfcomment)
        DeleteEnhMetaFile_(CloseEnhMetaFile_(hdc))
      EndIf
    Case #Menu_Aggregate_lists
      If imported>=0
        If Not IsWindow(#Win_aggregate)
          OpenWindow(#Win_aggregate,WindowX(#Win_para)+100,WindowY(#Win_para)+100,300,300,"Aggregation")          
          TextGadget(#Text_aggregate_interval,10,10,100,20,"Interval")          
          ComboBoxGadget(#Combo_aggregate_timeunit,210,10,80,20)
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Seconds")
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Minutes")
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Hours")
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Days")
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Months")
          AddGadgetItem(#Combo_aggregate_timeunit,-1,"Years")
          SetGadgetState(#Combo_aggregate_timeunit,intervaltype_aggregation)
          SpinGadget(#Spin_aggregate_interval,120,10,80,20,1,9999,#PB_Spin_Numeric):SetGadgetState(#Spin_aggregate_interval,interval_aggregation) 
          StringGadget(#String_aggregate_interval,120,10,80,20,StrD(interval_aggregation)) 
          If Not is_time
            HideGadget(#Combo_aggregate_timeunit,1)
            HideGadget(#Spin_aggregate_interval,1)
          Else  
            HideGadget(#String_aggregate_interval,1)
          EndIf
          OptionGadget(#Option_aggregate_linear,10,30,200,20,"linear interpolation between neighbors")
          OptionGadget(#Option_aggregate_operation,10,50,70,20,"operation")
          SetGadgetState(#Option_aggregate_linear+option_aggregation-1,1)
          ComboBoxGadget(#Combo_operationtype,100,50,100,20)
          AddGadgetItem(#Combo_operationtype,-1,"Mean")
          AddGadgetItem(#Combo_operationtype,-1,"Median")
          AddGadgetItem(#Combo_operationtype,-1,"Min")
          AddGadgetItem(#Combo_operationtype,-1,"Max")
          AddGadgetItem(#Combo_operationtype,-1,"Sum")
          SetGadgetState(#Combo_operationtype,operationtype_aggregation)
          OptionGadget(#Option_aggregate_backward,30,70,200,20,"backward")
          OptionGadget(#Option_aggregate_center,30,90,200,20,"centered")
          OptionGadget(#Option_aggregate_forward,30,110,200,20,"forward")
          SetGadgetState(#Option_aggregate_backward+aggregate_direction-1,1)
          ;           TextGadget(#Text_aggregate_from,10,78,100,20,"relative interval from")
          ;           StringGadget(#String_aggregate_from,120,75,50,20,StrD(from_aggregation))
          ;           TextGadget(#Text_aggregate_to,200,78,20,20,"to")
          ;           StringGadget(#String_aggregate_to,230,75,50,20,StrD(to_aggregation))
          ;           If is_time
          ;             Select intervaltype_aggregation
          ;               Case 0
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation))
          ;               Case 1
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60))
          ;               Case 2
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60))
          ;               Case 3
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24))
          ;               Case 4
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24/31))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24/31))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24/31))
          ;               Case 5
          ;                 SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation/60/60/24/31/12))
          ;                 SetGadgetText(#String_aggregate_from,StrD(from_aggregation/60/60/24/31/12))
          ;                 SetGadgetText(#String_aggregate_to,StrD(to_aggregation/60/60/24/31/12))
          ;             EndSelect
          ;           Else
          ;             SetGadgetText(#String_aggregate_interval,StrD(interval_aggregation))
          ;           EndIf
          
          ButtonGadget(#Button_apply_aggregation,10,160,80,20,"OK")
          
        Else
          SetActiveWindow(#Win_aggregate)
        EndIf  
      Else
        MessageRequester("Information","Import data")
      EndIf
      
    Case #Menu_Mark_specififed
      markmask.s=InputRequester("Enter value to be selected","Inequalities <,<=,>,>= before, tolerance +- after value","")
      If Not markmask=""
        mode=0
        If Mid(markmask,1,1)=">"
          mode=1
          markmask=Mid(markmask,2,Len(markmask)-1)
          If Mid(markmask,1,1)="="
            mode=2
            markmask=Mid(markmask,2,Len(markmask)-1)
          EndIf  
        EndIf
        If Mid(markmask,1,1)="<"
          mode=3
          markmask=Mid(markmask,2,Len(markmask)-1)
          If Mid(markmask,1,1)="="
            mode=4
            markmask=Mid(markmask,2,Len(markmask)-1)
          EndIf  
        EndIf
        If FindString(markmask,"+-")
          tolerance.d=ValD(Mid(markmask,FindString(markmask,"+-")+2,Len(markmask)-FindString(markmask,"+-")-1))
          markmask=Mid(markmask,1,FindString(markmask,"+-")-1)
        Else:tolerance.d=0  
        EndIf  
        temp.d=ValD(markmask)  
        For k=0 To ArraySize(imp())
          For j=0 To ArraySize(imp(k)\set(),2)           
            If imp(k)\draw(j)
              For i=0 To ArraySize(imp(k)\set(),1)
                If choose(temp,imp(k)\set(i,j),mode,tolerance) And active(k,j) And imp(k)\scale(i)>=para\bound_low And imp(k)\scale(i)<=para\bound_up 
                  imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bitmark
                Else  
                  imp(k)\tags(i,j)&~#Bitmark
                EndIf  
              Next i
            EndIf  
          Next j       
        Next k
        ;         change_edit_list()
        changed=1
      EndIf
    Case #Menu_Grid_x
      If gridx:gridx=0:Else:gridx=1:EndIf:changed=1
    Case #Menu_Help
      help()
    Case #Menu_About
      about()
    Case #Menu_Duplicate_list
      duplicate()
    Case #Menu_Appearance   
      If Not IsWindow(#Win_titles)
        OpenWindow(#Win_titles,WindowX(#Win_para)+100,WindowY(#Win_para)+100,300,400,"Appearance")          
        TextGadget(#Text_tag1,10,13,100,20,"Tag 1")
        TextGadget(#Text_tag2,10,33,100,20,"Tag 2")
        TextGadget(#Text_tag3,10,53,100,20,"Tag 3")
        TextGadget(#Text_title,10,73,100,20,"Diagramm Title")
        TextGadget(#Text_primaxis,10,93,100,20,"Primary Axis")
        TextGadget(#Text_secaxis,10,113,100,20,"Secondary Axis")
        TextGadget(#Text_abscissa,10,133,100,20,"Abscissa")
        ;TextGadget(#Text_editor,10,153,100,20,"Editor")
        
        StringGadget(#String_tag1,120,10,150,20,para\tag1)
        StringGadget(#String_tag2,120,30,150,20,para\tag2)
        StringGadget(#String_tag3,120,50,150,20,para\tag3)
        StringGadget(#String_title,120,70,150,20,para\title)
        StringGadget(#String_primaxis,120,90,150,20,para\primaxis)
        StringGadget(#String_secaxis,120,110,150,20,para\secaxis)
        StringGadget(#String_abscissa,120,130,150,20,para\abscissa)
        ;StringGadget(#String_editor,120,150,150,20,para\editor)
        ButtonGadget(#Button_fonttitle,10,150,150,20,"Title Font...")
        ButtonGadget(#Button_Fontprimaxis,10,170,150,20,"Prim. Axis Font...")
        ButtonGadget(#Button_Fontsecaxis,10,190,150,20,"Sec. Axis Font...")
        ButtonGadget(#Button_Fontabscissa,10,210,150,20,"Abscissa Font...")
        ButtonGadget(#Button_Fontlegend,10,230,150,20,"Legend Font...")
        ButtonGadget(#Button_Fontstandard,10,270,150,20,"Standard Font...")
        ButtonGadget(#Button_Fonteditor,10,250,150,20,"Editor Font...")
        ButtonGadget(#Button_Fontcomment,10,290,150,20,"Comment Font...")
        
        ;       ComboBoxGadget(#Combo_Font,120,150,150,20)
        ;       AddGadgetItem(#Combo_Font,-1,"Arial")
        ;       AddGadgetItem(#Combo_Font,-1,"Courier New")
        ;       AddGadgetItem(#Combo_Font,-1,"Calibri")
        ;       AddGadgetItem(#Combo_Font,-1,"Cambria")
        ;       AddGadgetItem(#Combo_Font,-1,"Tahoma")
        ;       AddGadgetItem(#Combo_Font,-1,"Times New Roman") 
        ;       AddGadgetItem(#Combo_Font,-1,"MS Shell Dlg")
        ;       AddGadgetItem(#Combo_Font,-1,"System")
        ;       If fontname="Arial":SetGadgetState(#Combo_Font,0):EndIf 
        ;       If fontname="Courier New":SetGadgetState(#Combo_Font,1):EndIf 
        ;       If fontname="Calibri":SetGadgetState(#Combo_Font,2):EndIf 
        ;       If fontname="Cambria":SetGadgetState(#Combo_Font,3):EndIf 
        ;       If fontname="Tahoma":SetGadgetState(#Combo_Font,4):EndIf 
        ;       If fontname="Times New Roman":SetGadgetState(#Combo_Font,5):EndIf 
        ;       If fontname="System":SetGadgetState(#Combo_Font,6):EndIf
        OptionGadget(#Option_color1,10,320,150,20,"Color Scheme 1")
        OptionGadget(#Option_color2,10,340,150,20,"Color Scheme 2")
        SetGadgetState(#Option_color1+colorscheme-1,1)
        ButtonGadget(#Button_apply_titles,10,370,80,20,"OK")      
      Else
        SetActiveWindow(#Win_titles)
      EndIf    
    Case #Menu_Grid_y
      If gridy:gridy=0:Else:gridy=1:EndIf:changed=1
    Case #Menu_Grid_ysec
      If gridy2:gridy2=0:Else:gridy2=1:EndIf:changed=1
    Case #Menu_Rename_entry
      For i=0 To ArraySize(imp(selected)\set(),2)
        If imp(selected)\draw(i):ok=1:Break(1):EndIf
      Next i
      If ok
        tempf=InputRequester("Input Request","Rename Entry Title",imp(selected)\header(i))
        If Not tempf=""
          imp(selected)\header(i)=tempf:changed=1:set_list():unsaved=1
        EndIf  
      Else
        MessageRequester("Warning","Nothing selected")
      EndIf 
    Case #Menu_Duplicate_entry
      duplicate_entries()
    Case #Menu_Rename_list
      If imported>=0
        text.s=InputRequester("Input Request","Insert New List Title",imp(selected)\description)
        If text:imp(selected)\description=text:unsaved=1:EndIf
        set_list()
        changed=1
      Else
        MessageRequester("Information","Import Data")
      EndIf      
    Case #Menu_Load_Autosave
      load_autosave()
    Case #Menu_Crop_List
      crop_list()
  EndSelect    
EndProcedure  

Procedure check_buttons(event.l)
  ;   
  ;     If KeyboardReleased(#PB_Key_A)   ;select all
  ;   EndIf
  
  ;   Static changing_selection.b
  ;  
  
  Static deselect_comment.b
  Static deselect_mergelist.b
  
  If GetActiveWindow()=#win_plot
    If event=#WM_KEYDOWN And EventwParam()=#VK_LEFT
      range.d=para\bound_up-para\bound_low
      para\bound_low-range/200
      para\bound_up-range/200
      changed=1
    EndIf  
    If event=#WM_KEYDOWN And EventwParam()=#VK_RIGHT
      range.d=para\bound_up-para\bound_low
      para\bound_low+range/200
      para\bound_up+range/200
      changed=1
    EndIf
    
    If event=#WM_KEYDOWN And EventwParam()=#VK_UP
      editorpos-1
      changed=1
    EndIf  
    If event=#WM_KEYDOWN And EventwParam()=#VK_DOWN
      editorpos+1
      changed=1
    EndIf
  EndIf
  
  If event=#WM_KEYUP And EventwParam() = #VK_RETURN
    Select GetActiveWindow()
      Case #Win_import
        import_data()
      Case #Win_aggregate
        aggregation()
      Case #Win_delcomment
        del_comment()  
      Case #Win_mergelists
        merge_lists()
      Case #win_filter
        filter()
      Case #Win_translate
        translate()
      Case #Win_scale
        scale_data()
        ;       Case #Win_editentry
        ;         edit_entry()
        ;         CloseWindow(#Win_editentry)
      Case #Win_scaleaddition
        scaled_addition()
      Case #Win_ehcorr
        eh_corr()
      Case #Win_editmeta
        edit_meta()
        CloseWindow(#Win_editmeta) 
      Case #Win_interpolate
        interpolate()
      Case #Win_lfcorrection
        ec_corr()
    EndSelect    
  EndIf  
  
  If event=#WM_KEYUP And EventwParam() = #VK_F1
    helptext.s
    Select GetActiveWindow()
      Case #Win_aggregate
        helptext=""
      Case #Win_delcomment
        helptext=""
      Case #Win_editentry
        helptext=""
      Case #Win_editmeta
        helptext=""
      Case #Win_ehcorr
        helptext=""
      Case #Win_filter 
        helptext=""
      Case #Win_import
        helptext=""
      Case #Win_interpolate
        helptext=""
      Case #Win_lfcorrection
        helptext=""
      Case #Win_mergelists
        helptext=""
      Case #Win_Para
        helptext=""
      Case #Win_Plot
        helptext=""
      Case #Win_scale
        helptext=""
      Case #Win_scaleaddition
        helptext=""
      Case #Win_titles
        helptext=""
      Case #Win_translate
        helptext="translation.htm"
      Default  
        helptext=""
    EndSelect
    OpenHelp("GAEA Helper.chm",helptext)
  EndIf  
  
  If KeyboardPushed(#PB_Key_End) ;decrease lower selection
                                 ;     changing_selection=1
                                 ;     ResetList(markers())
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To columns
        If imp(k)\draw(i)
          ;           NextElement(markers())
          j=0
          While Not imp(k)\tags(j,i)&#Bitmark And j<rows  
            j+1
          Wend
          If KeyboardPushed(#PB_Key_LeftShift)
            For l=1 To 10
              If j>0
                Repeat 
                  j-1  
                Until Not invalid(k,j,i) Or j=0
              EndIf
              If Not (j=0 And invalid(k,j,i))
                imp(k)\tags(j,i)|#Bitmark
                ;                 selection_low=imp(k)\scale(j)
                ;                 If Not ListSize(markers())=0:markers()\lower=StrD(imp(k)\set(j,i)):EndIf  
              EndIf
            Next l  
          Else
            If j>0
              Repeat 
                j-1  
              Until Not invalid(k,j,i) Or j=0
            EndIf
            If Not (j=0 And invalid(k,j,i))
              imp(k)\tags(j,i)|#Bitmark
              ;               selection_low=imp(k)\scale(j)
              ;               If Not ListSize(markers())=0:markers()\lower=StrD(imp(k)\set(j,i)):EndIf
            EndIf
          EndIf
        EndIf
      Next i
    Next k
    changed=1 
  EndIf
  
  
  If KeyboardPushed(#PB_Key_PageDown) ;increase lower selection
                                      ;     changing_selection=1
                                      ;     ResetList(markers())
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To columns
        If imp(k)\draw(i)
          ;           NextElement(markers())
          j=0
          While Not imp(k)\tags(j,i)&#Bitmark And j<rows  
            j+1
          Wend
          j-1
          If KeyboardPushed(#PB_Key_LeftShift)
            For l=1 To 10            
              If j<rows
                Repeat 
                  j+1  
                Until Not invalid(k,j,i) Or j=rows
              EndIf
              If Not (j=rows And invalid(k,j,i))
                imp(k)\tags(j,i)&~#Bitmark
                ;                 If j<rows
                ;                   selection_low=imp(k)\scale(j+1)              
                ;                   If Not ListSize(markers())=0:markers()\lower=StrD(imp(k)\set(j+1,i)):EndIf                
                ;                 Else
                ;                   selection_low=NaN() 
                ;                   If Not ListSize(markers())=0:markers()\lower="":EndIf
                ;                 EndIf
              EndIf
            Next l  
          Else 
            If j<rows
              Repeat
                j+1  
              Until Not invalid(k,j,i) Or j=rows  
            EndIf
            If Not (j=rows And invalid(k,j,i))
              imp(k)\tags(j,i)&~#Bitmark
              ;               If j<rows
              ;                 selection_low=imp(k)\scale(j+1)            
              ;                 If Not ListSize(markers())=0:markers()\lower=StrD(imp(k)\set(j+1,i)):EndIf
              ;               Else
              ;                 selection_low=NaN()
              ;                 If Not ListSize(markers())=0:markers()\lower="":EndIf
              ;               EndIf
            EndIf  
          EndIf
        EndIf
      Next i
    Next k    
    changed=1 
  EndIf
  
  If KeyboardPushed(#PB_Key_Home) ;decrease upper selection
                                  ;     changing_selection=1
                                  ;     ResetList(markers())
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To columns
        If imp(k)\draw(i)
          ;           NextElement(markers())
          j=rows
          While Not imp(k)\tags(j,i)&#Bitmark And j>0  
            j-1
          Wend
          j+1
          If KeyboardPushed(#PB_Key_LeftShift)
            For l=1 To 10
              If j>0
                Repeat 
                  j-1
                Until Not invalid(k,j,i) Or j=0 
              EndIf  
              If Not (j=0 And invalid(k,j,i))
                imp(k)\tags(j,i)&~#Bitmark
                ;                 If j>0
                ;                   selection_high=imp(k)\scale(j-1)
                ;                   If Not ListSize(markers())=0:markers()\upper=StrD(imp(k)\set(j-1,i)):EndIf             
                ;                 Else
                ;                   If Not ListSize(markers())=0:markers()\upper="":EndIf
                ;                   selection_high=NaN()
                ;                 EndIf
              EndIf 
            Next l  
          Else 
            If j>0
              Repeat
                j-1
              Until Not invalid(k,j,i) Or j=0
            EndIf
            If Not (j=0 And invalid(k,j,i))
              imp(k)\tags(j,i)&~#Bitmark
              ;               If j>0
              ;                 selection_high=imp(k)\scale(j-1)
              ;                 If Not ListSize(markers())=0:markers()\upper=StrD(imp(k)\set(j-1,i)):EndIf
              ;               Else
              ;                 selection_high=NaN()
              ;                 If Not ListSize(markers())=0:markers()\upper="":EndIf
              ;               EndIf
            EndIf  
          EndIf 
        EndIf
      Next i
    Next k
    changed=1 
  EndIf  
  
  If KeyboardPushed(#PB_Key_PageUp) ;increase upper selection
                                    ;     changing_selection=1
                                    ;     ResetList(markers())
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To columns
        If imp(k)\draw(i)
          ;           NextElement(markers())
          j=rows
          While Not imp(k)\tags(j,i)&#Bitmark And j>0  
            j-1
          Wend
          If KeyboardPushed(#PB_Key_LeftShift)
            For l=1 To 10            
              If j<rows
                Repeat
                  j+1
                Until Not invalid(k,j,i) Or j=rows  
              EndIf
              If Not (j=rows And invalid(k,j,i))
                imp(k)\tags(j,i)=imp(k)\tags(j,i)|#Bitmark
                ;                 selection_high=imp(k)\scale(j)
                ;                 If Not ListSize(markers())=0:markers()\upper=StrD(imp(k)\set(j,i)):EndIf
              EndIf 
            Next l  
          Else 
            If j<rows
              Repeat
                j+1
              Until Not invalid(k,j,i) Or j=rows 
            EndIf
            If Not (j=rows And invalid(k,j,i))
              imp(k)\tags(j,i)=imp(k)\tags(j,i)|#Bitmark
              ;               selection_high=imp(k)\scale(j)
              ;               If Not ListSize(markers())=0:markers()\upper=StrD(imp(k)\set(j,i)):EndIf
            EndIf 
          EndIf
        EndIf
      Next i
    Next k
    changed=1 
  EndIf    
  
  ;   If changing_selection And Not (KeyboardPushed(#PB_Key_PageUp) Or KeyboardPushed(#PB_Key_Home) Or KeyboardPushed(#PB_Key_PageDown) Or KeyboardPushed(#PB_Key_End))
  ;     changing_selection=0
  ;     change_edit_list()
  ;   EndIf  
  ;   
  If event=#WM_KEYUP And EventwParam() = #VK_DELETE And GetActiveWindow()=#win_para And GetActiveGadget()=#Gadget_ImportListe  ;delete entry
    delete_selected_entries()
  EndIf
  
  If event=#WM_KEYUP And EventwParam() = #VK_OEM_PLUS And GetActiveWindow()=#win_para And GetActiveGadget()=#Gadget_ImportListe And selected>=0 ;swap two entries
    unsaved=1
    index=GetGadgetState(#Gadget_ImportListe)
    If index>0
      tempset.setxy
      columns=ArraySize(imp(selected)\set(),2)
      rows=ArraySize(imp(selected)\set(),1)
      CopyStructure(@imp(selected),@tempset,setxy)
      For i=0 To columns
        If i=index-1
          tempset\draw(i)=imp(selected)\draw(index)
          tempset\header(i)=imp(selected)\header(index)
          tempset\secondaxis(i)=imp(selected)\secondaxis(index)
          For j=0 To rows
            tempset\set(j,i)=imp(selected)\set(j,index)
            tempset\drawset(j,i)=imp(selected)\drawset(j,index)
            tempset\tags(j,i)=imp(selected)\tags(j,index)
          Next j  
        ElseIf i=index
          tempset\draw(i)=imp(selected)\draw(index-1)
          tempset\header(i)=imp(selected)\header(index-1)
          tempset\secondaxis(i)=imp(selected)\secondaxis(index-1)
          For j=0 To rows
            tempset\set(j,i)=imp(selected)\set(j,index-1)
            tempset\drawset(j,i)=imp(selected)\drawset(j,index-1)
            tempset\tags(j,i)=imp(selected)\tags(j,index-1)
          Next j  
        EndIf  
      Next i
      CopyStructure(@tempset,@imp(selected),setxy)
      changed=1:set_list()
    EndIf
  EndIf
  
  If event=#WM_KEYUP And EventwParam() = #VK_OEM_2 And GetActiveWindow()=#win_para And GetActiveGadget()=#Gadget_ImportListe And selected>=0
    unsaved=1
    index=GetGadgetState(#Gadget_ImportListe)
    columns=ArraySize(imp(selected)\set(),2)
    If index<columns
      tempset.setxy    
      rows=ArraySize(imp(selected)\set(),1)
      CopyStructure(@imp(selected),@tempset,setxy)
      For i=0 To columns
        If i=index
          tempset\draw(i)=imp(selected)\draw(index+1)
          tempset\header(i)=imp(selected)\header(index+1)
          tempset\secondaxis(i)=imp(selected)\secondaxis(index+1)
          For j=0 To rows
            tempset\set(j,i)=imp(selected)\set(j,index+1)
            tempset\drawset(j,i)=imp(selected)\drawset(j,index+1)
            tempset\tags(j,i)=imp(selected)\tags(j,index+1)
          Next j  
        ElseIf i=index+1
          tempset\draw(i)=imp(selected)\draw(index)
          tempset\header(i)=imp(selected)\header(index)
          tempset\secondaxis(i)=imp(selected)\secondaxis(index)
          For j=0 To rows
            tempset\set(j,i)=imp(selected)\set(j,index)
            tempset\drawset(j,i)=imp(selected)\drawset(j,index)
            tempset\tags(j,i)=imp(selected)\tags(j,index)
          Next j  
        EndIf  
      Next i
      CopyStructure(@tempset,@imp(selected),setxy)
      changed=1:set_list()
    EndIf
  EndIf
  
  If event=#WM_KEYUP And EventwParam() = #VK_DOWN And GetActiveWindow()=#Win_import
    If filetype<5
      SetGadgetState(#Option_File1+filetype-1,0)
      SetGadgetState(#Option_File1+filetype,1)
    EndIf  
  EndIf
  
  If event=#WM_KEYUP And EventwParam() = #VK_UP And GetActiveWindow()=#Win_import
    If filetype>1
      SetGadgetState(#Option_File1+filetype-1,0)
      SetGadgetState(#Option_File1+filetype-2,1)
    EndIf  
  EndIf  
  
  If KeyboardReleased(#PB_Key_Delete) And GetActiveWindow()=#win_plot   ;delete selected
    unsaved=1
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To rows
        For j=0 To columns
          If imp(k)\tags(i,j)&#Bitmark
            imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bitdel
            imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bitmark
          EndIf  
        Next j       
      Next i
    Next k
    changed=1
  EndIf
  
  ;   If EventGadget()=#Button_delete_entries And EventType()=#PB_EventType_LeftClick ;delete entries from list
  ;         
  ;   EndIf  
  ;     
  ;     If EventGadget()=#Button_delete_list And EventType()=#PB_EventType_LeftClick  ;delete entire list
  ; 
  ;     EndIf
  ;    
  
  If KeyboardReleased(#PB_Key_Space)    ;hide/unhide selection
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To rows
        For j=0 To columns
          If imp(k)\tags(i,j)&#Bitmark=#Bitmark
            If KeyboardPushed(#PB_Key_LeftControl) Or KeyboardPushed(#PB_Key_RightControl)
              imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bithide
            Else  
              imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bithide
            EndIf  
          EndIf  
        Next j       
      Next i
    Next k
    changed=1
  EndIf
  
  If KeyboardReleased(#PB_Key_1)    ;un/set tag1
    unsaved=1
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To rows
        For j=0 To columns
          If imp(k)\tags(i,j)&#Bitmark=#Bitmark
            If KeyboardPushed(#PB_Key_LeftControl) Or KeyboardPushed(#PB_Key_RightControl)
              imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bittag1
            Else  
              imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bittag1
            EndIf  
          EndIf  
        Next j       
      Next i
    Next k
    changed=1
  EndIf
  If KeyboardReleased(#PB_Key_2)   ;un/set tag2
    unsaved=1
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To rows
        For j=0 To columns
          If imp(k)\tags(i,j)&#Bitmark=#Bitmark
            If KeyboardPushed(#PB_Key_LeftControl) Or KeyboardPushed(#PB_Key_RightControl)
              imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bittag2
            Else  
              imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bittag2
            EndIf  
          EndIf  
        Next j       
      Next i
    Next k
    changed=1
  EndIf
  If KeyboardReleased(#PB_Key_3)     ;un/set tag3
    unsaved=1
    For k=0 To ArraySize(imp())
      rows=ArraySize(imp(k)\set(),1)
      columns=ArraySize(imp(k)\set(),2)
      For i=0 To rows 
        For j=0 To columns
          If imp(k)\tags(i,j)&#Bitmark=#Bitmark
            If KeyboardPushed(#PB_Key_LeftControl) Or KeyboardPushed(#PB_Key_RightControl)
              imp(k)\tags(i,j)=imp(k)\tags(i,j)&~#Bittag3
            Else  
              imp(k)\tags(i,j)=imp(k)\tags(i,j)|#Bittag3
            EndIf  
          EndIf  
        Next j       
      Next i
    Next k
    changed=1
  EndIf
  
  If (EventGadget()=#Button_prev And EventType()=#PB_EventType_LeftClick) Or (event=#WM_KEYUP And EventwParam() = #VK_LEFT And GetActiveWindow()=#win_para And GetActiveGadget()=#Gadget_ImportListe) ;change selected list
    selected-1
    If selected<0:selected=imported:EndIf
    set_list()
    set_comment_list()
  EndIf
  
  If (EventGadget()=#Button_next And EventType()=#PB_EventType_LeftClick) Or (event=#WM_KEYUP And EventwParam() = #VK_RIGHT And GetActiveWindow()=#win_para And GetActiveGadget()=#Gadget_ImportListe)  ;change selected list
    selected+1
    If selected>imported:selected=0:EndIf
    set_list()  
    set_comment_list()
  EndIf
  
  If EventGadget()=#Button_help And EventType()=#PB_EventType_LeftClick
    help()
  EndIf  
  ;   EndIf
  
  If (EventGadget()=#Button_set_preview_file And EventType()=#PB_EventType_LeftClick)
      preview_filename=OpenFileRequester("Select Sample File",directory+"*.*","Alle Dateien (*.*)|*.*",0)
  If preview_filename
    directory=GetPathPart(preview_filename)
  Else
    CloseWindow(#Win_importpreview)
    ProcedureReturn 0
  EndIf
  EndIf
  
  If (EventGadget()=#Button_import_preview And EventType()=#PB_EventType_LeftClick); Or (GetActiveWindow()=#Win_import And KeyboardReleased(#PB_Key_Return))
    preview()
  EndIf
  
  If (EventGadget()=#Button_apply_import And EventType()=#PB_EventType_LeftClick); Or (GetActiveWindow()=#Win_import And KeyboardReleased(#PB_Key_Return))
    import_data()
  EndIf
  
  ;   If EventGadget()=#Button_undelete And EventType()=#PB_EventType_LeftClick
  ;     undelete()
  ;   EndIf
  If EventGadget()=#Button_Gettranslation And EventType()=#PB_EventType_LeftClick
    get_translation()
  EndIf  
  
  If (EventGadget()=#Button_apply_filter And EventType()=#PB_EventType_LeftClick)
    filter()   
  EndIf
  ;   If EventGadget()=#Button_consolidate And EventType()=#PB_EventType_LeftClick
  ;     consolidate()
  ;   EndIf
  
  If EventGadget()=#button_apply_merge_lists And EventType()=#PB_EventType_LeftClick
    merge_lists()
  EndIf
  
  If EventGadget()=#Button_mergelist_select And EventType()=#PB_EventType_LeftClick
    If deselect_mergelist
      deselect_mergelist=0
      For i=1 To CountGadgetItems(#List_mergelist)
        SetGadgetItemState(#List_mergelist,i-1,0)
      Next i  
    Else
      deselect_mergelist=1
      For i=1 To CountGadgetItems(#List_mergelist)
        SetGadgetItemState(#List_mergelist,i-1,1)
      Next i  
    EndIf  
  EndIf
  ;   If EventGadget()=#Button_export_list And EventType()=#PB_EventType_LeftClick
  ;     export_list()
  ;   EndIf
  ;   If EventGadget()=#Button_savedata And EventType()=#PB_EventType_LeftClick
  ;     save_data()
  ;   EndIf
  ;   If EventGadget()=#Button_loaddata And EventType()=#PB_EventType_LeftClick
  ;     load_data()
  ;   EndIf
  If EventGadget()=#Button_Apply_translation And EventType()=#PB_EventType_LeftClick
    translate()
  EndIf
  If (EventGadget()=#Button_apply_scale Or EventGadget()=#Button_apply_normalize) And EventType()=#PB_EventType_LeftClick
    scale_data()
  EndIf
  If (EventGadget()=#Button_apply_entryedit And EventType()=#PB_EventType_LeftClick) Or (event=#WM_KEYUP And EventwParam() = #VK_RETURN And GetActiveWindow()=#Win_editentry)
    unsaved=1
    If mrow=-1
      imp(mfile)\header(editorcols(mcol))=GetGadgetText(#String_EditEntry)
      set_list()
    Else  
      If mcol=-1
        If is_time
          imp(mfile)\scale(mrow)=ParseDate(maskgeneric,GetGadgetText(#String_EditEntry))
        Else
          imp(mfile)\scale(mrow)=ValD(GetGadgetText(#String_EditEntry))
        EndIf 
      ElseIf mcol=editorcolumns  
        imp(mfile)\notes(mrow)=GetGadgetText(#String_EditEntry)
      Else  
        imp(mfile)\set(mrow,editorcols(mcol))=ValD(GetGadgetText(#String_EditEntry))
        imp(mfile)\tags(mrow,editorcols(mcol))|#Bitedit
      EndIf
    EndIf
    changed=1
    CloseWindow(#Win_editentry)
  EndIf
  If EventGadget()=#button_apply_scale_addition And EventType()=#PB_EventType_LeftClick
    scaled_addition()
  EndIf
  If EventGadget()=#Button_apply_lf_correction And EventType()=#PB_EventType_LeftClick
    ec_corr()
  EndIf
  ;     If EventGadget()=#Button_addconstant And EventType()=#PB_EventType_LeftClick
  ;     add_constant()
  ;   EndIf    
  ;   If EventGadget()=#Button_merge_entries And EventType()=#PB_EventType_LeftClick
  ;     merge_entries()
  ;   EndIf
  If EventGadget()=#Button_apply_meta And EventType()=#PB_EventType_LeftClick
    edit_meta()
    CloseWindow(#Win_editmeta)
  EndIf
  
  If (EventGadget()=#Button_apply_interpolate And EventType()=#PB_EventType_LeftClick)
    interpolate()    
  EndIf
  ;   If EventGadget()=#Button_unselect_all And EventType()=#PB_EventType_LeftClick   ;reset selected entries
  ; 
  ;   EndIf
  If EventGadget()=#Button_apply_eh_correction And EventType()=#PB_EventType_LeftClick
    eh_corr()
  EndIf 
  If EventGadget()=#Button_apply_delcomment And EventType()=#PB_EventType_LeftClick        ;open delete comment window
    del_comment()
    set_comment_list()
  EndIf
    If EventGadget()=#Button_comment_select And EventType()=#PB_EventType_LeftClick
    If deselect_comment
      deselect_comment=0
      For i=1 To CountGadgetItems(#List_delcomment)
        SetGadgetItemState(#List_delcomment,i-1,0)
      Next i  
    Else
      deselect_comment=1
      For i=1 To CountGadgetItems(#List_delcomment)
        SetGadgetItemState(#List_delcomment,i-1,1)
      Next i  
    EndIf  
  EndIf
  
  If EventGadget()=#Button_apply_aggregation And EventType()=#PB_EventType_LeftClick        ;open delete comment window
    aggregation()
  EndIf
  If IsWindow(#win_titles)
    *fontpointer.font
    If EventType()=#PB_EventType_LeftClick 
      Select EventGadget()
        Case #Button_fonttitle
          *fontpointer=@fonttitle:go=1
        Case #Button_Fontabscissa
          *fontpointer=@fontabscissa:go=1
        Case #Button_Fontprimaxis
          *fontpointer=@fontprimaxis:go=1
        Case #Button_Fontsecaxis
          *fontpointer=@fontsecaxis:go=1
        Case #Button_Fontlegend
          *fontpointer=@fontlegend:go=1
        Case #Button_Fonteditor
          *fontpointer=@fonteditor:go=1
        Case #Button_Fontstandard
          *fontpointer=@fontstandard:go=1 
        Case #Button_Fontcomment
          *fontpointer=@fontcomment:go=1   
      EndSelect    
    EndIf  
    If go
      unsaved=1
      go=FontRequester(*fontpointer\name,*fontpointer\size,0,*fontpointer\color,*fontpointer\style)
      If go
        *fontpointer\name=SelectedFontName()
        *fontpointer\style=SelectedFontStyle()
        *fontpointer\size=SelectedFontSize()
        *fontpointer\color=SelectedFontColor()
        FreeFont(*fontpointer\id)
        *fontpointer\id=LoadFont(#PB_Any,*fontpointer\name,*fontpointer\size,*fontpointer\style)
        changed=1
      EndIf
      
    EndIf  
  EndIf  
  If EventGadget()=#Button_apply_titles And EventType()=#PB_EventType_LeftClick        ;open delete comment window
    unsaved=1
    para\tag1=GetGadgetText(#String_tag1)
    para\tag2=GetGadgetText(#String_tag2)
    para\tag3=GetGadgetText(#String_tag3)
    para\title=GetGadgetText(#String_title)
    para\primaxis=GetGadgetText(#String_primaxis)
    para\secaxis=GetGadgetText(#String_secaxis)
    para\abscissa=GetGadgetText(#String_abscissa)
    ;     fontsizesmall=GetGadgetState(#Spin_fontstd)
    ;     fontsizelarge=GetGadgetState(#Spin_fonttitle)
    ;fontname=GetGadgetItemText(#Combo_Font,GetGadgetState(#Combo_font))
    ;     FreeFont(font_large)
    ;     FreeFont(font_small)
    ;     font_large=LoadFont(#PB_Any,fontname,fontsizelarge)
    ;     font_small=LoadFont(#PB_Any,fontname,fontsizesmall)
    changed=1
    CloseWindow(#Win_titles)
  EndIf
  
EndProcedure  

Procedure set_menus()
  
  CreatePopupMenu(#Menu_popup_import)
  MenuItem(#Menu_Open, "Open..."   +Chr(9)+"Ctrl+O")
  MenuItem(#Menu_Load_Autosave, "Restore Autosave"   +Chr(9)+"Ctrl+R")
  MenuItem(#Menu_Save, "Save"   +Chr(9)+"Ctrl+S")
  MenuItem(#Menu_Save_as, "Save as..."+Chr(9)+"Alt+S")
  MenuItem(#Menu_Import, "Import..."+Chr(9)+"Ctrl+I")
  MenuItem(#Menu_Export, "Export current list..."+Chr(9)+"Ctrl+E")
  MenuItem(#Menu_Quit, "Quit"  +Chr(9)+"Esc")
  
  CreatePopupMenu(#Menu_popup_plot)
  MenuItem(#Menu_Add_comment, "Add comment here..."+Chr(9)+"C")
  MenuItem(#Menu_Delete_comments, "Delete comments..."+Chr(9)+"Ctrl+Del")
  MenuBar()
  MenuItem(#Menu_Search_selection,"Search for Selection"+Chr(9)+"F3")
  MenuBar()
  MenuItem(#Menu_Mark_all, "Mark all"+Chr(9)+"M")
  MenuItem(#Menu_Mark_specififed, "Mark specified value..."+Chr(9)+"Alt+M")
  MenuBar()
  MenuItem(#Menu_Grid_x, "Show Grid x"+Chr(9)+"G")
  MenuItem(#Menu_Grid_y, "Show Grid y"+Chr(9)+"Alt+G")
  MenuItem(#Menu_Grid_ysec, "Show Grid y sec."+Chr(9)+"Ctrl+G")
  MenuBar()
  MenuItem(#Menu_Undelete, "Undelete"   +Chr(9)+"U")
  MenuItem(#Menu_Filter, "Filter..."   +Chr(9)+"F")
  MenuItem(#Menu_Interpolate, "Interpolate..."   +Chr(9)+"I")
  MenuItem(#Menu_Translate, "Translate..."+Chr(9)+"T")
  MenuItem(#Menu_Graph_math, "Graph Math..."  +Chr(9)+"Ctrl+A")
  MenuItem(#Menu_Add_constant, "Add Constant Graph..."  +Chr(9)+"N")
  MenuItem(#Menu_Scaling, "Scaling..."+Chr(9)+"S")
  MenuBar()
  MenuItem(#Menu_Copy_to_Clipboard, "Copy to Clipboard")
  MenuItem(#Menu_Save_as_png, "Save as .png...")
  MenuItem(#Menu_Save_as_emf, "Save as .emf...")
  AddKeyboardShortcut(#Win_plot,#PB_Shortcut_C,26)
  CreatePopupMenu(#Menu_popup)
  MenuItem(#Menu_Select_all, "Select all"+Chr(9)+"A")
  MenuItem(#Menu_Deselect_all, "Deselect all"   +Chr(9)+"D")
  MenuItem(#Menu_Edit_metadata, "Edit meta data..."  +Chr(9)+"Ctrl+M")
  MenuItem(#Menu_Appearance, "Appearance..."+Chr(9)+"Ctrl+T")
  MenuBar()
  OpenSubMenu("Entry")
  ;     MenuItem(#Menu_Edit_entry, "Edit..."+Chr(9)+"E")
  MenuItem(#Menu_Rename_entry, "Rename..."+Chr(9)+"R")
  MenuItem(#Menu_Duplicate_entry, "Duplicate"+Chr(9)+"Ctrl+D")
  MenuItem(#Menu_Delete_entry, "Delete"+Chr(9)+"Del")
  CloseSubMenu()
  MenuBar()
  OpenSubMenu("List")
  MenuItem(#Menu_Rename_list, "Rename..."+Chr(9)+"Alt+R")
  MenuItem(#Menu_Delete_list, "Delete"+Chr(9)+"Alt+Del")
  MenuItem(#Menu_Duplicate_list, "Duplicate"+Chr(9)+"Alt+D")
  MenuItem(#Menu_Consolidate_lists, "Consolidate"+Chr(9)+"Alt+C")
  MenuItem(#Menu_Aggregate_lists, "Aggregate..."+Chr(9)+"Alt+A")
  MenuItem(#Menu_Delete_empty_entries,"Delete empty entries")
  MenuItem(#Menu_Crop_List,"Crop List to Selection"+Chr(9)+"Ctrl+C")
  CloseSubMenu() 
  
  AddKeyboardShortcut(#Win_Plot,#PB_Shortcut_F3,#Menu_Search_selection)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_T, #Menu_Appearance)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_O, #Menu_Open)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_R, #Menu_Load_Autosave)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_S, #Menu_Save)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_S, #Menu_Save_as)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_I, #Menu_Import)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_E, #Menu_Export)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_G, #Menu_Grid_ysec)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Escape, #Menu_Quit)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_A, #Menu_Graph_math)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_D, #Menu_Deselect_all)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_M, #Menu_Edit_metadata)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_C, #Menu_Crop_List)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_U, #Menu_Undelete)
  ;   AddKeyboardShortcut(#Win_plot, #PB_Shortcut_E, #Menu_Edit_entry)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_M, #Menu_Mark_all)
  ;AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Delete, 12)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_Delete, #Menu_Delete_list)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_D, #Menu_Duplicate_list)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_R, #Menu_Rename_list)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Control|#PB_Shortcut_Delete, #Menu_Delete_comments)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_F, #Menu_Filter)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_I, #Menu_Interpolate)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_T, #Menu_Translate)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_A, #Menu_Select_all)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_N, #Menu_Add_constant)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_S, #Menu_Scaling)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_G, #Menu_Grid_x)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_R, #Menu_Rename_entry)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_E, #Menu_Merge_entries)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_L, #Menu_Merge_lists)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_C, #Menu_Consolidate_lists)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_F, #Menu_EC_correction)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_H, #Menu_Eh_correction)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_A, #Menu_Aggregate_lists)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_M, #Menu_Mark_specififed)
  AddKeyboardShortcut(#Win_plot, #PB_Shortcut_Alt|#PB_Shortcut_G, #Menu_Grid_y)
  
  
EndProcedure  

init() 

open_window()
OpenWindow(#Win_Plot,0,0,scrwidth,scrheight,"Plot",#PB_Window_SystemMenu | #PB_Window_SizeGadget )
OpenWindowedScreen(WindowID(#Win_Plot),0,0,scrwidth,scrheight,0,0,0)
!fldcw[v_FPU_ControlWord]
set_menus()
transfer_values(0)
If restore_data:load_autosave():EndIf
Repeat
  
  If IsWindow(#Win_Plot)
    If Not (scrheight=WindowHeight(#Win_Plot) And scrwidth=WindowWidth(#Win_Plot)) And IsScreenActive()
      scrheight=WindowHeight(#Win_Plot)
      scrwidth=WindowWidth(#Win_Plot)
      CloseScreen()
      OpenWindowedScreen(WindowID(#Win_Plot),0,0,scrwidth,scrheight,0,0,0)
      !fldcw[v_FPU_ControlWord]
      changed=1
    EndIf
  EndIf 
  If Not GetActiveWindow()=#win_plot:rersterklick=0:EndIf
  If unsaved:SetWindowTitle(#Win_Plot,"Plot (*)"):Else:SetWindowTitle(#Win_Plot,"Plot"):EndIf
  If Not changed:event=WaitWindowEvent(60000):Else:event=WindowEvent():EndIf
  If ElapsedMilliseconds()-elapsedtime>300000:elapsedtime=ElapsedMilliseconds():auto_save():EndIf
  ExamineKeyboard()
  transfer_values(0)
  check_buttons(event)
  If GetActiveWindow()=#Win_Plot
    get_mouse(event)
  EndIf
  If GetActiveWindow()=#Win_para
    mx=WindowMouseX(#Win_para)
    my=WindowMouseY(#Win_para)
    If event=#WM_RBUTTONDOWN; And Not ispopup
      If mx>10 And mx<410 And my>50 And my<390
        DisplayPopupMenu(#Menu_popup,WindowID(#Win_para))
      Else
        DisplayPopupMenu(#Menu_popup_import,WindowID(#Win_para))
      EndIf
    EndIf
  EndIf 
  If event=#PB_Event_Menu
    select_from_menu()
  EndIf 
  If selected=-1:changed=0:EndIf
  If (EventType()=#PB_EventType_Change Or changed Or KeyboardReleased(#PB_Key_All)) And Not selected=-1
    set_scale()
    FreeImage(bildchen)
    bildchen=CreateImage(#PB_Any,scrwidth,scrheight)
    If Not draw_plot(bildchen,0):draw_plot(bildchen,0):EndIf
    If IsScreenActive() Or GetActiveWindow()=#Win_Para Or changed
      changed=0
      ClearScreen(RGB(255, 255, 255))
      StartDrawing(ScreenOutput())    
      DrawImage(ImageID(bildchen),0,0)     
      StopDrawing()  
    EndIf
    FlipBuffers()    
  EndIf
  
  If (event=#PB_Event_CloseWindow Or (event=#WM_KEYUP And EventwParam() = #VK_ESCAPE)) And Not (EventWindow()=#win_para Or EventWindow()=#Win_plot)
    CloseWindow(EventWindow())
    transfer_values(1)
  EndIf  
  
  If (event=#PB_Event_CloseWindow Or (event=#WM_KEYUP And EventwParam() = #VK_ESCAPE)) And (EventWindow()=#win_para Or EventWindow()=#Win_plot)
    shut_down()
  EndIf  
  
ForEver 


; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 2888
; FirstLine = 859
; Folding = IABACAAAAIQ+
; EnableXP
; UseIcon = gaea.ico
; Executable = Suite\GAEA.exe
; DisableDebugger
; IncludeVersionInfo
; VersionField0 = 1,0,0,0
; VersionField2 = Uni Jena
; VersionField6 = GAEA
; VersionField9 = Thomas R.
; EnableUnicode