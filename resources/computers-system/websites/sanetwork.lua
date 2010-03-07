-------------------------
-- San Andreas Network --
-------------------------

-- Website owner's forum name:
-- Website owner's Character's name:

function www_sanetwork_sa()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
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
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/plane_crash.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	local latest_news_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local latest_news_title = guiCreateLabel(10,92,450,20,"Latest News",false,bg)
	guiSetFont(latest_news_title,"default-bold-small")
	
	--------------- headline ------------
	local top_story_headline =  guiCreateLabel(10,279,440,16,"FORTUNATE ESCAPE IN MYSTERIOUS PLANE CRASH",false,bg)
	guiLabelSetColor(top_story_headline,0,0,0)
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.sanetwork.sa/fortunate_escape_in_mysterious_plane_crash")
			get_page(url)
		end,false)
	-- date
	local top_story_date =  guiCreateLabel(10,292,440,16,"Thursday, January 28th, 2010",false,bg)
	guiSetFont(top_story_date,"default-bold-small")
	guiLabelSetColor(top_story_date,132,5,16)
	-- Summary
	local top_story_summary =  guiCreateLabel(10,306,440,64,"Shortly after three thirty in the afternoon explosions were heard in the El Corona district of Los Santos after a light aircraft plummeted into Unity Station, exploding in a chorus of flames.",false,bg)
	guiLabelSetColor(top_story_summary,38,38,38)
	guiLabelSetHorizontalAlign(top_story_summary,"left",true)
	
	------------- Other News -------------
	local other_news_header_bg = guiCreateStaticImage(0,360,455,22,"websites/colours/3.png",false,bg)
	local other_news_title = guiCreateLabel(10,362,450,20,"Other News",false,bg)
	guiSetFont(other_news_title,"default-bold-small")
	
	-- Article 2--------------------------------------------------------------------------------------------------------------------------------------
		-- bullet point
		local  story_2_bp = guiCreateStaticImage(10,405,6,6,"websites/images/dots/red_dot.png",false,bg)
		-- headline
		local story_2_hl = guiCreateLabel(20,388,435,16,"TRAGEDY ON THE TRACKS",false,bg)
		guiLabelSetColor(story_2_hl,0,0,0)
		addEventHandler("onClientGUIClick",story_2_hl,function()
			local url = tostring("www.sanetwork.sa/tragedy_on_the_tracks") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		--date
		local story_2_date = guiCreateLabel(20,400,435,16,"Tuesday, January 26th, 2010",false,bg)
		guiLabelSetColor(story_2_date,132,5,16)
		guiSetFont(story_2_date,"default-bold-small")
		-- first line
		local story_2_summary = guiCreateLabel(18,412,435,16,"The sight and sound of a train is rarely heard around the city of Los Santos these days.",false,bg)
		guiLabelSetColor(story_2_summary,38,38,38)
		guiLabelSetHorizontalAlign(story_2_summary,"left",true)
	
	-- Article 3--------------------------------------------------------------------------------------------------------------------------------------
		-- bullet point
		local  story_3_bp = guiCreateStaticImage(10,455,6,6,"websites/images/dots/red_dot.png",false,bg)
		-- headline
		local story_3_hl = guiCreateLabel(20,438,435,16,"IMPOUND LOT AUCTION",false,bg)
		guiLabelSetColor(story_3_hl,0,0,0)
		addEventHandler("onClientGUIClick",story_3_hl,function()
			local url = tostring("www.sanetwork.sa/impound_lot_auction") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		--date
		local story_3_date = guiCreateLabel(20,450,435,16,"Monday, January 25th, 2010",false,bg)
		guiLabelSetColor(story_3_date,132,5,16)
		guiSetFont(story_3_date,"default-bold-small")
		-- first line
		local story_3_summary = guiCreateLabel(20,462,435,16,"Today, an auction was held at Best's Towing and Recovery.",false,bg)
		guiLabelSetColor(story_3_summary,38,38,38)
		guiLabelSetHorizontalAlign(story_3_summary,"left",true)
		
	-- Article 4--------------------------------------------------------------------------------------------------------------------------------------------
		-- bullet point
		local  story_4_bp = guiCreateStaticImage(9,505,6,6,"websites/images/dots/red_dot.png",false,bg)
		-- headline
		local story_4_hl = guiCreateLabel(20,488,435,16,"CORRUPTION IN BEST'S TOWING & RECOVERY",false,bg)
		guiLabelSetColor(story_4_hl,0,0,0)
		addEventHandler("onClientGUIClick",story_4_hl,function()
			local url = tostring("www.sanetwork.sa/corruption_in_bt_and_r") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		--date
		local story_4_date = guiCreateLabel(20,500,435,16,"Sunday, January 24th, 2010",false,bg)
		guiLabelSetColor(story_4_date,132,5,16)
		guiSetFont(story_4_date,"default-bold-small")
		-- first line
		local story_4_summary = guiCreateLabel(20,512,435,16,"Bests’ Towing and Recovery, or better known as “BT&R”, is the only towing",false,bg)
		guiLabelSetColor(story_4_summary,38,38,38)
		guiLabelSetHorizontalAlign(story_4_summary,"left",true)
		
	-- Article 5--------------------------------------------------------------------------------------------------------------------------------------
		-- bullet point
		local  story_5_bp = guiCreateStaticImage(9,555,6,6,"websites/images/dots/red_dot.png",false,bg)
		-- headline
		local story_5_hl = guiCreateLabel(20,538,435,16,"CARELESS CITIZENS BURDEN EACHOTHER TO IMPROVE CITY",false,bg)
		guiLabelSetColor(story_5_hl,0,0,0)
		addEventHandler("onClientGUIClick",story_5_hl,function()
			local url = tostring("www.sanetwork.sa/careless_citizens_burden_each_other_to_improve_city") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		--date
		local story_5_date = guiCreateLabel(20,550,435,16,"Sunday, January 24th, 2010",false,bg)
		guiLabelSetColor(story_5_date,132,5,16)
		guiSetFont(story_5_date,"default-bold-small")
		-- first line
		local story_5_summary = guiCreateLabel(20,562,435,16,"The belief that the city of Los Santos is riddled with crime, poverty, and",false,bg)
		guiLabelSetColor(story_5_summary,38,38,38)
		guiLabelSetHorizontalAlign(story_5_summary,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

function www_sanetwork_sa_fortunate_escape_in_mysterious_plane_crash()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Fortunate Escape In Mysterious Plane Crash - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/fortunate_escape_in_mysterious_plane_crash")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/plane_crash.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Fortunate Escape In Mysterious Plane Crash",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Date
	local article_date =  guiCreateLabel(10,290,440,16,"Thursday, January 28th, 2010",false,bg)
	guiLabelSetColor(article_date,132,5,16)
	guiSetFont(article_date,"default-bold-small")
	
	-- Author
	local author =  guiCreateLabel(10,304,440,16,"- Michel Bourgeois",false,bg)
	guiSetFont(author,"default-small")
	guiLabelSetColor(author,38,38,38)
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"Shortly after three thirty in the afternoon explosions were heard in the El Corona district of Los Santos after a light aircraft plummeted into Unity Station, exploding in a chorus of flames.\
\
Police and fire services were quick to respond to the scene and hastily set up a perimeter along the stations parking lot. Fortunately, no casualties were reported but investigators were unable to recover a body from the wreckage of the aircraft. Police were quick to dismiss speculation that this was in any way linked to terrorism.\
\
The aircraft in question, a Dodo S34, is commonly used by recreational pilots in Los Santos air space. It is heralded by many in the aviation industry for its robustness and reliability, bringing into question whether the crash was a mechanical fault or human error. It is currently unclear who the pilot of the aircraft was, where it was headed or who the aircraft belongs to.\
\
Police are appealing for witnesses to aid in their investigations.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

function www_sanetwork_sa_tragedy_on_the_tracks()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Tragedy on the Tracks - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/tragedy_on_the_tracks")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/skyline.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Tragedy on the Tracks",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Date
	local article_date =  guiCreateLabel(10,285,440,16,"Tuesday, January 26th, 2010",false,bg)
	guiLabelSetColor(article_date,132,5,16)
	guiSetFont(article_date,"default-bold-small")
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.sanetwork.sa/tragedy_on_the_tracks")
			get_page(url)
		end,false)
	
	-- Author
	local author =  guiCreateLabel(10,300,440,16,"- Richard Banks (r.banks@sanetwork.sa)",false,bg)
	guiSetFont(author,"default-small")
	guiLabelSetColor(author,38,38,38)
	
	-- Article
	local article =  guiCreateLabel(10,320,440,410,"The sight and sound of a train is rarely heard around the city of Los Santos these days. When a train does pass through, the railroad tracks carry the immensely heavy train and its cargo past busy roads, populated neighborhoods, and crowded public meeting areas. These tracks were the sight of a large and frightening accident.\
\
A man was driving on the road when he came to a railroad crossing. His car stalled on the tracks and would not restart. As he was attempting to start his car, he noticed that a train was coming down the tracks. He began to franticly turn the key in his ignition to start his car before the train hit him. The car would not budge and he was stranded. Faced with death, the man had to abandon his car on the tracks and run. He stood back and watched at the train not only hit his car. The train not only hit his car, it derailed and started skidding down the tracks.\
\
The train came to rest at the railroad bridge next to the basketball courts in East Los Santos. The driver of the car called 911 and the LSES and LSPD arrived on scene. They discovered that the conductor had been launched from the train and was lying injured in front of the train. The tracks were shut down as the rescue attempt began. The LSES took the injured man to the hospital for treatment. The conductor was the only injury in this major accident.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)

		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)			
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

function www_sanetwork_sa_impound_lot_auction()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Impound Lot Auction - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/impound_lot_auction")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/bullet.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Impound Lot Auction",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Date
	local article_date =  guiCreateLabel(10,290,440,16,"Tuesday, January 26th, 2010",false,bg)
	guiLabelSetColor(article_date,132,5,16)
	guiSetFont(article_date,"default-bold-small")
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.sanetwork.sa/tragedy_on_the_tracks")
			get_page(url)
		end,false)
	
	-- Author
	local author =  guiCreateLabel(10,304,440,16,"- Ralph Mountbatton (r.mountbatton@sanetwork.sa)",false,bg)
	guiSetFont(author,"default-small")
	guiLabelSetColor(author,38,38,38)
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"Today, an auction was held at Best's Towing and Recovery. They auctioned off automobiles that have been sitting in their lot and no one has retrieved, or could not afford to un-impound. With car styles ranging from sports cars, trucks and SUV's, to your average Greenwood, BT&R pulled in quite a crowd. People from all over Los Santos came to place their bids in hopes of winning their dream car. Around twenty cars up for sale were lined up against a wall.\
\
The police were present on scene to aid in security because of the sheer quantity of people present. Orders were given for the public to stand behind police barricades. The auction was running smoothly and cars were being sold. Then a man walked out from behind the police barricades. The man wished to buy every single car at the auction with a bid of $2 million dollars.\
\
I was able to snag one photo of the man, identified as Hans Vanderburg, as he jumped onto a car to proclaim his bid on every car at the auction.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Page 2 Link
	local continue_link = guiCreateLabel(10,690,440,16,"Continue to Page 2",false,bg)
	guiLabelSetColor(continue_link,38,38,38)
	guiSetFont(continue_link,"default-bold-small")
	guiLabelSetHorizontalAlign(continue_link,"right")
	addEventHandler("onClientGUIClick",continue_link,function()
		local url = tostring("www.sanetwork.sa/impound_lot_auction2")
		get_page(url)
	end,false)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)			
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

--=============================================================================================================================== PAGE 2

function www_sanetwork_sa_impound_lot_auction2()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Impound Lot Auction (Page 2) - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/impound_lot_auction2")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		--local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/bullet.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Impound Lot Auction",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Article
	local article =  guiCreateLabel(10,290,440,410,"Instantly, a rage struck the crowd. They were not passive bidders anymore; it was as though they had been replaced with rabid dogs. Cries of outrage poured from the enraged bidders as the reality that Best's Towing had allowed one person to purchase all the cars was setting in. Upon discussion with Best's Towing, It was found that Hans Vanderburg was allowed to purchase all the cars at auction for $2 million dollars. The real question one should ask is; what would one man need with all those cars?\
\
We may never find out, but I'm sure that there are a few upset citizens out there. Some of the people in attendance are now wondering what they will do for transportation. There is always the use of our city's public transportation system, but what about the people who wished to own their own automobile? Sadly, that didn't work out for them this time around.\
\
After accepting the $2 million deal, the cars were moved off site to one of Mr. Vanderburg's estates. People were infuriated as they began to cuss and swear at the BT&R employees, but the damage had been done and Mr. Vanderburg's deal accepted. The situation began to get very heated after the multi-million dollar purchase. BT&R was forced to call in S.W.A.T and the LSES for precautionary reasons. The auction was put to a close and citizens were told to disperse. Only a few stuck around to express their rights to the police. All is quiet in Los Santos now; let’s hope Mr. Vanderburg enjoys his new cars.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Page 2 Link
	local continue_link = guiCreateLabel(10,690,440,16,"Back to Page 1",false,bg)
	guiLabelSetColor(continue_link,38,38,38)
	guiSetFont(continue_link,"default-bold-small")
	guiLabelSetHorizontalAlign(continue_link,"right")
	addEventHandler("onClientGUIClick",continue_link,function()
		local url = tostring("www.sanetwork.sa/impound_lot_auction")
		get_page(url)
	end,false)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

function www_sanetwork_sa_corruption_in_bt_and_r()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Corruption In Best's Towing & Recovery - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/corruption_in_bt_and_r")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/slamvan.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Corruption In Best's Towing & Recovery",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Date
	local article_date =  guiCreateLabel(10,290,440,16,"Tuesday, January 26th, 2010",false,bg)
	guiLabelSetColor(article_date,132,5,16)
	guiSetFont(article_date,"default-bold-small")
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.sanetwork.sa/tragedy_on_the_tracks")
			get_page(url)
		end,false)
	
	-- Author
	local author =  guiCreateLabel(10,304,440,16,"- Richard Banks(r.banks@sanetwork.sa)",false,bg)
	guiSetFont(author,"default-small")
	guiLabelSetColor(author,38,38,38)
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"Bests’ Towing and Recovery, or better known as “BT&R”, is the only towing company in the city of Los Santos. They keep the streets clear of improperly parked vehicles and assist the Emergency Services and Police Department to clear up accident scenes to reopen roads for the public. They are an asset to the city to keep the roadways running and safe.\
\
Recently, there has been a shocking and appalling discovery made about BT&R. In the late night on January Fourth the SAN received an anonymous call about an illegal activity being conducted by the towing company. We were shocked to find that just outside of the SAN building, next to Pier 69, there were BT&R trucks towing away the many vehicles legally parked on the road.\
\
The cars being towed were brightly colored sports cars which I’m sure anyone who has traveled to pier 69 or Rodeo has seen. All of these cars were perfectly legally parked according to the laws of Los Santos. Despite being legally parked, the BT&R drivers were ordered to tow all of these cars by one of the company managers.\
\
SAN has multiple pictures of the scene as this was taking place. We have clear documents of the trucks pulling up, hooking up legally parked cars, and towing them off. There are also clear, uncompromised pictures of on of the perpetrators’ face. We followed the drivers back to the impound lot where all the cars we had seen being towed were visible in the lot.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Page 2 Link
	local continue_link = guiCreateLabel(10,690,440,16,"Continue to Page 2",false,bg)
	guiLabelSetColor(continue_link,38,38,38)
	guiSetFont(continue_link,"default-bold-small")
	guiLabelSetHorizontalAlign(continue_link,"right")
	addEventHandler("onClientGUIClick",continue_link,function()
		local url = tostring("www.sanetwork.sa/corruption_in_bt_and_r2")
		get_page(url)
	end,false)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

--=============================================================================================================================== PAGE 2

function www_sanetwork_sa_corruption_in_bt_and_r2()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Corruption In Best's Towing & Recovery (Page 2) - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/corruption_in_bt_and_r2")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/slamvan.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Impound Lot Auction",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Article
	local article =  guiCreateLabel(10,290,440,410,"One of the BT&R drivers spotted Richard Banks as he photographed the trucks going into and out of the lot. The driver was hostile toward Richard to the point where the driver started to insult and threaten him. The Richard attempted to leave but was chased by the infuriated BT&R driver. After a lengthy chase, Richard was cornered by the driver. The two exhausted men argued before the driver demanded to go onto air. An uplink was made with the SAN studio to the driver’s phone and an interview between the CEO of SAN, Josh Stafford and the driver was transmitted live.\
\
The interview between the two men showed what BT&R was really doing. The driver stated that there had been multiple crashes in the area due to those cars. The reason that the company gave for the cars being towed was that they were posing a safety threat to the ublic and had to have been taken care of. During the interview, Josh asked if the company possessed a warrant to tow the vehicles. There was a long pause and we eventually found that no warrant had been obtained for the seizure of vehicles.\
\
After a long debate, the interview ended and the driver returned to work. The SAN employee stayed at the BT&R building for some time after the fact and reported hearing messages from the BT&R radio saying “keep towing dem cars!” showing that there was no intention to stop, even when it was made abundantly clear that the actions being taken were illegal.\
\
With the reckless and uncaring drivers in this city, BT&R is a vital resource to the well being of the city. Cars would literally line the streets and block essential areas if it were not for the BT&R drivers. The comments given to me by several employees shows that they did not want any part in the towing. They were ordered and forced to by a corrupt manager. It is essential that the leadership and decisions of this company are fair and legal to keep this organization functional and the city streets clear.",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)
	
	-- Page 2 Link
	local continue_link = guiCreateLabel(10,690,440,16,"Back to Page 1",false,bg)
	guiLabelSetColor(continue_link,38,38,38)
	guiSetFont(continue_link,"default-bold-small")
	guiLabelSetHorizontalAlign(continue_link,"right")
	addEventHandler("onClientGUIClick",continue_link,function()
		local url = tostring("www.sanetwork.sa/corruption_in_bt_and_r")
		get_page(url)
	end,false)
	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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

--------------------------------------------------------------------------------------------------------------------------- Careless Citizens Burden Each Other To Improve City

function www_sanetwork_sa_careless_citizens_burden_each_other_to_improve_city()
	
	-- Webpage Properties
	---------------------
	local page_length = 764
	guiSetText(internet_address_label, "SANetwork.sa - Careless Citizens Burden Each Other To Improve City - Waterwolf")
	guiSetText(address_bar,"www.sanetwork.sa/careless_citizens_burden_each_other_to_improve_city")
	
	-- Page Background Colour
	-------------------------
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/14.png",false,internet_pane)
	
	------------
	-- Header --
	------------
	local san_logo = guiCreateStaticImage(5,0,659,73,"websites/images/san-logo.png",false,bg)
	
	-- Nav Links
		-- Home
		--local news_link_bg = guiCreateStaticImage(369,49,62,22,"websites/colours/1.png",false,bg)
		local news_link = guiCreateLabel(369,52,62,22,"Home",false,bg)
		--guiLabelSetColor(news_link,132,5,16)
		guiSetFont(news_link,"default-bold-small")
		guiLabelSetHorizontalAlign(news_link,"center")
		addEventHandler("onClientGUIClick",news_link,function()
			local url = tostring("www.sanetwork.sa") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
	
		-- Jobs
		--local jobs_link_bg = guiCreateStaticImage(443,49,62,22,"websites/colours/1.png",false,san_logo)
		local jobs_link = guiCreateLabel(443,52,62,22,"Jobs",false,bg)
		guiSetFont(jobs_link,"default-bold-small")
		guiLabelSetHorizontalAlign(jobs_link,"center")
		addEventHandler("onClientGUIClick",jobs_link,function()
			local url = tostring("www.sanetwork.sa/jobs") -- Put hyperlink url in quotation marks
			get_page(url)
		end,false)
		
		-- Places
		--local places_link_bg = guiCreateStaticImage(517,49,62,22,"websites/colours/1.png",false,san_logo)
		local places_link = guiCreateLabel(517,52,62,22,"Places",false,bg)
		guiSetFont(places_link,"default-bold-small")
		guiLabelSetHorizontalAlign(places_link,"center")
		addEventHandler("onClientGUIClick",places_link,function()
			local url = tostring("www.sanetwork.sa/places")
			get_page(url)
		end,false)
		
		-- Corporate
		--local corporate_link_bg = guiCreateStaticImage(599,49,62,22,"websites/colours/1.png",false,san_logo)
		local corporate_link = guiCreateLabel(599,52,62,22,"Corporate",false,bg)
		guiSetFont(corporate_link,"default-bold-small")
		guiLabelSetHorizontalAlign(corporate_link,"center")
		addEventHandler("onClientGUIClick",corporate_link,function()
			local url = tostring("www.sanetwork.sa/corporate")
			get_page(url)
		end,false)
	
	-------------
	-- Content --
	-------------
	
	local left_content_bg = guiCreateStaticImage(5,112,450,600,"websites/colours/1.png",false,bg)
	local right_content_bg = guiCreateStaticImage(470,112,190,210,"websites/colours/1.png",false,bg)

	-- Left Column
	------------- Latest News -------------
	local top_story_image = guiCreateStaticImage(95,90,280,189,"websites/images/theatre.png",false,bg)
	local top_story_mask_t = guiCreateStaticImage(5,112,450,5,"websites/colours/1.png",false,bg)
	local top_story_mask_b = guiCreateStaticImage(5,290,450,26,"websites/colours/1.png",false,bg)
	
	-- Title
	local title_header_bg = guiCreateStaticImage(0,90,455,22,"websites/colours/3.png",false,bg)
	local title = guiCreateLabel(10,92,450,20,"Careless Citizens Burden Each Other To Improve City",false,bg)
	guiSetFont(title,"default-bold-small")
	
	-- Date
	local article_date =  guiCreateLabel(10,290,440,16,"Tuesday, January 26th, 2010",false,bg)
	guiLabelSetColor(article_date,132,5,16)
	guiSetFont(article_date,"default-bold-small")
	addEventHandler("onClientGUIClick",top_story_headline,function()
			local url = tostring("www.sanetwork.sa/tragedy_on_the_tracks")
			get_page(url)
		end,false)
	
	-- Author
	local author =  guiCreateLabel(10,304,440,16,"- Megan Thorne (m.thorne@sanetwork.sa)",false,bg)
	guiSetFont(author,"default-small")
	guiLabelSetColor(author,38,38,38)
	
	-- Article
	local article =  guiCreateLabel(10,318,440,410,"The belief that the city of Los Santos is riddled with crime, poverty, and corruption is just another piece to the puzzle that leads to the carelessness of some citizens for themselves and their belongings. Because a fine line divides the rich and poor in Los Santos, there is virtually no developing middle class. Many homes have been left effortlessly abandoned for a home in the hills.\
	\
	With such a thin border between extreme affluence and complete destitute, it brings a very sharp question to mind. Why; when a majority of citizens in Los Santos is in such a financial crisis; would people leave their expensive posessions in the middle of the street?",false,bg)
	guiLabelSetColor(article,38,38,38)
	guiLabelSetHorizontalAlign(article,"left",true)

	
	-- Right Column
	--------------------------- Top Links ---------------------------
	local top_links_header_bg = guiCreateStaticImage(465,90,195,22,"websites/colours/3.png",false,bg)
	local top_links_title = guiCreateLabel(480,92,180,20,"Top Links",false,bg)
	guiSetFont(top_links_title,"default-bold-small")
		
		-- LS Government
		local top_link_1_bp = guiCreateStaticImage(474,121,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_1 = guiCreateLabel(490,114,142,16,"Los Santos Government",false,bg)
		guiLabelSetColor(top_link_1,38,38,38)
		addEventHandler("onClientGUIClick",top_link_1,function()
				local url = tostring("www.lossantos.gov")
				get_page(url)
			end,false)
		
		-- LSPD
		local top_link_2_bp = guiCreateStaticImage(474,137,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_2 = guiCreateLabel(490,129,142,16,"LS Police Department",false,bg)
		guiLabelSetColor(top_link_2,38,38,38)
		addEventHandler("onClientGUIClick",top_link_2,function()
				local url = tostring("www.lspd.gov")
				get_page(url)
			end,false)

		-- LSES
		local top_link_3_bp = guiCreateStaticImage(474,153,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_3 = guiCreateLabel(490,146,142,16,"LS Emergency Service",false,bg)
		guiLabelSetColor(top_link_3,38,38,38)
		addEventHandler("onClientGUIClick",top_link_3,function()
				local url = tostring("www.lses.gov")
				get_page(url)
			end,false)
	
		-- C&C Bank of San Andreas
		local top_link_4_bp = guiCreateStaticImage(474,169,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,162,142,16,"Bank of San Andreas",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.bankofsa.sa")
				get_page(url)
			end,false)
			
		-- Los Santos Internation Flight School
		local top_link_4_bp = guiCreateStaticImage(474,185,6,6,"websites/images/dots/red_dot.png",false,bg)
		local top_link_4 = guiCreateLabel(490,178,142,16,"LSI Flight School",false,bg)
		guiLabelSetColor(top_link_4,38,38,38)
		addEventHandler("onClientGUIClick",top_link_4,function()
				local url = tostring("www.lsiflight.sa")
				get_page(url)
			end,false)
			
	------------
	-- Footer --
	------------
	
	local footer_bg = guiCreateStaticImage(0,725,660,40,"websites/colours/3.png",false,bg)
	local footer_text = guiCreateLabel(14,739,254,14,"SAN       2010 San Andreas Network. All Rights Reserved.",false,bg)
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
