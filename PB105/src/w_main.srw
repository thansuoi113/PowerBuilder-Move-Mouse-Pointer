$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_no from commandbutton within w_main
end type
type cb_yes from commandbutton within w_main
end type
type st_1 from statictext within w_main
end type
type cb_1 from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 1518
integer height = 1020
boolean titlebar = true
string title = "Move Mouse"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_no cb_no
cb_yes cb_yes
st_1 st_1
cb_1 cb_1
end type
global w_main w_main

type prototypes
Function Boolean SetCursorPos(Int cx, Int cy)  Library "User32.dll"
Function Boolean GetCursorPos(Ref str_point POINT)  Library "User32.dll" Alias For "GetCursorPos;Ansi"
Subroutine Sleep(Long lMilliSec) Library "Kernel32.dll"
Function Boolean TrackMouseEvent(ref trackmouseevent lpEventTrack) Library "USER32.DLL"
Function Boolean _TrackMouseEvent(ref trackmouseevent lpEventTrack) Library "COMCTL32.DLL"
FUNCTION ulong ScreenToClient(ulong hwnd,ref str_point lpPoint) LIBRARY "user32.dll"



end prototypes

type variables
Constant ULong WM_MOUSEHOVER                   = 673 //0x02A1
Constant ULong WM_MOUSELEAVE                   = 675 //0x02A3
Constant ULong TME_HOVER       = 1 // 0x00000001
Constant ULong TME_LEAVE       = 2 // 0x00000002
Constant ULong TME_NONCLIENT   = 16 // 0x00000010
Constant ULong TME_QUERY       = 1073741824 // 0x40000000
Constant ULong TME_CANCEL      = 2147483648 // 0x80000000
Constant ULong HOVER_DEFAULT   = 4294967295 // 0xFFFFFFFF
Boolean	ib_mouseover = False
end variables

on w_main.create
this.cb_no=create cb_no
this.cb_yes=create cb_yes
this.st_1=create st_1
this.cb_1=create cb_1
this.Control[]={this.cb_no,&
this.cb_yes,&
this.st_1,&
this.cb_1}
end on

on w_main.destroy
destroy(this.cb_no)
destroy(this.cb_yes)
destroy(this.st_1)
destroy(this.cb_1)
end on

type cb_no from commandbutton within w_main
event mousehover ( )
event mouseleave ( )
event mousemove pbm_mousemove
integer x = 878
integer y = 256
integer width = 329
integer height = 128
integer taborder = 20
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "No"
end type

event mousehover();Integer li_dwx,li_dwy
li_dwx = cb_yes.X //Get the X attribute of the data window (the distance from the left border of the window, the unit is PB Units)
li_dwy = cb_yes.Y //Get the Y attribute of the data window (the distance from the upper border of the window, the unit is PB Units)
li_dwx = UnitsToPixels(li_dwx, XUnitsToPixels!) //Convert X with PB Units to Pixels
li_dwy = UnitsToPixels(li_dwy,YUnitsToPixels!) //Convert Y using PB Units as units to Pixels


Integer li_pdwx,li_pdwy
li_pdwx = Parent.X //Get the X attribute of the data window (the distance from the left border of the window, the unit is PB Units)
li_pdwy = Parent.Y //Get the Y attribute of the data window (the distance from the upper border of the window, the unit is PB Units)
li_pdwx = UnitsToPixels(li_pdwx, XUnitsToPixels!) //Convert X with PB Units to Pixels
li_pdwy = UnitsToPixels(li_pdwy,YUnitsToPixels!) //Convert Y using PB Units as units to Pixels

li_dwx = li_dwx + 40 + li_pdwx
li_dwy = li_dwy +  40 + li_pdwy

SetCursorPos(li_dwx,  li_dwy)




end event

event mousemove;
trackmouseevent lpEventTrack

If Not ib_mouseover Then
	ib_mouseover = True
	
	lpEventTrack.cbSize = 16 //structure is 4 ulongs which is 16 bytes
	lpEventTrack.dwFlags = TME_HOVER + TME_LEAVE
	lpEventTrack.hwndTrack = Handle (This)
	lpEventTrack.dwHoverTime = 100
	//hover time-out (if TME_HOVER was specified in dwFlags), in milliseconds
	
	//if this does not work, try swaping this call with the emulated one below
	//	TrackMouseEvent(lpEventTrack)
	_TrackMouseEvent(lpEventTrack)
End If

end event

event other;Choose Case Message.Number
	Case WM_MOUSEHOVER
		This.TriggerEvent("mousehover")
	Case WM_MOUSELEAVE
		ib_mouseover = False
		This.TriggerEvent("mouseleave")
End Choose


end event

type cb_yes from commandbutton within w_main
event mousehover ( )
integer x = 183
integer y = 256
integer width = 329
integer height = 128
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Yes"
end type

event clicked;Messagebox("Warning", "Yes, I Love You")
end event

type st_1 from statictext within w_main
integer x = 366
integer y = 96
integer width = 731
integer height = 128
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "do you love me?"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_main
integer x = 439
integer y = 736
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Move It"
end type

event clicked;Int i
Long j, k
str_point lstr_point
environment env

GetEnvironment(env)
GetCursorPos(lstr_point)
For i = 0 To 150
	j = lstr_point.posx + i
	If j > env.ScreenWidth Then j = env.ScreenWidth
	
	k = lstr_point.posy - i
	If k > env.ScreenHeight Then k = env.ScreenHeight
	SetCursorPos(j ,  k)
	Sleep(5)
Next

end event

