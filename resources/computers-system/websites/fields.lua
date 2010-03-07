----------------------
-- Template 1 (blue) --
----------------------

-- Website owner's forum name: Jamesc0330
-- Website owner's Character's name: James Fields


function www_fields_sa()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Fields Incorporated") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.fields.sa") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/10.png",false,internet_pane) -- DO NOT REMOVE THE BACKGROUND

	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,76,24,"websites/colours/7.png",false,bg)
	local link_1_hl = guiCreateStaticImage(12,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(2,10,72,16,"Home",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(78,4,76,24,"websites/colours/54.png",false,bg)
	local link_2_hl = guiCreateStaticImage(90,6,50,2,"websites/colours/0.png",false,bg)
	local link_2 = guiCreateLabel(80,10,72,16,"Electricals",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.fields.sa/fieldselectricals") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(156,4,76,24,"websites/colours/54.png",false,bg)
	local link_3_hl = guiCreateStaticImage(168,6,50,2,"websites/colours/0.png",false,bg)
	local link_3 = guiCreateLabel(158,10,72,16,"Sex Shop",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.fields.sa/sexshop") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_1_bg = guiCreateStaticImage(234,4,76,24,"websites/colours/54.png",false,bg)
	local link_1_hl = guiCreateStaticImage(246,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(236,10,72,16,"Club",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(312,4,148,24,"websites/colours/7.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label_shadow,28,28,28)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(324,10,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label,255,255,255)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,460,34,"websites/colours/7.png",false,bg)
	local header_label = guiCreateLabel(15,38,122,16,"Fields Incorporated",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,255,255)
	
	local header_shadow = guiCreateStaticImage(0,61,460,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	local side_text = guiCreateLabel(10,110,105,120,"Fields Incorporated\
												\
												Head Office Address:\
												Fiends Incorporated\
												Fields Complex\
												St Lawerence\
												Los Santos\
												San Andreas",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(107,67,353,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(108,66,353,25,"websites/colours/7.png",false,bg)
	local header_1_ul = guiCreateStaticImage(108,66,353,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(131,70,200,16,"About Fields Incorporated",false,bg)
	local para1 = guiCreateLabel(128,94,329,70,"At Fields incorporated, we take on each business plan as a possible investment, Just because you may have contacted Fields incorporated it does not mean we will buy your company. ",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)	
	
	-- Header 2
	local header_2_bg_shadow = guiCreateStaticImage(107,167,353,25,"websites/colours/13.png",false,bg)
	local header_2_bg = guiCreateStaticImage(108,166,353,25,"websites/colours/7.png",false,bg)
	local header_2_ul = guiCreateStaticImage(108,166,353,1,"websites/colours/1.png",false,bg)
	local header_2 = guiCreateLabel(131,170,200,16,"Ways to Contact us",false,bg)
	local para2 = guiCreateLabel(128,194,329,70,"The best way to contact Fields Incorporated will be by email, please leave you contact details and if we are intrested in your business plan we will be in touch",false,bg) 
	guiLabelSetHorizontalAlign(para2,"left",true)	
	
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,460,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end	
	
end

--=========================================================================================== Sex shop
function www_fields_sa_sexshop()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Fields Incorporated") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.fields.sa/sexshop") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/10.png",false,internet_pane) -- DO NOT REMOVE THE BACKGROUND

	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,76,24,"websites/colours/54.png",false,bg)
	local link_1_hl = guiCreateStaticImage(12,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(2,10,72,16,"Home",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(78,4,76,24,"websites/colours/54.png",false,bg)
	local link_2_hl = guiCreateStaticImage(90,6,50,2,"websites/colours/0.png",false,bg)
	local link_2 = guiCreateLabel(80,10,72,16,"Electricals",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.fields.sa/fieldselectricals") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(156,4,76,24,"websites/colours/7.png",false,bg)
	local link_3_hl = guiCreateStaticImage(168,6,50,2,"websites/colours/0.png",false,bg)
	local link_3 = guiCreateLabel(158,10,72,16,"Sex Shop",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.fields.sa/sexshop") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_1_bg = guiCreateStaticImage(234,4,76,24,"websites/colours/54.png",false,bg)
	local link_1_hl = guiCreateStaticImage(246,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(236,10,72,16,"Club",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(312,4,148,24,"websites/colours/7.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label_shadow,28,28,28)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(324,10,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label,255,255,255)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,460,34,"websites/colours/7.png",false,bg)
	local header_label = guiCreateLabel(15,38,122,16,"Fields Sex Shop",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,255,255)
	
	local header_shadow = guiCreateStaticImage(0,61,460,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	local side_text = guiCreateLabel(10,110,105,120,"Fields Incorporated\
												\
												Head Office Address:\
												Fiends Incorporated\
												Fields Complex\
												St Lawerence\
												Los Santos\
												San Andreas",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(107,67,353,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(108,66,353,25,"websites/colours/7.png",false,bg)
	local header_1_ul = guiCreateStaticImage(108,66,353,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(131,70,200,16,"About Fields Fields Sexshop",false,bg)
	local para1 = guiCreateLabel(128,94,329,70,"We offer great value adult toys for you and your partners.",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)	
	
	-- Header 2
	local header_2_bg_shadow = guiCreateStaticImage(107,167,353,25,"websites/colours/13.png",false,bg)
	local header_2_bg = guiCreateStaticImage(108,166,353,25,"websites/colours/7.png",false,bg)
	local header_2_ul = guiCreateStaticImage(108,166,353,1,"websites/colours/1.png",false,bg)
	local header_2 = guiCreateLabel(131,170,200,16,"What we offer?",false,bg)
	local para2 = guiCreateLabel(128,194,329,70,"We offer lots and lots of fun in the bedroom, we are current stockists of Anna Winters sex toys and Lingerie, we sell dildos and double headed dildos to handcuffs, let your wild dreams come true",false,bg) 
	guiLabelSetHorizontalAlign(para2,"left",true)

	-- Header 3
	local header_3_bg_shadow = guiCreateStaticImage(107,267,353,25,"websites/colours/13.png",false,bg)
	local header_3_bg = guiCreateStaticImage(108,266,353,25,"websites/colours/7.png",false,bg)
	local header_3_ul = guiCreateStaticImage(108,266,353,1,"websites/colours/1.png",false,bg)
	local header_3 = guiCreateLabel(131,270,200,16,"Where are we?",false,bg)
	local para3 = guiCreateLabel(128,294,329,70,"Fields Sexshop is currently located at Jefferson Shopping center, it offers free off street parking and complete descretion",false,bg) 
	guiLabelSetHorizontalAlign(para3,"left",true)		
	
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--================================================================================================== lap dancing club
function www_fields_sa_fieldslapdanceclub()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Fields Incorporated") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.fields.sa/fieldslapdanceclub") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/10.png",false,internet_pane) -- DO NOT REMOVE THE BACKGROUND
	
	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,76,24,"websites/colours/54.png",false,bg)
	local link_1_hl = guiCreateStaticImage(12,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(2,10,72,16,"Home",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(78,4,76,24,"websites/colours/54.png",false,bg)
	local link_2_hl = guiCreateStaticImage(90,6,50,2,"websites/colours/0.png",false,bg)
	local link_2 = guiCreateLabel(80,10,72,16,"Electricals",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.fields.sa/fieldselectricals") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(156,4,76,24,"websites/colours/54.png",false,bg)
	local link_3_hl = guiCreateStaticImage(168,6,50,2,"websites/colours/0.png",false,bg)
	local link_3 = guiCreateLabel(158,10,72,16,"Sex Shop",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.fields.sa/sexshop") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_1_bg = guiCreateStaticImage(234,4,76,24,"websites/colours/7.png",false,bg)
	local link_1_hl = guiCreateStaticImage(246,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(236,10,72,16,"Club",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(312,4,148,24,"websites/colours/7.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label_shadow,28,28,28)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(324,10,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label,255,255,255)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,460,34,"websites/colours/7.png",false,bg)
	local header_label = guiCreateLabel(15,38,122,16,"Fields Lap Dancing Club",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,255,255)
	
	local header_shadow = guiCreateStaticImage(0,61,460,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	local side_text = guiCreateLabel(10,110,105,120,"Fields Incorporated\
												\
												Head Office Address:\
												Fiends Incorporated\
												Fields Complex\
												St Lawerence\
												Los Santos\
												San Andreas",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(107,67,353,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(108,66,353,25,"websites/colours/7.png",false,bg)
	local header_1_ul = guiCreateStaticImage(108,66,353,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(131,70,200,16,"About Fields Fields Lapdance Club",false,bg)
	local para1 = guiCreateLabel(128,94,329,70,"We offer great value adult entertainment, we offer the fineist girls who have to pass auditions before being allowed to work in our club, our girls will be avalible for you to have a private session with our girls in our completly private VIP area, where you will have the the best lapdance of your life.",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)	
	
	-- Header 2
	local header_2_bg_shadow = guiCreateStaticImage(107,167,353,25,"websites/colours/13.png",false,bg)
	local header_2_bg = guiCreateStaticImage(108,166,353,25,"websites/colours/7.png",false,bg)
	local header_2_ul = guiCreateStaticImage(108,166,353,1,"websites/colours/1.png",false,bg)
	local header_2 = guiCreateLabel(131,170,200,16,"Employment",false,bg)
	local para2 = guiCreateLabel(128,194,329,70,"We are always looking for new talent, if you are female and intrested then drop us a email and we will be intouch",false,bg) 
	guiLabelSetHorizontalAlign(para2,"left",true)

	-- Header 3
	local header_3_bg_shadow = guiCreateStaticImage(107,267,353,25,"websites/colours/13.png",false,bg)
	local header_3_bg = guiCreateStaticImage(108,266,353,25,"websites/colours/7.png",false,bg)
	local header_3_ul = guiCreateStaticImage(108,266,353,1,"websites/colours/1.png",false,bg)
	local header_3 = guiCreateLabel(131,270,200,16,"Where are we?",false,bg)
	local para3 = guiCreateLabel(128,294,329,70,"We are curently Located Next to Fire Department Near St Lawerence",false,bg) 
	guiLabelSetHorizontalAlign(para3,"left",true)		
	
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--=================================================================================================== electricals
function www_fields_sa_fieldselectricals()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Fields Incorporated") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.fields.sa/fieldselectricals") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,460,page_length,"websites/colours/10.png",false,internet_pane) -- DO NOT REMOVE THE BACKGROUND

	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,76,24,"websites/colours/7.png",false,bg)
	local link_1_hl = guiCreateStaticImage(12,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(2,10,72,16,"Home",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(78,4,76,24,"websites/colours/7.png",false,bg)
	local link_2_hl = guiCreateStaticImage(90,6,50,2,"websites/colours/0.png",false,bg)
	local link_2 = guiCreateLabel(80,10,72,16,"Electricals",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.fields.sa/fieldselectricals") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(156,4,76,24,"websites/colours/54.png",false,bg)
	local link_3_hl = guiCreateStaticImage(168,6,50,2,"websites/colours/0.png",false,bg)
	local link_3 = guiCreateLabel(158,10,72,16,"Sex Shop",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.fields.sa/sexshop") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_1_bg = guiCreateStaticImage(234,4,76,24,"websites/colours/54.png",false,bg)
	local link_1_hl = guiCreateStaticImage(246,6,50,2,"websites/colours/1.png",false,bg)
	local link_1 = guiCreateLabel(236,10,72,16,"Club",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.Fields.sa/fieldslapdanceclub") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(312,4,148,24,"websites/colours/54.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label_shadow,28,28,28)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(324,10,130,16,"www.Fields.sa",false,bg)
	guiLabelSetColor(url_label,255,255,255)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,460,34,"websites/colours/7.png",false,bg)
	local header_label = guiCreateLabel(15,38,122,16,"Fields Electricals Outlet",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,255,255)
	
	local header_shadow = guiCreateStaticImage(0,61,460,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	local side_text = guiCreateLabel(10,110,105,120,"Fields Incorporated\
												\
												Head Office Address:\
												Fiends Incorporated\
												Fields Complex\
												St Lawerence\
												Los Santos\
												San Andreas",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(107,67,353,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(108,66,353,25,"websites/colours/7.png",false,bg)
	local header_1_ul = guiCreateStaticImage(108,66,353,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(131,70,200,16,"About Fields Electricals Outlets",false,bg)
	local para1 = guiCreateLabel(128,94,329,70,"At Fields Electricals Outlets, We strive on family values, we like to offer the best custer service just like the old days with a modern twist.  All Our staff are fully trained to answer your any questions you may have",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)	
	
	-- Header 2
	local header_2_bg_shadow = guiCreateStaticImage(107,167,353,25,"websites/colours/13.png",false,bg)
	local header_2_bg = guiCreateStaticImage(108,166,353,25,"websites/colours/7.png",false,bg)
	local header_2_ul = guiCreateStaticImage(108,166,353,1,"websites/colours/1.png",false,bg)
	local header_2 = guiCreateLabel(131,170,200,16,"What we offer",false,bg)
	local para2 = guiCreateLabel(128,194,329,70,"We can supply you with the modern electricals, from radios to cellphones, MP3 players to ghetto blasters, from satnavs to safes, Laptops to katanas, we are fairly sure that when you visit our stores that you wont be disapointed",false,bg) 
	guiLabelSetHorizontalAlign(para2,"left",true)

	-- Header 3
	local header_3_bg_shadow = guiCreateStaticImage(107,267,353,25,"websites/colours/13.png",false,bg)
	local header_3_bg = guiCreateStaticImage(108,266,353,25,"websites/colours/7.png",false,bg)
	local header_3_ul = guiCreateStaticImage(108,266,353,1,"websites/colours/1.png",false,bg)
	local header_3 = guiCreateLabel(131,270,200,16,"Where are we?",false,bg)
	local para3 = guiCreateLabel(128,294,329,70,"We currently have 3 stores situated over Los Santos, we have branches at Unity, Market and West Broadway ",false,bg) 
	guiLabelSetHorizontalAlign(para3,"left",true)		
	
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end