-------------------------
-- Best's Towing & Recovery --
-------------------------

-- Website owner's forum name: livelethal
-- Website owner's Character's name: Patrick Andersson
------------------------CONTACT FOR ADJUSTMENTS AND BUGS:-----------------------------------
-- Website builder's forum name: Morgfarm1
-- Website builder's Character's name: Dale Greene

function www_beststowing_sa()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Home")
	guiSetText(address_bar,"www.beststowing.sa")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,242,"websites/colours/1.png",false,bg)
	local left_content_bg_lower = guiCreateStaticImage(5,383,450,335,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	local latest_news_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local latest_news_title = guiCreateLabel(10,92,450,20,"Welcome to BT&R!",false,bg)
	guiSetFont(latest_news_title,"default-bold-small")
	
	--------------- headline ------------
	local top_story_headline =  guiCreateLabel(10,279,440,16,"Who we Are",false,bg)
	guiLabelSetColor(top_story_headline,0,0,0)
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.beststowing.sa/aboutus")
			get_page(url)
		end,false)

	-- Summary
	local top_story_summary =  guiCreateLabel(10,306,440,64,"Click here for information about what BT&R does for you.",false,bg)
	guiLabelSetColor(top_story_summary,38,38,38)
	guiLabelSetHorizontalAlign(top_story_summary,"left",true)
	
	------------- Other News -------------
	local other_news_header_bg = guiCreateStaticImage(0,360,455,22,"websites/colours/0.png",false,bg)
	local other_news_title = guiCreateLabel(10,362,450,20,"More Information",false,bg)
	guiSetFont(other_news_title,"default-bold-small")
	
	-- Article 2--------------------------------------------------------------------------------------------------------------------------------------
		-- bullet point
		local  story_2_bp = guiCreateStaticImage(10,405,6,6,"websites/images/dots/yellow_dot.png",false,bg)
		-- headline
		local story_2_hl = guiCreateLabel(20,388,435,16,"Looking for work?",false,bg)
		guiLabelSetColor(story_2_hl,0,0,0)
		addEventHandler("onClientGUIClick",story_2_hl,function()
			local url = tostring("www.beststowing.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- first line
		local story_2_summary = guiCreateLabel(18,412,435,16,"If you are searching for a job with BT&R, please click the link to your right.",false,bg)
		guiLabelSetColor(story_2_summary,38,38,38)
		guiLabelSetHorizontalAlign(story_2_summary,"left",true)
	
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
	----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

---------------------------------------------------------------
--------------------------- Stories ---------------------------
---------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------- LOS SANTOS EMERGENCY SERVICES HITTING THE FLOOR?

function www_beststowing_sa_aboutus()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - About Us")
	guiSetText(address_bar,"www.beststowing.sa/aboutus")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Best's Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"Everyone at BT&R Strives to give you fast service at an affordable rate and exceptional quality.\Our Specialty is the towing of obstructive vehicles and\
	the repair of your damaged ones. We also do automotive paint, modifications and roadside assistance.\
	Visit the Services section for information about these services",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end


--------------------------------------------------------------------------------------------------------------------------- Tragedy on the tracks

function www_beststowing_sa_jobs()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Employment")
	guiSetText(address_bar,"www.beststowing.sa/jobs")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Employment at BT&R",false,bg)
	guiSetFont(title,"default-bold-small")

	-- Article
	local article =  guiCreateLabel(10,320,440,410,"If you seek a job at BT&R, we have a few requirements you must meet. First, You must be 18 years of age or older. Second, no major criminal backround, and you must also have a Valid State of San Andreas Driver's License\
	You must also know the rules of the road, as stated in the 'Los Santos Highway Code' Driver's manual. A criminal History may or may not be a factor in your potential hiring, but is always considered.\
	To Apply,Visit the 'Apply at BT&R' Section of this website. Please leave your name, daytime and night time phone numbers, and Reasons why you think\
	You should be considered for work at Best's Towing and Revcovery.\
	All necesarry questions are on the page.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--------------------------------------------------------------------------------------------------------------------------- Impound Lot Auction

function www_beststowing_sa_999()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - About Our Hotline")
	guiSetText(address_bar,"www.beststowing.sa/999")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Proper Use of 999",false,bg)
	guiSetFont(title,"default-bold-small")

	-- Article
	local article =  guiCreateLabel(10,318,440,410,"999 Is used for all service calls. When you call, our operator will ask you your location, and whats wrong.\ When you call BT&R, please wait atleast 15 to 20 minutes, depending on how busy the city is. Your Response time should never be more than 20 minutes. If time exceeds 20 minutes, call again.\
	Please do not call every 5 to 10 minutes, as we will likely ignore calls from that area until further notice. we do not like pushy and impatient people. We do the best we can. DO NOT USE THE GPS SIGNAL UNLESS AUTHORIZED BY BT&R STAFF. That signal is designated for Police and Emergency Services use.\
	If you have to call more than twice, and you see our Black & Green towtrucks are about, you may report it at the link to your right and it will be properly dealt with.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--------------------------------------------------------------------------------------------------------------------------- Corruption in BT&R
-- Report Center
function www_beststowing_sa_report()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Report A Driver")
	guiSetText(address_bar,"www.beststowing.sa/report")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"About Best's Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"To report unanswered calls or drivers, please e-mail one of our Head Drivers. Dale Greene: D.Greene@btr.sa or James Fields: J.Fields@btr.sa. Please leave your name, daytime phone number and the location of your call.\
	If you are reporting a driver, Also tell us the drivers name and the time the incident occoured. (( Or visit the forums and report a driver through there ))",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end

--------------------------------------------------------------------------------------------------------------------------- Corruption in BT&R
-- Services
function www_beststowing_sa_services()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Services")
	guiSetText(address_bar,"www.beststowing.sa/services")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"BT&R Services",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"BT&R Offers a wide range of services for todays auto owner and commuter. Not only do we specialize in towing, we also do mechanic work.\
	All BT&R Drivers are trained mechanics. We can do anything from a minor body repair or tank top off, to extensive modifications ((Mods currently disbled server-side)). All you have to do is call our hotline at 999.\
	Our Basic Pricing is as follows:\
	\
	Body Repairs: $50-100, depending on severity.\
	\
	Full Service Repairs: $100-200, Depending on what needs done & Severity of existing damage\
	\
	Fuel: $15-20 per can (Quarter Tank) or up to $150 for a full tank, depending on how far we have to travel.\
	\
	Paint: $100-200, depending on if the vehicle has 1, 2, 3 or more color options ((ID sets))\
	\
	Modifications: All modifications differ in price, usually from $2500 to $9000 PER PART, depending on the part(s)\
	\
	SPECIAL NOTICE: Any and all Special paint jobs have a minimum charge of $7800, INCLUDING THE REMOVAL OF SUCH PAINT JOBS.\
	A Special paint job change with a regular paint change (( Changes the tone and appearance of the skin )) will cost between $7900 and $8000, No exceptions.\
	\
	Towing: We have no set price for the towing or the recovery of wrecked cars. However, if we have to travel long distances, you may be charged a fee to travel to, repair and right your vehicle."
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
end
----------------------------------------------------------------------

-- Contact

function www_beststowing_sa_contact()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Contact")
	guiSetText(address_bar,"www.beststowing.sa/contact")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Contact",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"How to Contact the Bosses of BT&R:\
	Owner/CEO Patrick Andersson: P.Andersson@btr.sa\
	Head Driver Dale Greene: email D.Greene@btr.sa\
	Head Driver James Fields: email J.Fields@btr.sa\
	Lead Driver Rachel Wood: No contact information at this time"
 	,false,bg)
 	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
end
----------------------------------------------------------------------

-- Drivers
function www_beststowing_sa_drivers()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Drivers")
	guiSetText(address_bar,"www.beststowing.sa/drivers")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"The Bosses of BT&R",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateLabel(10,318,440,410,"Owner & CEO: Patrick Andersson\
	Head Driver: Dale Greene\
	Co-Head Driver: James Fields\
	Lead Driver: Rachel Wood\
	Training Division (Experimental Division):Ashley Greene, Jimmy Queen"
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
				
	------------
	-- Footer --
	------------
end
	
-- Apply Part 1
function www_beststowing_sa_apply()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Applications (Beta)")
	guiSetText(address_bar,"www.beststowing.sa/apply")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
		
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Part 1 - IC Section",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateMemo(10,318,440,375,"To Apply at Best's Towing & Recovery, Please answer these questions HONESTLY AND COMPLETELY.\
	Your Name:\
	Age:\
	Daytime & Nighttime Phone number(s):\
	Address (If Available):\
	Native Language:\
	Past Employment:\
	Reasons for quitting and or Firing:\
	Past Experience in Auto Mechanics?\
	Ever Been Employed Here before?\
	Currently Employed?\
	\
	May we run a criminal background check and or a drug screening? (Are usually random):\
	Have you been convicted of a Felony or major crimes?:\
	If yes to the previous question, explain:\
	(( Copy and paste this page after filling in answers,)) Foreward to: D.Greene@btr.sa with 'BT&R Application, Part 1' in the subject line."
	,false,bg)
	
	-- Page 2 Link
	local continue_link = guiCreateLabel(10,690,440,16,"Continue to Page 2",false,bg)
	guiLabelSetColor(continue_link,38,38,38)
	guiSetFont(continue_link,"default-bold-small")
	guiLabelSetHorizontalAlign(continue_link,"right")
	addEventHandler("onClientGUIClick",continue_link,function()
		local url = tostring("www.beststowing.sa/apply_2")
		get_page(url)
	end,false)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
end
--------------------------------------------------------------------------------------------------------
-- Apply Part 2
function www_beststowing_sa_apply_2()

	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "Best's Towing & Recovery - Applications Part 2 (Beta)")
	guiSetText(address_bar,"www.beststowing.sa/apply_2")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/44.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local btr_logo = guiCreateStaticImage(5,0,659,73,"websites/images/btr-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/0.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.beststowing.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Info
		local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/0.png",false,btr_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Services",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.beststowing.sa/services") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Drivers
		local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/0.png",false,btr_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Drivers",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.beststowing.sa/drivers")
			get_page(url)
		end,false)
		
		-- 
		local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/0.png",false,btr_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Contact",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.beststowing.sa/contact")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/towtruck.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/0.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Application - Part 2",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Text
	local article =  guiCreateMemo(10,318,440,410,"Part 2 - OOC Section\
	RL Age:\
	Gender:\
	Timezone:\
	Game Activity (average hours/day):\
	Forums Activity:\
	Any Admin jails, kicks or warnings? if so, state Why:\
	Why Do you want to Join BT&R? (Long answer):\
	Do you know and understand fully and completly the server rules?:\
	\
	YOU ARE BOUND BY FACTION RULES ONCE ACCPTED, THIS MEANS:\
	Absolutly NO Alts\
	You are not allowed to tow any vehicle that is parked legally\
	You may not /park a towtruck FOR ANY REASON unless otherwise stated by a BT&R leader\
	You are to be courteous and respect all other players and BT&R members\
	\
	NOTICE: WE MAY AND PROBABLY WILL CHECK YOUR ADMINISTRATOR RECORDS, DONT FUDGE THEM HERE!\
	By Submitting this application, you understand and agree to the faction rules, and if the rules are violated, you realize you can and likely will be kicked from the BT&R faction\
	(( Copy and paste this page after filling in answers,)) Foreward to: D.Greene@btr.sa with 'BT&R Application, Part 2' in the subject line."
	,false,bg)
	
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/0.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"More Information",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- BT&R Info
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"About BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/aboutus")
				get_page(url)
			end,false)
		
		-- BT&R Employment
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"Working for BT&R",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.beststowing.sa/jobs")
				get_page(url)
			end,false)

		-- Abuse of Hotline
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"About 999",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.beststowing.sa/999")
				get_page(url)
			end,false)
	
		-- Report Drivers
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Report a Driver",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.beststowing.sa/report")
				get_page(url)
			end,false)
			
			-- Applications
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/black_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,178,142,16,"Apply at BT&R",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.beststowing.sa/apply")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/6.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"BTR       2010 Best's Towing & Recovery",false,bg)
	guiSetFont(footer_text,"default-small")
	
	local copyright = guiCreateStaticImage(38,739,12,12,"websites/images/copyright.png",false,bg)
--------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------	
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end