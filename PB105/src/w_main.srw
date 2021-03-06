$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type tv_multi from u_tv within w_main
end type
end forward

global type w_main from window
integer width = 1349
integer height = 1596
boolean titlebar = true
string title = "Multi Select TreeView"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
tv_multi tv_multi
end type
global w_main w_main

on w_main.create
this.tv_multi=create tv_multi
this.Control[]={this.tv_multi}
end on

on w_main.destroy
destroy(this.tv_multi)
end on

event open;TreeViewItem ltvi_root
TreeViewItem ltvi_node

Integer li_index
Integer li_items = 5
Long ll_lev0
Long ll_lev1
Long ll_lev2
String	ls_list
String	ls_root = 'Non-mutually exclusive items'

ltvi_root.PictureIndex = 1
ltvi_root.SelectedPictureIndex = 1

ltvi_node.PictureIndex = 2
ltvi_node.SelectedPictureIndex = 2
ltvi_node.StatePictureIndex = 1

// Root
ltvi_root.Label = ls_root
ll_lev1 = tv_multi.InsertItemLast(0, ltvi_root)

// Nodes
For li_index = 1 To li_items
	ltvi_node.Label = "Item " + String(li_index)
	ll_lev2 = tv_multi.InsertItemLast(ll_lev1, ltvi_node)
Next

ll_lev0 = tv_multi.FindItem(RootTreeItem!, 0)
tv_multi.ExpandAll(ll_lev0)

// Radio buttons.
String ls_items[3]
String ls_blank[3]

// root
ltvi_root.PictureIndex = 4
ltvi_root.SelectedPictureIndex = 4
ltvi_root.Label = 'Mutually exclusive items'
ll_lev1 = tv_multi.InsertItemLast(0, ltvi_root)

// nodes
ls_items = ls_blank
ls_items[1] = 'Item 1'
ls_items[2] = 'Item 2'
ls_items[3] = 'Item 3'

li_items = UpperBound(ls_items)
For li_index = 1 To li_items - 1
	ltvi_node.Label = ls_items[li_index]
	ltvi_node.PictureIndex = 5
	ltvi_node.SelectedPictureIndex = 5
	ltvi_node.StatePictureIndex = 3
	ll_lev2 = tv_multi.InsertItemSort(ll_lev1, ltvi_node)
Next

ltvi_node.Label = ls_items[3]
ltvi_node.PictureIndex = 6
ltvi_node.SelectedPictureIndex = 6
ll_lev2 = tv_multi.InsertItemSort(ll_lev1, ltvi_node)
tv_multi.Of_SelectItem(ll_lev2 - 2, True)

ll_lev0 = tv_multi.FindItem(RootTreeItem!, 0)
tv_multi.ExpandAll(ll_lev0)
ll_lev0 = tv_multi.FindItem(NextTreeItem!, ll_lev0)
tv_multi.ExpandAll(ll_lev0)

end event

type tv_multi from u_tv within w_main
integer x = 37
integer y = 32
integer width = 1207
integer height = 1312
string picturename[] = {"Library!","Window!","RunWindow!","Library!","ViewPainter!","WebPBWizard!"}
end type

