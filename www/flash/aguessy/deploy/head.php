<div id="header">
	<div class="top">
		<h1 class="home">
			<a class="home dispBlock" href="<?php echo "/".utf8_encode(nl2br($txt['lng']))."/"; ?>">
			KOSSI AGUESSY - Designer since 1977.; Paris
			<span>home</span>
			</a>
		</h1> 	
		<div class="pictos">
			<ul>
				<li><a id="about_link" href="#about" class="lay"><span><?php echo utf8_encode(nl2br($txt['about'])); ?></span></a></li>
				<li><a id="philosophy_link" href="#philosophy" class="lay"><span><?php echo utf8_encode(nl2br($txt['philosophy'])); ?></span></a></li>
				<li><a id="awards_link" href="#awards" class="lay"><span><?php echo utf8_encode(nl2br($txt['price'])); ?></span></a></li>
				<li><a id="photos_link" href="#photos" class="lay"><span><?php echo utf8_encode(nl2br($txt['photo'])); ?></span></a></li>
				<li><a id="blog_link" href="http://www.aguessy.com/aguessyblog/index.php?" target="_blank"><span><?php echo utf8_encode(nl2br($txt['blog'])); ?></span></a></li>
				<li><a id="pressBtn" href="#press"><span><?php echo utf8_encode(nl2br($txt['press'])); ?></span></a></li>
				<li><a id="industry_link" href="#correspond" class="lay"><span><?php echo utf8_encode(nl2br($txt['industry'])); ?></span></a></li>
				<li><a id="contacts_link" href="#contacts" class="lay"><span><?php echo utf8_encode(nl2br($txt['contact'])); ?></span></a></li>
				<li><a id="credits_link" href="#credits" class="lay"><span><?php echo utf8_encode(nl2br($txt['credits'])); ?></span></a></li>
			</ul>
		</div>
		<div class="extralinks">
			<ul>
				<li><a id="shop" href="#"><span>A+ Magazine</span></a></li>
				<li><a id="aPlus" href="#"><span>Online Shop</span></a></li>
			</ul>
		</div>
		<div class="searchBar">
			<div id="search">
				<h2>
					<label for="q"><?php echo utf8_encode(nl2br($txt['search'])); ?></label>
				</h2>
				<form method="post" action="../php/search.php">
					<fieldset>
						<p>
							<input type="text" value="" name="q" id="q" maxlength="255" size="10"/>
							<input type="submit" value="ok" class="submit"/>
						</p>
					</fieldset>
				</form>
			</div>
			<?php
			
				$req = mysql_query('SELECT * FROM active_lng WHERE id="1"');
				$act = mysql_fetch_array($req);

			?>
			<ul class="lang">
				<li><a <?php if($act['fr'] == 1){echo "href='/fr/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?> >Français</a>.</li>
				<li><a <?php if($act['en'] == 1){echo "href='/en/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>English</a>.</li>
				<li><a <?php if($act['de'] == 1){echo "href='/de/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Deutsch</a>.</li>
				<li><a <?php if($act['po'] == 1){echo "href='/po/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Português</a>.</li>
				<li><a <?php if($act['es'] == 1){echo "href='/es/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Español</a>.</li>
				<li><a <?php if($act['it'] == 1){echo "href='/it/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Italiano</a>.</li>
				<li><a <?php if($act['ru'] == 1){echo "href='/ru/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Русский</a>.</li>
				<li><a <?php if($act['sn'] == 1){echo "href='/sn/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>中文</a>.</li>
				<li><a <?php if($act['jp'] == 1){echo "href='/jp/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>日本語</a>.</li>
				<li><a <?php if($act['ar'] == 1){echo "href='/ar/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>العربية</a>.</li>
				<li><a <?php if($act['sw'] == 1){echo "href='/sw/' class='online'"; } else{ echo "href='javascript:void(0)'"; }?>>Swahili</a></li>
			</ul>
		</div>
	</div>
	<div id="contactPress" class="hidden">
		<form method="post" action="../php/req_press.php" id="connexPress">
			<fieldset>
				<h3><?php echo utf8_encode(nl2br($txt['press_title'])); ?></h3>
				<br />
				<p>
					<?php echo utf8_encode(nl2br($txt['press_access'])); ?>
					<a href="mailto:<?php echo utf8_encode(nl2br($txt['press_email'])); ?>"><?php echo utf8_encode(nl2br($txt['press_email_txt'])); ?></a>
				</p>
				<p class="txt">
					<br />
					<label><?php echo utf8_encode(nl2br($txt['pass'])); ?>&nbsp;&nbsp;&nbsp;<input type="password" name="password" id="password" /></label>
					<input type="submit" class="submit" value="<?php echo utf8_encode(nl2br($txt['press_submit'])); ?>" /><span class="error" style="display:block;color:red;"></span>
				</p>
			</fieldset>
		</form>
	</div>
</div>