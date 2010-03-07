-- Website owner's forum name: herbjr
-- Website owner's Character's name: Tony Salvana


function www_lsiflight_sa()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Los Santos International Flight School") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.lsiflight.sa") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,678,page_length,"websites/colours/36.png",false,internet_pane)
		
	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,90,24,"websites/colours/0.png",false,bg)
	local link_1_hl = guiCreateStaticImage(20,6,50,2,"websites/colours/3.png",false,bg)
	local link_1 = guiCreateLabel(2,10,90,16,"News/About Us",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.lsiflight.sa") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(92,4,100,24,"websites/colours/11.png",false,bg)
	local link_2_hl = guiCreateStaticImage(115,6,50,2,"websites/colours/43.png",false,bg)
	local link_2 = guiCreateLabel(83,10,115,16,"Pilot Applications",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.lsiflight.sa/pilota") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(194,4,76,24,"websites/colours/11.png",false,bg)
	local link_3_hl = guiCreateStaticImage(206,6,50,2,"websites/colours/43.png",false,bg)
	local link_3 = guiCreateLabel(195,10,72,16,"Careers",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.lsiflight.sa/careera") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_4_bg = guiCreateStaticImage(272,4,76,24,"websites/colours/11.png",false,bg)
	local link_4_hl = guiCreateStaticImage(285,6,50,2,"websites/colours/43.png",false,bg)
	local link_4 = guiCreateLabel(275,10,72,16,"Contact Us",false,bg)
	guiLabelSetColor(link_4,255,255,255)
	guiLabelSetHorizontalAlign(link_4,"center")
	addEventHandler("onClientGUIClick",link_4,function()
		local url = tostring("www.lsiflight.sa/contact") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(350,4,678,24,"websites/colours/0.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"",false,bg)
	guiLabelSetColor(url_label_shadow,255,0,0)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(460,10,215,16,"You are viewing: WWW.LSIFLIGHT.SA",false,bg)
	guiLabelSetColor(url_label,255,0,0)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,678,34,"websites/colours/0.png",false,bg)
	local header_label = guiCreateLabel(15,38,300,16,"LSI Flight School: \"Giving you your own set of wings!\"",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,0,0)
	
	local header_shadow = guiCreateStaticImage(0,61,678,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	--local side_text = guiCreateLabel(10, 110, 105, 120, "", false, bg)
	local side_text = guiCreateStaticImage(10,110,100,250,"websites/images/lsifsi.png",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(111,67,600,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(112,66,600,25,"websites/colours/0.png",false,bg)
	local header_1_ul = guiCreateStaticImage(112,66,600,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(126,70,200,16,"!> Who are we and What do we do?",false,bg)
	local para1 = guiCreateLabel(128,94,329,150,"\
	The LSI Flight School is a Business based in Los Santos which offers Aviation Training to local Citizens. They specialize in Helicopter, Personal & Commercial Plane operation as well as proper Aviation Radio Usage.\
	\
	..more information coming soon!\
	",false,bg)
	guiLabelSetHorizontalAlign(para1,"left",true)
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,678,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end	
end

--[PILOT APPLICATIONS]
function www_lsiflight_sa_pilota()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 800
	guiSetText(internet_address_label, "Los Santos International Flight School") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.lsiflight.sa/pilota") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,678,page_length,"websites/colours/36.png",false,internet_pane)
		
	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,90,24,"websites/colours/11.png",false,bg)
	local link_1_hl = guiCreateStaticImage(20,6,50,2,"websites/colours/43.png",false,bg)
	local link_1 = guiCreateLabel(2,10,90,16,"News/About Us",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.lsiflight.sa") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(92,4,100,24,"websites/colours/0.png",false,bg)
	local link_2_hl = guiCreateStaticImage(115,6,50,2,"websites/colours/3.png",false,bg)
	local link_2 = guiCreateLabel(83,10,115,16,"Pilot Applications",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.lsiflight.sa/pilota") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(194,4,76,24,"websites/colours/11.png",false,bg)
	local link_3_hl = guiCreateStaticImage(206,6,50,2,"websites/colours/43.png",false,bg)
	local link_3 = guiCreateLabel(195,10,72,16,"Careers",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.lsiflight.sa/careera") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_4_bg = guiCreateStaticImage(272,4,76,24,"websites/colours/11.png",false,bg)
	local link_4_hl = guiCreateStaticImage(285,6,50,2,"websites/colours/43.png",false,bg)
	local link_4 = guiCreateLabel(275,10,72,16,"Contact Us",false,bg)
	guiLabelSetColor(link_4,255,255,255)
	guiLabelSetHorizontalAlign(link_4,"center")
	addEventHandler("onClientGUIClick",link_4,function()
		local url = tostring("www.lsiflight.sa/contact") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(350,4,678,24,"websites/colours/0.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"",false,bg)
	guiLabelSetColor(url_label_shadow,255,0,0)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(460,10,215,16,"You are viewing: WWW.LSIFLIGHT.SA",false,bg)
	guiLabelSetColor(url_label,255,0,0)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,678,34,"websites/colours/0.png",false,bg)
	local header_label = guiCreateLabel(15,38,300,16,"LSI Flight School: \"Giving you your own set of wings!\"",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,0,0)
	
	local header_shadow = guiCreateStaticImage(0,61,678,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	--local side_text = guiCreateLabel(10, 110, 105, 120, "", false, bg)
	local side_text = guiCreateStaticImage(10,110,100,250,"websites/images/lsifsi.png",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(111,67,600,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(112,66,600,25,"websites/colours/0.png",false,bg)
	local header_1_ul = guiCreateStaticImage(112,66,600,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(126,70,320,16,"!> Los Santos International Flight School Pilot Applications",false,bg)
	local para1 = guiCreateLabel(128,94,500,720,"\
If you are a resident of Los Santos and you are planning to or are required to operate any Aircraft vehicle within City limits, you are REQUIRED by the State and the Law to be licensed to do so. In order to receive the proper license, you must register with us to be trained and tested before certified.\
\
To apply for your Aircraft license, please fill out this form and e-mail it to 'pilot@lsiflight.sa' [subject: Pilot Application].\
Application Fee: $15,000\
Certificate Fee: $50,000 for Civilians and $25,000 for ES, PD and SAN members.\
There is a small $15,000 fee for submitting an application. Please send a Check or Money Order along with your application. We will not process your applications with out it.\
\
Name:\
Age:\
Phone Number:\
Address:\
Occupation:\
\
Need License For:\
Reasons:\
Previous Flight Experience[Yes/No]:\
Experience With:\
Licensed?[Yes/No]:\
\
Do you give us permission to preform a background check on you?[Yes/No]:\
Available Date/Time[MM/DD/YYYY @ HH:MM]:\
\
((OOC:\
What are your IC and OOC reason for wanting this Pilots License.))\
	",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,678,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end	
end

--[JOB APPLICATIONS]
function www_lsiflight_sa_careera()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 700
	guiSetText(internet_address_label, "Los Santos International Flight School") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.lsiflight.sa/careera") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,678,page_length,"websites/colours/36.png",false,internet_pane)
		
	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,90,24,"websites/colours/11.png",false,bg)
	local link_1_hl = guiCreateStaticImage(20,6,50,2,"websites/colours/43.png",false,bg)
	local link_1 = guiCreateLabel(2,10,90,16,"News/About Us",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.lsiflight.sa") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(92,4,100,24,"websites/colours/11.png",false,bg)
	local link_2_hl = guiCreateStaticImage(115,6,50,2,"websites/colours/43.png",false,bg)
	local link_2 = guiCreateLabel(83,10,115,16,"Pilot Applications",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.lsiflight.sa/pilota") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(194,4,76,24,"websites/colours/0.png",false,bg)
	local link_3_hl = guiCreateStaticImage(206,6,50,2,"websites/colours/3.png",false,bg)
	local link_3 = guiCreateLabel(195,10,72,16,"Careers",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.lsiflight.sa/careera") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_4_bg = guiCreateStaticImage(272,4,76,24,"websites/colours/11.png",false,bg)
	local link_4_hl = guiCreateStaticImage(285,6,50,2,"websites/colours/43.png",false,bg)
	local link_4 = guiCreateLabel(275,10,72,16,"Contact Us",false,bg)
	guiLabelSetColor(link_4,255,255,255)
	guiLabelSetHorizontalAlign(link_4,"center")
	addEventHandler("onClientGUIClick",link_4,function()
		local url = tostring("www.lsiflight.sa/contact") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(350,4,678,24,"websites/colours/0.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"",false,bg)
	guiLabelSetColor(url_label_shadow,255,0,0)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(460,10,215,16,"You are viewing: WWW.LSIFLIGHT.SA",false,bg)
	guiLabelSetColor(url_label,255,0,0)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,678,34,"websites/colours/0.png",false,bg)
	local header_label = guiCreateLabel(15,38,300,16,"LSI Flight School: \"Giving you your own set of wings!\"",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,0,0)
	
	local header_shadow = guiCreateStaticImage(0,61,678,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	--local side_text = guiCreateLabel(10, 110, 105, 120, "", false, bg)
	local side_text = guiCreateStaticImage(10,110,100,250,"websites/images/lsifsi.png",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(111,67,600,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(112,66,600,25,"websites/colours/0.png",false,bg)
	local header_1_ul = guiCreateStaticImage(112,66,600,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(126,70,315,16,"!> Los Santos International Flight School Job Applications",false,bg)
	local para1 = guiCreateLabel(128,94,500,700,
	"Thank you for your interest in working with this company. We require a bit of information from you to check the quality of your person and check the compatibility of your skills with the position you are applying for. When signing this document and submitting it to our company, you are agreeing to allow us the Legal right to look into your background and use this information to suit our needs.\
\
Full Name:\
AGE+DOB:\
Address:\
Desired Position: [Helicopter or Plane Instructor/Airport Security/Janitor]\
How long have you lived in Los Santos:\
Do you have any flight experience:\
If so, with what:\
Do you or have you ever hold/held a pilots license:\
Current - Last Occupation:\
Last Employer:\
Have you recently committed any crimes:\
If so, when:\
What was the charge:\
Do you agree to a background check:\
((OOC:\
Ventrilo Name:\
Do you have a microphone:\
Age:\
Gender:\
Timezome:\
Location:\
How active are you in-game/forums:))\
\
Please email your application to 'apps@lsiflight.sa' [subject: Job Application] so that we may process it accordingly. Thank You!\ ",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
	else
		guiSetSize(bg,678,700,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end	
end

--[CONTACT US]
function www_lsiflight_sa_contact()
	---------------------
	-- Page Properties --
	---------------------
	local page_length = 390 
	guiSetText(internet_address_label, "Los Santos International Flight School") -- This text is displayed at the top of the browser window when the page is opened. It is the same as the <title> tag used in the meta of a real webpage.
	guiSetText(address_bar,"www.lsiflight.sa/contact") -- The url of the page. This should be the same as the function name but with the original "."s and "/". Example www.google.com.	
	---------------------------------------------- Start of webpage design ----------------------------------------------
	
	----------------------------
	-- Page Background Colour --
	----------------------------
	bg = guiCreateStaticImage(0,0,678,page_length,"websites/colours/36.png",false,internet_pane)
		
	------------
	-- Header --
	------------
	local link_1_bg = guiCreateStaticImage(0,4,90,24,"websites/colours/11.png",false,bg)
	local link_1_hl = guiCreateStaticImage(20,6,50,2,"websites/colours/43.png",false,bg)
	local link_1 = guiCreateLabel(2,10,90,16,"News/About Us",false,bg)
	guiLabelSetColor(link_1,255,255,255)
	guiLabelSetHorizontalAlign(link_1,"center")
	addEventHandler("onClientGUIClick",link_1,function()
		local url = tostring("www.lsiflight.sa") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_2_bg = guiCreateStaticImage(92,4,100,24,"websites/colours/11.png",false,bg)
	local link_2_hl = guiCreateStaticImage(115,6,50,2,"websites/colours/43.png",false,bg)
	local link_2 = guiCreateLabel(83,10,115,16,"Pilot Applications",false,bg)
	guiLabelSetColor(link_2,255,255,255)
	guiLabelSetHorizontalAlign(link_2,"center")
	addEventHandler("onClientGUIClick",link_2,function()
		local url = tostring("www.lsiflight.sa/pilota") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_3_bg = guiCreateStaticImage(194,4,76,24,"websites/colours/11.png",false,bg)
	local link_3_hl = guiCreateStaticImage(206,6,50,2,"websites/colours/43.png",false,bg)
	local link_3 = guiCreateLabel(195,10,72,16,"Careers",false,bg)
	guiLabelSetColor(link_3,255,255,255)
	guiLabelSetHorizontalAlign(link_3,"center")
	addEventHandler("onClientGUIClick",link_3,function()
		local url = tostring("www.lsiflight.sa/careera") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_4_bg = guiCreateStaticImage(272,4,76,24,"websites/colours/0.png",false,bg)
	local link_4_hl = guiCreateStaticImage(285,6,50,2,"websites/colours/3.png",false,bg)
	local link_4 = guiCreateLabel(275,10,72,16,"Contact Us",false,bg)
	guiLabelSetColor(link_4,255,255,255)
	guiLabelSetHorizontalAlign(link_4,"center")
	addEventHandler("onClientGUIClick",link_4,function()
		local url = tostring("www.lsiflight.sa/contact") -- Put hyperlink url in quotation marks
		get_page(url)
	end,false)
	
	local link_end_bg = guiCreateStaticImage(350,4,678,24,"websites/colours/0.png",false,bg)
	local url_label_shadow = guiCreateLabel(325,11,130,16,"",false,bg)
	guiLabelSetColor(url_label_shadow,255,0,0)
	guiLabelSetHorizontalAlign(url_label_shadow,"center")
	local url_label = guiCreateLabel(460,10,215,16,"You are viewing: WWW.LSIFLIGHT.SA",false,bg)
	guiLabelSetColor(url_label,255,0,0)
	guiLabelSetHorizontalAlign(url_label,"center")
	
	local header_bg = guiCreateStaticImage(0,28,678,34,"websites/colours/0.png",false,bg)
	local header_label = guiCreateLabel(15,38,300,16,"LSI Flight School: \"Giving you your own set of wings!\"",false,bg)
	guiSetFont(header_label,"default-bold-smal")
	guiLabelSetColor(header_label,255,0,0)
	
	local header_shadow = guiCreateStaticImage(0,61,678,1,"websites/colours/13.png",false,bg)
	
	-------------
	-- Content --
	-------------
	--local side_text = guiCreateLabel(10, 110, 105, 120, "", false, bg)
	local side_text = guiCreateStaticImage(10,110,100,250,"websites/images/lsifsi.png",false,bg)	
	-- Header 1
	local header_1_bg_shadow = guiCreateStaticImage(111,67,600,25,"websites/colours/13.png",false,bg)
	local header_1_bg = guiCreateStaticImage(112,66,600,25,"websites/colours/0.png",false,bg)
	local header_1_ul = guiCreateStaticImage(112,66,600,1,"websites/colours/1.png",false,bg)
	local header_1 = guiCreateLabel(126,70,200,16,"!> How to Contact Us!",false,bg)
	local para1 = guiCreateLabel(128,94,329,300,"\
	Listed here is how you may get in contact with LSI Flight School\
	\
	\
	Phone:\
	-No Phone Number Listed-\
	\
	E-mail:\
	contact@lsiflight.sa\
	\
	Address:\
	Los Santos International Flight School Administration\
	#1 Los Santos Airport\
	Los Santos, SA 01001\
	",false,bg) 
	guiLabelSetHorizontalAlign(para1,"left",true)
	----------------------------------------------- End of webpage -- Do not edit below this line. -----------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(bg,false,true)
	else
		guiSetSize(bg,678,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end	
end