$PBExportHeader$u_tv.sru
forward
global type u_tv from treeview
end type
type os_point from structure within u_tv
end type
type os_tvhittestinfo from structure within u_tv
end type
end forward

type os_point from structure
	long		l_x
	long		l_y
end type

type os_tvhittestinfo from structure
	os_point		str_pt
	long		l_flags
	long		l_hitem
end type

global type u_tv from treeview
integer width = 503
integer height = 368
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string picturename[] = {"DatabaseProfile!"}
integer picturewidth = 16
integer pictureheight = 16
long picturemaskcolor = 12632256
string statepicturename[] = {"state0.bmp","state1.bmp","radio0.bmp","radio1.bmp"}
integer statepicturewidth = 16
integer statepictureheight = 16
long statepicturemaskcolor = 16777215
event mousemove pbm_mousemove
end type
global u_tv u_tv

type prototypes
Function Long HitMsg(Long hWindow, UInt Msg, Long wParam,  Ref os_tvhittestinfo lParam) Library 'user32.dll' Alias for "SendMessageA;Ansi"
end prototypes

type variables
Public:
Constant UInt	TVM_HITTEST = 4369
Constant UInt	TVHT_ONITEMSTATEICON = 64

Protected:
Boolean		ib_stateclick

Long		il_handle

end variables
forward prototypes
public function boolean of_isselected (long al_handle)
public function integer of_deselectall ()
public function integer of_deselectall (long al_root)
public function integer of_selectitem (long al_handle, boolean ab_switch)
public function integer of_getselecteditems (long al_root, ref any aa_data[])
public function integer of_getselecteditems (ref any aa_data[])
public function integer of_selectall (long al_root)
public function integer of_selectall ()
public function integer of_getselecteditems (long al_root, ref long al_handles[])
public function integer of_getselecteditems (ref long al_handles[])
public function integer of_getselecteditems (long al_root, ref string as_strings[])
public function integer of_getselecteditems (ref string as_strings[])
end prototypes

event mousemove;os_tvhittestinfo lstr_tvhittest


lstr_tvhittest.str_pt.l_x = UnitsToPixels(xpos, XUnitsToPixels!)
lstr_tvhittest.str_pt.l_y = UnitsToPixels(ypos, YUnitsToPixels!)

HitMsg(il_handle, TVM_HITTEST, 0, lstr_tvhittest)

If lstr_tvhittest.l_hItem <> 0 Then
	ib_stateclick = (lstr_tvhittest.l_flags = TVHT_ONITEMSTATEICON)
End If

end event

public function boolean of_isselected (long al_handle);TreeViewItem ltvi_node
Long ll_rc

ll_rc = This.GetItem(al_handle, ltvi_node)

If ll_rc > 0 Then
	Return ltvi_node.StatePictureIndex = 2 Or ltvi_node.StatePictureIndex = 4
End If

Return False

end function

public function integer of_deselectall ();Integer li_rc = 1
Long ll_root
Long ll_count

ll_root = FindItem(RootTreeItem!, 0)

If ll_root > 0 Then
	This.Of_DeSelectAll(ll_root)
	ll_root = This.FindItem(NextTreeItem!, ll_root)
	Do While ll_root > 0
		This.Of_DeSelectall(ll_root)
		ll_root = This.FindItem(NextTreeItem!, ll_root)
	Loop
Else
	li_rc = 0
End If

Return li_rc

end function

public function integer of_deselectall (long al_root);TreeViewItem ltvi_node
Integer li_rc
Long ll_root
Long ll_count

If al_root > 0 Then
	ll_root = al_root
	Do
		ll_root = FindItem(ChildTreeItem!, ll_root)
		Do
			This.GetItem(ll_root, ltvi_node)
			If ltvi_node.StatePictureIndex = 2 Then
				ltvi_node.StatePictureIndex = 1
				This.SetItem(ll_root, ltvi_node)
			End If
			ll_root = This.FindItem(NextTreeItem!, ll_root)
		Loop While ll_root > 0
	Loop While ll_root > 0
End If

Return li_rc

end function

public function integer of_selectitem (long al_handle, boolean ab_switch);TreeViewItem ltvi_node
Integer li_rc
Long ll_handle

If al_handle > 0 Then
	This.GetItem(al_handle, ltvi_node)
	If ab_switch Then
		Choose Case ltvi_node.StatePictureIndex
			Case 1
				ltvi_node.StatePictureIndex = 2 // Check Box
				This.SetItem(al_handle, ltvi_node)
				li_rc = 1
			Case 3
				ltvi_node.StatePictureIndex = 4 // Check Radio
				This.SetItem(al_handle, ltvi_node)
				
				// Uncheck all sibling radio buttons.
				ll_handle = al_handle
				Do While ll_handle <> -1
					ll_handle = This.FindItem(PreviousTreeItem!, ll_handle)
					If ll_handle > 0 Then
						This.GetItem(ll_handle, ltvi_node)
						If ltvi_node.StatePictureIndex = 4 Then
							ltvi_node.StatePictureIndex = 3
							This.SetItem(ll_handle, ltvi_node)
						End If
					End If
				Loop
				ll_handle = al_handle
				Do While ll_handle <> -1
					ll_handle = This.FindItem(NextTreeItem!, ll_handle)
					If ll_handle > 0 Then
						This.GetItem(ll_handle, ltvi_node)
						If ltvi_node.StatePictureIndex = 4 Then
							ltvi_node.StatePictureIndex = 3
							This.SetItem(ll_handle, ltvi_node)
						End If
					End If
				Loop
				li_rc = 1
		End Choose
	Else
		Choose Case ltvi_node.StatePictureIndex
			Case 2
				ltvi_node.StatePictureIndex = 1 // Uncheck Box
				This.SetItem(al_handle, ltvi_node)
				li_rc = 1
				
			Case 4
				// Cannot uncheck radio -- Only through checking another item.
				li_rc = 0
		End Choose
	End If
End If

Return li_rc

end function

public function integer of_getselecteditems (long al_root, ref any aa_data[]);TreeViewItem ltvi_node
Integer li_rc
Long ll_root
Long ll_count

If al_root > 0 Then
	ll_root = al_root
	Do
		ll_root = This.FindItem(ChildTreeItem!, ll_root)
		Do
			This.GetItem(ll_root, ltvi_node)
			If ltvi_node.StatePictureIndex = 2 Or ltvi_node.StatePictureIndex = 4 Then
				ll_count = UpperBound( aa_data[] ) + 1
				aa_data[ll_count] = ltvi_node.Data
			End If
			ll_root = This.FindItem(NextTreeItem!, ll_root)
		Loop While ll_root > 0
	Loop While ll_root > 0
End If

Return li_rc

end function

public function integer of_getselecteditems (ref any aa_data[]);TreeViewItem ltvi_node
Integer li_rc = 1
Long ll_root
Long ll_count

ll_root = This.FindItem(RootTreeItem!, 0)

If ll_root > 0 Then
	This.of_GetSelectedItems(ll_root, aa_data)
	ll_root = This.FindItem(NextTreeItem!, ll_root)
	Do While ll_root > 0
		This.Of_GetSelectedItems(ll_root, aa_data)
		ll_root = This.FindItem(NextTreeItem!, ll_root)
	Loop
Else
	li_rc = 0
End If

Return li_rc

end function

public function integer of_selectall (long al_root);TreeViewItem ltvi_node
Integer li_rc
Long ll_root
Long ll_count

If al_root > 0 Then
	ll_root = al_root
	Do
		ll_root = This.FindItem(ChildTreeItem!, ll_root)
		Do
			This.Of_SelectItem(ll_root, True)
			ll_root = This.FindItem(NextTreeItem!, ll_root)
		Loop While ll_root > 0
	Loop While ll_root > 0
End If

Return li_rc

end function

public function integer of_selectall ();TreeViewItem ltvi_node
Integer li_rc = 1
Long ll_root
Long ll_count

ll_root = This.FindItem(RootTreeItem!, 0)

If ll_root > 0 Then
	This.Of_SelectAll(ll_root)
	ll_root = This.FindItem(NextTreeItem!, ll_root)
	Do While ll_root > 0
		This.Of_SelectAll(ll_root)
		ll_root = This.FindItem(NextTreeItem!, ll_root)
	Loop
Else
	li_rc = 0
End If

Return li_rc

end function

public function integer of_getselecteditems (long al_root, ref long al_handles[]);TreeViewItem ltvi_node
Integer li_rc
Long ll_root
Long ll_count

If al_root > 0 Then
	ll_root = al_root
	Do
		ll_root = This.FindItem(ChildTreeItem!, ll_root)
		Do
			This.GetItem(ll_root, ltvi_node)
			If ltvi_node.StatePictureIndex = 2 Or ltvi_node.StatePictureIndex = 4 Then
				ll_count = UpperBound(al_handles[]) + 1
				al_handles[ll_count] = ll_root
			End If
			ll_root = This.FindItem(NextTreeItem!, ll_root)
		Loop While ll_root > 0
	Loop While ll_root > 0
End If

Return li_rc

end function

public function integer of_getselecteditems (ref long al_handles[]);TreeViewItem ltvi_node
Integer li_rc = 1
Long ll_root
Long ll_count

ll_root = This.FindItem(RootTreeItem!, 0)

If ll_root > 0 Then
	This.Of_GetSelectedItems(ll_root, al_handles)
	ll_root = This.FindItem(NextTreeItem!, ll_root)
	Do While ll_root > 0
		This.Of_GetSelectedItems(ll_root, al_handles)
		ll_root = This.FindItem(NextTreeItem!, ll_root)
	Loop
Else
	li_rc = 0
End If

Return li_rc

end function

public function integer of_getselecteditems (long al_root, ref string as_strings[]);TreeViewItem ltvi_node
Integer li_rc
Long ll_root
Long ll_count


If al_root > 0 Then
	ll_root = al_root
	Do
		ll_root = This.FindItem(ChildTreeItem!, ll_root)
		Do
			This.GetItem(ll_root, ltvi_node)
			If ltvi_node.StatePictureIndex = 2 Or ltvi_node.StatePictureIndex = 4 Then
				ll_count = UpperBound(as_strings[]) + 1
				as_strings[ll_count] = ltvi_node.Label
			End If
			ll_root = This.FindItem(NextTreeItem!, ll_root)
		Loop While ll_root > 0
	Loop While ll_root > 0
End If

Return li_rc

end function

public function integer of_getselecteditems (ref string as_strings[]);TreeViewItem ltvi_node
Integer li_rc = 1
Long ll_root
Long ll_count

ll_root = This.FindItem(RootTreeItem!, 0)

If ll_root > 0 Then
	This.Of_GetSelectedItems(ll_root, as_strings)
	ll_root = This.FindItem(NextTreeItem!, ll_root)
	Do While ll_root > 0
		This.Of_GetSelectedItems(ll_root, as_strings)
		ll_root = This.FindItem(NextTreeItem!, ll_root)
	Loop
Else
	li_rc = 0
End If

Return li_rc

end function

event clicked;Long ll_rc

If ib_stateclick Then
	ll_rc = This.Of_SelectItem(Handle, Not This.Of_IsSelected(Handle))
End If

Return ll_rc

end event

event constructor;il_handle = Handle(This)

end event

event selectionchanging;If newhandle > 0 Then
	If ib_stateclick Then Return 1
End If

end event

on u_tv.create
end on

on u_tv.destroy
end on

